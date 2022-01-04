using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MedicalStore.Models;
using PagedList;
using PagedList.Mvc;
using vtsMMC.Models;
using System.IO;
using CrystalDecisions.CrystalReports;
using CrystalDecisions.CrystalReports.Engine;
using System.Collections;
using ManikHospital.Controllers;


namespace ManikHospital.Controllers
{
    public class PatientRegController : Controller
    {
        clsPatientReg patient = new clsPatientReg();
        clsRoom room = new clsRoom();
        clsContact cont = new clsContact();
        clsConnection objCon = new clsConnection();
        clsPatientSurgery objSurg = new clsPatientSurgery();
        clsDiagnosticTest dt = new clsDiagnosticTest();
        clsTransaction objTrans = new clsTransaction();
        clsPatientPanel pp = new clsPatientPanel();
     //   SalesViewModel objViewModel = new SalesViewModel();

        clsProduct objProd = new clsProduct();
        clsSalesMaster objSalesMaster = new clsSalesMaster();
        clsSalesDetail objSalesDetail = new clsSalesDetail();
        clsProduct ObjProduct = new clsProduct();
       

        [HttpGet]
        public ActionResult Index(int? page)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            int pageSize = 15;
            int pageNumber = (page ?? 1);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                Session["SaleID"] = null;
                Session["ID"] = null;
                Session["INVAdmit"] = null;

                List<clsPatientReg> cmp = patient.GetAllData();
                return View(cmp.ToPagedList(pageNumber, pageSize));
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        public JsonResult GetData()
        {
            JsonResult json = new JsonResult();
            List<clsPatientReg> pregList = patient.GetAllData();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = pregList;
            return json;
        }

        public int AllocateRoom(clsPatientReg obj)
        {
            // 1 means Sucessfully 
            // 0 means UnSuccessfully
            try
            {
                if (obj != null)
                {
                    objCon.ExecuteNonQuery("update RoomStatus set RoomStatus = 'Available' where RoomID = (select RoomID from PatientRegistration Where PatientID =  '" + obj.PatientID + "')");
                    objCon.ExecuteNonQuery("update PatientRegistration set RoomID = '" + obj.RoomID + "' where PatientID = '" + obj.PatientID + "'");
                    objCon.ExecuteNonQuery("update RoomStatus set RoomStatus = 'Alloted' where RoomID = '" + obj.RoomID + "'");
                    //Obj.ExpensesType.Add(expType);
                    //Obj.SaveChanges();
                    return 1;
                }

            }
            catch (Exception exp)
            {
                return 0;
            }
            return 0;
        }

        public JsonResult GetDataByID(int id)
        {
            JsonResult json = new JsonResult();
            patient.PatientID = id;
            clsPatientReg pregList = patient.GetAllDataByID();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = pregList;
            return json;
        }

        [HttpPost]
        public ActionResult Index(clsPatientReg obj, int? page, string btnIsDischage)
        {
            // update Discharge Status here we use reverse condition
            int IsDischarge = (btnIsDischage == "Admit") ? 1 : 0;
            //obj.UpdatePatientStatus(obj.PatientID, IsDischarge);

            int pageSize = 15;
            int pageNumber = (page ?? 1);
            List<clsPatientReg> cmp = patient.GetAllData();
            return View(cmp.ToPagedList(pageNumber, pageSize));
        }

        [HttpGet]
        public ActionResult AddNew()
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                cont.Search = "Doctor";
                ViewBag.DdDoctor = new SelectList(cont.GetSearchData(), "ContactID", "FullName", 0);
                ViewBag.DdRoom = new SelectList(room.GetAllData(), "RoomID", "Room", 0);
                ViewBag.PatientNo = patient.GetPatientNo();
                return View();
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult AddNew(clsPatientReg obj)
        {
            cont.Search = "Doctor";
            ViewBag.DdDoctor = new SelectList(cont.GetSearchData(), "ContactID", "FullName", 0);
            ViewBag.DdRoom = new SelectList(room.GetAllData(), "RoomID", "Room", 0);
            ViewBag.PatientNo = obj.GetPatientNo();

            // some validation for dates
            ModelState.Remove("DateOfBirth");
            ModelState.Remove("SurgeryDate");
            ModelState.Remove("DischargeDate");
            if (ModelState.IsValid)
            {
                int i = obj.SaveMethod();
                if (i > 0)
                {
                    return RedirectToAction("Index");
                }
            }
            return View();
        }

        [HttpGet]
        public ActionResult Edit(int id)
        {
            cont.Search = "Doctor";
            ViewBag.DdDoctor = new SelectList(cont.GetSearchData(), "ContactID", "FullName", 0);
            ViewBag.DdRoom = new SelectList(room.GetAllData(), "RoomID", "Room", 0);
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                //ViewBag.DdpatientType = new SelectList(conttype.GetSearchData(), "patientTypeID", "patientType", id);
                patient.PatientID = id;
                return View(patient.GetAllDataByID());
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult Edit(clsPatientReg obj)
        {
            cont.Search = "Doctor";
            ViewBag.DdDoctor = new SelectList(cont.GetSearchData(), "ContactID", "FullName", 0);
            ViewBag.DdRoom = new SelectList(room.GetAllData(), "RoomID", "Room", 0);
            if (ModelState.IsValid)
            {
                int result = obj.UpdateMethod();
                if (result > 0)
                {
                    return RedirectToAction("Index");
                }
            }
            return View();
        }

        public ActionResult Delete(int id)
        {
            int UserID = Convert.ToInt32(Session["patientID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                patient.PatientID = id;
                patient.DeleteMethod();
                return RedirectToAction("Index");
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpGet]
        public ActionResult Surgery(int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                clsPatientReg pat = new clsPatientReg();
                patient.PatientID = id;
                pat = patient.GetAllDataByID();

                clsFeeType ft = new clsFeeType();
                var feeTypeData = (from f in ft.GetAllData()
                                   select new
                                   {
                                       SurgeryType = f.FeeType
                                   }).Where(x => x.SurgeryType != "OPD").ToList();
                ViewBag.DdFeesType = new SelectList(feeTypeData, "SurgeryType", "SurgeryType", "Minor Surgery");
                ViewBag.DdPatient = new SelectList(patient.GetAllData(), "PatientID", "PatientName", id);
                clsPatientSurgery obj = new clsPatientSurgery();
                obj.PatientID = pat.PatientID;
                obj.DoctorName = pat.DoctorName;

                if (objSurg.GetSearchData().Where(x => x.PatientID == id).Count() > 0)
                {
                    obj = objSurg.GetSearchData().Where(x => x.PatientID == id).SingleOrDefault();
                    obj.SurgeryAmount = obj.GetSurgeryAmount(pat.DoctorID, obj.SurgeryType);
                }
                else
                {
                    obj.SurgeryAmount = obj.GetSurgeryAmount(pat.DoctorID, "Minor Surgery");
                }
                return View(obj);
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult Surgery(clsPatientSurgery obj, int id, string submit1 = "")
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                ViewBag.DdPatient = new SelectList(patient.GetAllData(), "PatientID", "PatientName", obj.PatientID);

                clsFeeType ft = new clsFeeType();
                var feeTypeData = (from f in ft.GetAllData()
                                   select new
                                   {
                                       SurgeryType = f.FeeType
                                   }).Where(x => x.SurgeryType != "OPD").ToList();
                ViewBag.DdFeesType = new SelectList(feeTypeData, "SurgeryType", "SurgeryType", obj.SurgeryType);

                clsPatientReg pat = new clsPatientReg();
                patient.PatientID = id;
                pat = patient.GetAllDataByID();
                obj.PatientID = id;
                obj.DoctorName = pat.DoctorName;
                obj.SurgeryAmount = obj.GetSurgeryAmount(pat.DoctorID, obj.SurgeryType);


                //if (objSurg.GetSearchData().Where(x => x.PatientID == id).Count() > 0)
                //{
                //    objSurg.SurgeryType = obj.SurgeryType;
                //    //obj = objSurg.GetSearchData().Where(x => x.PatientID == id).SingleOrDefault();
                //    obj.SurgeryAmount = obj.GetSurgeryAmount(pat.DoctorID, objSurg.SurgeryType);
                //}
                //else
                //{ 
                //    obj.DoctorName = pat.DoctorName;
                //    obj.SurgeryAmount = obj.GetSurgeryAmount(pat.DoctorID, obj.SurgeryType);
                //}

                if (ModelState.IsValid && submit1.Equals("Save"))
                {
                    int SurgeryID = 0;
                    obj.PatientID = id;
                    int i = 0;
                    if (obj.PatientID > 0)
                    {
                        try
                        {
                            SurgeryID = objSurg.GetSearchData().Where(x => x.PatientID == obj.PatientID).SingleOrDefault().SurgeryID;
                            obj.SurgeryID = SurgeryID;
                            i = obj.UpdateMethod();
                        }
                        catch (Exception exp) { }
                        obj.SurgeryID = SurgeryID;
                    }
                    if (SurgeryID == 0)
                    {
                        i = obj.SaveMethod();
                    }
                    if (i > 0)
                    {
                        return RedirectToAction("Index");
                    }
                }
                return View(obj);
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpGet]
        public ActionResult Test(int id)
        {
            dt.Search = "Lab";
            ViewBag.DdTestName = new SelectList(dt.GetSearchData(), "TestID", "TestName", 0);

            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                patient.PatientID = id;
                clsPatientReg p = patient.GetAllDataByID();

                clsPatientDiagnosticTest pdt = new clsPatientDiagnosticTest();
                pdt.PatientID = id;
                pdt.Age = p.Age;
                pdt.ContactNo = p.MobileNo;
                pdt.DoctorName = p.DoctorName;
                pdt.Gender = p.Gender;
                pdt.PatientName = p.PatientName;
                pdt.Symptoms = p.Diagnosis;
                pdt.TestDate = DateTime.Now.Date;
                ViewBag.Charges = 0;
                return View(pdt);
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult Test(clsPatientDiagnosticTest obj, string btnType, int id)
        {
            dt.Search = obj.TestType;
            ViewBag.DdTestName = new SelectList(dt.GetSearchData(), "TestID", "TestName", obj.TestID);

            patient.PatientID = id;
            clsPatientReg p = patient.GetAllDataByID();

            obj.PatientID = id;
            obj.Age = p.Age;
            obj.ContactNo = p.MobileNo;
            obj.DoctorName = p.DoctorName;
            obj.Gender = p.Gender;
            obj.PatientName = p.PatientName;
            obj.Symptoms = p.Diagnosis;
            if (dt.GetSearchData().Where(x => x.TestID == obj.TestID).Count() > 0)
            {
                ViewBag.Charges = dt.GetSearchData().Where(x => x.TestID == obj.TestID).SingleOrDefault().Charges;
            }
            else
            {
                ViewBag.Charges = 0;
            }
            obj.Payment = "Not Received";

            if (btnType == "Save")
            {
                if (ModelState.IsValid)
                {
                    int i = obj.SaveMethod();
                    if (i > 0)
                    {
                        return RedirectToAction("Index");
                    }
                }
            }
            return View(obj);
        }

        public JsonResult GetPayByPID(int id)
        {
            JsonResult json = new JsonResult();
            objTrans.PatientID = id;
            List<clsTransaction> transList = objTrans.GetPatientPaymentsByPatID();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = transList;
            return json;
        }

        [HttpGet]
        public ActionResult Payment(int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                ViewBag.RemainBalance = patient.GetPatientRemainBalance(id).ToString();
                ViewBag.DdPatient = new SelectList(patient.GetAllData(), "PatientID", "PatientName", id);
                //clsTransaction obj = objTrans.GetSearchData ().Where(x => x.PatientID == id).SingleOrDefault();
                clsTransaction obj = new clsTransaction();
                obj.PatientID = id;
                obj.PaymentType = "Deposit";
                obj.Amount = 0;
                //obj.PaymentType = "Deposit";
                return View(obj);
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }
        }

        [HttpPost]
        public ActionResult Payment(clsTransaction obj, int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                ViewBag.RemainBalance = patient.GetPatientRemainBalance(id).ToString();
                obj.PatientID = id;
                obj.PaymentType = (String.IsNullOrEmpty(obj.PaymentType) ? "Deposit" : obj.PaymentType);
                ViewBag.DdPatient = new SelectList(patient.GetAllData(), "PatientID", "PatientName", obj.PatientID);
                if (ModelState.IsValid)
                {
                    int i = 0;
                    obj.EnteredBy = UserName;                    
                    if (obj.PatientID > 0 && obj.Amount > 0)
                    {
                        i = obj.SaveMethod();
                        if (i > 0)
                        {
                            return RedirectToAction("Index");
                        }
                    }
                }
                else
                {
                    ModelState.Clear();
                }
                return View();
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpGet]
        public ActionResult Discharge(int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                ViewBag.RemainBalance = patient.GetPatientRemainBalance(id).ToString();
                ViewBag.btnState = "none";
                if (patient.GetPatientRemainBalance(id) <= 0)
                {
                    ViewBag.btnState = "";
                }
                ViewBag.DdPatient = new SelectList(patient.GetAllData(), "PatientID", "PatientName", id);
                clsPatientReg obj = patient.GetAllData().Where(x => x.PatientID == id).SingleOrDefault();

                clsPatientDischarge pd = new clsPatientDischarge();
                pd.PatientID = obj.PatientID;
                return View(pd);
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }
        }

        [HttpPost]
        public ActionResult Discharge(clsPatientDischarge obj, int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                obj.PatientID = id;
                ViewBag.DdPatient = new SelectList(patient.GetAllData(), "PatientID", "PatientName", obj.PatientID);
                ViewBag.btnState = "none";
                ViewBag.RemainBalance = patient.GetPatientRemainBalance(id).ToString();
                if (patient.GetPatientRemainBalance(id) <= 0)
                {
                    ViewBag.btnState = "";

                    if (ModelState.IsValidField("DischargeDate"))
                    {
                        int i = 0;
                        if (obj.PatientID > 0)
                        {
                            //i = obj.DischargePatient();
                            i = obj.SaveMethod();
                            if (i > 0)
                            {
                                return RedirectToAction("Index");
                            }
                        }
                    }
                }
                return View();
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpGet]
        public ActionResult PrintReport(int id)
        {
            List<clsRptPatientReg> allCustomer = new List<clsRptPatientReg>();
            clsRptPatientReg pr = new clsRptPatientReg();
            pr.PatientID = id;
            allCustomer = pr.GetPatientRegInformationByID();

            ReportDocument rd = new ReportDocument();
            rd.Load(Path.Combine(Server.MapPath("~/CrystalReports/"), "rptPatientRegistration.rpt"));

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
            string pdffilename = allCustomer[0].PatientRegNo + "_" + datetime.ToString() + "Patient Registration" + ".pdf";

            //return File(stream, "application/pdf", "CustomerList.pdf");  
            return File(stream, "application/pdf", pdffilename);

        }

        [HttpGet]
        public ActionResult PrintDischargeSummary(int id)
        {
            List<clsRptPatientReg> allCustomer = new List<clsRptPatientReg>();
            clsRptPatientReg pr = new clsRptPatientReg();
            pr.PatientID = id;
            allCustomer = pr.GetPatientRegInformationByID();

            ReportDocument rd = new ReportDocument();
            rd.Load(Path.Combine(Server.MapPath("~/CrystalReports/"), "rptDischargeSummary.rpt"));

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
            string pdffilename = allCustomer[0].PatientRegNo + "_" + datetime.ToString() + "Discharge Summary" + ".pdf";

            //return File(stream, "application/pdf", "CustomerList.pdf");  
            return File(stream, "application/pdf", pdffilename);

        }

        [HttpGet]
        public ActionResult PrintPatientMidicine(int id)
        {
            List<clsRptPatientReg> allCustomer = new List<clsRptPatientReg>();
            clsRptPatientReg pr = new clsRptPatientReg();
            pr.PatientID = id;
            allCustomer = pr.GetIndoorPatientMedicineReport();

            ReportDocument rd = new ReportDocument();
            rd.Load(Path.Combine(Server.MapPath("~/CrystalReports/"), "rptPatientMedicine.rpt"));

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
            string pdffilename = allCustomer[0].PatientRegNo + "_" + datetime.ToString() + "Patient Medicine" + ".pdf";

            //return File(stream, "application/pdf", "CustomerList.pdf");  
            return File(stream, "application/pdf", pdffilename);

        }

        [HttpGet]
        public ActionResult PrintPatientTests(int id)
        {
            List<clsRptPatientReg> allCustomer = new List<clsRptPatientReg>();
            clsRptPatientReg pr = new clsRptPatientReg();
            pr.PatientID = id;
            allCustomer = pr.GetIndoorPatientInvestigationTestReport();

            ReportDocument rd = new ReportDocument();
            rd.Load(Path.Combine(Server.MapPath("~/CrystalReports/"), "rptPatientTest.rpt"));

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
            string pdffilename = allCustomer[0].PatientRegNo + "_" + datetime.ToString() + "Patient Tests" + ".pdf";

            //return File(stream, "application/pdf", "CustomerList.pdf");  
            return File(stream, "application/pdf", pdffilename);

        }

        [HttpGet]
        public ActionResult PatientPanel(int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                clsPatientReg pat = new clsPatientReg();
                clsOrganization o = new clsOrganization();
                patient.PatientID = id;
                pat = patient.GetAllDataByID();

                if(pat.PatientCategory == "Panel")
                {
                    ViewBag.DdPatient = new SelectList(patient.GetAllData(), "PatientID", "PatientName", id);
                    ViewBag.DdOrganization = new SelectList(o.GetSearchData(), "OrganizationID", "OrgName", 0);

                    clsPatientPanel obj = new clsPatientPanel();
                    obj.PatientID = id;

                    if (pp.GetSearchData().Where(x => x.PatientID == id).Count() > 0)
                    {
                        obj = pp.GetSearchData().Where(x => x.PatientID == id).SingleOrDefault();
                        ViewBag.DdOrganization = new SelectList(o.GetSearchData(), "OrganizationID", "OrgName", obj.OrganizationID);
                    }
                    return View(obj);
                }
                else
                {
                    return RedirectToAction("../PatientReg/Index");
                }
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult PatientPanel(clsPatientPanel obj, int id, string submit1 = "")
        {
            clsOrganization o = new clsOrganization();
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                patient.PatientID = id;
                ViewBag.DdPatient = new SelectList(patient.GetAllData(), "PatientID", "PatientName", id);
                ViewBag.DdOrganization = new SelectList(o.GetSearchData(), "OrganizationID", "OrgName", obj.OrganizationID);

                if (ModelState.IsValid && submit1.Equals("Save"))
                {
                    int i = 0;
                    obj.PatientID = id;
                    i = obj.SaveMethod();
                    if (i > 0)
                    {
                        return RedirectToAction("Index");
                    }
                }
                return View(obj);
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }
        }

    
        [HttpGet]
        public ActionResult DeleteRow(int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                objSalesDetail.SaleDetailID = id;
                objSalesDetail.DeleteMethod();

                return RedirectToAction("../PatientReg/IndoorPatientMedicine/" + Convert.ToInt32(Session["PatientID"]));
                Session["PatientID"] = null;
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }
        }

        [HttpGet]
        public ActionResult PrintDepositSlip(int id)
        {
            List<clsRptPatientReg> allCustomer = new List<clsRptPatientReg>();
            clsRptPatientReg pr = new clsRptPatientReg();
            pr.PatientID = id;
            allCustomer = pr.GetPatientRegInformationByID();

            ReportDocument rd = new ReportDocument();
            //rd.Load(Path.Combine(Server.MapPath("~/CrystalReports/"), "rptDepositSlip.rpt"));
            rd.Load(Path.Combine(Server.MapPath("~/CrystalReports/"), "Deposit.rpt"));

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
            string pdffilename = allCustomer[0].PatientRegNo + "_" + datetime.ToString() + "Deposit Slip" + ".pdf";

            //return File(stream, "application/pdf", "CustomerList.pdf");  
            return File(stream, "application/pdf", pdffilename);

        }

        //DeleteTransaction
        public ActionResult DeleteTransaction(int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                clsTransaction objTrans = new clsTransaction();
                objTrans.TransactionID = id;
                objTrans.DeleteTransactionUpdateBalanceOwing();

                
                return RedirectToAction("../PatientReg/Index");
                
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }
        }

        [HttpGet]
        public ActionResult SearchPatient()
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                Session["SearchPatient"] = "";
                return View();
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }
        }

        [HttpPost]
        public ActionResult SearchPatient(string id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                Session["SearchPatient"] = (id == null) ? "" : id.ToLower();
                return View();
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }
        }

        public JsonResult GetDataOnInvoiceNo()
        {
            string Search = Convert.ToString(Session["SearchPatient"]);

            List<clsPatientReg> saleMstList = new List<clsPatientReg>();
            if (Search != "")
            {
                patient.Search = Search;
                saleMstList = patient.GetPatientSearch();

                return Json(saleMstList, JsonRequestBehavior.AllowGet);
            }
            return Json(saleMstList, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public ActionResult AddDiscount(int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                patient.PatientID = id;
                return View(patient.GetPatientInfoForDiscount());
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }
        }

        [HttpPost]
        public ActionResult AddDiscount(clsPatientReg obj, int id, string submit1 = "")
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                patient.PatientID = id;
                patient.DiscountAmount = obj.DiscountAmount;
                patient.AddNewDiscountAfterPatientDischarge();
                return RedirectToAction("../PatientReg/Index");
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }
        }

      
      
        public string GetNewInvoiceNumber()
        {
            string ret = "";

            string InvNo = null;
            DateTime InvDate = DateTime.Now;
            string year = Convert.ToString(InvDate.Year);
            string yearP = Convert.ToString(InvDate.Year);
            string DayP = Convert.ToString(InvDate.Day);
            if (DayP.Length == 1)
            {
                DayP = "0" + InvDate.Day;
            }
            else
            {
                DayP = Convert.ToString(InvDate.Day);
            }

            year = year.Substring(2, 2);
            string Month = Convert.ToString(InvDate.Month);
            string CodeMonth = null;
            if (Month == "1")
            {
                CodeMonth = "01";
            }
            else if (Month == "2")
            {
                CodeMonth = "02";
            }
            else if (Month == "3")
            {
                CodeMonth = "03";
            }
            else if (Month == "4")
            {
                CodeMonth = "04";
            }
            else if (Month == "5")
            {
                CodeMonth = "05";
            }
            else if (Month == "6")
            {
                CodeMonth = "06";
            }
            else if (Month == "7")
            {
                CodeMonth = "07";
            }
            else if (Month == "8")
            {
                CodeMonth = "08";
            }
            else if (Month == "9")
            {
                CodeMonth = "09";
            }
            else
            {
                CodeMonth = Month;
            }

            string LastINVNo = objSalesMaster.GetLastINVNo(Convert.ToInt32(Month), Convert.ToInt32(yearP), Convert.ToInt32(DayP));
            int PreviousMonth = 0;
            int Previousday = 0;
            string LastCode = null;
            if (string.IsNullOrEmpty(LastINVNo) || LastINVNo == "99999")
            {
                LastCode = "00001";
            }
            else
            {
                int LastCodee = 0;
                LastCodee = Convert.ToInt32(LastINVNo);


                if (LastCodee < 10)
                {
                    if (LastCodee == 9)
                    {
                        LastCode = "000" + (LastCodee + 1);
                    }
                    else
                    {
                        LastCode = "0000" + (LastCodee + 1);
                    }

                }
                else if (LastCodee < 100 | LastCodee == 10)
                {
                    if (LastCodee == 99)
                    {
                        LastCode = "00" + (LastCodee + 1);
                    }
                    else
                    {
                        LastCode = "000" + (LastCodee + 1);
                    }

                }
                else if (LastCodee < 10000 | LastCodee == 1000)
                {
                    if (LastCodee == 999)
                    {
                        LastCode = "0" + (LastCodee + 1);

                    }
                    else
                    {
                        LastCode = Convert.ToString((LastCodee + 1));
                    }
                }
                else
                {
                    LastCode = Convert.ToString((LastCodee + 1));
                }

            }

            ret = "INV" + "-" + DayP + "-" + CodeMonth + "-" + yearP + "-" + LastCode;

            return ret;
        }
    }
}
