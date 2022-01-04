using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MedicalStore.Models;
using System.Web.UI;
using CrystalDecisions.CrystalReports.Engine;
using System.IO;



namespace MedicalStore.Controllers
{
    public class rptMonthlySaleController : Controller
    {
        //
        // GET: /rptMonthlySale/

        clsSalesReport sr = new clsSalesReport();
        clsContact ObjContact = new clsContact();

        public ActionResult Print()
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                DateTime date = DateTime.Now;
                var firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
                ViewBag.fDate = firstDayOfMonth.ToShortDateString();
                ViewBag.tDate = (firstDayOfMonth.AddMonths(1).AddDays(-1)).ToShortDateString();

                ObjContact.Search = "Doctor";
                ViewBag.DdDoctor = new SelectList(ObjContact.GetSearchData(), "ContactID", "FullName", 0);

                return View();
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }
            
        }


        [HttpPost]
        public ActionResult Print(clsSalesReport obj, FormCollection frm)
        {
            DateTime date = DateTime.Now;
            var firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
            ViewBag.fDate = firstDayOfMonth.ToShortDateString();
            ViewBag.tDate = (firstDayOfMonth.AddMonths(1).AddDays(-1)).ToShortDateString();

            ObjContact.Search = "Doctor";
            ViewBag.DdDoctor = new SelectList(ObjContact.GetSearchData(), "ContactID", "FullName", 0);

            sr.FromDate = frm["FromDate"];
            sr.ToDate = frm["ToDate"];
            sr.DoctorID = frm["DoctorID"] == "" ? "0" : frm["DoctorID"];

            string reporttype = frm["ReportType"];

            List<clsSalesReport> allCustomer = new List<clsSalesReport>();

            //ViewBag.List = exp.ExpensesReport();

            ReportDocument rd = new ReportDocument();
            if (reporttype == "SaleDetail")
            {
                allCustomer = sr.MonthlySalesReport();
                rd.Load(Path.Combine(Server.MapPath("~/CrystalReports/"), "rptMonthlySaleDetail.rpt"));
            }
            else
            {
                allCustomer = sr.MonthlySalesSummaryReport();
                rd.Load(Path.Combine(Server.MapPath("~/CrystalReports/"), "rptMonthlySaleSummary.rpt"));
            }

            rd.SetDataSource(allCustomer);
            DateTime dtStartDate = Convert.ToDateTime(obj.FromDate);
            DateTime dtEndDate = Convert.ToDateTime(obj.ToDate);
            rd.SetParameterValue("StartDate", dtStartDate);
            rd.SetParameterValue("EndDate", dtEndDate);


            Response.Buffer = false;
            Response.ClearContent();
            Response.ClearHeaders();

            Stream stream = rd.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
            stream.Seek(0, SeekOrigin.Begin);

            string datetime = "";
            string time = DateTime.Now.Hour.ToString() + DateTime.Now.Minute.ToString() + DateTime.Now.Second.ToString();        
            string dt = DateTime.Now.Day.ToString() + DateTime.Now.Month.ToString() + DateTime.Now.Year.ToString();  
            dt = dt.ToString().Replace('/', '_');
            datetime = dt + "_" + time;
            string pdffilename = datetime.ToString() + "_Monthly_"+ reporttype + ".pdf";

            //return File(stream, "application/pdf", "CustomerList.pdf");  
            return File(stream, "application/pdf", pdffilename);
        }

        //[HttpPost]
        //public ActionResult Print(clsSalesReport obj, FormCollection frm)
        //{
        //    DateTime date = DateTime.Now;
        //    var firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
        //    ViewBag.fDate = firstDayOfMonth.ToShortDateString();
        //    ViewBag.tDate = (firstDayOfMonth.AddMonths(1).AddDays(-1)).ToShortDateString();

        //    sr.FromDate = frm["FromDate"];
        //    sr.ToDate = frm["ToDate"];

        //    ViewBag.List = sr.MonthlySalesReport();

        //    LocalReport lr = new LocalReport();
        //    string pathh = Path.Combine(Server.MapPath("~/Reports"), "rptMonthlySale.rdlc");
        //    if (System.IO.File.Exists(pathh))
        //    {
        //        lr.ReportPath = pathh;
        //    }
        //    else
        //    {
        //        return View();
        //    }

        //    ReportDataSource rd = new ReportDataSource("DataSet1", ViewBag.List);
        //    lr.DataSources.Add(rd);
        //    string reportType = "PDF";
        //    string mimeType;
        //    string encoding;
        //    string fileNameExtension;
        //    string deviceInfo =
        //    "<DeviceInfo>" +
        //    "  <OutputFormat>PDF</OutputFormat>" +
        //    "  <PageWidth>8in</PageWidth>" +
        //    "  <PageHeight>11in</PageHeight>" +
        //    "  <MarginTop>0</MarginTop>" +
        //    "  <MarginLeft>0</MarginLeft>" +
        //    "  <MarginRight>0</MarginRight>" +
        //    "  <MarginBottom>0</MarginBottom>" +
        //    "</DeviceInfo>";
        //    Warning[] warnings;
        //    string[] streams;
        //    byte[] renderedBytes;
        //    renderedBytes = lr.Render(
        //        reportType,
        //        deviceInfo,
        //        out mimeType,
        //        out encoding,
        //        out fileNameExtension,
        //        out streams,
        //        out warnings);


        //    Response.Buffer = true;
        //    Response.Clear();
        //    Response.ContentType = mimeType;
        //    Response.AddHeader("content-disposition", "attachment; filename=MonthlySalesReport.pdf");
        //    Response.BinaryWrite(renderedBytes); // create the file
        //    Response.Flush();

        //    return File(renderedBytes, mimeType);
        //}

    }
}
