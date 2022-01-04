using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MedicalStore.Models;
using PagedList;
using PagedList.Mvc;

namespace MedicalStore.Controllers
{
    public class EmployeeController : Controller
    {
        clsContact contact = new clsContact();
        clsContactType conttype = new clsContactType();
        clsDepartment dept = new clsDepartment();

        [HttpGet]
        public ActionResult EmployeeList()
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

        [HttpGet]
        public ActionResult AddEmployee()
        {
            // here id is the ContactType
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                ViewBag.DdContactType = new SelectList(conttype.GetSearchData(), "ContactTypeID", "ContactType", 0);
                ViewBag.DdDepartment = new SelectList(dept.GetAllData(), "DeptID", "DeptName", 0);

                ViewBag.JoiningDate = DateTime.Now.ToShortDateString();

                return View();
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult AddEmployee(clsContact obj)
        {
            ViewBag.DdContactType = new SelectList(conttype.GetSearchData(), "ContactTypeID", "ContactType", 0);
            ViewBag.DdDepartment = new SelectList(dept.GetAllData(), "DeptID", "DeptName", 0);

            ViewBag.JoiningDate = DateTime.Now.ToShortDateString();

            if (ModelState.IsValid)
            {
                int i = obj.SaveMethod();
                if (i > 0)
                {
                    return RedirectToAction("EmployeeList");
                }
            }
            return View();
        }

        [HttpGet]
        public ActionResult EditEmployee(int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                contact.ContactID = id;
                clsContact con = new clsContact();
                con = contact.GetAllDataByID();
                ViewBag.DdContactType = new SelectList(conttype.GetSearchData(), "ContactTypeID", "ContactType", con.ContactTypeID);
                ViewBag.DdDepartment = new SelectList(dept.GetAllData(), "DeptID", "DeptName", con.DepartmentID);
                return View(con);
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult EditEmployee(clsContact obj)
        {
            ViewBag.DdContactType = new SelectList(conttype.GetSearchData(), "ContactTypeID", "ContactType", obj.ContactTypeID);
            ViewBag.DdDepartment = new SelectList(dept.GetAllData(), "DeptID", "DeptName", obj.DepartmentID);
            if (ModelState.IsValid)
            {
                int result = obj.UpdateMethod();
                if (result > 0)
                {
                    return RedirectToAction("EmployeeList");
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
                contact.ContactID = id;
                contact.DeletedBy = Convert.ToString(UserID);
                contact.DeleteMethod();
                return RedirectToAction("EmployeeList");
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }
    }
}
