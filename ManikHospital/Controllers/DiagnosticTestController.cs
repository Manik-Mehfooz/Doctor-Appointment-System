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
    public class DiagnosticTestController : Controller
    {
        clsDiagnosticTest diagnosticTest = new clsDiagnosticTest();

        [HttpGet]
        public ActionResult Index(int? page)
        {
            int pageSize = 15;
            int pageNumber = (page ?? 1);
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                diagnosticTest.Search = "";
                List<clsDiagnosticTest> cmp = diagnosticTest.GetSearchData();
                return View(cmp.ToPagedList(pageNumber, pageSize));
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult Index(clsDiagnosticTest obj, int? page)
        {
            int pageSize = 15;
            int pageNumber = (page ?? 1);
            diagnosticTest.Search = obj.Search;
            List<clsDiagnosticTest> cmp = diagnosticTest.GetSearchData();
            return View(cmp.ToPagedList(pageNumber, pageSize));
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
        public ActionResult AddNew(clsDiagnosticTest obj, string b)
        {
            ViewBag.ErrorMessage = "";
            if (ModelState.IsValid)
            {
                if (obj.CheckExitData(0))
                {
                    int i = obj.SaveMethod();
                    if (i > 0)
                    {
                        if (b == "back")
                        {
                            return RedirectToAction("../PatientDiagnosticTest/AddNew");
                        }
                        else
                            return RedirectToAction("Index");
                    }
                }
                ViewBag.ErrorMessage = obj.TestName + " is already exist";
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
                diagnosticTest.TestID = id;
                return View(diagnosticTest.GetAllDataByID());
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult Edit(clsDiagnosticTest obj)
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
                ViewBag.ErrorMessage = obj.TestName + " is already exist";
            }
            return View();
        }

        public ActionResult Delete(int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                diagnosticTest.TestID = id;
                diagnosticTest.DeleteMethod();
                return RedirectToAction("Index");
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }
    }
}
