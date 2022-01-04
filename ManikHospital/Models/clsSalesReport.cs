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
    [Table("sp_SalesReport")]
    public class clsSalesReport
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
        private string _Diagnostics;
        private string _Remarks;
        private string _DateEntered;
        private string _EnteredBy;
        private string _SaleDetailID;
        private string _Quantity;
        private decimal _Price;
        private string _Discount;
        private string _DiscountAmount;
        private string _Total;
        private string _NetAmount;
        private string _ProductID;
        private string _ProductName;
        private string _ProductType;
        private string _Company;
        private string _DoctorID;

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
        public string Diagnostics { get { return _Diagnostics; } set { _Diagnostics = value; } }
        public string Remarks { get { return _Remarks; } set { _Remarks = value; } }
        public string DateEntered { get { return _DateEntered; } set { _DateEntered = value; } }
        public string EnteredBy { get { return _EnteredBy; } set { _EnteredBy = value; } }
        public string SaleDetailID { get { return _SaleDetailID; } set { _SaleDetailID = value; } }
        public string Quantity { get { return _Quantity; } set { _Quantity = value; } }
        public decimal Price { get { return _Price; } set { _Price = value; } }
        public string Discount { get { return _Discount; } set { _Discount = value; } }
        public string DiscountAmount { get { return _DiscountAmount; } set { _DiscountAmount = value; } }
        public string Total { get { return _Total; } set { _Total = value; } }
        public string NetAmount { get { return _NetAmount; } set { _NetAmount = value; } }
        public string ProductID { get { return _ProductID; } set { _ProductID = value; } }
        public string ProductName { get { return _ProductName; } set { _ProductName = value; } }
        public string ProductType { get { return _ProductType; } set { _ProductType = value; } }
        public string Company { get { return _Company; } set { _Company = value; } }
        public string DoctorID { get { return _DoctorID; } set { _DoctorID = value; } }

        public string FromDate { get { return _FromDate; } set { _FromDate = value; } }
        public string ToDate { get { return _ToDate; } set { _ToDate = value; } }

        public string DoctorName { get; set; }

        #endregion 

        
        public List<clsSalesReport> DailySalesReport()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@SaleType", _SaleType),
                new SqlParameter("@DoctorID", _DoctorID),
                new SqlParameter("@SaleDate", _SaleDate), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DailySaleReport");
            List<clsSalesReport> list = new List<clsSalesReport>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsSalesReport obj = new clsSalesReport();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsSalesReport AssignValues(clsSalesReport obj, DataTable dt, int row)
        {

            
            obj.SaleID = Convert.ToString(dt.Rows[row]["SaleID"]);
            obj.SaleInvoiceNumber = Convert.ToString(dt.Rows[row]["SaleInvoiceNumber"]);
            obj.SaleDate = Convert.ToString(dt.Rows[row]["SaleDate"]);
            obj.Remarks = Convert.ToString(dt.Rows[row]["Remarks"]);
            obj.SaleType = Convert.ToString(dt.Rows[row]["SaleType"]);
            obj.PatientName = Convert.ToString(dt.Rows[row]["PatientName"]);
            obj.ContactNo = Convert.ToString(dt.Rows[row]["ContactNo"]);
            obj.GuardianName = Convert.ToString(dt.Rows[row]["GuardianName"]);
            obj.GuardianContactNo = Convert.ToString(dt.Rows[row]["GuardianContactNo"]);
            obj.RoomNo = Convert.ToString(dt.Rows[row]["RoomNo"]);

            obj.Diagnostics = Convert.ToString(dt.Rows[row]["Diagnostics"]);

            obj.DateEntered = Convert.ToString(dt.Rows[row]["DateEntered"]);
            obj.EnteredBy = Convert.ToString(dt.Rows[row]["EnteredBy"]);

            obj.SaleDetailID = Convert.ToString(dt.Rows[row]["SaleDetailID"]);
            obj.Quantity = Convert.ToString(dt.Rows[row]["Quantity"]);
            obj.Price = Convert.ToDecimal(dt.Rows[row]["Price"]);
            obj.Discount = Convert.ToString(dt.Rows[row]["Discount"]);
            obj.DiscountAmount = Convert.ToString(dt.Rows[row]["DiscountAmount"]);
            obj.Total = Convert.ToString(dt.Rows[row]["Total"]);
            obj.NetAmount = Convert.ToString(dt.Rows[row]["NetAmount"]);

            obj.ProductType = Convert.ToString(dt.Rows[row]["ProductType"]);
            obj.ProductID = Convert.ToString(dt.Rows[row]["ProductID"]);
            obj.Company = Convert.ToString(dt.Rows[row]["Company"]);
            obj.ProductName = Convert.ToString(dt.Rows[row]["ProductName"]);
            obj.DoctorName = Convert.ToString(dt.Rows[row]["DoctorName"]);
            return obj;
        }

        public List<clsSalesReport> MonthlySalesReport()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@DoctorID", _DoctorID),
                new SqlParameter("@FromDate", _FromDate),
                new SqlParameter("@ToDate", _ToDate), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_MonthlySaleReport");
            List<clsSalesReport> list = new List<clsSalesReport>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsSalesReport obj = new clsSalesReport();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        public List<clsSalesReport> MonthlySalesSummaryReport()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@DoctorID", _DoctorID),
                new SqlParameter("@FromDate", _FromDate),
                new SqlParameter("@ToDate", _ToDate), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_MonthlySaleSummaryReport");
            List<clsSalesReport> list = new List<clsSalesReport>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsSalesReport obj = new clsSalesReport();
                obj = AssignValuesSummary(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsSalesReport AssignValuesSummary(clsSalesReport obj, DataTable dt, int row)
        {
            obj.Quantity = Convert.ToString(dt.Rows[row]["Quantity"]);
            obj.Price = Convert.ToDecimal(dt.Rows[row]["Price"]);           
            obj.DiscountAmount = Convert.ToString(dt.Rows[row]["DiscountAmount"]);
            obj.Total = Convert.ToString(dt.Rows[row]["Total"]);
            obj.NetAmount = Convert.ToString(dt.Rows[row]["NetAmount"]);
            obj.ProductType = Convert.ToString(dt.Rows[row]["ProductType"]);
            obj.ProductID = Convert.ToString(dt.Rows[row]["ProductID"]);
            obj.Company = Convert.ToString(dt.Rows[row]["Company"]);
            obj.ProductName = Convert.ToString(dt.Rows[row]["ProductName"]);
            obj.DoctorName = Convert.ToString(dt.Rows[row]["DoctorName"]);

            return obj;
        }

        public List<clsSalesReport> DailySalesReportSummary()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@SaleType", _SaleType),
                new SqlParameter("@DoctorID", _DoctorID),
                new SqlParameter("@SaleDate", _SaleDate), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DailySaleReport");
            List<clsSalesReport> list = new List<clsSalesReport>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsSalesReport obj = new clsSalesReport();
                obj = AssignValuesSumaryList(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsSalesReport AssignValuesSumaryList(clsSalesReport obj, DataTable dt, int row)
        {
            obj.SaleType = Convert.ToString(dt.Rows[row]["SaleType"]);
            obj.Quantity = Convert.ToString(dt.Rows[row]["Quantity"]);
            obj.Price = Convert.ToDecimal(dt.Rows[row]["Price"]);   
            obj.Total = Convert.ToString(dt.Rows[row]["Total"]);          
            obj.ProductName = Convert.ToString(dt.Rows[row]["ProductName"]);
            obj.DoctorName = Convert.ToString(dt.Rows[row]["DoctorName"]);
            return obj;
        }
        
    }
}
