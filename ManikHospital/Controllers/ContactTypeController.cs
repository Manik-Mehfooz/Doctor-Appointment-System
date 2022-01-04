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
    public class ContactTypeController : Controller
    {
        clsContactType contactType = new clsContactType();

        [HttpGet]
        public ActionResult Index(int? page)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            int pageSize = 15;
            int pageNumber = (page ?? 1);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                contactType.Search = "";
                List<clsContactType> cmp = contactType.GetSearchData();
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
            contactType.Search = obj.Search;
            List<clsContactType> cmp = contactType.GetSearchData();
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
        public ActionResult AddNew(clsContactType obj)
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
                ViewBag.ErrorMessage = obj.ContactType + " is already exist";
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
                contactType.ContactTypeID = id;
                return View(contactType.GetAllDataByID());
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult Edit(clsContactType obj)
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
                ViewBag.ErrorMessage = obj.ContactType + " is already exist";
            }
            return View();
        }

        public ActionResult Delete(int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                contactType.ContactTypeID = id;
                contactType.DeleteMethod();
                return RedirectToAction("Index");
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }
    }
}
