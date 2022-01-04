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
    public class RoomController : Controller
    {
        clsRoom room = new clsRoom();
      
        [HttpGet]
        public ActionResult Index(int? page)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            int pageSize = 15;
            int pageNumber = (page ?? 1);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                List<clsRoom> cmp = room.GetAllData();
                return View(cmp.ToPagedList(pageNumber, pageSize));
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        public JsonResult GetAvailableRoom()
        {
            JsonResult json = new JsonResult();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = room.GetRoomsForAlloted().Where(x => x.RoomStatus == "Available");
            return json;
        }

        public JsonResult GetAvailableRoomByPatientID(int id)
        { 
            JsonResult json = new JsonResult();
            json.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            json.Data = room.GetRoomsForAllotedByPatientID(id);
            return json;
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
        public ActionResult AddNew(clsRoom obj)
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
                room.RoomID = id;
                return View(room.GetAllDataByID());
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult Edit(clsRoom obj)
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
                room.RoomID = id;
                room.DeleteMethod();
                return RedirectToAction("Index");
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }
    }
}
