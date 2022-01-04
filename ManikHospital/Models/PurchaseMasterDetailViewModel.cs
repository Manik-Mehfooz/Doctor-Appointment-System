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
    public class PurchaseMasterDetailViewModel
    {
        clsConnection con = new clsConnection();

        //Purchase Master
        #region private properties
        private int _PurchaseID;
        private string _InvioceNumber;
        private string _DrugAgency;
        private string _AgencyInvoiceNo;
        private DateTime _InvoiceDate;
        private string _Remarks;
        private string _EnteredBy;
        private string _UpdatedBy;
        private string _DeletedBy;

        //Purchase Detail
        private int _PurchaseDetailID;        
        private int _CompanyID;
        private int _ProductID;
        private string _BatchNo;
        private DateTime _MfgDate;
        private DateTime _ExpiryDate;
        private int _Quantity;
        private decimal _Price;
        private decimal _Discount;
        private decimal _DiscountAmount;
        private decimal _SpecialDiscount;
        private decimal _SpecialDiscAmount;
        private decimal _GST;
        private decimal _Total;

        #endregion

        #region Public Properties

        //Purchase Master
        public int PurchaseID { get { return _PurchaseID; } set { _PurchaseID = value; } }

        [Display(Name = "Invoice Number")]
        public string InvioceNumber { get { return _InvioceNumber; } set { _InvioceNumber = value; } }

        [Required(ErrorMessage = "Please Enter Agency Name"), Display(Name = "Agency Name")]
        public string DrugAgency { get { return _DrugAgency; } set { _DrugAgency = value; } }

        [Required(ErrorMessage = "Please Enter Agency Invoice Name"), Display(Name = "Agency Invoice Name")]
        public string AgencyInvoiceNo { get { return _AgencyInvoiceNo; } set { _AgencyInvoiceNo = value; } }

        [Required(ErrorMessage = "Please Enter Invoice Date"), Display(Name = "Invoice Date")]
        public DateTime InvoiceDate { get { return _InvoiceDate; } set { _InvoiceDate = value; } }

        public string Remarks { get { return _Remarks; } set { _Remarks = value; } }
        public string EnteredBy { get { return _EnteredBy; } set { _EnteredBy = value; } }
        public string UpdatedBy { get { return _UpdatedBy; } set { _UpdatedBy = value; } }
        public string DeletedBy { get { return _DeletedBy; } set { _DeletedBy = value; } }


        //Purchase Detail
        public int PurchaseDetailID { get { return _PurchaseDetailID; } set { _PurchaseDetailID = value; } }       
        public int CompanyID { get { return _CompanyID; } set { _CompanyID = value; } }
        [Required]
        public int ProductID { get { return _ProductID; } set { _ProductID = value; } }
        public string BatchNo { get { return _BatchNo; } set { _BatchNo = value; } }
        public DateTime MfgDate { get { return _MfgDate; } set { _MfgDate = value; } }
        [Required]
        public DateTime ExpiryDate { get { return _ExpiryDate; } set { _ExpiryDate = value; } }
        [Required]
        public int Quantity { get { return _Quantity; } set { _Quantity = value; } }
        [Required]
        public decimal Price { get { return _Price; } set { _Price = value; } }
        [Required]
        public decimal Discount { get { return _Discount; } set { _Discount = value; } }
        public decimal DiscountAmount { get { return _DiscountAmount; } set { _DiscountAmount = value; } }
        public decimal SpecialDiscount { get { return _SpecialDiscount; } set { _SpecialDiscount = value; } }
        public decimal SpecialDiscAmount { get { return _SpecialDiscAmount; } set { _SpecialDiscAmount = value; } }
        public decimal GST { get { return _GST; } set { _GST = value; } }
        public decimal Total { get { return _Total; } set { _Total = value; } }

        #endregion


        #region DDL Methods

        public List<PurchaseMasterDetailViewModel> GetAllMasterData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {                  
                new SqlParameter("@ModeType", "GET_LIST"), 
            };
            dt = con.SqlFillDataStoreProcedure(sqlParams, "SP_PurchaseMaster");
            List<PurchaseMasterDetailViewModel> list = new List<PurchaseMasterDetailViewModel>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                PurchaseMasterDetailViewModel obj = new PurchaseMasterDetailViewModel();
                obj = AssignMasterValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected PurchaseMasterDetailViewModel AssignMasterValues(PurchaseMasterDetailViewModel obj, DataTable dt, int row)
        {
            obj.PurchaseID = Convert.ToInt32(dt.Rows[row]["PurchaseID"]);
            obj.InvioceNumber = dt.Rows[row]["InvioceNumber"].ToString();
            obj.DrugAgency = Convert.ToString(dt.Rows[row]["DrugAgency"]);
            obj.AgencyInvoiceNo = Convert.ToString(dt.Rows[row]["AgencyInvoiceNo"]);
            obj.InvoiceDate = Convert.ToDateTime(dt.Rows[row]["InvoiceDate"]);
           
            return obj;
        }


        


        #endregion 

    }
}