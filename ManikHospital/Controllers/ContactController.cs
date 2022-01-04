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
    public class ContactController : Controller
    {
        clsContact contact = new clsContact();
        clsContactType conttype = new clsContactType();
        clsDepartment dept = new clsDepartment();

        [HttpGet]
        public ActionResult Index(int? page)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            int pageSize = 15;
            int pageNumber = (page ?? 1);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                contact.Search = "";
                List<clsContact> cmp = contact.GetSearchData();
                return View(cmp.ToPagedList(pageNumber, pageSize));
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult Index(clsContactType obj, int? page)
        {
            int pageSize = 15;
            int pageNumber = (page ?? 1);
            contact.Search = obj.Search;
            List<clsContact> cmp = contact.GetSearchData();
            return View(cmp.ToPagedList(pageNumber, pageSize));
        }

        [HttpGet]
        public ActionResult Doctors()
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
        public ActionResult Staff()
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
        public ActionResult AddNew()
        {
            // here id is the ContactType
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                ViewBag.DdContactType = new SelectList(conttype.GetSearchData(), "ContactTypeID", "ContactType", 0);
                ViewBag.DdDepartment = new SelectList(dept.GetAllData(), "DeptID", "DeptName", 0);
                return View();
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult AddNew(clsContact obj)
        {
            ViewBag.DdContactType = new SelectList(conttype.GetSearchData(), "ContactTypeID", "ContactType", 0);
            ViewBag.DdDepartment = new SelectList(dept.GetAllData(), "DeptID", "DeptName", 0);
            if (ModelState.IsValid)
            {
                obj.JoiningDate = DateTime.Now;

                int i = obj.SaveMethod();
                if (i > 0)
                {
                    return RedirectToAction("Doctors");
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
        public ActionResult Edit(clsContact obj)
        {
            ViewBag.DdContactType = new SelectList(conttype.GetSearchData(), "ContactTypeID", "ContactType", obj.ContactTypeID);
            ViewBag.DdDepartment = new SelectList(dept.GetAllData(), "DeptID", "DeptName", obj.DepartmentID);
            if (ModelState.IsValid)
            {
                obj.JoiningDate = DateTime.Now;

                int result = obj.UpdateMethod();
                if (result > 0)
                {
                    return RedirectToAction("Doctors");
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
                return RedirectToAction("Index");
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }
    }
}
