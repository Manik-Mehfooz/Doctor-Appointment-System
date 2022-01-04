using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MedicalStore.Models;
using PagedList;
using PagedList.Mvc;
using CrystalDecisions.CrystalReports.Engine;
using System.IO;
using System.Globalization;

namespace vtsMMC.Controllers
{
    public class EmplyeeSalaryController : Controller
    {
        //
        // GET: /EmplyeeSalary/
        clsContact cc = new clsContact();
        clsEmployeeWages ew = new clsEmployeeWages();

        [HttpGet]
        public ActionResult Index(int? page)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            int pageSize = 15;
            int pageNumber = (page ?? 1);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                List<clsEmployeeWages> cmp = ew.GetAllWagesData();
                ViewBag.List = cmp.ToPagedList(pageNumber, pageSize);
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
                ViewBag.DdEmployees = new SelectList(cc.GetAllEmployeeDataNotDoctor(), "ContactID", "FullName", 0);
                ViewBag.ErrorMessage = "";
                return View();
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        [HttpPost]
        public ActionResult AddNew(clsEmployeeWages obj)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {                
                ViewBag.DdEmployees = new SelectList(cc.GetAllEmployeeDataNotDoctor(), "ContactID", "FullName", 0);
                ew.EnteredBy = Session["UserName"].ToString();
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
                ViewBag.DdEmployees = new SelectList(cc.GetAllEmployeeDataNotDoctor(), "ContactID", "FullName", 0);
                ew.WagesID = id;
                return View(ew.GetAllDataByID());
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }
        [HttpPost]
        public ActionResult Edit(clsEmployeeWages obj)
        {
            ViewBag.DdEmployees = new SelectList(cc.GetAllEmployeeDataNotDoctor(), "ContactID", "FullName", 0);
            
            if (ModelState.IsValid)
            {
                ew.EnteredBy = Session["UserName"].ToString();
                int result = obj.UpdateMethod();
                if (result > 0)
                {
                    return RedirectToAction("Index");
                }
            }
            return View();
        }

        [HttpGet]
        public ActionResult Delete(int id)
        {
            int UserID = Convert.ToInt32(Session["ContactID"]);
            string UserName = Convert.ToString(Session["UserName"]);
            if (UserID > 0 && (UserName != null || UserName != ""))
            {
                ew.WagesID = id;
                ew.EnteredBy = Session["UserName"].ToString();
                ew.DeleteMethod();
                return RedirectToAction("Index");
            }
            else
            {
                return RedirectToAction("../Users/Login");
            }

        }

        public ActionResult EmployeeSalaryReport()
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
        public ActionResult EmployeeSalaryReport(clsEmployeeWages obj, FormCollection frm)
        {
           
            ew.SalaryMonth = frm["SalaryMonth"];
            ew.SalaryYear = frm["SalaryYear"];

            string SalaryMonth = frm["SalaryMonth"];
            string SalaryYear = frm["SalaryYear"];

            List<clsEmployeeWages> allCustomer = new List<clsEmployeeWages>();

            //ViewBag.List = exp.ExpensesReport();
            allCustomer = ew.GetEmployeeMonthlySalaryReport();

            ReportDocument rd = new ReportDocument();
            rd.Load(Path.Combine(Server.MapPath("~/CrystalReports/"), "rptEmployeeSalary.rpt"));

            rd.SetDataSource(allCustomer);
            rd.SetParameterValue("SalaryMonth", SalaryMonth);
            rd.SetParameterValue("SalaryYear", SalaryYear);

            Response.Buffer = false;
            Response.ClearContent();
            Response.ClearHeaders();

            Stream stream = rd.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
            stream.Seek(0, SeekOrigin.Begin);

            string datetime = "";
            string time = DateTime.Now.Hour.ToString() + DateTime.Now.Minute.ToString() + DateTime.Now.Second.ToString();         // User current time
            string dt = DateTime.Now.Day.ToString() + DateTime.Now.Month.ToString() + DateTime.Now.Year.ToString();              // Use current date
            dt = dt.ToString().Replace('/', '_');
            datetime = dt + "_" + time;
            string pdffilename = "Employee Salary Report" + ".pdf";

            //return File(stream, "application/pdf", "CustomerList.pdf");  
            return File(stream, "application/pdf", pdffilename);
        }

    }
}
