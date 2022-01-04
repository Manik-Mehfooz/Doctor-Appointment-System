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
    public class clsRptOutDoorPatientTestSummary
    {
        clsConnection objconn = new clsConnection();

        #region Properties
         
        private string _DoctorID;
        private string _TestType;

        private string _FromDate;
        private string _ToDate;

        
        [Display(Name="Doctor")]
        public string DoctorID { get { return _DoctorID; } set { _DoctorID = value; } }
        [Display(Name = "Test Type")]
        public string TestType { get { return _TestType; } set { _TestType = value; } }
        
        public string FromDate { get { return _FromDate; } set { _FromDate = value; } }
        public string ToDate { get { return _ToDate; } set { _ToDate = value; } }

        public string TestDate { get; set; }
        public string TestName { get; set; }
        public string DoctorName { get; set; } 
        public decimal Charges { get; set; }
        public int TotalTest { get; set; }
        public decimal TotalAmount { get; set; }
        public decimal Discount { get; set; }
        public decimal NetAmount { get; set; }

        public string TestNo { get; set; }
        public string PatientName { get; set; }
        public string TestTime { get; set; }
        public string ContactNo { get; set; }

        #endregion

        public List<clsRptOutDoorPatientTestSummary> OutDoorPatientTestSummary()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
               new SqlParameter("@DoctorID", _DoctorID),
               new SqlParameter("@TestType", _TestType),
               new SqlParameter("@FromDate", _FromDate),
               new SqlParameter("@ToDate", _ToDate),
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_RptOutDoorPatientTestSummaryReport");
            List<clsRptOutDoorPatientTestSummary> list = new List<clsRptOutDoorPatientTestSummary>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsRptOutDoorPatientTestSummary obj = new clsRptOutDoorPatientTestSummary();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsRptOutDoorPatientTestSummary AssignValues(clsRptOutDoorPatientTestSummary obj, DataTable dt, int row)
        {
            obj.TestDate = Convert.ToString(dt.Rows[row]["TestDate"]);
            obj.TestName = Convert.ToString(dt.Rows[row]["TestName"]);
            obj.DoctorName = Convert.ToString(dt.Rows[row]["DoctorName"]);
            obj.TestType = Convert.ToString(dt.Rows[row]["TestType"]);
            obj.Charges = Convert.ToDecimal(dt.Rows[row]["Charges"]);
            obj.TotalTest = Convert.ToInt32(dt.Rows[row]["TotalTest"]);
            obj.TotalAmount = Convert.ToDecimal(dt.Rows[row]["TotalAmount"]);
            obj.Discount = Convert.ToDecimal(dt.Rows[row]["Discount"]);
            obj.NetAmount = Convert.ToDecimal(dt.Rows[row]["NetAmount"]);
            return obj;
        }


        public List<clsRptOutDoorPatientTestSummary> DailyOPDInvestigationTestReport()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
               new SqlParameter("@DoctorID", _DoctorID),
               new SqlParameter("@TestType", _TestType),
               new SqlParameter("@FromDate", _FromDate),
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_RptDailyOPDInvestigationTestReport");
            List<clsRptOutDoorPatientTestSummary> list = new List<clsRptOutDoorPatientTestSummary>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsRptOutDoorPatientTestSummary obj = new clsRptOutDoorPatientTestSummary();
                obj = AssignValuesDaily(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsRptOutDoorPatientTestSummary AssignValuesDaily(clsRptOutDoorPatientTestSummary obj, DataTable dt, int row)
        {
            obj.TestDate = Convert.ToString(dt.Rows[row]["TestDate"]);
            obj.TestNo = Convert.ToString(dt.Rows[row]["TestNo"]);
            obj.PatientName = Convert.ToString(dt.Rows[row]["PatientName"]);
            obj.TestType = Convert.ToString(dt.Rows[row]["TestType"]);
            obj.TestName = Convert.ToString(dt.Rows[row]["TestName"]);
            obj.DoctorName = Convert.ToString(dt.Rows[row]["DoctorName"]);
            obj.Charges = Convert.ToDecimal(dt.Rows[row]["Charges"]);
            obj.Discount = Convert.ToDecimal(dt.Rows[row]["Discount"]);
            obj.NetAmount = Convert.ToDecimal(dt.Rows[row]["NetAmount"]);
            obj.TestTime = Convert.ToString(dt.Rows[row]["TestTime"]);
            obj.ContactNo = Convert.ToString(dt.Rows[row]["ContactNo"]);
            return obj;
        }

    }
}