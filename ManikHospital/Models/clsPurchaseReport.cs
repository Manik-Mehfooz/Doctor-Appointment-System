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
    [Table("sp_PurchaseReport")]
    public class clsPurchaseReport
    {
        clsConnection objconn = new clsConnection();

        #region Properties

        private string _PurchaseID;
        private string _InvioceNumber;
        private string _DrugAgency;
        private string _AgencyInvoiceNo;
        private string _InvoiceDate;
        private string _Remarks;
        private string _DateEntered;
        private string _EnteredBy;

        private string _PurchaseDetailID;
        private string _BatchNo;
        private string _MfgDate;
        private string _ExpiryDate;
        private string _Quantity;
        private int _Bonus;
        private string _Price;
        private string _Discount;
        private string _DiscountAmount;
        private string _SpecialDiscount;
        private string _SpecialDiscAmount;
        private string _GST;
        private decimal _Total;

        private string _ProductName;
        private string _Company;
        private string _CompanyID;

        private string _FromDate;
        private string _ToDate;
        


        public string PurchaseID { get { return _PurchaseID; } set { _PurchaseID = value; } }
        public string InvioceNumber { get { return _InvioceNumber; } set { _InvioceNumber = value; } }
        public string DrugAgency { get { return _DrugAgency; } set { _DrugAgency = value; } }
        public string AgencyInvoiceNo { get { return _AgencyInvoiceNo; } set { _AgencyInvoiceNo = value; } }
        public string InvoiceDate { get { return _InvoiceDate; } set { _InvoiceDate = value; } }
        public string Remarks { get { return _Remarks; } set { _Remarks = value; } }
        public string DateEntered { get { return _DateEntered; } set { _DateEntered = value; } }
        public string EnteredBy { get { return _EnteredBy; } set { _EnteredBy = value; } }

        public string PurchaseDetailID { get { return _PurchaseDetailID; } set { _PurchaseDetailID = value; } }
        public string BatchNo { get { return _BatchNo; } set { _BatchNo = value; } }
        public string MfgDate { get { return _MfgDate; } set { _MfgDate = value; } }
        public string ExpiryDate { get { return _ExpiryDate; } set { _ExpiryDate = value; } }
        public string Quantity { get { return _Quantity; } set { _Quantity = value; } }
        public string Price { get { return _Price; } set { _Price = value; } }
        public string Discount { get { return _Discount; } set { _Discount = value; } }
        public string DiscountAmount { get { return _DiscountAmount; } set { _DiscountAmount = value; } }
        public string SpecialDiscount { get { return _SpecialDiscount; } set { _SpecialDiscount = value; } }
        public string SpecialDiscAmount { get { return _SpecialDiscAmount; } set { _SpecialDiscAmount = value; } }
        public string GST { get { return _GST; } set { _GST = value; } }
        public decimal Total { get { return _Total; } set { _Total = value; } }

        public string ProductName { get { return _ProductName; } set { _ProductName = value; } }
        public string Company { get { return _Company; } set { _Company = value; } }
        public string CompanyID { get { return _CompanyID; } set { _CompanyID = value; } }

        public string FromDate { get { return _FromDate; } set { _FromDate = value; } }
        public string ToDate { get { return _ToDate; } set { _ToDate = value; } }

        public int Bonus { get { return _Bonus; } set { _Bonus = value; } }

        public string CompanyInvoiceNo { get; set; }
        public decimal TotalAmount { get; set; }
        public decimal PurchaseQty { get; set; }

        #endregion

        public List<clsPurchaseReport> PurchaseReport()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@PurchaseID", _PurchaseID), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_PurchaseReport");
            List<clsPurchaseReport> list = new List<clsPurchaseReport>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsPurchaseReport obj = new clsPurchaseReport();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsPurchaseReport AssignValues(clsPurchaseReport obj, DataTable dt, int row)
        {
            obj.PurchaseID = Convert.ToString(dt.Rows[row]["PurchaseID"]);
            obj.InvioceNumber = dt.Rows[row]["InvioceNumber"].ToString();
            obj.DrugAgency = Convert.ToString(dt.Rows[row]["DrugAgency"]);
            obj.AgencyInvoiceNo = dt.Rows[row]["AgencyInvoiceNo"].ToString();
            obj.InvoiceDate = Convert.ToString(dt.Rows[row]["InvoiceDate"].ToString());
            obj.Remarks = Convert.ToString(dt.Rows[row]["Remarks"]);
            obj.DateEntered = Convert.ToString(dt.Rows[row]["DateEntered"]);
            obj.EnteredBy = Convert.ToString(dt.Rows[row]["EnteredBy"]);

            obj.PurchaseDetailID = Convert.ToString(dt.Rows[row]["PurchaseDetailID"]);           
            obj.BatchNo = Convert.ToString(dt.Rows[row]["BatchNo"]);
            obj.MfgDate = Convert.ToString(dt.Rows[row]["MfgDate"].ToString());
            obj.ExpiryDate = Convert.ToString(dt.Rows[row]["ExpiryDate"].ToString());
            obj.Quantity = Convert.ToString(dt.Rows[row]["Quantity"]);
            obj.Bonus = Convert.ToInt32(dt.Rows[row]["Bonus"]);
            obj.Price = Convert.ToString(dt.Rows[row]["Price"]);
            obj.Discount = Convert.ToString(dt.Rows[row]["Discount"]);
            obj.DiscountAmount = Convert.ToString(dt.Rows[row]["DiscountAmount"]);
            obj.SpecialDiscount = Convert.ToString(dt.Rows[row]["SpecialDiscount"]);
            obj.SpecialDiscAmount = Convert.ToString(dt.Rows[row]["SpecialDiscAmount"]);
            obj.GST = Convert.ToString(dt.Rows[row]["GST"]);
            obj.Total = Convert.ToDecimal(dt.Rows[row]["Total"]);
            obj.EnteredBy = Convert.ToString(dt.Rows[row]["EnteredBy"]);

            obj.ProductName = Convert.ToString(dt.Rows[row]["ProductName"]);
            obj.Company = Convert.ToString(dt.Rows[row]["Company"]);


            return obj;
        }
        public List<clsPurchaseReport> PurchaseMainRpt()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@FromDate", _FromDate), 
                new SqlParameter("@ToDate", _ToDate), 
                new SqlParameter("@ModeType", "PurchaseByDate"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_PurchaseReport");
            List<clsPurchaseReport> list = new List<clsPurchaseReport>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsPurchaseReport obj = new clsPurchaseReport();
                obj = AssignValuesMain(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsPurchaseReport AssignValuesMain(clsPurchaseReport obj, DataTable dt, int row)
        {
            obj.PurchaseID = Convert.ToString(dt.Rows[row]["PurchaseID"]);
            obj.InvioceNumber = dt.Rows[row]["InvioceNumber"].ToString();
            obj.DrugAgency = Convert.ToString(dt.Rows[row]["DrugAgency"]);
            obj.AgencyInvoiceNo = dt.Rows[row]["AgencyInvoiceNo"].ToString();
            obj.InvoiceDate = Convert.ToString(dt.Rows[row]["InvoiceDate"].ToString());
            obj.Remarks = Convert.ToString(dt.Rows[row]["Remarks"]);
            obj.DateEntered = Convert.ToString(dt.Rows[row]["DateEntered"]);
            obj.EnteredBy = Convert.ToString(dt.Rows[row]["EnteredBy"]);

            return obj;
        }

        public List<clsPurchaseReport> PurchaseSummaryReport()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@FromDate", _FromDate),
                new SqlParameter("@ToDate", _ToDate),
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_PurchaseSummaryReport");
            List<clsPurchaseReport> list = new List<clsPurchaseReport>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsPurchaseReport obj = new clsPurchaseReport();
                obj = AssignValuesSummary(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsPurchaseReport AssignValuesSummary(clsPurchaseReport obj, DataTable dt, int row)
        {
            obj.InvioceNumber = dt.Rows[row]["InvioceNumber"].ToString();
            obj.Company = Convert.ToString(dt.Rows[row]["DrugAgency"]);
            obj.CompanyInvoiceNo = dt.Rows[row]["AgencyInvoiceNo"].ToString();
            obj.InvoiceDate = Convert.ToString(dt.Rows[row]["InvoiceDate"].ToString());
            obj.Remarks = Convert.ToString(dt.Rows[row]["Remarks"]);
            obj.TotalAmount = Convert.ToDecimal(dt.Rows[row]["TotalAmount"]);            

            return obj;
        }

        public List<clsPurchaseReport> MonthlyPurchaseDetailReport()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@FromDate", _FromDate), 
                new SqlParameter("@ToDate", _ToDate), 
                new SqlParameter("@ModeType", "MonthlyPurchaseDetail"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_PurchaseReport");
            List<clsPurchaseReport> list = new List<clsPurchaseReport>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsPurchaseReport obj = new clsPurchaseReport();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        
    }
}