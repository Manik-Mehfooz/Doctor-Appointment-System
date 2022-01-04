using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MedicalStore.Models
{
    [Table("OutDoorPatientTest")]
    public class clsRptOutDoorPatientTestToken
    {
        clsConnection objconn = new clsConnection();

        #region Private variables
        private int _OutDoorTestID;
        private string _TestNo;
        private string _TestDate;
        private string _PatientName;
        private string _ContactNo;
        private string _PatientAge;
        private DateTime _OPDDate;
        private decimal _Discount;
        private string _Status;

        public int OutDoorTestID { get { return _OutDoorTestID; } set { _OutDoorTestID = value; } }
        public string TestNo { get { return _TestNo; } set { _TestNo = value; } }
        public string TestDate { get { return _TestDate; } set { _TestDate = value; } }       
        public string PatientName { get { return _PatientName; } set { _PatientName = value; } }        
        public string ContactNo { get { return _ContactNo; } set { _ContactNo = value; } }
        public string PatientAge { get { return _PatientAge; } set { _PatientAge = value; } }
        public decimal Discount { get { return _Discount; } set { _Discount = value; } }
        public string DoctorName { get; set; }
        public string TestTime { get; set; }
        public string TestName { get; set; }
        public string Charges { get; set; }
        public string TotalCharges { get; set; }
        public string Sex { get; set; }

        #endregion

        #region DDL Methods
        public List<clsRptOutDoorPatientTestToken> GetOutDoorPatientInvestigationToken()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParam = new SqlParameter[]  
            {                  
                new SqlParameter("@OutDoorTestID", _OutDoorTestID), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParam, "sp_OutDoorPatientTestTokenReport");
            List<clsRptOutDoorPatientTestToken> list = new List<clsRptOutDoorPatientTestToken>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsRptOutDoorPatientTestToken obj = new clsRptOutDoorPatientTestToken();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        public List<clsRptOutDoorPatientTestToken> GetTodayOutDoorPatientInvestigationToken()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParam = new SqlParameter[]  
            {                  
                new SqlParameter("@TodayTest", DateTime.Now.ToShortDateString()), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParam, "sp_OutDoorPatientTestTokenReport");
            List<clsRptOutDoorPatientTestToken> list = new List<clsRptOutDoorPatientTestToken>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsRptOutDoorPatientTestToken obj = new clsRptOutDoorPatientTestToken();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsRptOutDoorPatientTestToken AssignValues(clsRptOutDoorPatientTestToken obj, DataTable dt, int row)
        {
            obj.TestNo = Convert.ToString(dt.Rows[row]["TestNo"]);
            obj.TestDate = Convert.ToString(dt.Rows[row]["TestDate"]);
            obj.TestTime = Convert.ToString(dt.Rows[row]["TestTime"]);     
            obj.PatientName = Convert.ToString(dt.Rows[row]["PatientName"]);          
            obj.ContactNo = Convert.ToString(dt.Rows[row]["ContactNo"]);
            obj.PatientAge = Convert.ToString(dt.Rows[row]["PatientAge"]);
            obj.Sex = Convert.ToString(dt.Rows[row]["Sex"]);
            obj.DoctorName = Convert.ToString(dt.Rows[row]["DoctorName"]);                  
            obj.TestName = Convert.ToString(dt.Rows[row]["TestName"]);           
            obj.Discount = Convert.ToDecimal(dt.Rows[row]["Discount"]);
            obj.Charges = Convert.ToString(dt.Rows[row]["Charges"]);
            obj.TotalCharges = Convert.ToString(dt.Rows[row]["TotalCharges"]);
            
            return obj;
        }

        #endregion
    }
}