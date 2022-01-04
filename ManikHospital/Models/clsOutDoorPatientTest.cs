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
    [Table("OutDoorPatientTest")]
    public class clsOutDoorPatientTest
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _OutDoorTestID;
        private string _TestNo;
        private DateTime _TestDate;
        private string _PatientName;
        private int _DoctorID;
        private string _DoctorName;
        private string _ContactNo;
        private int _Age;
        private string _Sex;
        private int _TestID;
        private decimal _Discount;
        private string _ModeType;

        private string _InvestigationTestNumber;

        #endregion 

        #region Properties

        public int OutDoorTestID { get { return _OutDoorTestID; } set { _OutDoorTestID = value; } }

        [Display(Name = "Test Number")]
        public string TestNo { get { return _TestNo; } set { _TestNo = value; } }

        [Display(Name = "Test Date")]
        public DateTime TestDate { get { return _TestDate; } set { _TestDate = value; } }

        [Display(Name = "Patient Name")]
        public string PatientName { get { return _PatientName; } set { _PatientName = value; } }

        [Display(Name = "Refer By")]
        public int DoctorID { get { return _DoctorID; } set { _DoctorID = value; } }

        [Display(Name = "Doctor Name")]
        public string DoctorName { get { return _DoctorName; } set { _DoctorName = value; } }

        [Display(Name = "Contact No")]
        public string ContactNo { get { return _ContactNo; } set { _ContactNo = value; } }

        [Display(Name = "Age")]
        public int Age { get { return _Age; } set { _Age = value; } }

        [Display(Name = "Sex")]
        public string Sex { get { return _Sex; } set { _Sex = value; } }

        [Display(Name = "Investigation Test")]
        public int TestID { get { return _TestID; } set { _TestID = value; } }

        public decimal Discount { get { return _Discount; } set { _Discount = value; } } 
        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }

        public string TestName { get; set; }
        [Display(Name = "Investigation Type")]
        public string TestType { get; set; }
        public decimal Charges { get; set; }

        public string InvestigationTestNumber { get { return _InvestigationTestNumber; } set { _InvestigationTestNumber = value; } }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            { 
                 new SqlParameter("@TestNo",_TestNo),
                 new SqlParameter("@TestDate",_TestDate.ToShortDateString()+" "+DateTime.Now.ToShortTimeString()),
                 new SqlParameter("@PatientName",_PatientName),
                 new SqlParameter("@DoctorID",_DoctorID),
                 new SqlParameter("@DoctorName",_DoctorName),
                 new SqlParameter("@ContactNo",_ContactNo),
                 new SqlParameter("@Age",_Age),
                 new SqlParameter("@Sex",_Sex),
                 new SqlParameter("@TestID",_TestID),
                 new SqlParameter("@Discount",_Discount),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_OutDoorPatientTest");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                 new SqlParameter("@OutDoorTestID",_OutDoorTestID),
                 new SqlParameter("@TestNo",_TestNo),
                 new SqlParameter("@TestDate",_TestDate),
                 new SqlParameter("@PatientName",_PatientName),
                 new SqlParameter("@DoctorID",_DoctorID),
                 new SqlParameter("@DoctorName",_DoctorName),
                 new SqlParameter("@ContactNo",_ContactNo),
                 new SqlParameter("@Age",_Age),
                 new SqlParameter("@Sex",_Sex),
                 new SqlParameter("@TestID",_TestID),
                 new SqlParameter("@Discount",_Discount),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_OutDoorPatientTest");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@OutDoorTestID",_OutDoorTestID),
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_OutDoorPatientTest");
        }

        #endregion

        #region DDL Methods
         
        public clsOutDoorPatientTest GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@OutDoorTestID",_OutDoorTestID),  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_OutDoorPatientTest");
            clsOutDoorPatientTest obj = new clsOutDoorPatientTest();            
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsOutDoorPatientTest AssignValues(clsOutDoorPatientTest obj, DataTable dt, int row)
        { 
            obj.OutDoorTestID = Convert.ToInt32(dt.Rows[row]["OutDoorTestID"]);
            obj.TestNo = Convert.ToString(dt.Rows[row]["TestNo"]);
            obj.TestDate = Convert.ToDateTime(dt.Rows[row]["TestDate"]);
            obj.PatientName = Convert.ToString(dt.Rows[row]["PatientName"]);
            obj.DoctorID = Convert.ToInt32(dt.Rows[row]["DoctorID"]);
            obj.DoctorName = Convert.ToString(dt.Rows[row]["DoctorName"]);
            obj.ContactNo = Convert.ToString(dt.Rows[row]["ContactNo"]);
            obj.Age = Convert.ToInt32(dt.Rows[row]["Age"]);
            obj.Sex = Convert.ToString(dt.Rows[row]["Sex"]);
            obj.TestID = Convert.ToInt32(dt.Rows[row]["TestID"]);
            obj.Discount = Convert.ToDecimal(dt.Rows[row]["Discount"]);
            obj.Charges = Convert.ToDecimal(dt.Rows[row]["Charges"]);
            obj.TestType = Convert.ToString(dt.Rows[row]["TestType"]);
            obj.TestName = Convert.ToString(dt.Rows[row]["TestName"]);
            return obj;
        }

        public List<clsOutDoorPatientTest> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_OutDoorPatientTest");
            List<clsOutDoorPatientTest> list = new List<clsOutDoorPatientTest>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsOutDoorPatientTest obj = new clsOutDoorPatientTest();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }  
            return list;
        }

        public string GetInvetigationTestNumber()
        {
            DataTable dt = new DataTable();
            string investigationnumber = "";
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@TestID", TestID), 
                new SqlParameter("@ModeType", "InvestigationTestNumber"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_OutDoorPatientTest");
            clsOutDoorPatientTest obj = new clsOutDoorPatientTest();
            if (dt.Rows.Count > 0)
            {
                investigationnumber = dt.Rows[0]["InvestigationTestNumber"].ToString();
            }
            return investigationnumber;
        }

        public int GetMaxOutDoorPatientTestID()
        {
            DataTable dt = new DataTable();
            int maxID = 0;
            SqlParameter[] sqlParams = new SqlParameter[]  
            {                 
                new SqlParameter("@ModeType", "GetMaxID"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_OutDoorPatientTest");
            clsOutDoorPatientTest obj = new clsOutDoorPatientTest();
            if (dt.Rows.Count > 0)
            {
                maxID = Convert.ToInt32(dt.Rows[0]["OutDoorTestID"].ToString());
            }
            return maxID;
        }
       
        #endregion
    }
}
