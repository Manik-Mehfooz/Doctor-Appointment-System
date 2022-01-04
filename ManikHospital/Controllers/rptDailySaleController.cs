using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MedicalStore.Models;
using System.Web.UI;
using System.IO;
using CrystalDecisions.CrystalReports.Engine;


namespace MedicalStore.Controllers
{
    public class rptDailySaleController : Controller
    {
        //
        // GET: /rptDailySale/
        clsSalesReport sr = new clsSalesReport();
        clsContact ObjContact = new clsContact();

        [HttpGet]
        public ActionResult Print()
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                ObjContact.Search = "Doctor";
                ViewBag.DdDoctor = new SelectList(ObjContact.GetSearchData(), "ContactID", "FullName", 0);
                return View();
                //=DateSerial(Year(Now), Month(Now)+1, 0)
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }
            
        }


        [HttpPost]
        public ActionResult Print(clsSalesReport obj, FormCollection frm)
        {
            ObjContact.Search = "Doctor";
            ViewBag.DdDoctor = new SelectList(ObjContact.GetSearchData(), "ContactID", "FullName", 0);

            string ReportType = frm["ReportType"];
            string type = frm["SaleType"];
            sr.SaleType = type;
            sr.DoctorID = frm["DoctorID"] == "" ? "0" : frm["DoctorID"];
            sr.SaleDate = frm["SaleDate"];

            List<clsSalesReport> allCustomer = new List<clsSalesReport>();
            ReportDocument rd = new ReportDocument();

            //ViewBag.List = sr.DailySalesReport();
            if (ReportType == "Detail")
            {
                allCustomer = sr.DailySalesReport();
                rd.Load(Path.Combine(Server.MapPath("~/CrystalReports/"), "rptDailySale.rpt"));
            }
            else
            {
                sr.SaleType = ((type == "ALL") ? "ALLSummary" : (type == "OPD") ? "OPDSummary" : "AdmitPatientSummary");
                allCustomer = sr.DailySalesReportSummary();
                rd.Load(Path.Combine(Server.MapPath("~/CrystalReports/"), "rptDailySaleSummary.rpt"));
            }


            rd.SetDataSource(allCustomer);

            rd.SetParameterValue("SaleDate", frm["SaleDate"]);

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
            string pdffilename = "Daily Sale Report" + datetime.ToString() + ".pdf";
            return File(stream, "application/pdf", pdffilename);
        }

        //[HttpPost]
        //public ActionResult Print(clsSalesReport obj, FormCollection frm)
        //{
        //    string type = frm["SaleType"];
        //    sr.SaleType = type;
        //    sr.SaleDate = frm["SaleDate"];
        //    ViewBag.List = sr.DailySalesReport();

        //    LocalReport lr = new LocalReport();
        //    string pathh = Path.Combine(Server.MapPath("~/Reports"), "rptDailySale.rdlc");
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
        //    Response.AddHeader("content-disposition", "attachment; filename=DailySalesReport.pdf");
        //    Response.BinaryWrite(renderedBytes); // create the file
        //    Response.Flush();
          
        //    return File(renderedBytes, mimeType);
        //}

    }
}
