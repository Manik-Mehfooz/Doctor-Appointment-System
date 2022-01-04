using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MedicalStore.Models
{
    [Table("PurchaseDetail")]
    public class clsPurchaseDetail
    {
        clsConnection objconn = new clsConnection();

        #region Private Properties
        private int _PurchaseDetailID;
        private int _PurchaseID;
        private int _CompanyID;
        private int _ProductID;
        private string _BatchNo;
        private DateTime _MfgDate;
        private DateTime _ExpiryDate;
        private int _Quantity;
        private int _Bonus;
        private decimal _Price;
        private decimal _Discount;
        private decimal _DiscountAmount;
        private decimal _SpecialDiscount;
        private decimal _SpecialDiscAmount;
        private decimal _GST;
        private decimal _Total;
        private string _EnteredBy;
        private string _UpdatedBy;
        private string _DeletedBy;
        private string _ProductName;
        private string _Barcode;

        #endregion

        #region Public Properties
        public int PurchaseDetailID { get { return _PurchaseDetailID; } set { _PurchaseDetailID = value; } }
        public int PurchaseID { get { return _PurchaseID; } set { _PurchaseID = value; } }
        public int CompanyID { get { return _CompanyID; } set { _CompanyID = value; } }
        [Required]
        public int ProductID { get { return _ProductID; } set { _ProductID = value; } }
        public string BatchNo { get { return _BatchNo; } set { _BatchNo = value; } }
        public DateTime MfgDate { get { return _MfgDate; } set { _MfgDate = value; } }
        [Required, Display(Name = "Expiry Date")]
        public DateTime ExpiryDate { get { return _ExpiryDate; } set { _ExpiryDate = value; } }
        [Required]
        public int Quantity { get { return _Quantity; } set { _Quantity = value; } }

        public int Bonus { get { return _Bonus; } set { _Bonus = value; } }

        [Required]
        public decimal Price { get { return _Price; } set { _Price = value; } }
        [Required]
        public decimal Discount { get { return _Discount; } set { _Discount = value; } }
        public decimal DiscountAmount { get { return _DiscountAmount; } set { _DiscountAmount = value; } }
        public decimal SpecialDiscount { get { return _SpecialDiscount; } set { _SpecialDiscount = value; } }
        public decimal SpecialDiscAmount { get { return _SpecialDiscAmount; } set { _SpecialDiscAmount = value; } }
        public decimal GST { get { return _GST; } set { _GST = value; } }
        public decimal Total { get { return _Total; } set { _Total = value; } }
        [Display(Name = "Product Name")]
        public string ProductName { get { return _ProductName; } set { _ProductName = value; } }
        public string EnteredBy { get { return _EnteredBy; } set { _EnteredBy = value; } }
        public string UpdatedBy { get { return _UpdatedBy; } set { _UpdatedBy = value; } }
        public string DeletedBy { get { return _DeletedBy; } set { _DeletedBy = value; } }
        public string Company { get; set; }

        public string Barcode { get { return _Barcode; } set { _Barcode = value; } }

        #endregion

        #region DML methods
        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PurchaseID",_PurchaseID),
                new SqlParameter("@CompanyID",_CompanyID),
                new SqlParameter("@ProductID",_ProductID),
                new SqlParameter("@BatchNo",_BatchNo),
                new SqlParameter("@MfgDate",_MfgDate),
                new SqlParameter("@ExpiryDate",_ExpiryDate),
                new SqlParameter("@Quantity",_Quantity),  
                new SqlParameter("@Bonus",_Bonus),  
                new SqlParameter("@Price",_Price),
                new SqlParameter("@Discount",_Discount),
                new SqlParameter("@DiscountAmount",_DiscountAmount),
                new SqlParameter("@SpecialDiscount",_SpecialDiscount),
                new SqlParameter("@SpecialDiscAmount",_SpecialDiscAmount),
                new SqlParameter("@GST",_GST),
                new SqlParameter("@Total",_Total),
                new SqlParameter("@EnteredBy",_EnteredBy),
                new SqlParameter("@Barcode",_Barcode),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "SP_PurchaseDetail");
        }
        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PurchaseDetailID",_PurchaseDetailID),
                new SqlParameter("@PurchaseID",_PurchaseID),
                new SqlParameter("@CompanyID",_CompanyID),
                new SqlParameter("@ProductID",_ProductID),
                new SqlParameter("@BatchNo",_BatchNo),
                new SqlParameter("@MfgDate",_MfgDate),
                new SqlParameter("@ExpiryDate",_ExpiryDate),
                new SqlParameter("@Quantity",_Quantity),  
                new SqlParameter("@Bonus",_Bonus),  
                new SqlParameter("@Price",_Price),
                new SqlParameter("@Discount",_Discount),
                new SqlParameter("@DiscountAmount",_DiscountAmount),
                new SqlParameter("@SpecialDiscount",_SpecialDiscount),
                new SqlParameter("@SpecialDiscAmount",_SpecialDiscAmount),
                new SqlParameter("@GST",_GST),
                new SqlParameter("@Total",_Total),
                new SqlParameter("@UpdatedBy",_UpdatedBy),  
                new SqlParameter("@Barcode",_Barcode),
                new SqlParameter("@ModeType", "UPDATE"),
            };
            return objconn.SqlCommParam(sqlParams, "SP_PurchaseDetail");
        }
        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PurchaseDetailID",_PurchaseDetailID),  
                new SqlParameter("@DeletedBy",_DeletedBy),  
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "SP_PurchaseDetail");
        }

        public int DeleteMethodBYPurchaseID()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PurchaseID",_PurchaseID),  
                new SqlParameter("@ModeType", "DELETE_PurchaseIDWise"), 
            };
            return objconn.SqlCommParam(sqlParams, "SP_PurchaseDetail");
        }

        public int DeleteMethodBYPurchaseID_IsDeleted1()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PurchaseID",_PurchaseID),  
                new SqlParameter("@ModeType", "DELETE_PurchaseIDWise_IsDeleted1"), 
            };
            return objconn.SqlCommParam(sqlParams, "SP_PurchaseDetail");
        }
        #endregion

        #region DDL
        public List<clsPurchaseDetail> GetAllData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            { 
                new SqlParameter("@PurchaseID", _PurchaseID),  
                new SqlParameter("@ModeType", "GetListForView"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "SP_PurchaseDetail");
            List<clsPurchaseDetail> list = new List<clsPurchaseDetail>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsPurchaseDetail obj = new clsPurchaseDetail();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        public List<clsPurchaseDetail> GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            { 
                new SqlParameter("@PurchaseID", _PurchaseID),  
                new SqlParameter("@ModeType", "GetListForView"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "SP_PurchaseDetail");
            List<clsPurchaseDetail> list = new List<clsPurchaseDetail>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsPurchaseDetail obj = new clsPurchaseDetail();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsPurchaseDetail AssignValues(clsPurchaseDetail obj, DataTable dt, int row)
        {
            obj.PurchaseDetailID = Convert.ToInt32(dt.Rows[row]["PurchaseDetailID"]);
            obj.PurchaseID = Convert.ToInt32(dt.Rows[row]["PurchaseID"]);
            obj.ProductID = Convert.ToInt32(dt.Rows[row]["ProductID"].ToString());
            obj.BatchNo = Convert.ToString(dt.Rows[row]["BatchNo"]);
            obj.MfgDate = Convert.ToDateTime(dt.Rows[row]["MfgDate"].ToString());
            obj.ExpiryDate = Convert.ToDateTime(dt.Rows[row]["ExpiryDate"].ToString());
            obj.Quantity = Convert.ToInt32(dt.Rows[row]["Quantity"]);
            obj.Bonus = Convert.ToInt32(dt.Rows[row]["Bonus"]);
            obj.Price = Convert.ToDecimal(dt.Rows[row]["Price"]);
            obj.Discount = Convert.ToInt32(dt.Rows[row]["Discount"]);
            obj.DiscountAmount = Convert.ToDecimal(dt.Rows[row]["DiscountAmount"]);
            obj.SpecialDiscount = Convert.ToInt32(dt.Rows[row]["SpecialDiscount"]);
            obj.SpecialDiscAmount = Convert.ToDecimal(dt.Rows[row]["SpecialDiscAmount"]);
            obj.GST = Convert.ToDecimal(dt.Rows[row]["GST"]);
            obj.Total = Convert.ToDecimal(dt.Rows[row]["Total"]);
            obj.EnteredBy = Convert.ToString(dt.Rows[row]["EnteredBy"]);

            obj.ProductName = Convert.ToString(dt.Rows[row]["ProductName"]);
            obj.Company = Convert.ToString(dt.Rows[row]["Company"]);


            return obj;
        }
        public int GetProductIDByBarcode()
        {
            DataTable dt = new DataTable();
            int ret = 0;
            SqlParameter[] sqlParams = new SqlParameter[]  
            { 
                new SqlParameter("@Barcode", _Barcode),  
                new SqlParameter("@ModeType", "GetProductIDByBarcode"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "SP_PurchaseDetail");

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                ret = Convert.ToInt32(dt.Rows[0]["ProductID"].ToString());
            }
            return ret;
        }
        #endregion

    }
}