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
    [Table("sp_DashBoard")]
    public class clsDashBoard
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private string _TodayLabTest;
        private string _TodayXRay;
        private string _PatientName;
        private string _ContactNo;
        private string _TestName;
        private string _TestDate;
        private string _InvioceNumber;
        private string _DrugAgency;
        private string _AgencyInvoiceNo;
        private string _InvoiceDate;
        private string _ProductName;
        private string _BatchNo;
        private string _ExpiryDate;
        private string _Charges;

        private string _StockQuantity;

        #endregion 

        #region Properties

        public string TodayLabTest { get { return _TodayLabTest; } set { _TodayLabTest = value; } }
        public string TodayXRay { get { return _TodayXRay; } set { _TodayXRay = value; } }
        public string PatientName { get { return _PatientName; } set { _PatientName = value; } }
        public string ContactNo { get { return _ContactNo; } set { _ContactNo = value; } }
        public string TestName { get { return _TestName; } set { _TestName = value; } }
        public string TestDate { get { return _TestDate; } set { _TestDate = value; } }
        public string InvioceNumber { get { return _InvioceNumber; } set { _InvioceNumber = value; } }
        public string DrugAgency { get { return _DrugAgency; } set { _DrugAgency = value; } }
        public string AgencyInvoiceNo { get { return _AgencyInvoiceNo; } set { _AgencyInvoiceNo = value; } }
        public string InvoiceDate { get { return _InvoiceDate; } set { _InvoiceDate = value; } }
        public string ProductName { get { return _ProductName; } set { _ProductName = value; } }
        public string BatchNo { get { return _BatchNo; } set { _BatchNo = value; } }
        public string ExpiryDate { get { return _ExpiryDate; } set { _ExpiryDate = value; } }
        public string Charges { get { return _Charges; } set { _Charges = value; } }

        public string StockQuantity { get { return _StockQuantity; } set { _StockQuantity = value; } }
        


        #endregion
        

        #region DDL Methods       

        public List<clsDashBoard> GetAllExpiraryDateProducts()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {                
                new SqlParameter("@ModeType", "GetAllExpiryDateBeforeOneMonth"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DashBoard");
            List<clsDashBoard> list = new List<clsDashBoard>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsDashBoard obj = new clsDashBoard();  
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        protected clsDashBoard AssignValues(clsDashBoard obj, DataTable dt, int row)
        {
            obj.ProductName = Convert.ToString(dt.Rows[row]["ProductName"]);
            obj.BatchNo = Convert.ToString(dt.Rows[row]["BatchNo"]);
            obj.InvioceNumber = Convert.ToString(dt.Rows[row]["InvioceNumber"]);
            obj.DrugAgency = Convert.ToString(dt.Rows[row]["DrugAgency"]);
            obj.AgencyInvoiceNo = Convert.ToString(dt.Rows[row]["AgencyInvoiceNo"]);
            obj.InvoiceDate = Convert.ToString(dt.Rows[row]["InvoiceDate"]);
            obj.ExpiryDate = Convert.ToString(dt.Rows[row]["ExpiryDate"]);
            return obj;
        }

        public List<clsDashBoard> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {                 
                new SqlParameter("@ModeType", "GetAllPaymentReceivable"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DashBoard");
            List<clsDashBoard> list = new List<clsDashBoard>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsDashBoard obj = new clsDashBoard();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }  
            return list;
        }

        public string GetTodayTotalLabTest()
        {
            DataTable dt = new DataTable();
            string labtest = "";
            SqlParameter[] sqlParams = new SqlParameter[]  
            {                
                new SqlParameter("@ModeType", "LabTest"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DashBoard");
           
            if (dt.Rows.Count > 0)
            {
                labtest = dt.Rows[0]["TodayLabTest"].ToString();
            }
            return labtest;
        }
        public string GetTodayTotalXray()
        {
            DataTable dt = new DataTable();
            string xraytest = "";
            SqlParameter[] sqlParams = new SqlParameter[]  
            {                
                new SqlParameter("@ModeType", "XRayTest"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DashBoard");

            if (dt.Rows.Count > 0)
            {
                xraytest = dt.Rows[0]["TodayXRay"].ToString();
            }
            return xraytest;
        }

        public string TodayTotalPurchase()
        {
            DataTable dt = new DataTable();
            string amount = "";
            SqlParameter[] sqlParams = new SqlParameter[]  
            {                
                new SqlParameter("@ModeType", "TodayTotalPurchase"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DashBoard");

            if (dt.Rows.Count > 0)
            {
                amount = dt.Rows[0]["TotalPurchaseAmount"].ToString();
            }
            return amount;
        }
        public string TodayTotalSale()
        {
            DataTable dt = new DataTable();
            string amount = "";
            SqlParameter[] sqlParams = new SqlParameter[]  
            {                
                new SqlParameter("@ModeType", "TodayTotalSale"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DashBoard");

            if (dt.Rows.Count > 0)
            {
                amount = dt.Rows[0]["TotalSale"].ToString();
            }
            return amount;
        }

        public List<clsDashBoard> GetAllPaymentReceivable()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {                
                new SqlParameter("@ModeType", "GetAllPaymentReceivable"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DashBoard");
            List<clsDashBoard> list = new List<clsDashBoard>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsDashBoard obj = new clsDashBoard();
                obj = AssignValuesPayment(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsDashBoard AssignValuesPayment(clsDashBoard obj, DataTable dt, int row)
        {
            obj.PatientName = Convert.ToString(dt.Rows[row]["PatientName"]);
            obj.ContactNo = Convert.ToString(dt.Rows[row]["ContactNo"]);
            obj.TestName = Convert.ToString(dt.Rows[row]["TestName"]);
            obj.TestDate = Convert.ToString(dt.Rows[row]["TestDate"]);
            obj.Charges = Convert.ToString(dt.Rows[row]["Charges"]);           
            return obj;
        }


        public List<clsDashBoard> GetAllMedicineNeedToPurchase()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {                
                new SqlParameter("@ModeType", "DashBoardView"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_CurrentStock");
            List<clsDashBoard> list = new List<clsDashBoard>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsDashBoard obj = new clsDashBoard();  
                obj = AssignStockQunatity(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        protected clsDashBoard AssignStockQunatity(clsDashBoard obj, DataTable dt, int row)
        {
            obj.ProductName = Convert.ToString(dt.Rows[row]["ProductName"]);
            obj.StockQuantity = Convert.ToString(dt.Rows[row]["StockQuantity"]);

            return obj;
        }

        public int TodayOPDSaleInvoice()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ModeType", "TodayOPDSaleInvoice"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DashBoard");
            if (dt.Rows.Count > 0)
            {
                return Convert.ToInt32(dt.Rows[0]["TotalInv"]);
            }
            return 0;
        }

        #endregion
    }
}
