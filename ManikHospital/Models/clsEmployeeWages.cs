using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace MedicalStore.Models
{
    [Table("EmplyeeWages")]
    public class clsEmployeeWages
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _WagesID;
        private int _ContactID;
        private string _PaymentType;
        private decimal _SalaryAmount;
        private decimal _LoanAmount;
        private DateTime _SalaryDate;
        private string _Remarks;
        private string _EnteredBy;

        private string _SalaryMonth;
        private string _SalaryYear;

        #endregion 

        #region Properties

        public int WagesID { get { return _WagesID; } set { _WagesID = value; } }

        [Display(Name = "Employee Name"), Required(ErrorMessage = "Please Select Employee")]
        public int ContactID { get { return _ContactID; } set { _ContactID = value; } }

        [Display(Name = "Payment Type"), Required(ErrorMessage = "Please Select Payment Type")]
        public string PaymentType { get { return _PaymentType; } set { _PaymentType = value; } }

        [Display(Name = "Amount"), Required(ErrorMessage = "Please Enter Salary Amount")]
        public decimal SalaryAmount { get { return _SalaryAmount; } set { _SalaryAmount = value; } }

        [Display(Name = "Loan")]
        public decimal LoanAmount { get { return _LoanAmount; } set { _LoanAmount = value; } }

        [Display(Name = "Salary Date")]
        public DateTime SalaryDate { get { return _SalaryDate; } set { _SalaryDate = value; } }
        public string Remarks { get { return _Remarks; } set { _Remarks = value; } }
        public string EnteredBy { get { return _EnteredBy; } set { _EnteredBy = value; } }

        public string ContactType { get; set; }
        public string EmployeeName { get; set; }
        public string Mobile { get; set; }

        public string SalaryMonth { get { return _SalaryMonth; } set { _SalaryMonth = value; } }
        public string SalaryYear { get { return _SalaryYear; } set { _SalaryYear = value; } }

        public int Index { get; set; }
        public string Name { get; set; }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ContactID",_ContactID),
                new SqlParameter("@PaymentType",_PaymentType),
                new SqlParameter("@SalaryAmount",_SalaryAmount),
                new SqlParameter("@LoanAmount",_LoanAmount),
                new SqlParameter("@SalaryDate",_SalaryDate),
                new SqlParameter("@Remarks",_Remarks),
                new SqlParameter("@EnteredBy",_EnteredBy),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_EmployeeWages");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@WagesID",_WagesID),
                new SqlParameter("@ContactID",_ContactID),
                new SqlParameter("@PaymentType",_PaymentType),
                new SqlParameter("@SalaryAmount",_SalaryAmount),
                new SqlParameter("@LoanAmount",_LoanAmount),
                new SqlParameter("@SalaryDate",_SalaryDate),
                new SqlParameter("@Remarks",_Remarks),
                new SqlParameter("@EnteredBy",_EnteredBy),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_EmployeeWages");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@WagesID",_WagesID),  
                new SqlParameter("@EnteredBy",_EnteredBy),  
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_EmployeeWages");
        }

        #endregion

        #region DDL Methods       

        public clsEmployeeWages GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@WagesID",_WagesID),  
                new SqlParameter("@ModeType", "GETDATABYID"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_EmployeeWages");
            clsEmployeeWages obj = new clsEmployeeWages();            
            if (dt.Rows.Count > 0)
            {
                obj = AssignValuesByID(obj, dt, 0);
            }
            return obj;
        }

        protected clsEmployeeWages AssignValuesByID(clsEmployeeWages obj, DataTable dt, int row)
        {
            obj.WagesID = Convert.ToInt32(dt.Rows[row]["WagesID"]);
            obj.ContactID = Convert.ToInt32(dt.Rows[row]["ContactID"]);
            obj.PaymentType = Convert.ToString(dt.Rows[row]["PaymentType"]);
            obj.SalaryAmount = Convert.ToDecimal(dt.Rows[row]["SalaryAmount"]);
            obj.LoanAmount = Convert.ToDecimal(dt.Rows[row]["LoanAmount"]);
            obj.SalaryDate = Convert.ToDateTime(dt.Rows[row]["SalaryDate"]);
            obj.Remarks = Convert.ToString(dt.Rows[row]["Remarks"]);
            return obj;
        }

        public List<clsEmployeeWages> GetAllWagesData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {                  
                new SqlParameter("@ModeType", "GETALLDATA"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_EmployeeWages");
            List<clsEmployeeWages> list = new List<clsEmployeeWages>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsEmployeeWages obj = new clsEmployeeWages();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }  
            return list;
        }
        protected clsEmployeeWages AssignValues(clsEmployeeWages obj, DataTable dt, int row)
        {
            obj.WagesID = Convert.ToInt32(dt.Rows[row]["WagesID"]);
            obj.ContactID = Convert.ToInt32(dt.Rows[row]["ContactID"]);
            obj.PaymentType = Convert.ToString(dt.Rows[row]["PaymentType"]);
            obj.SalaryAmount = Convert.ToDecimal(dt.Rows[row]["SalaryAmount"]);
            obj.LoanAmount = Convert.ToDecimal(dt.Rows[row]["LoanAmount"]);
            obj.SalaryDate = Convert.ToDateTime(dt.Rows[row]["SalaryDate"]);
            obj.Remarks = Convert.ToString(dt.Rows[row]["Remarks"]);
            obj.ContactType = Convert.ToString(dt.Rows[row]["ContactType"]);
            obj.EmployeeName = Convert.ToString(dt.Rows[row]["EmployeeName"]);
            return obj;
        }


        public List<clsEmployeeWages> GetEmployeeMonthlySalaryReport()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {                  
                new SqlParameter("@Month", SalaryMonth), 
                new SqlParameter("@Year", SalaryYear), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_RptEmployeeSalary");
            List<clsEmployeeWages> list = new List<clsEmployeeWages>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsEmployeeWages obj = new clsEmployeeWages();
                obj = AssignValuesReport(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsEmployeeWages AssignValuesReport(clsEmployeeWages obj, DataTable dt, int row)
        {
            obj.EmployeeName = Convert.ToString(dt.Rows[row]["EmployeeName"]);          
            obj.PaymentType = Convert.ToString(dt.Rows[row]["PaymentType"]);
            obj.SalaryAmount = Convert.ToDecimal(dt.Rows[row]["SalaryAmount"]);
            obj.LoanAmount = Convert.ToDecimal(dt.Rows[row]["LoanAmount"]);
            obj.SalaryDate = Convert.ToDateTime(dt.Rows[row]["SalaryDate"]);
            obj.Remarks = Convert.ToString(dt.Rows[row]["Remarks"]);
            obj.ContactType = Convert.ToString(dt.Rows[row]["ContactType"]);
            obj.Mobile = Convert.ToString(dt.Rows[row]["Mobile"]);
            return obj;
        }
        #endregion
    }
}
