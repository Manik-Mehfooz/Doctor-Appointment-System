using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MedicalStore.Models;
using PagedList;
using PagedList.Mvc;

namespace vtsMMC.Controllers
{
    public class DoctorFeeController : Controller
    {
        //
        // GET: /DoctorFee/
        clsDoctorFee df = new clsDoctorFee();
        clsContact cc = new clsContact();
        clsFeeType ft = new clsFeeType();

        public ActionResult Index(int? page)
        {
            int pageSize = 15;
            int pageNumber = (page ?? 1);
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                List<clsDoctorFee> cmp = df.GetAllData();
                return View(cmp.ToPagedList(pageNumber, pageSize));
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }
        }
        public ActionResult Delete(int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                df.FeeID = id;
                df.DeleteMethod();
                return RedirectToAction("Index");
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpGet]
        public ActionResult AddNew()
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                cc.Search = "Doctor";
                ViewBag.DdDoctorName = new SelectList(cc.GetSearchData(), "ContactID", "FirstName", 0);
                ViewBag.FeeType = new SelectList(ft.GetAllData(), "FeeTypeID", "FeeType", 0);
                return View();
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult AddNew(clsDoctorFee obj)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                cc.Search = "Doctor";
                ViewBag.DdDoctorName = new SelectList(cc.GetSearchData(), "ContactID", "FirstName", 0);
                ViewBag.FeeType = new SelectList(ft.GetAllData(), "FeeTypeID", "FeeType", 0);
                int i = obj.SaveMethod();
                if (i > 0)
                {
                    return RedirectToAction("Index");
                }
                return View();
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }
        }

        [HttpGet]
        public ActionResult Edit(int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                cc.Search = "Doctor";
                ViewBag.DdDoctorName = new SelectList(cc.GetSearchData(), "ContactID", "FirstName", 0);
                ViewBag.FeeType = new SelectList(ft.GetAllData(), "FeeTypeID", "FeeType", 0);
                df.FeeID = id;
                return View(df.GetAllDataByID());
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }
        [HttpPost]
        public ActionResult Edit(clsDoctorFee obj)
        {
            cc.Search = "Doctor";
            ViewBag.DdDoctorName = new SelectList(cc.GetSearchData(), "ContactID", "FirstName", 0);
            ViewBag.FeeType = new SelectList(ft.GetAllData(), "FeeTypeID", "FeeType", 0);
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
    }
}
