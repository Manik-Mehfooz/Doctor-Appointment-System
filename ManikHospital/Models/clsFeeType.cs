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
    [Table("FeeType")]
    public class clsFeeType
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _FeeTypeID;
        private string _FeeType;
        private string _ModeType;

        #endregion 

        #region Properties

        public int FeeTypeID { get { return _FeeTypeID; } set { _FeeTypeID = value; } }
        [Required(ErrorMessage = "Please Enter Fee Type"), Display(Name = "Field Type")]
        public string FeeType { get { return _FeeType; } set { _FeeType = value; } }
        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }
        
        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@FeeType",_FeeType),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_FeeType");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@FeeTypeID",_FeeTypeID),
                new SqlParameter("@FeeType",_FeeType),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_FeeType");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@FeeTypeID",_FeeTypeID),  
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_FeeType");
        }

        #endregion

        #region DDL Methods

        public clsFeeType GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@FeeTypeID",_FeeTypeID),  
                new SqlParameter("@ModeType", "GETDATA"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_FeeType");
            clsFeeType obj = new clsFeeType();            
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }
        public List<clsFeeType> GetAllData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ModeType", "GETDATA"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_FeeType");
            List<clsFeeType> list = new List<clsFeeType>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsFeeType obj = new clsFeeType();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsFeeType AssignValues(clsFeeType obj, DataTable dt, int row)
        {
            obj.FeeTypeID = Convert.ToInt32(dt.Rows[row]["FeeTypeID"]);
            obj.FeeType = Convert.ToString(dt.Rows[row]["FeeType"]);
            return obj;
        }

        #endregion
    }
}
