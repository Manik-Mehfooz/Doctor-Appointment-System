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
    [Table("sp_DailyOPDReport")]
    public class clsRptDailyOPD
    {
        clsConnection objconn = new clsConnection();

        #region Properties
        private string _OPDID;
        private string _OPDNumber;
        private string _DoctorID;
        private string _PatientName;
        private string _ContactNo;
        private string _Age;
        private string _OPDDate;
        private string _DoctorName;

        private string _FromDate;
        private string _ToDate;

        public string OPDID { get { return _OPDID; } set { _OPDID = value; } }
        public string OPDNumber { get { return _OPDNumber; } set { _OPDNumber = value; } }
        [Display(Name="Doctor")]
        public string DoctorID { get { return _DoctorID; } set { _DoctorID = value; } }
        public string PatientName { get { return _PatientName; } set { _PatientName = value; } }
        public string ContactNo { get { return _ContactNo; } set { _ContactNo = value; } }
        public string Age { get { return _Age; } set { _Age = value; } }
        public string OPDDate { get { return _OPDDate; } set { _OPDDate = value; } }
        public string DoctorName { get { return _DoctorName; } set { _DoctorName = value; } }

        public string FromDate { get { return _FromDate; } set { _FromDate = value; } }
        public string ToDate { get { return _ToDate; } set { _ToDate = value; } }

        public string OPDFee { get; set; }
        public string NetOPDFee { get; set; }
        public decimal Discount { get; set; }
        public string Status { get; set; }
        public string Sex { get; set; }
        public string City { get; set; }

        public int OPDCount { get; set; }
        public string TokenDate { get; set; }
        public string TokenTime { get; set; }
        public string OPDCharges { get; set; }
        public decimal TotalAmount { get; set; }
        public decimal NetAmount { get; set; }
        public decimal Fees { get; set; }
                
       
        public decimal TotalFees { get; set; }
        public DateTime OPDTokenDate { get; set; }
        

        #endregion

        public List<clsRptDailyOPD> DailyOPDTokenReport()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
               new SqlParameter("@ModeType", "PrintOPDToken"),
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DailyOPDReport");
            List<clsRptDailyOPD> list = new List<clsRptDailyOPD>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsRptDailyOPD obj = new clsRptDailyOPD();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        public List<clsRptDailyOPD> RePrintDailyOPDTokenReport()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
               new SqlParameter("@OPDID", _OPDID),
               new SqlParameter("@ModeType", "RePrintOPDToken"),
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DailyOPDReport");
            List<clsRptDailyOPD> list = new List<clsRptDailyOPD>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsRptDailyOPD obj = new clsRptDailyOPD();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        protected clsRptDailyOPD AssignValues(clsRptDailyOPD obj, DataTable dt, int row)
        {
            obj.OPDID = Convert.ToString(dt.Rows[row]["OPDID"]);
            obj.OPDNumber = Convert.ToString(dt.Rows[row]["OPDNumber"]);
            obj.PatientName = Convert.ToString(dt.Rows[row]["PatientName"]);
            obj.ContactNo = Convert.ToString(dt.Rows[row]["ContactNo"]);
            obj.Age = Convert.ToString(dt.Rows[row]["Age"]);
            obj.Sex = Convert.ToString(dt.Rows[row]["Sex"]);
            obj.City = Convert.ToString(dt.Rows[row]["City"]);
            obj.OPDDate = Convert.ToString(dt.Rows[row]["OPDDate"]);
            obj.DoctorName = Convert.ToString(dt.Rows[row]["DoctorName"]);
            obj.Status = Convert.ToString(dt.Rows[row]["Status"]);
            obj.Discount = Convert.ToDecimal(dt.Rows[row]["Discount"]);
            obj.OPDFee = Convert.ToString(dt.Rows[row]["OPDFee"]);
            obj.NetOPDFee = Convert.ToString(dt.Rows[row]["NetOPDFee"]);

            return obj;
        }
        public List<clsRptDailyOPD> PatientAppointmentOPDToday()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
               new SqlParameter("@TodayOPD", DateTime.Now.ToShortDateString()),
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_RptPatientAppointmentOPDReport");
            List<clsRptDailyOPD> list = new List<clsRptDailyOPD>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsRptDailyOPD obj = new clsRptDailyOPD();
                obj = AssignValuesOPD(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsRptDailyOPD AssignValuesOPD(clsRptDailyOPD obj, DataTable dt, int row)
        {
            obj.OPDID = Convert.ToString(dt.Rows[row]["OPDID"]);
            obj.OPDNumber = Convert.ToString(dt.Rows[row]["OPDNumber"]);
            obj.PatientName = Convert.ToString(dt.Rows[row]["PatientName"]);
            obj.ContactNo = Convert.ToString(dt.Rows[row]["ContactNo"]);
            obj.Age = Convert.ToString(dt.Rows[row]["Age"]);
            obj.Sex = Convert.ToString(dt.Rows[row]["Sex"]);
            obj.City = Convert.ToString(dt.Rows[row]["City"]);
            obj.TokenDate = Convert.ToString(dt.Rows[row]["TokenDate"]);
            obj.TokenTime = Convert.ToString(dt.Rows[row]["TokenTime"]);
            obj.DoctorName = Convert.ToString(dt.Rows[row]["DoctorName"]);
            obj.OPDFee = Convert.ToString(dt.Rows[row]["OPDFee"]);
            obj.Discount = Convert.ToDecimal(dt.Rows[row]["Discount"]);
            obj.NetOPDFee = Convert.ToString(dt.Rows[row]["NetOPDFee"]);
            obj.Status = Convert.ToString(dt.Rows[row]["Status"]);
            obj.OPDCharges = Convert.ToString(dt.Rows[row]["OPDCharges"]);
            return obj;
        }
        public List<clsRptDailyOPD> DailyOPDSummaryReport()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
               new SqlParameter("@DoctorID", _DoctorID),
               new SqlParameter("@FromDate", _FromDate),
               new SqlParameter("@ToDate", _ToDate),
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DailyOPDSummaryReport");
            List<clsRptDailyOPD> list = new List<clsRptDailyOPD>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsRptDailyOPD obj = new clsRptDailyOPD();
                obj = AssignValuesForSummary(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsRptDailyOPD AssignValuesForSummary(clsRptDailyOPD obj, DataTable dt, int row)
        {
            obj.OPDDate = Convert.ToString(dt.Rows[row]["OPDDate"]);
            obj.DoctorName = Convert.ToString(dt.Rows[row]["DoctorName"]);
            obj.OPDCount = Convert.ToInt32(dt.Rows[row]["OPDCount"]);
            obj.Discount = Convert.ToDecimal(dt.Rows[row]["Discount"]);
            obj.Fees = Convert.ToDecimal(dt.Rows[row]["Fees"]);
            obj.TotalAmount = Convert.ToDecimal(dt.Rows[row]["TotalAmount"]);
            obj.NetAmount = Convert.ToDecimal(dt.Rows[row]["NetAmount"]);
            

            return obj;
        }

        public List<clsRptDailyOPD> PrintDailyOPDReport()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
               new SqlParameter("@DoctorID", _DoctorID),
               new SqlParameter("@PrintDate", _FromDate),               
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DailyOPDPrintReport");
            List<clsRptDailyOPD> list = new List<clsRptDailyOPD>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsRptDailyOPD obj = new clsRptDailyOPD();
                obj = AssignValuesPrint(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsRptDailyOPD AssignValuesPrint(clsRptDailyOPD obj, DataTable dt, int row)
        {           
            obj.OPDNumber = Convert.ToString(dt.Rows[row]["OPDNumber"]);
            obj.PatientName = Convert.ToString(dt.Rows[row]["PatientName"]);
            obj.ContactNo = Convert.ToString(dt.Rows[row]["ContactNo"]);
            obj.Age = Convert.ToString(dt.Rows[row]["Age"]);
            obj.Sex = Convert.ToString(dt.Rows[row]["Sex"]);
            obj.City = Convert.ToString(dt.Rows[row]["City"]);
            obj.OPDDate = Convert.ToString(dt.Rows[row]["OPDDate"]);
            obj.DoctorName = Convert.ToString(dt.Rows[row]["DoctorName"]);
            obj.Status = Convert.ToString(dt.Rows[row]["Status"]);
            obj.Discount = Convert.ToDecimal(dt.Rows[row]["Discount"]);
            obj.Fees = Convert.ToDecimal(dt.Rows[row]["Fees"]);
            obj.TotalFees = Convert.ToDecimal(dt.Rows[row]["TotalFees"]);
            obj.OPDTokenDate = Convert.ToDateTime(dt.Rows[row]["OPDTokenDate"]);
            obj.TokenTime = Convert.ToString(dt.Rows[row]["TokenTime"]);

            return obj;
        }
    }
}