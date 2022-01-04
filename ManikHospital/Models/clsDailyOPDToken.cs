using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MedicalStore.Models
{
    [Table("DailyOPD")]
    public class clsDailyOPDToken
    {
        clsConnection objconn = new clsConnection();

        #region Private variables
        private int _OPDID;
        private string _OPDNumber;
        private int _DoctorID;
        private string _PatientName;
        private string _ContactNo;
        private int _Age;
        private string _Sex;
        private string _City;
        private DateTime _OPDDate;
        private decimal _Discount;
        private string _Status;
        private string _Search;

        public int OPDID { get { return _OPDID; } set { _OPDID = value; } }

        [Display(Name = "OPD Number")]
        public string OPDNumber { get { return _OPDNumber; } set { _OPDNumber = value; } }

        [Display(Name ="Doctor Name"), Required(ErrorMessage = "Please Select Doctor Name")]
        public int DoctorID { get { return _DoctorID; } set { _DoctorID = value; } }

        [Display(Name = "Patient Name"), Required(ErrorMessage = "Please enter Patient Name")]
        public string PatientName { get { return _PatientName; } set { _PatientName = value; } }

        [Display(Name = "Contact Number")]
        public string ContactNo { get { return _ContactNo; } set { _ContactNo = value; } }

        [Display(Name = "Age"), Required(ErrorMessage = "Please enter Patient Age")]
        public int Age { get { return _Age; } set { _Age = value; } }

        [Display(Name = "Sex")]
        public string Sex { get { return _Sex; } set { _Sex = value; } }

        [Display(Name = "City")]
        public string City { get { return _City; } set { _City = value; } }

        public DateTime OPDDate { get { return _OPDDate; } set { _OPDDate = value; } }
        public decimal Discount { get { return _Discount; } set { _Discount = value; } }
        public string Status { get { return _Status; } set { _Status = value; } }

        public string Search { get { return _Search; } set { _Search = value; } }

        [Display(Name = "Doctor Name")]
        public string DoctorName { get; set; }

        

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@OPDNumber",_OPDNumber),
                new SqlParameter("@DoctorID",_DoctorID),
                new SqlParameter("@PatientName",_PatientName),
                new SqlParameter("@ContactNo",_ContactNo),
                new SqlParameter("@Age",_Age), 
                new SqlParameter("@Sex",_Sex), 
                new SqlParameter("@City",_City), 
                new SqlParameter("@Discount",_Discount), 
                new SqlParameter("@Status",_Status), 
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_DailyOPD");
        }
        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@OPDID",_OPDID),   
                new SqlParameter("@PatientName",_PatientName), 
                new SqlParameter("@ContactNo",_ContactNo), 
                new SqlParameter("@Age",_Age), 
                new SqlParameter("@Sex",_Sex), 
                new SqlParameter("@City",_City), 
                new SqlParameter("@Discount",_Discount), 
                new SqlParameter("@Status",_Status), 
                new SqlParameter("@ModeType", "Update"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_DailyOPD");
        }

        public int UpdateStatus()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@OPDID",_OPDID),                
                new SqlParameter("@Status",_Status), 
                new SqlParameter("@ModeType", "StatusUpdate"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_DailyOPD");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@OPDID",_OPDID),  
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_DailyOPD");
        }

        #endregion


        #region DDL Methods
        public clsDailyOPDToken GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@OPDID",_OPDID),  
                new SqlParameter("@ModeType", "GetByID"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DailyOPD");
            clsDailyOPDToken obj = new clsDailyOPDToken();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValuesEdit(obj, dt, 0);
            }
            return obj;
        }
        protected clsDailyOPDToken AssignValuesEdit(clsDailyOPDToken obj, DataTable dt, int row)
        {
            obj.OPDID = Convert.ToInt32(dt.Rows[row]["OPDID"]);
            obj.OPDNumber = Convert.ToString(dt.Rows[row]["OPDNumber"]);
            obj.DoctorID = Convert.ToInt32(dt.Rows[row]["DoctorID"]);
            obj.PatientName = Convert.ToString(dt.Rows[row]["PatientName"]);
            obj.ContactNo = Convert.ToString(dt.Rows[row]["ContactNo"]);
            obj.Age = Convert.ToInt32(dt.Rows[row]["Age"]);
            obj.Sex = Convert.ToString(dt.Rows[row]["Sex"]);
            obj.City = Convert.ToString(dt.Rows[row]["City"]);
            obj.OPDDate = Convert.ToDateTime(dt.Rows[row]["OPDDate"]);
            obj.Discount = Convert.ToDecimal(dt.Rows[row]["Discount"]);
            obj.Status = Convert.ToString(dt.Rows[row]["Status"]);
            return obj;
        }
        public List<clsDailyOPDToken> GetTodayOPDToken()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParam = new SqlParameter[]  
            {  
                //new SqlParameter("@OPDDate", _OPDDate),
                new SqlParameter("@ModeType", "GetDailyOPDToken"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParam, "sp_DailyOPD");
            List<clsDailyOPDToken> list = new List<clsDailyOPDToken>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsDailyOPDToken obj = new clsDailyOPDToken();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsDailyOPDToken AssignValues(clsDailyOPDToken obj, DataTable dt, int row)
        {
            obj.OPDID = Convert.ToInt32(dt.Rows[row]["OPDID"]);
            obj.OPDNumber = Convert.ToString(dt.Rows[row]["OPDNumber"]);
            obj.DoctorID = Convert.ToInt32(dt.Rows[row]["DoctorID"]);
            obj.PatientName = Convert.ToString(dt.Rows[row]["PatientName"]);
            obj.ContactNo = Convert.ToString(dt.Rows[row]["ContactNo"]);
            obj.Age = Convert.ToInt32(dt.Rows[row]["Age"]);
            obj.Sex = Convert.ToString(dt.Rows[row]["Sex"]);
            obj.City = Convert.ToString(dt.Rows[row]["City"]);
            obj.OPDDate = Convert.ToDateTime(dt.Rows[row]["OPDDate"]);
            obj.Discount = Convert.ToDecimal(dt.Rows[row]["Discount"]);
            obj.Status = Convert.ToString(dt.Rows[row]["Status"]);
            obj.DoctorName = Convert.ToString(dt.Rows[row]["DoctorName"]);
            
            return obj;
        }
        public string GenerateNewTokenNumber()
        {
            DataTable dt = new DataTable();
            string newtoken = "";
            SqlParameter[] sqlParam = new SqlParameter[]  
            {  
                new SqlParameter("@DoctorID", _DoctorID),
                new SqlParameter("@ModeType", "GenerateNewToken"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParam, "sp_DailyOPD");

            if (dt.Rows.Count > 0)
            {
                newtoken = dt.Rows[0]["NewToken"].ToString();
            }
            return newtoken;
        }

        public List<clsDailyOPDToken> SearchOldOPDToken()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParam = new SqlParameter[]  
            {  
                new SqlParameter("@Search", _Search),
                new SqlParameter("@ModeType", "SearchOPD"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParam, "sp_DailyOPD");
            List<clsDailyOPDToken> list = new List<clsDailyOPDToken>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsDailyOPDToken obj = new clsDailyOPDToken();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        #endregion
    }
}