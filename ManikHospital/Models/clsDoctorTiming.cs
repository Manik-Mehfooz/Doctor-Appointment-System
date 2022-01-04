using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using MedicalStore.Models;
using System.Data;
using System.ComponentModel.DataAnnotations;

namespace vtsMMC.Models
{
    public class clsDoctorTiming
    {
        clsConnection objconn = new clsConnection();
        private int _ID;
        private int _DoctorID;
        private string _DoctorTime;
        private string _Days;

        public int ID { get { return _ID; } set { _ID = value; } }
        [Required,Display(Name="Doctor Name")]
        public int DoctorID { get { return _DoctorID; } set { _DoctorID = value; } }
        public string DoctorName { get; set; }
        [Display(Name="Doctor Time")]
        public string DoctorTime { get { return _DoctorTime; } set { _DoctorTime = value; } }
        public string Days { get { return _Days; } set { _Days = value; } }

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@DoctorID",_DoctorID),
                new SqlParameter("@DoctorTime",_DoctorTime),
                new SqlParameter("@Days",_Days),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_DoctorTiming");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ID",_ID),
                new SqlParameter("@DoctorID",_DoctorID),
                new SqlParameter("@DoctorTime",_DoctorTime),
                new SqlParameter("@Days",_Days),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_DoctorTiming");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ID",_ID),
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_DoctorTiming");
        }

        #endregion

        #region DDL Methods

        public clsDoctorTiming GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ID",_ID),  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DoctorTiming");
            clsDoctorTiming obj = new clsDoctorTiming();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsDoctorTiming AssignValues(clsDoctorTiming obj, DataTable dt, int row)
        {
            obj.ID = Convert.ToInt32(dt.Rows[row]["ID"]);
            obj.DoctorID = Convert.ToInt32(dt.Rows[row]["DoctorID"]);
            obj.DoctorName = Convert.ToString(dt.Rows[row]["DoctorName"]);
            obj.DoctorTime = Convert.ToString(dt.Rows[row]["DoctorTime"]);
            obj.Days = Convert.ToString(dt.Rows[row]["Days"]);
            return obj;
        }

        public List<clsDoctorTiming> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DoctorTiming");
            List<clsDoctorTiming> list = new List<clsDoctorTiming>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsDoctorTiming obj = new clsDoctorTiming();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        #endregion
    }
}