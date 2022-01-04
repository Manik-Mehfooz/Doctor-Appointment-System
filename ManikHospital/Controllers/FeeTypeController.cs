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
    public class FeeTypeController : Controller
    {
        //
        // GET: /FeeType/
        clsFeeType ft = new clsFeeType();

        public ActionResult Index(int? page)
        {
            int pageSize = 15;
            int pageNumber = (page ?? 1);
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                List<clsFeeType> cmp = ft.GetAllData();
                return View(cmp.ToPagedList(pageNumber, pageSize));
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
                return View();
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult AddNew(clsFeeType obj)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {                
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
                ft.FeeTypeID = id;
                return View(ft.GetAllDataByID());
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
                ft.FeeTypeID = id;
                ft.DeleteMethod();
                return RedirectToAction("Index");
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }
        [HttpPost]
        public ActionResult Edit(clsFeeType obj)
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
    }
}
