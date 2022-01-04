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
    [Table("sp_AdmitPatientSaleReport")]
    public class clsAdmitPatientSaleReport
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private string _SaleID;
        private string _SaleInvoiceNumber;
        private string _SaleDate;
        private string _SaleType;
        private string _PatientName;
        private string _ContactNo;
        private string _GuardianName;
        private string _GuardianContactNo;
        private string _RoomNo;
        private string _Remarks;       
        private string _EnteredBy;
        private string _SaleDetailID;
        private string _Quantity;
        private decimal _Price;
        private string _Discount;
        private string _DiscountAmount;
        private string _Total;             
        private string _ProductName;
        
       

        private string _FromDate;
        private string _ToDate;

        public string SaleID { get { return _SaleID; } set { _SaleID = value; } }
        public string SaleInvoiceNumber { get { return _SaleInvoiceNumber; } set { _SaleInvoiceNumber = value; } }
        public string SaleDate { get { return _SaleDate; } set { _SaleDate = value; } }
        public string SaleType { get { return _SaleType; } set { _SaleType = value; } }
        public string PatientName { get { return _PatientName; } set { _PatientName = value; } }
        public string ContactNo { get { return _ContactNo; } set { _ContactNo = value; } }
        public string GuardianName { get { return _GuardianName; } set { _GuardianName = value; } }
        public string GuardianContactNo { get { return _GuardianContactNo; } set { _GuardianContactNo = value; } }
        public string RoomNo { get { return _RoomNo; } set { _RoomNo = value; } }
        public string Remarks { get { return _Remarks; } set { _Remarks = value; } }        
        public string EnteredBy { get { return _EnteredBy; } set { _EnteredBy = value; } }

        public string SaleDetailID { get { return _SaleDetailID; } set { _SaleDetailID = value; } }
        public string Quantity { get { return _Quantity; } set { _Quantity = value; } }
        public decimal Price { get { return _Price; } set { _Price = value; } }
        public string Discount { get { return _Discount; } set { _Discount = value; } }
        public string DiscountAmount { get { return _DiscountAmount; } set { _DiscountAmount = value; } }
        public string Total { get { return _Total; } set { _Total = value; } }
        
        public string ProductName { get { return _ProductName; } set { _ProductName = value; } }

        public string PatientRegNo { get; set; }

        public string FromDate { get { return _FromDate; } set { _FromDate = value; } }
        public string ToDate { get { return _ToDate; } set { _ToDate = value; } }

        #endregion

        public List<clsAdmitPatientSaleReport> AdmitPatientSalesReport()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@SaleID", _SaleID),
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_AdmitPatientSaleReport");
            List<clsAdmitPatientSaleReport> list = new List<clsAdmitPatientSaleReport>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsAdmitPatientSaleReport obj = new clsAdmitPatientSaleReport();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        protected clsAdmitPatientSaleReport AssignValues(clsAdmitPatientSaleReport obj, DataTable dt, int row)
        {
            obj.SaleID = Convert.ToString(dt.Rows[row]["SaleID"]);
            obj.SaleInvoiceNumber = Convert.ToString(dt.Rows[row]["SaleInvoiceNumber"]);
            obj.SaleDate = Convert.ToString(dt.Rows[row]["SaleDate"]);
            obj.Remarks = Convert.ToString(dt.Rows[row]["Remarks"]);
            obj.SaleType = Convert.ToString(dt.Rows[row]["SaleType"]);
            obj.PatientRegNo = Convert.ToString(dt.Rows[row]["PatientRegNo"]);            
            obj.PatientName = Convert.ToString(dt.Rows[row]["PatientName"]);
            obj.ContactNo = Convert.ToString(dt.Rows[row]["ContactNo"]);
            obj.GuardianName = Convert.ToString(dt.Rows[row]["GuardianName"]);
            obj.GuardianContactNo = Convert.ToString(dt.Rows[row]["GuardianContactNo"]);
            obj.RoomNo = Convert.ToString(dt.Rows[row]["RoomNo"]);            
            obj.EnteredBy = Convert.ToString(dt.Rows[row]["EnteredBy"]);

            obj.SaleDetailID = Convert.ToString(dt.Rows[row]["SaleDetailID"]);
            obj.Quantity = Convert.ToString(dt.Rows[row]["Quantity"]);
            obj.Price = Convert.ToDecimal(dt.Rows[row]["Price"]);
            obj.Discount = Convert.ToString(dt.Rows[row]["Discount"]);
            obj.DiscountAmount = Convert.ToString(dt.Rows[row]["DiscountAmount"]);
            obj.Total = Convert.ToString(dt.Rows[row]["Total"]);

            obj.ProductName = Convert.ToString(dt.Rows[row]["ProductName"]);

            return obj;
        }

    }
}