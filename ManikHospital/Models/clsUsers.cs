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
    public class clsUsers
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _UserID;
        private string _UserName;
        private string _Password;
        private string _ModeType;
        private string _Search;

        #endregion

        #region Properties

        public int UserID { get { return _UserID; } set { _UserID = value; } }
        
        [Required(ErrorMessage = "Username field is required"), Display(Name = "Username")]
        public string UserName { get { return _UserName; } set { _UserName = value; } }
        
        [Required(ErrorMessage = "Password field is required")]
        public string Password { get { return _Password; } set { _Password = value; } }

        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }
        public string Search { get { return _Search; } set { _Search = value; } }

        public string MonthName { get; set; }
        public int Patients { get; set; }
        public string YearNumber { get; set; }

        public int OPD { get; set; }
        public string OPDDay { get; set; }
        public string OPDMonth { get; set; }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@UserName",_UserName),
                new SqlParameter("@Password",_Password),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_Users");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@UserID",_UserID),
                new SqlParameter("@UserName",_UserName),
                new SqlParameter("@Password",_Password),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_Users");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@UserID",_UserID),  
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_Users");
        }

        #endregion

        #region DDL Methods

        public clsUsers GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@UserID",_UserID),  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Users");
            clsUsers obj = new clsUsers();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsUsers AssignValues(clsUsers obj, DataTable dt, int row)
        {
            obj.UserID = Convert.ToInt32(dt.Rows[row]["UserID"]);
            obj.UserName = Convert.ToString(dt.Rows[row]["UserName"]);
            obj.Password = Convert.ToString(dt.Rows[row]["Password"]);
            return obj;
        }

        public List<clsUsers> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@Search", _Search),
                new SqlParameter("@ModeType", "SEARCH"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Users");
            List<clsUsers> list = new List<clsUsers>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsUsers obj = new clsUsers();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        public DataTable GetAuthentication()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@UserName", _UserName),
                new SqlParameter("@Password",_Password),
                new SqlParameter("@ModeType", "AUTHENTICATION"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Users");
            return dt;
        }

        public List<clsUsers> GetDataForChart()
        {
            DataTable dt = new DataTable();
            string qry = @" SELECT COUNT(*)Patients, DATENAME(MONTH, DATEADD(MM, MONTH(AdmissionDate), CONVERT(DATETIME, -1))) AS [MonthName],
                            MONTH(AdmissionDate)
                            from PatientRegistration
                            where AdmissionDate Between cast(DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0) AS date)
                            and cast(DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)as date)
                            group by DATENAME(MONTH, DATEADD(MM, MONTH(AdmissionDate), CONVERT(DATETIME, 0))), MONTH(AdmissionDate)
                            order by MONTH(AdmissionDate) ";
            dt = objconn.GetDataTable(qry);
            List<clsUsers> list = new List<clsUsers>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsUsers obj = new clsUsers();
                obj = AssignValuesChart(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsUsers AssignValuesChart(clsUsers obj, DataTable dt, int row)
        {
            obj.MonthName = Convert.ToString(dt.Rows[row]["MonthName"]);
            obj.Patients = Convert.ToInt32(dt.Rows[row]["Patients"]);

            return obj;
        }

        public List<clsUsers> GetYearlyPatientListDataForChart()
        {
            DataTable dt = new DataTable();
            string qry = @" SELECT Year(AdmissionDate) YearNumber, COUNT(*) YearlyPatients
                            from PatientRegistration
                            group by Year(AdmissionDate)
                            order by Year(AdmissionDate) ";
            dt = objconn.GetDataTable(qry);
            List<clsUsers> list = new List<clsUsers>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsUsers obj = new clsUsers();
                obj = AssignValuesYearChart(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsUsers AssignValuesYearChart(clsUsers obj, DataTable dt, int row)
        {
            obj.YearNumber = Convert.ToString(dt.Rows[row]["YearNumber"]);
            obj.Patients = Convert.ToInt32(dt.Rows[row]["YearlyPatients"]);

            return obj;
        }

        public List<clsUsers> GetMonthlyOPDListDataForChart()
        {
            DataTable dt = new DataTable();
            string qry = @" SELECT Day(OPDDate) OPDDay, COUNT(*) TotalPatients
                            From DailyOPD 
                            where OPDDate Between Cast(DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) as DATE) 
                            and Cast(DATEADD(ms, -3, DATEADD(mm, DATEDIFF(m, 0, GETDATE()) + 1, 0)) as DATE)
                            --where OPDDate Between '2019/4/1' and '2019/4/30' 
                            and Status='Checked' 
                            group by Day(OPDDate)
                            order by Day(OPDDate) ";
            dt = objconn.GetDataTable(qry);
            List<clsUsers> list = new List<clsUsers>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsUsers obj = new clsUsers();
                obj = AssignValuesMonthlyOPDChart(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsUsers AssignValuesMonthlyOPDChart(clsUsers obj, DataTable dt, int row)
        {
            obj.OPDDay = Convert.ToString(dt.Rows[row]["OPDDay"]);
            obj.OPD = Convert.ToInt32(dt.Rows[row]["TotalPatients"]);

            return obj;
        }

        public List<clsUsers> GetYearlyOPDListDataForChart()
        {
            DataTable dt = new DataTable();
            string qry = @" SELECT COUNT(*)TotalPatients, DATENAME(MONTH, DATEADD(MM, MONTH(OPDDate), CONVERT(DATETIME, -1))) AS [OPDMonth],
                            MONTH(OPDDate)
                            From DailyOPD
                            where OPDDate Between cast(DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0) AS date)
                            and cast(DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)as date)
                            and Status='Checked'
                            group by DATENAME(MONTH, DATEADD(MM, MONTH(OPDDate), CONVERT(DATETIME, 0))), MONTH(OPDDate)
                            order by MONTH(OPDDate)  ";
            dt = objconn.GetDataTable(qry);
            List<clsUsers> list = new List<clsUsers>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsUsers obj = new clsUsers();
                obj = AssignValuesYearlyOPDChart(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsUsers AssignValuesYearlyOPDChart(clsUsers obj, DataTable dt, int row)
        {
            obj.OPDMonth = Convert.ToString(dt.Rows[row]["OPDMonth"]);
            obj.OPD = Convert.ToInt32(dt.Rows[row]["TotalPatients"]);

            return obj;
        }

        #endregion
    }

    public class clsChangePassword
    {
        clsConnection objconn = new clsConnection();
        #region Private Variables

        private int _UserID;
        private string _Password;
        private string _NewPassword;
        private string _ModeType;

        #endregion

        #region Properties

        public int UserID { get { return _UserID; } set { _UserID = value; } }

        [Required(ErrorMessage = "Password field is required")]
        public string Password { get { return _Password; } set { _Password = value; } }

        [Required(ErrorMessage = "New Password field is required"), Display(Name = "New Password")]
        public string NewPassword { get { return _NewPassword; } set { _NewPassword = value; } }

        [NotMapped]  // not effected on the database
        [Compare("NewPassword"), Display(Name = "Confirm Password")]
        public string ConfirmPassword { get; set; }


        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }

        #endregion

        public int UpdatePwdMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]
            {
                new SqlParameter("@UserID",_UserID),
                new SqlParameter("@Password",_Password),
                new SqlParameter("@NewPassword",_NewPassword),
                new SqlParameter("@ModeType","UPDATEPWD"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_Users");
        }

    }
}
