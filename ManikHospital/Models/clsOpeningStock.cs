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
    [Table("OpeningStock")]
    public class clsOpeningStock
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _OpningStockID;
        private int _CompanyID;
        private int _ProductID;
        private int _ProductTypeID;
        private int _StrengthID;
        private int _Quantity;
        private string _ModeType;
        private string _Search;

        #endregion

        #region Properties

        public int OpningStockID { get { return _OpningStockID; } set { _OpningStockID = value; } }
        
        [Required(ErrorMessage="Please Select Company"),Display(Name="Company")]
        public int CompanyID { get { return _CompanyID; } set { _CompanyID = value; } }
        public string Company { get; set; }

        [Required(ErrorMessage = "Please Select Product Name"), Display(Name = "Product Name")]
        public int ProductID { get { return _ProductID; } set { _ProductID = value; } }
        public string ProductName { get; set; }

        [Required(ErrorMessage = "Please Select Product Type"), Display(Name = "Product Type")]
        public int ProductTypeID { get { return _ProductTypeID; } set { _ProductTypeID = value; } }
        public string ProductType { get; set; }

        [Required(ErrorMessage = "Please Select Strength"), Display(Name = "Strength")]
        public int StrengthID { get { return _StrengthID; } set { _StrengthID = value; } }
        public string Strength { get; set; }

        [Required(ErrorMessage = "Please Enter Product Quantity"), Display(Name = "Quantity")]
        public int Quantity { get { return _Quantity; } set { _Quantity = value; } }
        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }
        public string Search { get { return _Search; } set { _Search = value; } }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ProductID",_ProductID),
                new SqlParameter("@Quantity",_Quantity),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_OpeningStock");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@OpningStockID",_OpningStockID),
                new SqlParameter("@ProductID",_ProductID),
                new SqlParameter("@Quantity",_Quantity),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_OpeningStock");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@OpningStockID",_OpningStockID),  
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_OpeningStock");
        }

        #endregion

        #region DDL Methods

        public clsOpeningStock GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@OpningStockID",_OpningStockID),  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_OpeningStock");
            clsOpeningStock obj = new clsOpeningStock();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsOpeningStock AssignValues(clsOpeningStock obj, DataTable dt, int row)
        {
            obj.OpningStockID = Convert.ToInt32(dt.Rows[row]["OpningStockID"]);
            //obj.CompanyID = Convert.ToInt32(dt.Rows[row]["CompanyID"]);
            obj.Company = Convert.ToString(dt.Rows[row]["Company"]);
            obj.ProductName = Convert.ToString(dt.Rows[row]["ProductName"]);
            obj.ProductID = Convert.ToInt32(dt.Rows[row]["ProductID"]);
            obj.ProductType = Convert.ToString(dt.Rows[row]["ProductType"]);
            //obj.ProductTypeID = Convert.ToInt32(dt.Rows[row]["ProductTypeID"]);
            //obj.StrengthID = Convert.ToInt32(dt.Rows[row]["StrengthID"]);
            obj.Strength = Convert.ToString(dt.Rows[row]["Strength"]);
            obj.Quantity = Convert.ToInt32(dt.Rows[row]["Quantity"]);
            return obj;
        }

        public List<clsOpeningStock> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@Search", _Search),
                new SqlParameter("@ModeType", "SEARCH"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_OpeningStock");
            List<clsOpeningStock> list = new List<clsOpeningStock>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsOpeningStock obj = new clsOpeningStock();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        #endregion
    }
}
