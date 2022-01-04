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
    [Table("StoreInformation")]
    public class clsStoreInformation
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _StoreID;
        private string _StoreName;
        private string _OwnerName;
        private string _Address;
        private string _MobileNo;
        private string _ModeType;
        private string _Search;

        #endregion

        #region Properties

        public int StoreID { get { return _StoreID; } set { _StoreID = value; } }
        
        [Required,Display(Name="Store Name")]
        public string StoreName { get { return _StoreName; } set { _StoreName = value; } }

        [Required,Display(Name="Owner Name")]
        public string OwnerName { get { return _OwnerName; } set { _OwnerName = value; } }

        [Required]
        public string Address { get { return _Address; } set { _Address = value; } }

        [Required,Display(Name="Mobile No")]
        [RegularExpression(@"^03\d{9}$",ErrorMessage="Invalid Mobile Number")]
        public string MobileNo { get { return _MobileNo; } set { _MobileNo = value; } }
        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }
        public string Search { get { return _Search; } set { _Search = value; } }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@StoreName",_StoreName),
                new SqlParameter("@OwnerName",_OwnerName),
                new SqlParameter("@Address",_Address),
                new SqlParameter("@MobileNo",_MobileNo),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_StoreInformation");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@StoreID",_StoreID),
                new SqlParameter("@StoreName",_StoreName),
                new SqlParameter("@OwnerName",_OwnerName),
                new SqlParameter("@Address",_Address),
                new SqlParameter("@MobileNo",_MobileNo),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_StoreInformation");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@StoreID",_StoreID),  
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_StoreInformation");
        }

        #endregion

        #region DDL Methods

        public clsStoreInformation GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@StoreID",_StoreID),  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_StoreInformation");
            clsStoreInformation obj = new clsStoreInformation();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsStoreInformation AssignValues(clsStoreInformation obj, DataTable dt, int row)
        {
            obj.StoreID = Convert.ToInt32(dt.Rows[row]["StoreID"]);
            obj.StoreName = Convert.ToString(dt.Rows[row]["StoreName"]);
            obj.OwnerName = Convert.ToString(dt.Rows[row]["OwnerName"]);
            obj.Address = Convert.ToString(dt.Rows[row]["Address"]);
            obj.MobileNo = Convert.ToString(dt.Rows[row]["MobileNo"]);
            return obj;
        }

        public List<clsStoreInformation> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@Search", _Search),
                new SqlParameter("@ModeType", "SEARCH"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_StoreInformation");
            List<clsStoreInformation> list = new List<clsStoreInformation>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsStoreInformation obj = new clsStoreInformation();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        #endregion
    }
}
