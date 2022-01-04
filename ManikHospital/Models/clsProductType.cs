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
    [Table("ProductType")]
    public class clsProductType
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _ProductTypeID;
        private string _ProductType;
        private string _ModeType;
        private string _Search;

        #endregion

        #region Properties

        public int ProductTypeID { get { return _ProductTypeID; } set { _ProductTypeID = value; } }
        [Required(ErrorMessage = "Please Enter Product Type")]
        [Display(Name="Product Type")]
        public string ProductType { get { return _ProductType; } set { _ProductType = value; } }
        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }
        public string Search { get { return _Search; } set { _Search = value; } }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ProductType",_ProductType),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_ProductType");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ProductTypeID",_ProductTypeID),
                new SqlParameter("@ProductType",_ProductType),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_ProductType");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ProductTypeID",_ProductTypeID),  
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_ProductType");
        }

        #endregion

        #region DDL Methods

        public bool CheckExitData(int id)
        {
            DataTable dt = new DataTable();
            if (id == 0)
            {
                SqlParameter[] sqlParams = new SqlParameter[]  
                {
                    new SqlParameter("@ProductType",_ProductType),  
                    new SqlParameter("@ModeType", "CHECK"), 
                };
                dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_ProductType");
            }
            else
            {
                SqlParameter[] sqlParams = new SqlParameter[]  
                {
                    new SqlParameter("@ProductTypeID",_ProductTypeID),  
                    new SqlParameter("@ProductType",_ProductType),  
                    new SqlParameter("@ModeType", "CHECK"), 
                };
                dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_ProductType");
            }
            return !(dt.Rows.Count > 0);
        }


        public clsProductType GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ProductTypeID",_ProductTypeID),  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_ProductType");
            clsProductType obj = new clsProductType();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsProductType AssignValues(clsProductType obj, DataTable dt, int row)
        {
            obj.ProductTypeID = Convert.ToInt32(dt.Rows[row][0]);
            obj.ProductType = Convert.ToString(dt.Rows[row][1]);
            return obj;
        }

        public List<clsProductType> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@Search", _Search),
                new SqlParameter("@ModeType", "SEARCH"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_ProductType");
            List<clsProductType> list = new List<clsProductType>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsProductType obj = new clsProductType();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        #endregion
    }
}