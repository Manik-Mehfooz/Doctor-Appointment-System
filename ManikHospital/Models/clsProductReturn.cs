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
    public class clsProductReturn
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _ReturnID;
        private int _ProductID;
        private string _ReturnType;
        private string _SalesInvoiceNumber;
        private string _PurchaseInvoiceNumber;
        private int _Quantity;
        private decimal _Price;
        private decimal _Total;
        private DateTime _EnteredDate;
        private string _EnteredBy;
        private DateTime _UpdatedDate;
        private string _UpdatedBy;
        private DateTime _DeletedDate;
        private string _DeletedBy;
        private int _IsDeleted;
        private string _ModeType;
        private string _Search;

        #endregion

        #region Properties

        public int ReturnID { get { return _ReturnID; } set { _ReturnID = value; } }

        [Required(ErrorMessage = "Please Select Product Name"), Display(Name = "Product Name")]
        public int ProductID { get { return _ProductID; } set { _ProductID = value; } }

        public string ProductName { get; set; }

        [Required(ErrorMessage= "Please Select Return Type"), Display(Name="Return Type")]
        public string ReturnType { get { return _ReturnType; } set { _ReturnType = value; } }

        [Required(ErrorMessage = "Please Enter Invoice Number"), Display(Name = "Sales Invoice No")]
        public string SalesInvoiceNumber { get { return _SalesInvoiceNumber; } set { _SalesInvoiceNumber = value; } }

        [Required(ErrorMessage = "Please Enter Invoice Number"), Display(Name = "Purchase Invoice No")]
        public string PurchaseInvoiceNumber { get { return _PurchaseInvoiceNumber; } set { _PurchaseInvoiceNumber = value; } }

        [Required(ErrorMessage = "Please Enter Invoice Number"),  Display(Name = "Invoice Number")]
        public string InvoiceNumber { get; set; }

        [Required(ErrorMessage = "Please Enter Return Quantity")]
        public int Quantity { get { return _Quantity; } set { _Quantity = value; } }

        [Required(ErrorMessage ="Please Enter Prodcut Price")]
        public decimal Price { get { return _Price; } set { _Price = value; } }

        [Required(ErrorMessage = "Please Enter Total Amount")]
        public decimal Total { get { return _Total; } set { _Total = value; } } 

        public DateTime EnteredDate { get { return _EnteredDate; } set { _EnteredDate = value; } }

        public string EnteredBy { get { return _EnteredBy; } set { _EnteredBy = value; } }

        public string UpdatedBy { get { return _UpdatedBy; } set { _UpdatedBy = value; } }

        public DateTime UpdatedDate { get { return _UpdatedDate; } set { _UpdatedDate = value; } }

        public string DeletedBy { get { return _DeletedBy; } set { _DeletedBy = value; } }

        public DateTime DeletedDate { get { return _DeletedDate; } set { _DeletedDate = value; } }

        public int IsDeleted { get { return _IsDeleted; } set { _IsDeleted = value; } }

        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }
        public string Search { get { return _Search; } set { _Search = value; } }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ProductID",_ProductID),
                new SqlParameter("@ReturnType",_ReturnType),
                new SqlParameter("@SalesInvoiceNumber",_SalesInvoiceNumber),
                new SqlParameter("@PurchaseInvoiceNumber",_PurchaseInvoiceNumber),                
                new SqlParameter("@Quantity",_Quantity),
                new SqlParameter("@Price",_Price),
                new SqlParameter("@Total",_Total),
                new SqlParameter("@EnteredBy",_EnteredBy),
                new SqlParameter("@IsDeleted",_IsDeleted),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_ProductReturn");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ReturnID",_ReturnID),
                new SqlParameter("@ProductID",_ProductID),
                new SqlParameter("@ReturnType",_ReturnType),
                new SqlParameter("@SalesInvoiceNumber",_SalesInvoiceNumber),                
                new SqlParameter("@PurchaseInvoiceNumber",_PurchaseInvoiceNumber),                
                new SqlParameter("@Quantity",_Quantity),
                new SqlParameter("@Price",_Price),
                new SqlParameter("@Total",_Total),
                new SqlParameter("@UpdatedBy",_UpdatedBy),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_ProductReturn");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ReturnID",_ReturnID),
                new SqlParameter("@DeletedBy",_DeletedBy),
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_ProductReturn");
        }

        #endregion

        #region DDL Methods

        public clsProductReturn GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ReturnID",_ReturnID),
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_ProductReturn");
            clsProductReturn obj = new clsProductReturn();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        
        protected clsProductReturn AssignValues(clsProductReturn obj, DataTable dt, int row)
        {
            obj.ReturnID = Convert.ToInt32(dt.Rows[row]["ReturnID"]);
            obj.ProductID = Convert.ToInt32(dt.Rows[row]["ProductID"]);
            obj.ProductName = Convert.ToString(dt.Rows[row]["ProductName"]);
            obj.ReturnType = Convert.ToString(dt.Rows[row]["ReturnType"]);
            obj.InvoiceNumber = Convert.ToString(dt.Rows[row]["InvoiceNumber"]);
            obj.SalesInvoiceNumber = Convert.ToString(dt.Rows[row]["SalesInvoiceNumber"]);
            obj.PurchaseInvoiceNumber = Convert.ToString(dt.Rows[row]["PurchaseInvoiceNumber"]);
            obj.Quantity = Convert.ToInt32(dt.Rows[row]["Quantity"]);
            obj.Price = Convert.ToDecimal(dt.Rows[row]["Price"]);
            obj.Total = Convert.ToDecimal(dt.Rows[row]["Total"]);
            obj.EnteredDate = Convert.ToDateTime(dt.Rows[row]["EnteredDate"]);
            obj.EnteredBy = Convert.ToString(dt.Rows[row]["EnteredBy"]);
            obj.UpdatedDate = Convert.ToDateTime(dt.Rows[row]["UpdatedDate"]);
            obj.UpdatedBy = Convert.ToString(dt.Rows[row]["UpdatedBy"]);
            obj.IsDeleted = Convert.ToInt32(dt.Rows[row]["IsDeleted"]);
            obj.DeletedDate = Convert.ToDateTime(dt.Rows[row]["DeletedDate"]);
            obj.DeletedBy = Convert.ToString(dt.Rows[row]["DeletedBy"]);
            return obj;
        }

        public List<clsProductReturn> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@Search", _Search),
                new SqlParameter("@ModeType", "SEARCH"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_ProductReturn");
            List<clsProductReturn> list = new List<clsProductReturn>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsProductReturn obj = new clsProductReturn();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        #endregion
    }
}
