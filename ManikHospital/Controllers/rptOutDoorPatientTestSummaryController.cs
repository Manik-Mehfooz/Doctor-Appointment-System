using CrystalDecisions.CrystalReports.Engine;
using MedicalStore.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace vtsMMC.Controllers
{
    public class rptOutDoorPatientTestSummaryController : Controller
    {
        clsContact cont = new clsContact();
        clsRptOutDoorPatientTestSummary exp = new clsRptOutDoorPatientTestSummary();

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
        public ActionResult PrintReport(clsRptOutDoorPatientTestSummary obj, FormCollection frm)
        {
            cont.Search = "Doctor";
            ViewBag.DdDoctor = new SelectList(cont.GetSearchData(), "ContactID", "FullName", obj.DoctorID);
            DateTime date = DateTime.Now;
            var firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
            ViewBag.fDate = firstDayOfMonth.ToShortDateString();
            ViewBag.tDate = (firstDayOfMonth.AddMonths(1).AddDays(-1)).ToShortDateString();
            exp.TestType = obj.TestType;
            exp.DoctorID = obj.DoctorID;
            exp.FromDate = frm["FromDate"];
            exp.ToDate = frm["ToDate"];

            List<clsRptOutDoorPatientTestSummary> data = new List<clsRptOutDoorPatientTestSummary>();

            //ViewBag.List = exp.ExpensesReport();
            data = exp.OutDoorPatientTestSummary();

            ReportDocument rd = new ReportDocument();
            rd.Load(Path.Combine(Server.MapPath("~/CrystalReports/"), "rptOutDoorPatientTestSummary.rpt"));

            rd.SetDataSource(data);

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
            string pdffilename = datetime.ToString() + "_OutDoor Patient Test Summary Report" + ".pdf";

            //return File(stream, "application/pdf", "CustomerList.pdf");  
            return File(stream, "application/pdf", pdffilename);
        }

    }
}
