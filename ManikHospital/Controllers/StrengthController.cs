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
    public class StrengthController : Controller
    {
        clsStrength strength = new clsStrength();

        [HttpGet]
        public ActionResult Index(int? page)
        {
            int pageSize = 15;
            int pageNumber = (page ?? 1);
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                strength.Search = "";
                List<clsStrength> cmp = strength.GetSearchData();
                return View(cmp.ToPagedList(pageNumber, pageSize));
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult Index(clsStrength obj, int? page)
        {
            int pageSize = 15;
            int pageNumber = (page ?? 1);
            strength.Search = obj.Search;
            List<clsStrength> cmp = strength.GetSearchData();
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
        public ActionResult AddNew(clsStrength obj, string b)
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
                            return RedirectToAction("../Product/AddNew");
                        }
                        else
                            return RedirectToAction("Index");
                    }
                }
                ViewBag.ErrorMessage = obj.Strength + " is already exist";
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
                strength.StrengthID = id;
                return View(strength.GetAllDataByID());
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult Edit(clsStrength obj)
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
                ViewBag.ErrorMessage = obj.Strength + " is already exist";
            }
            return View();
        }

        public ActionResult Delete(int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                strength.StrengthID = id;
                strength.DeleteMethod();
                return RedirectToAction("Index");
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }
    }
}
