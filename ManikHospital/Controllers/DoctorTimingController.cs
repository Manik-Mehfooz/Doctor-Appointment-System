using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MedicalStore.Models;
using PagedList;
using PagedList.Mvc;
using vtsMMC.Models;

namespace MedicalStore.Controllers
{
    public class DoctorTimingController : Controller
    {
        clsDoctorTiming DoctorTiming = new clsDoctorTiming();
        clsContact cont = new clsContact();
        [HttpGet]
        public ActionResult Index(int? page)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            int pageSize = 15;
            int pageNumber = (page ?? 1);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                List<clsDoctorTiming> cmp = DoctorTiming.GetSearchData();
                return View(cmp.ToPagedList(pageNumber, pageSize));
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult Index(clsDoctorTiming obj, int? page)
        {
            int pageSize = 15;
            int pageNumber = (page ?? 1);
            List<clsDoctorTiming> cmp = DoctorTiming.GetSearchData();
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
            
                ViewBag.ErrorMessage = "";
                return View();
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult AddNew(clsDoctorTiming obj)
        {
            cont.Search = "Doctor";
            ViewBag.DdDoctor = new SelectList(cont.GetSearchData(), "ContactID", "FullName", 0);
            ViewBag.ErrorMessage = "";
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
                cont.Search = "Doctor";
                ViewBag.DdDoctor = new SelectList(cont.GetSearchData(), "ContactID", "FullName", 0);
            
                ViewBag.ErrorMessage = "";
                DoctorTiming.ID = id;
                return View(DoctorTiming.GetAllDataByID());
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult Edit(clsDoctorTiming obj)
        {
            cont.Search = "Doctor";
            ViewBag.DdDoctor = new SelectList(cont.GetSearchData(), "ContactID", "FullName", 0);
            
            ViewBag.ErrorMessage = "";
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
                DoctorTiming.ID = id;
                DoctorTiming.DeleteMethod();
                return RedirectToAction("Index");
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }
    }
}
