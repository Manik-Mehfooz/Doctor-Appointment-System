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
    public class clsAdmitPatientSummaryReport
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        
        private string _SaleInvoiceNumber;
        private string _SaleDate;       
        private string _PatientName;
        private string _ContactNo;
        private string _GuardianName;
        private string _GuardianContactNo;
        private string _RoomNo;
        private string _Diagnostics;        
        private string _DiscountAmount;
        private string _Total;          

        private string _FromDate;
        private string _ToDate;

       
        public string SaleInvoiceNumber { get { return _SaleInvoiceNumber; } set { _SaleInvoiceNumber = value; } }
        public string SaleDate { get { return _SaleDate; } set { _SaleDate = value; } }
        public string PatientName { get { return _PatientName; } set { _PatientName = value; } }       
        public string ContactNo { get { return _ContactNo; } set { _ContactNo = value; } }    
        public string GuardianName { get { return _GuardianName; } set { _GuardianName = value; } }
        public string GuardianContactNo { get { return _GuardianContactNo; } set { _GuardianContactNo = value; } }
        public string RoomNo { get { return _RoomNo; } set { _RoomNo = value; } }
        public string Diagnostics { get { return _Diagnostics; } set { _Diagnostics = value; } }
        public string DiscountAmount { get { return _DiscountAmount; } set { _DiscountAmount = value; } }
        public string Total { get { return _Total; } set { _Total = value; } }
        public string FromDate { get { return _FromDate; } set { _FromDate = value; } }
        public string ToDate { get { return _ToDate; } set { _ToDate = value; } }
        
        

        #endregion 

        
        public List<clsAdmitPatientSummaryReport> AdmitPatientSummaryReport()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@FromDate", _FromDate),
                new SqlParameter("@ToDate", _ToDate),
                new SqlParameter("@ModeType", "GetAdmitPatient"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_rptAdmitPatientSummary");
            List<clsAdmitPatientSummaryReport> list = new List<clsAdmitPatientSummaryReport>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsAdmitPatientSummaryReport obj = new clsAdmitPatientSummaryReport();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsAdmitPatientSummaryReport AssignValues(clsAdmitPatientSummaryReport obj, DataTable dt, int row)
        {
            obj.SaleInvoiceNumber = Convert.ToString(dt.Rows[row]["SaleInvoiceNumber"]);
            obj.SaleDate = Convert.ToString(dt.Rows[row]["SaleDate"]);
            obj.PatientName = Convert.ToString(dt.Rows[row]["PatientName"]);
            obj.ContactNo = Convert.ToString(dt.Rows[row]["ContactNo"]);
            obj.GuardianName = Convert.ToString(dt.Rows[row]["GuardianName"]);
            obj.GuardianContactNo = Convert.ToString(dt.Rows[row]["GuardianContactNo"]);
            obj.RoomNo = Convert.ToString(dt.Rows[row]["RoomNo"]);
            obj.Diagnostics = Convert.ToString(dt.Rows[row]["Diagnostics"]);
            obj.DiscountAmount = Convert.ToString(dt.Rows[row]["DiscountAmount"]);
            obj.Total = Convert.ToString(dt.Rows[row]["Total"]);
            obj.FromDate = Convert.ToString(dt.Rows[row]["FromDate"]);
            obj.ToDate = Convert.ToString(dt.Rows[row]["ToDate"]);            

            return obj;
        }

    }
}
