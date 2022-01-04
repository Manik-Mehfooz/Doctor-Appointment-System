using MedicalStore.Models;
using Microsoft.Reporting.WebForms;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Printing;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Web.UI;
using PagedList;
using CrystalDecisions.CrystalReports;
using CrystalDecisions.CrystalReports.Engine;

namespace MedicalStore.Controllers
{
    public class DailyOPDTokenController : Controller
    {
        private IList<Stream> m_streams;
        private int m_currentPageIndex;

        clsDailyOPDToken opd = new clsDailyOPDToken();
        clsRptDailyOPD rdopd = new clsRptDailyOPD();
        clsContact c = new clsContact();

        public ActionResult Index(int? page)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            int pageSize = 15;
            int pageNumber = (page ?? 1);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                //opd.Search = "";
                List<clsDailyOPDToken> cmp = opd.GetTodayOPDToken();
                ViewBag.List = cmp.ToPagedList(pageNumber, pageSize);
                return View(cmp.ToPagedList(pageNumber, pageSize));
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }
        }

        public ActionResult GenerateToken()
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                c.Search = "Doctor";
                ViewBag.DdDoctor = new SelectList(c.GetSearchData(), "ContactID", "FirstName", 0);
                //opd.DoctorID = 1;
                ViewBag.NewTokenNumbwe = "";// opd.GenerateNewTokenNumber();
               
                return View();
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }
        }

        [HttpPost]
        public ActionResult GenerateToken(clsDailyOPDToken opd, IEnumerable<string> DoctorID, string btnType)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);

            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                c.Search = "Doctor";
                ViewBag.DdDoctor = new SelectList(c.GetSearchData(), "ContactID", "FirstName", 0);

                if (btnType != "Print Token")
                {
                    ModelState["PatientName"].Errors.Clear();
                    ModelState["ContactNo"].Errors.Clear();
                    ModelState["Age"].Errors.Clear();
                }
                if (ModelState.IsValidField("DoctorID"))
                {
                    opd.DoctorID = Convert.ToInt32(DoctorID.ElementAt(0));
                    ViewBag.NewTokenNumbwe = opd.GenerateNewTokenNumber();
                }
                if (ModelState.IsValid)
                {
                    if (btnType == "Print Token")
                    {
                        opd.Status = "Checked";
                        opd.SaveMethod();
                        opd.DoctorID = Convert.ToInt32(DoctorID.ElementAt(0));
                        ViewBag.NewTokenNumbwe = opd.GenerateNewTokenNumber();
                        Print(0);
                        return RedirectToAction("GenerateToken");
                    }
                }
            }
          return View();
            
        }

        [HttpGet]
        public ActionResult EditOPDToken(int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                ViewBag.ErrorMessage = "";
                opd.OPDID = id;
                return View(opd.GetAllDataByID());
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult EditOPDToken(clsDailyOPDToken obj)
        {
            ViewBag.ErrorMessage = "";
            if (ModelState.IsValid)
            {
                //if (obj.CheckExitData(1))
                //{
                    int result = obj.UpdateMethod();
                    if (result > 0)
                    {
                        RePrintReport(obj.OPDID);
                        return RedirectToAction("Index");
                    }
                //}
                //ViewBag.ErrorMessage = obj.ContactType + " is already exist";
            }
            return View();
        }

        [HttpGet]
        public ActionResult Delete(int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                opd.OPDID = id;
                opd.Status = "Cancel";
                opd.UpdateStatus();
                return RedirectToAction("Index");
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        #region Dowonload Print Functionality

        //public void Print()
        //{
        //    int UserID = Convert.ToInt32(Session["ContactID"]);
        //    string UserName = Convert.ToString(Session["UserName"]);
        //    if (UserID > 0 && (UserName != null || UserName != ""))
        //    {
        //        ViewBag.List = rdopd.DailyOPDTokenReport();

        //        LocalReport lr = new LocalReport();
        //        string pathh = Path.Combine(Server.MapPath("~/Reports"), "OPDTokenReport.rdlc");
        //        if (System.IO.File.Exists(pathh))
        //        {
        //            lr.ReportPath = pathh;
        //        }
        //        else
        //        {
        //            //return View();
        //        }

        //        ReportDataSource rd = new ReportDataSource("OPDTokenDS", ViewBag.List);
        //        lr.DataSources.Add(rd);
        //        string reportType = "PDF";
        //        string mimeType;
        //        string encoding;
        //        string fileNameExtension;
        //        string deviceInfo =
        //        "<DeviceInfo>" +
        //        "  <OutputFormat>EMF</OutputFormat>" +
        //        "  <PageWidth>3in</PageWidth>" +
        //        "  <PageHeight>4in</PageHeight>" +
        //        "  <MarginTop>0</MarginTop>" +
        //        "  <MarginLeft>0</MarginLeft>" +
        //        "  <MarginRight>0</MarginRight>" +
        //        "  <MarginBottom>0</MarginBottom>" +
        //        "</DeviceInfo>";
        //        Warning[] warnings;
        //        string[] streams;
        //        byte[] renderedBytes;
        //        renderedBytes = lr.Render(
        //            reportType,
        //            deviceInfo,
        //            out mimeType,
        //            out encoding,
        //            out fileNameExtension,
        //            out streams,
        //            out warnings);


        //        Response.Buffer = true;
        //        Response.Clear();
        //        Response.ContentType = mimeType;
        //        Response.AddHeader("content-disposition", "attachment; filename=OPD Token.pdf");
        //        Response.BinaryWrite(renderedBytes); // create the file
        //        Response.Flush();


        //        //return File(renderedBytes, mimeType);
        //    }
        //    else
        //    {
        //        //return RedirectToAction("../Users/Login");
        //    }

        //}

        #endregion

        #region Auto Print Functionality

        public void Print(int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                if (Convert.ToInt32(id) > 0)
                {
                    rdopd.OPDID = id.ToString();
                    ViewBag.List = rdopd.RePrintDailyOPDTokenReport();
                }
                else
                {
                    ViewBag.List = rdopd.DailyOPDTokenReport();
                }

                LocalReport lr = new LocalReport();
                string pathh = Path.Combine(Server.MapPath("~/Reports"), "OPDTokenReport.rdlc");
                if (System.IO.File.Exists(pathh))
                {
                    lr.ReportPath = pathh;
                }
                else
                {
                    // return View();
                }

                ReportDataSource rd = new ReportDataSource("OPDTokenDS", ViewBag.List);
                lr.DataSources.Add(rd);

                Export(lr);
                Printreport();


                //return View(""); // File(renderedBytes, mimeType);
                //return RedirectToAction("AddNew");
            }
            else
            {
                //return RedirectToAction("../Users/Login");
            }
        }

        private void Export(LocalReport report)
        {
            string deviceInfo =
                "<DeviceInfo>" +
                "  <OutputFormat>EMF</OutputFormat>" +
                "  <PageWidth>3in</PageWidth>" +
                "  <PageHeight>5in</PageHeight>" +
                "  <MarginTop>0</MarginTop>" +
                "  <MarginLeft>0</MarginLeft>" +
                "  <MarginRight>0</MarginRight>" +
                "  <MarginBottom>0</MarginBottom>" +
                "</DeviceInfo>";
            Warning[] warnings;
            m_streams = new List<Stream>();
            //string[] streams;
            report.Render("image", deviceInfo, CreateStream,
               out warnings);
            foreach (Stream stream in m_streams)
                stream.Position = 0;
        }
        private Stream CreateStream(string name, string fileNameExtension, Encoding encoding, string mimeType, bool willSeek)
        {
            Stream stream = new MemoryStream();
            m_streams.Add(stream);
            return stream;
        }
        private void Printreport()
        {
            if (m_streams == null || m_streams.Count == 0)
                throw new Exception("Error: no stream to print.");
            PrintDocument printDoc = new PrintDocument();
            //PrintDialog pd = new PrintDialog();



            if (!printDoc.PrinterSettings.IsValid)
            {
                throw new Exception("Error: cannot find the default printer.");
            }
            else
            {
                printDoc.PrintPage += new PrintPageEventHandler(PrintPage);
                printDoc.PrinterSettings.PrinterName = "BlackCopper 80mm Series";
                //printDoc.PrinterSettings.PrinterName = "Black Copper BC-85AC";
                printDoc.OriginAtMargins = false;
                printDoc.DefaultPageSettings.Landscape = false;



                //m_currentPageIndex = 0;
                //printDoc.Print();
            }
        }

        private void PrintPage(object sender, PrintPageEventArgs ev)
        {

            Metafile pageImage = new Metafile(m_streams[m_currentPageIndex]);

            // Adjust rectangular area with printer margins.
            Rectangle adjustedRect = new Rectangle(
                ev.PageBounds.Left - (int)ev.PageSettings.HardMarginX,
                ev.PageBounds.Top - (int)ev.PageSettings.HardMarginY,
                288,
                384);

            // Draw a white background for the report
            ev.Graphics.FillRectangle(Brushes.White, adjustedRect);

            // Draw the report content
            ev.Graphics.DrawImage(pageImage, adjustedRect);

            // Prepare for the next page. Make sure we haven't hit the end.
            m_currentPageIndex++;
            ev.HasMorePages = (m_currentPageIndex < m_streams.Count);


        }

        public void Dispose()
        {
            if (m_streams != null)
            {
                foreach (Stream stream in m_streams)
                    stream.Close();
                m_streams = null;
            }
        }

        #endregion


        [HttpGet]
        public ActionResult PrintReport(FormCollection frm)
        {
            List<clsRptDailyOPD> allCustomer = new List<clsRptDailyOPD>();
            allCustomer = rdopd.PatientAppointmentOPDToday();

            ReportDocument rd = new ReportDocument();
            rd.Load(Path.Combine(Server.MapPath("~/CrystalReports/"), "rptPatientOPD.rpt"));

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
            string pdffilename = datetime.ToString() + "_OPD_Report" + ".pdf";

            //return File(stream, "application/pdf", "CustomerList.pdf");  
            return File(stream, "application/pdf", pdffilename);

        }

        public ActionResult RePrintReport(int id)
        {
            opd.OPDID = id;
            Print(id);
            //return View();
            return RedirectToAction("Index");

        }

        [HttpGet]
        public ActionResult SearchOPD()
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                Session["SearchOPD"] = "";
                return View();
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }
        }

        [HttpPost]
        public ActionResult SearchOPD(string id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                Session["SearchOPD"] = (id == null) ? "" : id.ToLower();
                return View();
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }
        }
        public JsonResult SearchOldOPDTokenForReprint()
        {
            string Search = Convert.ToString(Session["SearchOPD"]);

            List<clsDailyOPDToken> OPDList = new List<clsDailyOPDToken>();
            if (Search != "")
            {
                opd.Search = Search;
                OPDList = opd.SearchOldOPDToken();

                return Json(OPDList, JsonRequestBehavior.AllowGet);
            }
            return Json(OPDList, JsonRequestBehavior.AllowGet);
        }

    }
}
