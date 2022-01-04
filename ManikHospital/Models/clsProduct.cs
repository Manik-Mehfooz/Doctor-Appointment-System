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
    [Table("Product")]
    public class clsProduct
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _ProductID;
        private int _CompanyID;
        private int _ProductTypeID;
        private string _ProductName;
        private string _ProductCode;
        private string _ProductRegNo;
        private string _Formula;
        private int _StrengthID;
        private decimal _UnitPrice;
        private decimal _PurchasePrice;
        private bool _IsOTProduct;
        private string _ModeType;
        private string _Search;

        private string _BarCodeImageName;

        #endregion

        #region Properties

        public int ProductID { get { return _ProductID; } set { _ProductID = value; } }

        [Required(ErrorMessage = "Please Select Company"), Display(Name = "Company")]
        public int CompanyID { get { return _CompanyID; } set { _CompanyID = value; } }

        [Required(ErrorMessage = "Please Select Product Type"), Display(Name = "Product Type")]
        public int ProductTypeID { get { return _ProductTypeID; } set { _ProductTypeID = value; } }

        [Required(ErrorMessage = "Please Enter Product Name"), Display(Name = "Product Name")]
        public string ProductName { get { return _ProductName; } set { _ProductName = value; } }

        [Display(Name = "Product Code")]
        public string ProductCode { get { return _ProductCode; } set { _ProductCode = value; } }

        [Display(Name = "Product Reg No")]
        public string ProductRegNo { get { return _ProductRegNo; } set { _ProductRegNo = value; } }

        [Display(Name = "Formula")]
        public string Formula { get { return _Formula; } set { _Formula = value; } }

        [Required(ErrorMessage = "Please Select Strength"), Display(Name = "Strength")]
        public int StrengthID { get { return _StrengthID; } set { _StrengthID = value; } }

        [Required(ErrorMessage = "Please Enter Retail Price"), Display(Name = "Retial Price")]
        public decimal UnitPrice { get { return _UnitPrice; } set { _UnitPrice = value; } }

        [Required(ErrorMessage = "Please Enter Purchase Price"), Display(Name = "Purchase Price")]
        public decimal PurchasePrice { get { return _PurchasePrice; } set { _PurchasePrice = value; } }

        [Display(Name = "OT Product")]
        public bool IsOTProduct { get { return _IsOTProduct; } set { _IsOTProduct = value; } }

        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }
        public string Search { get { return _Search; } set { _Search = value; } }

        public string Company { get; set; }

        [Display(Name = "Product Type")]
        public string ProductType { get; set; }

        public string Strength { get; set; }

        public string BarCodeImageName { get { return _BarCodeImageName; } set { _BarCodeImageName = value; } }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@CompanyID",_CompanyID),
                new SqlParameter("@ProductTypeID",_ProductTypeID),
                new SqlParameter("@ProductName",_ProductName),
                new SqlParameter("@ProductCode",_ProductCode),
                new SqlParameter("@ProductRegNo",_ProductRegNo),
                new SqlParameter("@Formula",_Formula),
                new SqlParameter("@StrengthID",_StrengthID),
                new SqlParameter("@UnitPrice",_UnitPrice),
                new SqlParameter("@PurchasePrice",_PurchasePrice),
                new SqlParameter("@IsOTProduct",_IsOTProduct),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_Product");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ProductID",_ProductID),
                new SqlParameter("@CompanyID",_CompanyID),
                new SqlParameter("@ProductTypeID",_ProductTypeID),
                new SqlParameter("@ProductName",_ProductName),
                new SqlParameter("@ProductCode",_ProductCode),
                new SqlParameter("@ProductRegNo",_ProductRegNo),
                new SqlParameter("@Formula",_Formula),
                new SqlParameter("@StrengthID",_StrengthID),
                new SqlParameter("@UnitPrice",_UnitPrice),
                new SqlParameter("@PurchasePrice",_PurchasePrice),
                new SqlParameter("@IsOTProduct", _IsOTProduct),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_Product");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ProductID",_ProductID),  
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_Product");
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
                    new SqlParameter("@ProductName",_ProductName),
                    new SqlParameter("@ProductTypeID", _ProductTypeID),
                    new SqlParameter("@StrengthID", _StrengthID),
                    new SqlParameter("@ModeType", "CHECK"), 
                };
                dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Product");
            }
            else
            {
                SqlParameter[] sqlParams = new SqlParameter[]  
                {
                    new SqlParameter("@ProductID",_ProductID),  
                    new SqlParameter("@ProductName",_ProductName),
                    new SqlParameter("@ProductTypeID", _ProductTypeID),
                    new SqlParameter("@StrengthID", _StrengthID),
                    new SqlParameter("@ModeType", "CHECK"), 
                };
                dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Product");

            }
            return !(dt.Rows.Count > 0);
        }

        public clsProduct GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ProductID",_ProductID),  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Product");
            clsProduct obj = new clsProduct();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsProduct AssignValues(clsProduct obj, DataTable dt, int row)
        {
            obj.ProductID = Convert.ToInt32(dt.Rows[row]["ProductID"]);
            obj.CompanyID = Convert.ToInt32(dt.Rows[row]["CompanyID"]);
            obj.Company = Convert.ToString(dt.Rows[row]["Company"]);
            obj.ProductTypeID = Convert.ToInt32(dt.Rows[row]["ProductTypeID"]);
            obj.ProductType = Convert.ToString(dt.Rows[row]["ProductType"]);
            obj.ProductName = Convert.ToString(dt.Rows[row]["ProductName"]);
            obj.ProductCode = Convert.ToString(dt.Rows[row]["ProductCode"]);
            obj.ProductRegNo = Convert.ToString(dt.Rows[row]["ProductRegNo"]);
            obj.Formula = Convert.ToString(dt.Rows[row]["Formula"]);
            obj.StrengthID = Convert.ToInt32(dt.Rows[row]["StrengthID"]);
            obj.Strength = Convert.ToString(dt.Rows[row]["Strength"]);
            obj.UnitPrice = Convert.ToDecimal(dt.Rows[row]["UnitPrice"]);
            obj.PurchasePrice = Convert.ToDecimal(dt.Rows[row]["PurchasePrice"]);
            obj.IsOTProduct = Convert.ToBoolean(dt.Rows[row]["IsOTProduct"]);
            return obj;
        }

        public List<clsProduct> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@Search", _Search),
                new SqlParameter("@ModeType", "SEARCH"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Product");
            List<clsProduct> list = new List<clsProduct>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsProduct obj = new clsProduct();
                obj = AssignValuesView(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        public List<clsProduct> GetSearchData_New()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@Search", _Search),
                new SqlParameter("@ModeType", "SEARCH_New"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Product");
            List<clsProduct> list = new List<clsProduct>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsProduct obj = new clsProduct();
                obj = AssignValuesAuto_New(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        public List<clsProduct> GetAutoCompleteProduct()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                //new SqlParameter("@Search", _Search),
                new SqlParameter("@ModeType", "AUTOCOMPLETEPRODUCT"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Product");
            List<clsProduct> list = new List<clsProduct>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsProduct obj = new clsProduct();
                obj = AssignValuesAuto(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsProduct AssignValuesAuto(clsProduct obj, DataTable dt, int row)
        {
            obj.ProductID = Convert.ToInt32(dt.Rows[row]["ProductID"]);
            obj.ProductName = Convert.ToString(dt.Rows[row]["ProductName"]);
            return obj;
        }

        protected clsProduct AssignValuesAuto_New(clsProduct obj, DataTable dt, int row)
        {
            //obj.ProductID = Convert.ToInt32(dt.Rows[row]["ProductID"]);
            obj.ProductName = Convert.ToString(dt.Rows[row]["ProductName"]);
            return obj;
        }

        public List<clsProduct> GetProductByCompanyID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParam = new SqlParameter[]  
            {  
                new SqlParameter("@CompanyID", _CompanyID),
                new SqlParameter("@ModeType", "GetProductsByCompanyID"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParam, "sp_Product");
            List<clsProduct> list = new List<clsProduct>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsProduct obj = new clsProduct();
                obj = AssignValuesByCompany(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsProduct AssignValuesByCompany(clsProduct obj, DataTable dt, int row)
        {
            obj.ProductID = Convert.ToInt32(dt.Rows[row]["ProductID"]);
            obj.ProductName = Convert.ToString(dt.Rows[row]["ProductName"]);
            obj.UnitPrice = Convert.ToDecimal(dt.Rows[row]["UnitPrice"]);
            return obj;
        }

        public List<clsProduct> GetProductDataByIDOrName()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ProductID", _ProductID),
                new SqlParameter("@ProductName", _ProductName),
                new SqlParameter("@ModeType", "GetProductByIDOrName"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Product");
            List<clsProduct> list = new List<clsProduct>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsProduct obj = new clsProduct();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        public List<clsProduct> GetProductDataByIDOrName_New(string ProductName, string ProductType, string Strength)
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ProductID", _ProductID),
                new SqlParameter("@ProductName", _ProductName),
                new SqlParameter("@ModeType", "GetProductByIDOrName"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Product");
            List<clsProduct> list = new List<clsProduct>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsProduct obj = new clsProduct();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        public List<clsProduct> GetAutoBind()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ModeType", "AUTOBIND"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Product");
            List<clsProduct> list = new List<clsProduct>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsProduct obj = new clsProduct();
                obj = AssignValuesForAutoBind(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        protected clsProduct AssignValuesForAutoBind(clsProduct obj, DataTable dt, int row)
        {
            obj.ProductID = Convert.ToInt32(dt.Rows[row]["ProductID"]);
            obj.ProductName = Convert.ToString(dt.Rows[row]["ProductName"]);
            return obj;
        }

        public int GetMaxID()
        {

            DataTable dt = new DataTable();
            int maxid = 0;
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ModeType", "GetMaxID"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Product");
            List<clsProduct> list = new List<clsProduct>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                maxid = Convert.ToInt32(dt.Rows[0]["MaxProductID"]);
            }
            return maxid;
        }

        protected clsProduct AssignValuesView(clsProduct obj, DataTable dt, int row)
        {
            obj.ProductID = Convert.ToInt32(dt.Rows[row]["ProductID"]);
            obj.CompanyID = Convert.ToInt32(dt.Rows[row]["CompanyID"]);
            obj.Company = Convert.ToString(dt.Rows[row]["Company"]);
            obj.ProductTypeID = Convert.ToInt32(dt.Rows[row]["ProductTypeID"]);
            obj.ProductType = Convert.ToString(dt.Rows[row]["ProductType"]);
            obj.ProductName = Convert.ToString(dt.Rows[row]["ProductName"]);
            obj.ProductCode = Convert.ToString(dt.Rows[row]["ProductCode"]);
            obj.ProductRegNo = Convert.ToString(dt.Rows[row]["ProductRegNo"]);
            obj.Formula = Convert.ToString(dt.Rows[row]["Formula"]);
            obj.StrengthID = Convert.ToInt32(dt.Rows[row]["StrengthID"]);
            obj.Strength = Convert.ToString(dt.Rows[row]["Strength"]);
            obj.UnitPrice = Convert.ToDecimal(dt.Rows[row]["UnitPrice"]);
            obj.PurchasePrice = Convert.ToDecimal(dt.Rows[row]["PurchasePrice"]);
            obj.BarCodeImageName = Convert.ToString(dt.Rows[row]["BarCodeImageName"]);
            obj.IsOTProduct = Convert.ToBoolean(dt.Rows[row]["IsOTProduct"]);

            return obj;
        }


        
        #endregion
    }
}