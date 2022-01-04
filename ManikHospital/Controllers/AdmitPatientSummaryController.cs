using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MedicalStore.Models;
using Microsoft.Reporting.WebForms;
using System.Web.UI;
using System.IO;

namespace MedicalStore.Controllers
{
    public class AdmitPatientSummaryController : Controller
    {
        //
        // GET: /AdmitPatientSummary/
        clsAdmitPatientSummaryReport sr = new clsAdmitPatientSummaryReport();

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

            sr.FromDate = frm["FromDate"];
            sr.ToDate = frm["ToDate"];

            ViewBag.List = sr.AdmitPatientSummaryReport();

            LocalReport lr = new LocalReport();
            string pathh = Path.Combine(Server.MapPath("~/Reports"), "rptAdmitPatient.rdlc");
            if (System.IO.File.Exists(pathh))
            {
                lr.ReportPath = pathh;
            }
            else
            {
                return View();
            }

            ReportDataSource rd = new ReportDataSource("DataSet1", ViewBag.List);
            lr.DataSources.Add(rd);
            string reportType = "PDF";
            string mimeType;
            string encoding;
            string fileNameExtension;
            string deviceInfo =
            "<DeviceInfo>" +
            "  <OutputFormat>PDF</OutputFormat>" +
            "  <PageWidth>8in</PageWidth>" +
            "  <PageHeight>11in</PageHeight>" +
            "  <MarginTop>0</MarginTop>" +
            "  <MarginLeft>0</MarginLeft>" +
            "  <MarginRight>0</MarginRight>" +
            "  <MarginBottom>0</MarginBottom>" +
            "</DeviceInfo>";
            Warning[] warnings;
            string[] streams;
            byte[] renderedBytes;
            renderedBytes = lr.Render(
                reportType,
                deviceInfo,
                out mimeType,
                out encoding,
                out fileNameExtension,
                out streams,
                out warnings);


            Response.Buffer = true;
            Response.Clear();
            Response.ContentType = mimeType;
            Response.AddHeader("content-disposition", "attachment; filename=Patient Bill Report.pdf");
            Response.BinaryWrite(renderedBytes); // create the file
            Response.Flush();

            return File(renderedBytes, mimeType);
        }


    }
}
