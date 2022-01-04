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
    [Table("sp_ProfitReport")]
    public class clsProfitReport
    {
        clsConnection objconn = new clsConnection();
        #region Properties
        private string _SaleDate;
        private string _PurchaseDiscountAmount;
        private string _SaleDiscountAmount;
        private string _ProfitAmount;
        private string _FromDate;
        private string _ToDate;
        private string _Year;

        private string _ReportType;

        public string SaleDate { get { return _SaleDate; } set { _SaleDate = value; } }
        public string PurchaseDiscountAmount { get { return _PurchaseDiscountAmount; } set { _PurchaseDiscountAmount = value; } }
        public string SaleDiscountAmount { get { return _SaleDiscountAmount; } set { _SaleDiscountAmount = value; } }
        public string ProfitAmount { get { return _ProfitAmount; } set { _ProfitAmount = value; } }

        public string FromDate { get { return _FromDate; } set { _FromDate = value; } }
        public string ToDate { get { return _ToDate; } set { _ToDate = value; } }
        public string Year { get { return _Year; } set { _Year = value; } }

        public string ReportType { get { return _ReportType; } set { _ReportType = value; } }
        

        public List<clsProfitReport> ProfitReport()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@FromDate", _FromDate), 
                new SqlParameter("@ToDate", _ToDate), 
                new SqlParameter("@ModeType", _ReportType), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_ProfitReport");
            List<clsProfitReport> list = new List<clsProfitReport>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsProfitReport obj = new clsProfitReport();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsProfitReport AssignValues(clsProfitReport obj, DataTable dt, int row)
        {
            obj.SaleDate = Convert.ToString(dt.Rows[row]["SaleDate"]);
            obj.PurchaseDiscountAmount = dt.Rows[row]["PurchaseDiscountAmount"].ToString();
            obj.SaleDiscountAmount = Convert.ToString(dt.Rows[row]["SaleDiscountAmount"]);
            obj.ProfitAmount = dt.Rows[row]["ProfitAmount"].ToString();

            return obj;
        }
        
        
        #endregion
    }
}