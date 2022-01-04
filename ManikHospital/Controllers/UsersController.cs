using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MedicalStore.Models;
using System.Data;
using System.Web.Security;
using vtsMMC.Models;

namespace MedicalStore.Controllers
{
    public class UsersController : Controller
    {
        clsUsers user = new clsUsers();
        clsContact Contact = new clsContact();
        clsProduct product = new clsProduct();
        clsRMForm OrmForm = new clsRMForm();

        clsContact Objtcontact = new clsContact();
        clsDepartment objdept = new clsDepartment();
        clsDailyOPDToken objOPD = new clsDailyOPDToken();
        clsOutDoorPatientTest objtest = new clsOutDoorPatientTest();
        clsRoom objroom = new clsRoom();
        clsPatientReg pr = new clsPatientReg();
        

        public ActionResult Index()
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                MenuGenerate();

                clsDashBoard db = new clsDashBoard();

                ViewBag.TotalDoctors = Objtcontact.GetSearchData().ToList().Where(x => x.ContactType.ToLower().Equals("doctor")).ToList().Count().ToString();
                //ViewBag.TotalStaff = Objtcontact.GetSearchData().ToList().Where(x => x.ContactType.ToLower().Equals("staff")).ToList().Count().ToString();
                //ViewBag.TotalDepartment = objdept.GetAllData().ToList().Count().ToString();
                ViewBag.TotalTodaysToken = objOPD.GetTodayOPDToken().ToList().Count().ToString();
                //ViewBag.TotalTodaysToken = objOPD.GetTodayOPDToken().ToList().Count().ToString();
                ViewBag.TotalTodayInvestigation = objtest.GetSearchData().ToList().Where(x => x.TestDate.ToShortDateString() == DateTime.Now.ToShortDateString()).ToList().Count().ToString();
                //ViewBag.TotalAvailableRooms = objroom.GetAllData().ToList().Where(x => x.RoomStatus.Equals("Available")).ToList().Count().ToString();

                //ViewBag.TotalAdmitPatient = pr.GetAllData().ToList().Where(x => x.IsDischarge == true).ToList().Count().ToString();
                //ViewBag.TotalAdmitPatient = pr.GetAllData().ToList().Count().ToString();
                ViewBag.TotalAdmitPatient = pr.GetTotalAdmitPatientDashboard().ToString();
                
                ViewBag.TodayOPDSaleInvoice = db.TodayOPDSaleInvoice().ToString();

                string saleamount = db.TodayTotalSale();
                ViewBag.TodaySaleAmount = saleamount;

                #region Unused code
                //clsDashBoard db = new clsDashBoard();
                //string testlab = db.GetTodayTotalLabTest();
                //ViewBag.LabTestCount = testlab;

                //string xraycount = db.GetTodayTotalXray();
                //ViewBag.XrayCount = xraycount;

                //string amount = db.TodayTotalPurchase();
                //ViewBag.PurchaseAmount = amount;

                //string saleamount = db.TodayTotalSale();
                //ViewBag.SaleAmount = saleamount;

                //ViewBag.List = db.GetAllExpiraryDateProducts();
                //ViewBag.PaymentList = db.GetAllPaymentReceivable();

                //ViewBag.PurchaseMedicineList = db.GetAllMedicineNeedToPurchase();

                //List <clsProduct > p = product.GetSearchData ();
                //string ProductCount = p.Count.ToString();
                //ViewBag.NoOfProduct = ProductCount;

                // for menu 

//                List<clsRMForm> oParent = new List<clsRMForm>();
//                oParent = OrmForm.GetParentLinks(UserID);

//                string strMenu = "";
//                for (int i = 0; i < oParent.Count; i++)
//                {
//                    string strLink = "";
//                    if (!String.IsNullOrEmpty(oParent[i].Link) || !string.IsNullOrWhiteSpace(oParent[i].Link))
//                    {
//                        strLink = oParent[i].Link;
//                    }
//                    else
//                    {
//                        strLink = "#";
//                    }

//                    strMenu += @"<li class=''>
//                        <a href='"+strLink+ @"'><i class='fa fa-tachometer'></i><span>"+ oParent[i].Name +"</span>";
                    
//                    string StrSubMenu = "";
//                    List<clsRMForm> osubList = new List<clsRMForm>();
//                    osubList = OrmForm.GetParentLinks(UserID, oParent[i].FormId);
//                    if (osubList.Count > 0)
//                    {
//                        strMenu += @"<span class='pull-right-container'>
//                                <i class='fa fa-angle-left pull-right'></i></span>";
//                    }
//                    strMenu += " </a>";

//                    for (int j = 0; j < osubList.Count; j++)
//                    {
//                        if (j == 0)
//                        {
//                            strMenu += @"<ul class='treeview-menu'>";
//                        }

//                        strMenu += @"<li class=''>
//                            <a href='../"+osubList[j].Link+"'><i class='fa fa-arrow-right'></i><span>"
//                                      +osubList[j].Name+"</span></a></li>";

//                        if (j == osubList.Count - 1)
//                        {
//                            strMenu += @"</ul>";
//                        }
//                    }
//                    strMenu += "</li>";
//                }

//                ViewBag.strMenuList = strMenu;
                //                Session["TopMenuBar"] = ViewBag.strMenuList;

                #endregion

                return View();
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpGet]
        public ActionResult Login()
        {
            ViewBag.ErrorMessage = "";
            return View();
        }

        //[HttpPost]
        //public ActionResult Login(clsUsers obj)
        //{
        //    if (ModelState.IsValid)
        //    {
        //        DataTable dt = obj.GetAuthentication();
        //        if (dt.Rows.Count > 0)
        //        {
        //            Session["ContactID"] = Convert.ToString(dt.Rows[0][0]);
        //            Session["UserName"] = Convert.ToString(dt.Rows[0][1]);
        //            return RedirectToAction("Index");
        //        }
        //        ViewBag.ErrorMessage = "Username & Password is not correct";
        //    }
        //    return View();
        //}

        [HttpPost]
        public ActionResult Login(clsContact obj)
        {
            DataTable dt = obj.GetAuthentication();
            if (dt.Rows.Count > 0)
            {
                Session["ContactID"] = Convert.ToString(dt.Rows[0]["ContactID"]);
                Session["UserName"] = Convert.ToString(dt.Rows[0]["ShowName"]);
                Session["ContactType"] = Convert.ToString(dt.Rows[0]["ContactType"]);

                MenuGenerate();
                if(Session["ContactType"].ToString().ToLower() == "staff")
                    return RedirectToAction("AddNew","Sales");
                else
                    return RedirectToAction("Index");
            }
            ViewBag.ErrorMessage = "Username & Password is not correct";
            return View();
        }

        [HttpGet]
        public ActionResult Logout()
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                Session["ContactID"] = "";
                Session["UserName"] = "";
                Session.Abandon();
                Session.Clear();
                FormsAuthentication.SignOut();
                return RedirectToAction("../Users/Login");
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpGet]
        public ActionResult ChangePwd()
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                ViewBag.ErrorMessage = "";
                return View();
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult ChangePwd(clsChangePassword obj)
        {
            ViewBag.ErrorMessage = "";
            if (ModelState.IsValid)
            {
                try
                {
                    obj.UserID = Convert.ToInt32(Session["Contact"]);
                }
                catch (Exception exp) { obj.UserID = 0; }
                int result = obj.UpdatePwdMethod();
                if (result > 0)
                {
                    return RedirectToAction("Index");
                }
                ViewBag.ErrorMessage = "you enter wrong password";
            }
            return View();
        }

        [HttpGet]
        public ActionResult AddNew()
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                return View();
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult AddNew(clsUsers obj)
        {
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
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                user.UserID = id;
                return View(user.GetAllDataByID());
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult Edit(clsUsers obj)
        {
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
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                user.UserID = id;
                user.DeleteMethod();
                return RedirectToAction("Index");
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        #region Menu Start

        public void MenuGenerate()
        {
            clsContact c = new clsContact();
            c.ContactID = Convert.ToInt32(Session["ContactID"]);
            c = c.GetAllDataByID();

            int RoleID = c.ContactTypeID;
            clsAssignPages OrmForm = new clsAssignPages();
            List<clsAssignPages> oParent = new List<clsAssignPages>();
            oParent = OrmForm.GetSearchData().Where(x => x.ContactTypeID == RoleID && x.ParentPageID == 0).ToList();

            string host = Request.Url.Host;
            Uri myurl = new Uri(Request.Url.AbsoluteUri);

            string strMenu = "";
            for (int i = 0; i < oParent.Count; i++)
            {
                string strLink = "";
                strLink =  oParent[i].PageLink;

                //strLink = strLink.Replace("../", "");
                //if (host.Contains("localhost"))
                //    strLink = "http://localhost:5439/" + strLink;
                //else if (host.Contains("127.0.0.1"))
                //    strLink = "http://127.0.0.1/MedicalStore/" + strLink;
                //else
                //    strLink = "http://192.168.1.1/MaidahMedicalCenter/" + strLink;

                //strMenu += @"<li class=''> <a href='" + strLink + @"'><i class='fa fa-list'></i><span>" + oParent[i].LabelName + "</span>";
                if (oParent[i].LabelName.ToLower() == "dashboard")
                    strMenu += @"<li class=''> <a href='" + strLink + @"'><i class='fa fa-tachometer'></i><span>" + oParent[i].LabelName + "</span>";
                else if (oParent[i].LabelName.ToLower() == "user management")
                    strMenu += @"<li class=''> <a href='" + strLink + @"'><i class='fa fa-user'></i><span>" + oParent[i].LabelName + "</span>";
                else if (oParent[i].LabelName.ToLower().Contains("center"))
                    strMenu += @"<li class=''> <a href='" + strLink + @"'><i class='fa fa-hospital-o'></i><span>" + oParent[i].LabelName + "</span>";
                else if (oParent[i].LabelName.ToLower().Contains("human"))
                    strMenu += @"<li class=''> <a href='" + strLink + @"'><i class='fa fa-users'></i><span>" + oParent[i].LabelName + "</span>";
                else if (oParent[i].LabelName.ToLower() == "finance")
                    strMenu += @"<li class=''> <a href='" + strLink + @"'><i class='fa fa-dollar'></i><span>" + oParent[i].LabelName + "</span>";
                else if (oParent[i].LabelName.ToLower().Contains("report"))
                    strMenu += @"<li class=''> <a href='" + strLink + @"'><i class='fa fa-file'></i><span>" + oParent[i].LabelName + "</span>";
                else
                    strMenu += @"<li class=''> <a href='" + strLink + @"'><i class='fa fa-list'></i><span>" + oParent[i].LabelName + "</span>";

                List<clsAssignPages> osubList = new List<clsAssignPages>();
                //osubList = OrmForm.GetParentLinks(RoleID, oParent[i].FormRoleID);
                osubList = OrmForm.GetSearchData().Where(x => x.ContactTypeID == RoleID && x.ParentPageID == oParent[i].AssignPageID).ToList();
                if (osubList.Count > 0)
                {
                    strMenu += @"<span class='pull-right-container'>
                                <i class='fa fa-angle-left pull-right'></i></span>";
                }
                strMenu += " </a>";

                for (int j = 0; j < osubList.Count; j++)
                {
                    if (j == 0)
                    {
                        strMenu += @"<ul class='treeview-menu'>";
                    }

                    string childlink = osubList[j].PageLink;
                    //childlink = childlink.Replace("../", "~/");

                    //childlink = childlink.Replace("../", "");

                    //if (host.Contains("localhost"))
                    //    childlink = "http://localhost:5439/" + childlink;
                    //else if (host.Contains("127.0.0.1"))
                    //    childlink = "http://127.0.0.1/MedicalStore/" + childlink;
                    //else
                    //    childlink = "http://192.168.1.1/MaidahMedicalCenter/" + childlink;

                    strMenu += @"<li class=''>
                            <a href='" + childlink + "'><i class='fa fa-arrow-right'></i><span>"
                                  + osubList[j].LabelName + "</span></a></li>";

                    if (j == osubList.Count - 1)
                    {
                        strMenu += @"</ul>";
                    }
                }
                strMenu += "</li>";
            }
            ViewBag.strMenuList = strMenu;
            Session["MenuBar"] = ViewBag.strMenuList;
        }

//        public void MenuGenerate()
//        {
//            clsContact c = new clsContact();
//            c.ContactID = Convert.ToInt32(Session["ContactID"]);
//            c = c.GetAllDataByID();

//            int RoleID = c.ContactTypeID;
//            clsForm OrmForm = new clsForm();
//            List<clsForm> oParent = new List<clsForm>();
//            oParent = OrmForm.GetParentLinks(RoleID);

//            string strMenu = "";
//            for (int i = 0; i < oParent.Count; i++)
//            {
//                string strLink = "";
//                strLink = oParent[i].LabelLink;
//                strMenu += @"<li class=''>
//                        <a href='../" + strLink + @"'><i class='fa fa-list'></i><span>" + oParent[i].LabelName + "</span>";
//                List<clsForm> osubList = new List<clsForm>();
//                osubList = OrmForm.GetParentLinks(RoleID, oParent[i].FormRoleID);
//                if (osubList.Count > 0)
//                {
//                    strMenu += @"<span class='pull-right-container'>
//                                <i class='fa fa-angle-left pull-right'></i></span>";
//                }
//                strMenu += " </a>";

//                for (int j = 0; j < osubList.Count; j++)
//                {
//                    if (j == 0)
//                    {
//                        strMenu += @"<ul class='treeview-menu'>";
//                    }

//                    strMenu += @"<li class=''>
//                            <a href='../" + osubList[j].LabelLink + "'><i class='fa fa-arrow-right'></i><span>"
//                                  + osubList[j].LabelName + "</span></a></li>";

//                    if (j == osubList.Count - 1)
//                    {
//                        strMenu += @"</ul>";
//                    }
//                }
//                strMenu += "</li>";
//            }
//            ViewBag.strMenuList = strMenu;
//            Session["MenuBar"] = ViewBag.strMenuList;
//        }

        public ActionResult VisualizeMonthlySale()
        {
            List<clsUsers> allCustomer = new List<clsUsers>();

            allCustomer = user.GetDataForChart();

            var reducedList = allCustomer.Select(e => new { e.MonthName, e.Patients }).ToList();

            return Json(reducedList, JsonRequestBehavior.AllowGet);
            //return View();
        }

        public ActionResult VisualizeYearlyPatientList()
        {
            List<clsUsers> allCustomer = new List<clsUsers>();

            allCustomer = user.GetYearlyPatientListDataForChart();

            var reducedList = allCustomer.Select(e => new { e.YearNumber, e.Patients }).ToList();

            return Json(reducedList, JsonRequestBehavior.AllowGet);
            //return View();
        }

        public ActionResult VisualizeMonthlyOPD()
        {
            List<clsUsers> allCustomer = new List<clsUsers>();

            allCustomer = user.GetMonthlyOPDListDataForChart();

            var reducedList = allCustomer.Select(e => new { e.OPDDay, e.OPD }).ToList();

            return Json(reducedList, JsonRequestBehavior.AllowGet);
            //return View();
        }

        public ActionResult VisualizeYearlyOPD()
        {
            List<clsUsers> allCustomer = new List<clsUsers>();

            allCustomer = user.GetYearlyOPDListDataForChart();

            var reducedList = allCustomer.Select(e => new { e.OPDMonth, e.OPD }).ToList();

            return Json(reducedList, JsonRequestBehavior.AllowGet);
            //return View();
        }

        #endregion Menu End
    }
}
