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
    public class DepartmentController : Controller
    {
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
                List<clsDepartment> dep = dept.GetAllData();
                return View(dep.ToPagedList(pageNumber, pageSize));
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult Index(clsDepartment obj, int? page)
        {
            int pageSize = 15;
            int pageNumber = (page ?? 1);
            List<clsDepartment> dep = dept.GetAllData();
            return View(dep.ToPagedList(pageNumber, pageSize));
        }

        [HttpGet]
        public ActionResult AddNew()
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
        public ActionResult AddNew(clsDepartment obj)
        {
            ViewBag.ErrorMessage = "";
            if (ModelState.IsValid)
            {
                if (obj.CheckExitData(0))
                {
                    int i = obj.SaveMethod();
                    if (i > 0)
                    {
                        return RedirectToAction("Index");
                    }
                }
                ViewBag.ErrorMessage = obj.DeptName + " is already exist";
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
                ViewBag.ErrorMessage = "";
                dept.DeptID = id;
                return View(dept.GetAllDataByID());
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult Edit(clsDepartment obj)
        {
            ViewBag.ErrorMessage = "";
            if (ModelState.IsValid)
            {
                if (obj.CheckExitData(1))
                {
                    int result = obj.UpdateMethod();
                    if (result > 0)
                    {
                        return RedirectToAction("Index");
                    }
                }
                ViewBag.ErrorMessage = obj.DeptName + " is already exist";
            }
            return View();
        }

        public ActionResult Delete(int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                dept.DeptID = id;
                dept.DeleteMethod();
                return RedirectToAction("Index");
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }
    }
}
