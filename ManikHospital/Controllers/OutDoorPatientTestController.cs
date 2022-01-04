using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MedicalStore.Models;
using PagedList;
using PagedList.Mvc;
using System.Data;
using Microsoft.Reporting.WebForms;
using System.IO;
using CrystalDecisions.CrystalReports;
using CrystalDecisions.CrystalReports.Engine;

using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Printing;
using System.Text;

namespace vtsMMC.Controllers
{
    public class OutDoorPatientTestController : Controller
    {
        private IList<Stream> m_streams;
        private int m_currentPageIndex;

        clsOutDoorPatientTest objOut = new clsOutDoorPatientTest();
        clsDiagnosticTest dt = new clsDiagnosticTest();
        clsContact cont = new clsContact();
        clsRptOutDoorPatientTestToken rouptt = new clsRptOutDoorPatientTestToken();

        [HttpGet]
        public ActionResult Index(int? page)
        {
            int pageSize = 15;
            int pageNumber = (page ?? 1);
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                List<clsOutDoorPatientTest> cmp = objOut.GetSearchData();
                return View(cmp.ToPagedList(pageNumber, pageSize));
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult Index(clsOutDoorPatientTest obj, int? page)
        {
            int pageSize = 15;
            int pageNumber = (page ?? 1);
            List<clsOutDoorPatientTest> cmp = objOut.GetSearchData();
            return View(cmp.ToPagedList(pageNumber, pageSize));
        }


        [HttpGet]
        public ActionResult AddNew()
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                ViewBag.InvestigationTestNo = ""; //objOut.GetInvetigationTestNumber();
                ViewBag.IsOther = true;
                ViewBag.ChargesValue = "0"; 
                cont.Search = "Doctor";
                List<clsContact> objConList = new List<clsContact>();
                objConList = cont.GetSearchData();
                clsContact contact = new clsContact();
                contact.ContactID = 0;
                contact.FullName = "Others";
                objConList.Add(contact);

                ViewBag.DdDoctor = new SelectList(objConList, "ContactID", "FullName", 0);
                dt.Search = "Lab";
                ViewBag.DdTestName = new SelectList(dt.GetSearchData(), "TestID", "TestName", 0);
                return View();
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult AddNew(clsOutDoorPatientTest obj,string submit1 = "")
        {

            string TestType = obj.TestType;
            if (obj.TestID > 0)
            {
                objOut.TestID = obj.TestID;
                ViewBag.InvestigationTestNo = objOut.GetInvetigationTestNumber();
            }
            else
                ViewBag.InvestigationTestNo = "";

            ViewBag.IsOther = (obj.DoctorID == 0) ? true : false;
            cont.Search = "Doctor";
            List<clsContact> objConList = new List<clsContact>();
            objConList = cont.GetSearchData();
            clsContact contact = new clsContact();
            contact.ContactID = 0;
            contact.FullName = "Others";
            objConList.Add(contact);

            ViewBag.DdDoctor = new SelectList(objConList, "ContactID", "FullName", obj.DoctorID); 
            ViewBag.DdTestName = new SelectList(dt.GetSearchData().Where(x => x.TestType == obj.TestType), "TestID", "TestName", obj.TestID);

            if (obj.TestID > 0)
            {
                obj.Charges = dt.GetSearchData().Where(x => x.TestID == obj.TestID).Single().Charges;
                ViewBag.ChargesValue = obj.Charges;
            }
            else
            {
                ViewBag.ChargesValue = 0;
            }

            if (submit1 == "Add" || submit1 == "Add & Print")
            {
                if (ModelState.IsValid)
                {
                    int i = obj.SaveMethod();
                    ViewBag.InvestigationTestNo = objOut.GetInvetigationTestNumber();
                    //objOut.OutDoorTestID = objOut.GetMaxOutDoorPatientTestID();
                    int newid = objOut.GetMaxOutDoorPatientTestID();
                    Print(newid);
                    return RedirectToAction("AddNew");
                }
            }
            else
            {
                ChangeState();
            }
            return View();
        }

        public void ChangeState()
        { 
            ModelState["TestNo"].Errors.Clear();
            ModelState["TestDate"].Errors.Clear();
            ModelState["PatientName"].Errors.Clear();
            ModelState["DoctorID"].Errors.Clear();
            //ModelState["DoctorName"].Errors.Clear();
            ModelState["ContactNo"].Errors.Clear();
            ModelState["Age"].Errors.Clear();
            ModelState["TestID"].Errors.Clear();
            ModelState["Discount"].Errors.Clear();
        }

        [HttpGet]
        public ActionResult Edit(int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            { 
                objOut.OutDoorTestID = id;
                objOut = objOut.GetAllDataByID();
                ViewBag.IsOther = (objOut.DoctorID == 0) ? true : false;
                ViewBag.ChargesValue = objOut.Charges;
                cont.Search = "Doctor";
                List<clsContact> objConList = new List<clsContact>();
                objConList = cont.GetSearchData();
                clsContact contact = new clsContact();
                contact.ContactID = 0;
                contact.FullName = "Others";
                objConList.Add(contact);

                ViewBag.DdDoctor = new SelectList(objConList, "ContactID", "FullName", objOut.DoctorID);
                dt.Search = objOut.TestType;
                ViewBag.DdTestName = new SelectList(dt.GetSearchData(), "TestID", "TestName", objOut.TestID);
                return View(objOut);
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult Edit(clsOutDoorPatientTest obj, string submit1)
        {  
            ViewBag.IsOther = (obj.DoctorID == 0) ? true : false;
            ViewBag.ChargesValue = obj.Charges;
            cont.Search = "Doctor";
            List<clsContact> objConList = new List<clsContact>();
            objConList = cont.GetSearchData();
            clsContact contact = new clsContact();
            contact.ContactID = 0;
            contact.FullName = "Others";
            objConList.Add(contact);

            ViewBag.DdDoctor = new SelectList(objConList, "ContactID", "FullName", obj.DoctorID);
            dt.Search = objOut.TestType; 
            ViewBag.DdTestName = new SelectList(dt.GetSearchData().Where(x => x.TestType == obj.TestType), "TestID", "TestName", obj.TestID);

            if (submit1 == "Update")
            {
                if (ModelState.IsValid)
                {
                    int i = obj.UpdateMethod();
                    if (i > 0)
                    {
                        return RedirectToAction("Index");
                    }
                }
            }
            else
            {
                ChangeState();
            }
            return View();
        }

        public ActionResult Delete(int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                objOut.OutDoorTestID = id;
                objOut.DeleteMethod();
                return RedirectToAction("Index");
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }


        }

        
        #region Auto Print Functionality

        public void Print(int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                clsRptOutDoorPatientTestToken rptout = new clsRptOutDoorPatientTestToken();
                rptout.OutDoorTestID = id;
                ViewBag.List = rptout.GetOutDoorPatientInvestigationToken();
                
                LocalReport lr = new LocalReport();
                string pathh = Path.Combine(Server.MapPath("~/Reports"), "PatientInvestigationTestToken.rdlc");
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
                //printDoc.PrinterSettings.PrinterName = "BlackCopper 80mm Series on 192.168.1.2";
                //printDoc.PrinterSettings.PrinterName = "BlackCopper 80mm Series";
                //printDoc.PrinterSettings.PrinterName = "Black Copper BC-85AC";

                printDoc.PrinterSettings.PrinterName = printDoc.PrinterSettings.PrinterName;

                printDoc.OriginAtMargins = false;
                printDoc.DefaultPageSettings.Landscape = false;
                

                
                ////m_currentPageIndex = 0;
                printDoc.Print();
                
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
            List<clsRptOutDoorPatientTestToken> allCustomer = new List<clsRptOutDoorPatientTestToken>();
            clsRptOutDoorPatientTestToken todayrpt = new clsRptOutDoorPatientTestToken();
            allCustomer = todayrpt.GetTodayOutDoorPatientInvestigationToken();

            ReportDocument rd = new ReportDocument();
            rd.Load(Path.Combine(Server.MapPath("~/CrystalReports/"), "rptTodayInvestigationTest.rpt"));

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
            string pdffilename = datetime.ToString() + "_Investigation_Report" + ".pdf";

            //return File(stream, "application/pdf", "CustomerList.pdf");  
            return File(stream, "application/pdf", pdffilename);

        }

        [HttpGet]
        public ActionResult RePrintReport(int id)
        {
            rouptt.OutDoorTestID = id;
            Print(id);
            //return View();
            return RedirectToAction("Index");

        }

    }
}
