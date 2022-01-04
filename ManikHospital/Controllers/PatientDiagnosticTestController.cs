using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MedicalStore.Models;
using Microsoft.Reporting.WebForms;
using System.IO;
using System.Data;
using PagedList;
using PagedList.Mvc;

namespace MedicalStore.Controllers
{
    public class PatientDiagnosticTestController : Controller
    {
        clsPatientDiagnosticTest pdTest = new clsPatientDiagnosticTest();
        clsDiagnosticTest dt = new clsDiagnosticTest();

        [HttpGet]
        public ActionResult Index(int? page)
        {
            int pageSize = 15;
            int pageNumber = (page ?? 1);
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                pdTest.Search = "";
                List<clsPatientDiagnosticTest> cmp = pdTest.GetSearchData();
                return View(cmp.ToPagedList(pageNumber, pageSize));
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult Index(clsPatientDiagnosticTest obj, int? page)
        {
            int pageSize = 15;
            int pageNumber = (page ?? 1);
            pdTest.Search = obj.Search;
            List<clsPatientDiagnosticTest> cmp = pdTest.GetSearchData();
            return View(cmp.ToPagedList(pageNumber, pageSize));
        }

        public JsonResult GetDataByPatientID(int id)
        {
            try
            {
                JsonResult json = new JsonResult();
                var data = pdTest.GetSearchData().Where(x => x.PatientID == id);
                json.Data = data;
                json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
                return json;
            }
            catch (Exception exp) {
                return null;
            }
        }

        [HttpGet]
        public ActionResult AddNew()
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                ViewBag.ChargesValue = "0";
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
        public ActionResult AddNew(clsPatientDiagnosticTest obj, FormCollection frm, string addnewtest, string submit1 = "")
        {
            if (addnewtest == "newtest")
            {
                return RedirectToAction("AddNew", "DiagnosticTest", new { b = "back" });
            }

            dt.TestType = String.IsNullOrEmpty(frm["TestType"]) ? null : Convert.ToString(frm["TestType"].Split(',')[0]);
            ViewBag.DdTestName = new SelectList(dt.GetTestType(), "TestID", "TestName", 0);
            dt.TestID = String.IsNullOrEmpty(frm["TestID"]) ? 0 : Convert.ToInt32(frm["TestID"]);
            ViewBag.ChargesValue = dt.GetAllDataByID().Charges;

            if (submit1 == "Add" || submit1 == "Add & Print")
            {
                if (ModelState.IsValid)
                {
                    int i = obj.SaveMethod();
                    if (i > 0)
                    {
                        if (submit1 == "Add & Print")
                        {
                            Print(pdTest.GetMaxRow());
                        }
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

        public void ChangeState()
        {
            ModelState["TestID"].Errors.Clear();
            ModelState["TestType"].Errors.Clear();
            ModelState["PatientName"].Errors.Clear();
            ModelState["ContactNo"].Errors.Clear();
            ModelState["DoctorName"].Errors.Clear();
            ModelState["Symptoms"].Errors.Clear();
            ModelState["Discount"].Errors.Clear();
            ModelState["Remarks"].Errors.Clear();
            ModelState["Status"].Errors.Clear();
            ModelState["TestDate"].Errors.Clear();
            ModelState["Payment"].Errors.Clear();
            ModelState["Gender"].Errors.Clear();
            ModelState["Age"].Errors.Clear();
            ModelState["TestRange"].Errors.Clear();
            ModelState["Payment"].Errors.Clear();
            ModelState["DeliveryDate"].Errors.Clear();
        }

        [HttpGet]
        public ActionResult Edit(int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                ViewBag.DdTestName = new SelectList(dt.GetSearchData(), "TestID", "TestName", id);
                pdTest.PatientTestID = id;
                ViewBag.ChargesValue = pdTest.GetAllDataByID().Charges;
                return View(pdTest.GetAllDataByID());
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult Edit(clsPatientDiagnosticTest obj, FormCollection frm, string submit1)
        {
            dt.TestType = String.IsNullOrEmpty(frm["TestType"]) ? null : Convert.ToString(frm["TestType"].Split(',')[0]);
            ViewBag.DdTestName = new SelectList(dt.GetTestType(), "TestID", "TestName", 0);
            dt.TestID = String.IsNullOrEmpty(frm["TestID"]) ? 0 : Convert.ToInt32(frm["TestID"]);
            ViewBag.ChargesValue = dt.GetAllDataByID().Charges;

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
                pdTest.PatientTestID = id;
                pdTest.DeletedBy = Convert.ToString(UserID);
                pdTest.DeleteMethod();
                return RedirectToAction("Index");
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }


        }

        public ActionResult Print(int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                pdTest.PatientTestID = id;
                DataTable dtable = new DataTable();
                dtable = pdTest.GetForReportByID();

                LocalReport lr = new LocalReport();
                string pathh = Path.Combine(Server.MapPath("~/Reports"), "PatientDiagnosticReport.rdlc");
                if (System.IO.File.Exists(pathh))
                {
                    lr.ReportPath = pathh;
                }
                else
                {
                    return View();
                }

                //ReportDataSource rd = new ReportDataSource("MedicalStoreDataSet", ViewBag.List);
                //lr.DataSources.Add(rd);

                // parameter if necessary

                ReportParameter p0 = new ReportParameter("pDoctorName", dtable.Rows[0]["DoctorName"].ToString());
                ReportParameter p1 = new ReportParameter("pTestName", dtable.Rows[0]["TestName"].ToString());
                ReportParameter p2 = new ReportParameter("pPatientName", dtable.Rows[0]["PatientName"].ToString());
                ReportParameter p3 = new ReportParameter("pContactNo", dtable.Rows[0]["ContactNo"].ToString());
                ReportParameter p4 = new ReportParameter("pRemarks", dtable.Rows[0]["Remarks"].ToString());
                ReportParameter p5 = new ReportParameter("pTestDate", Convert.ToDateTime(dtable.Rows[0]["TestDate"]).ToString("dd/MM/yyyy"));
                ReportParameter p6 = new ReportParameter("pDeliveryDate", Convert.ToDateTime(dtable.Rows[0]["DeliveryDate"]).ToString("dd/MM/yyyy"));
                ReportParameter p7 = new ReportParameter("pStatus", dtable.Rows[0]["Status"].ToString());
                ReportParameter p8 = new ReportParameter("pCharges", dtable.Rows[0]["Charges"].ToString());
                ReportParameter p9 = new ReportParameter("pDiscount", dtable.Rows[0]["Discount"].ToString());

                ReportParameter p10 = new ReportParameter("pPatientTestID", dtable.Rows[0]["PatientTestID"].ToString());
                ReportParameter p11 = new ReportParameter("pLabNumber", dtable.Rows[0]["LabNumber"].ToString());
                ReportParameter p12 = new ReportParameter("pTestGroup", dtable.Rows[0]["TestGroup"].ToString());
                ReportParameter p13 = new ReportParameter("pTestType", dtable.Rows[0]["TestType"].ToString());
                ReportParameter p14 = new ReportParameter("pSymptoms", dtable.Rows[0]["Symptoms"].ToString());
                ReportParameter p15 = new ReportParameter("pPayment", dtable.Rows[0]["Payment"].ToString());
                ReportParameter p16 = new ReportParameter("pGender", dtable.Rows[0]["Gender"].ToString());
                ReportParameter p17 = new ReportParameter("pAge", dtable.Rows[0]["Age"].ToString());
                ReportParameter p18 = new ReportParameter("pTestRange", dtable.Rows[0]["TestRange"].ToString());
                ReportParameter p19 = new ReportParameter("pResult", dtable.Rows[0]["Result"].ToString());

                ReportParameter p20 = new ReportParameter("pPathologist", dtable.Rows[0]["Pathologist"].ToString());
                ReportParameter p21 = new ReportParameter("pTechnologist", dtable.Rows[0]["Technologist"].ToString());


                Decimal total = Convert.ToDecimal(dtable.Rows[0]["Charges"]) - Convert.ToDecimal(dtable.Rows[0]["Discount"]);

                ReportParameter p22 = new ReportParameter("pTotalAmount", total.ToString());

                lr.SetParameters(new ReportParameter[] { p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22 });

                string reportType = "PDF";
                string mimeType;
                string encoding;
                string fileNameExtension;
                string deviceInfo =
                "<DeviceInfo>" +
                "  <OutputFormat>PDF</OutputFormat>" +
                "  <PageWidth>8.5in</PageWidth>" +
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
                Response.AddHeader("content-disposition", "attachment; filename=PatientDiagnosticReport.pdf");
                Response.BinaryWrite(renderedBytes); // create the file
                Response.Flush();


                return File(renderedBytes, mimeType);

                //return View(diagnosticTest.GetAllDataByID());
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }
    }
}
