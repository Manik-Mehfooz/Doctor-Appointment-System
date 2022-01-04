using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MedicalStore.Models;
using CrystalDecisions.CrystalReports.Engine;
using System.IO;

namespace vtsMMC.Controllers
{
    public class rptDailyOPDSummaryController : Controller
    {
        clsContact cont = new clsContact();
        clsRptDailyOPD exp = new clsRptDailyOPD();

        [HttpGet]
        public ActionResult PrintReport()
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                DateTime date = DateTime.Now;
                var firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
                ViewBag.fDate = firstDayOfMonth.ToShortDateString();
                ViewBag.tDate = (firstDayOfMonth.AddMonths(1).AddDays(-1)).ToShortDateString();
                cont.Search = "Doctor";
                ViewBag.DdDoctor = new SelectList(cont.GetSearchData(), "ContactID", "FullName", 0);
                return View();

            }
            else
            {
                return RedirectToAction("../Users/Login");
            }
        }

        [HttpPost]
        public ActionResult PrintReport(clsRptDailyOPD obj, FormCollection frm)
        {
            cont.Search = "Doctor";
            ViewBag.DdDoctor = new SelectList(cont.GetSearchData(), "ContactID", "FullName", obj.DoctorID);
            DateTime date = DateTime.Now;
            var firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
            ViewBag.fDate = firstDayOfMonth.ToShortDateString();
            ViewBag.tDate = (firstDayOfMonth.AddMonths(1).AddDays(-1)).ToShortDateString();
            exp.DoctorID = obj.DoctorID;
            exp.FromDate = frm["FromDate"];
            exp.ToDate = frm["ToDate"];

            List<clsRptDailyOPD> allCustomer = new List<clsRptDailyOPD>();

            //ViewBag.List = exp.ExpensesReport();
            allCustomer = exp.DailyOPDSummaryReport();

            ReportDocument rd = new ReportDocument();
            rd.Load(Path.Combine(Server.MapPath("~/CrystalReports/"), "rptOPDSummary.rpt"));

            rd.SetDataSource(allCustomer);

            Response.Buffer = false;
            Response.ClearContent();
            Response.ClearHeaders();

            Stream stream = rd.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
            stream.Seek(0, SeekOrigin.Begin);

            string datetime = "";
            string time = DateTime.Now.Hour.ToString() + DateTime.Now.Minute.ToString() + DateTime.Now.Second.ToString();         // User current time
            string dt = DateTime.Now.Day.ToString() + DateTime.Now.Month.ToString() + DateTime.Now.Year.ToString();              // Use current date
            dt = dt.ToString().Replace('/', '_');
            datetime = dt + "_" + time;
            string pdffilename = datetime.ToString() + "_OPD Summary Report" + ".pdf";

            //return File(stream, "application/pdf", "CustomerList.pdf");  
            return File(stream, "application/pdf", pdffilename);
        }

    }
}
