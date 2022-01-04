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
    public class clsPatientDiagnosticTest
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _PatientTestID;
        private int _TestID;
        private int _PatientID;
        private string _PatientName;
        private string _ContactNo;
        private string _DoctorName;
        private string _Symptoms;
        private decimal _Discount;
        private string _Remarks;
        private string _Status;
        private DateTime _TestDate;
        private string _Payment;
        private string _Gender;
        private string _Age;
        private string _TestRange;
        private string _Result;
        private string _Pathologist;
        private string _Technologist;
        private string _LabNumber;
        private DateTime _DeliveryDate;
        private string _EnteredBy;
        private DateTime _UpdatedDate;
        private string _UpdatedBy;
        private int _IsDeleted;
        private DateTime _DeletedDate;
        private string _DeletedBy;
        private string _ModeType;
        private string _Search;

        #endregion

        #region Properties

        public int PatientTestID { get { return _PatientTestID; } set { _PatientTestID = value; } }
        public int PatientID { get { return _PatientID; } set { _PatientID = value; } }

        [Required(ErrorMessage = "Please Select Test Name"), Display(Name = "Test Name")]
        public int TestID { get { return _TestID; } set { _TestID = value; } }

        public string TestName { get; set; }

        [Required(ErrorMessage = "Please Select Test Type"), Display(Name = "Test Type")]
        public string TestType { get; set; }

        public decimal Charges { get; set; }

        [Required(ErrorMessage = "Please Enter Patient Name"), Display(Name = "Patient Name")]
        public string PatientName { get { return _PatientName; } set { _PatientName = value; } }

        public string ContactNo { get { return _ContactNo; } set { _ContactNo = value; } }

        [Display(Name = "Doctor Name")]
        public string DoctorName { get { return _DoctorName; } set { _DoctorName = value; } }

        public string Symptoms { get { return _Symptoms; } set { _Symptoms = value; } }

        public string Remarks { get { return _Remarks; } set { _Remarks = value; } }

        public string Status { get { return _Status; } set { _Status = value; } }

        [Display(Name = "Test Date")]
        public DateTime TestDate { get { return _TestDate; } set { _TestDate = value; } }

        public string Payment { get { return _Payment; } set { _Payment = value; } }

        
        public string Gender { get { return _Gender; } set { _Gender = value; } }

        //[RegularExpression("([0-9]+)")]
        public string Age { get { return _Age; } set { _Age = value; } }

        public string TestRange { get { return _TestRange; } set { _TestRange = value; } }

        public string Result { get { return _Result; } set { _Result = value; } }

        public string Pathologist { get { return _Pathologist; } set { _Pathologist = value; } }

        public string Technologist { get { return _Technologist; } set { _Technologist = value; } }

        public string LabNumber { get { return _LabNumber; } set { _LabNumber = value; } }

        [Required(ErrorMessage = "Please Entere Test Delivery Date"), Display(Name = "Delivery Date")]
        public DateTime DeliveryDate { get { return _DeliveryDate; } set { _DeliveryDate = value; } }

        public string EnteredBy { get { return _EnteredBy; } set { _EnteredBy = value; } }

        public string UpdatedBy { get { return _UpdatedBy; } set { _UpdatedBy = value; } }

        public DateTime UpdatedDate { get { return _UpdatedDate; } set { _UpdatedDate = value; } }

        public string DeletedBy { get { return _DeletedBy; } set { _DeletedBy = value; } }

        public DateTime DeletedDate { get { return _DeletedDate; } set { _DeletedDate = value; } }

        public int IsDeleted { get { return _IsDeleted; } set { _IsDeleted = value; } }

        public decimal Discount { get { return _Discount; } set { _Discount = value; } }
        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }
        public string Search { get { return _Search; } set { _Search = value; } }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@TestID",_TestID),
                new SqlParameter("@PatientID",_PatientID),
                new SqlParameter("@PatientName",_PatientName),
                new SqlParameter("@ContactNo",_ContactNo),
                new SqlParameter("@DoctorName",_DoctorName),
                new SqlParameter("@Symptoms",_Symptoms),
                new SqlParameter("@Discount",_Discount),
                new SqlParameter("@Remarks",_Remarks),
                new SqlParameter("@Status",_Status),
                new SqlParameter("@TestDate",_TestDate),
                new SqlParameter("@Payment",_Payment),
                new SqlParameter("@Gender",_Gender),
                new SqlParameter("@Age",_Age),
                new SqlParameter("@TestRange",_TestRange),
                new SqlParameter("@Result",_Result),
                new SqlParameter("@Pathologist",_Pathologist),
                new SqlParameter("@Technologist",_Technologist),
                new SqlParameter("@DeliveryDate",_DeliveryDate),
                new SqlParameter("@EnteredBy",_EnteredBy),
                new SqlParameter("@IsDeleted",_IsDeleted),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_PatientDisgnosticTest");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@PatientTestID",_PatientTestID),
                new SqlParameter("@TestID",_TestID),
                new SqlParameter("@PatientID",_PatientID),
                new SqlParameter("@PatientName",_PatientName),
                new SqlParameter("@ContactNo",_ContactNo),
                new SqlParameter("@DoctorName",_DoctorName),
                new SqlParameter("@Symptoms",_Symptoms),
                new SqlParameter("@Discount",_Discount),
                new SqlParameter("@Remarks",_Remarks),
                new SqlParameter("@Status",_Status),
                new SqlParameter("@TestDate",_TestDate),
                new SqlParameter("@Payment",_Payment),
                new SqlParameter("@Gender",_Gender),
                new SqlParameter("@Age",_Age),
                new SqlParameter("@TestRange",_TestRange),
                new SqlParameter("@Result",_Result),
                new SqlParameter("@Pathologist",_Pathologist),
                new SqlParameter("@Technologist",_Technologist),
                new SqlParameter("@DeliveryDate",_DeliveryDate),
                new SqlParameter("@UpdatedBy",_UpdatedBy),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_PatientDisgnosticTest");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PatientTestID",_PatientTestID),
                new SqlParameter("@DeletedBy",_DeletedBy),
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_PatientDisgnosticTest");
        }

        #endregion

        #region DDL Methods

        public DataTable GetForReportByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@PatientTestID",_PatientTestID),  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "SP_PatientDiagnosticReport");
            return dt;
        }

        public clsPatientDiagnosticTest GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PatientTestID",_PatientTestID),
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_PatientDisgnosticTest");
            clsPatientDiagnosticTest obj = new clsPatientDiagnosticTest();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        public DataTable GetDTByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PatientTestID",_PatientTestID),
                new SqlParameter("@ModeType", "GET"), 
            };
            return dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_PatientDisgnosticTest");
        }


        public int GetMaxRow()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ModeType", "MAX"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_PatientDisgnosticTest");
            return Convert.ToInt32(dt.Rows[0][0]);
        }

        protected clsPatientDiagnosticTest AssignValues(clsPatientDiagnosticTest obj, DataTable dt, int row)
        {
            obj.PatientTestID = Convert.ToInt32(dt.Rows[row]["PatientTestID"]);
            obj.TestID = Convert.ToInt32(dt.Rows[row]["TestID"]);
            obj.PatientID = Convert.ToInt32(dt.Rows[row]["PatientID"]);
            obj.TestType = Convert.ToString(dt.Rows[row]["TestType"]);
            obj.TestName = Convert.ToString(dt.Rows[row]["TestName"]);
            obj.Charges = Convert.ToDecimal(dt.Rows[row]["Charges"]);
            obj.PatientName = Convert.ToString(dt.Rows[row]["PatientName"]);
            obj.ContactNo = Convert.ToString(dt.Rows[row]["ContactNo"]);
            obj.DoctorName = Convert.ToString(dt.Rows[row]["DoctorName"]);
            obj.Symptoms = Convert.ToString(dt.Rows[row]["Symptoms"]);
            obj.Discount = Convert.ToDecimal(dt.Rows[row]["Discount"]);
            obj.Remarks = Convert.ToString(dt.Rows[row]["Remarks"]);
            obj.Status = Convert.ToString(dt.Rows[row]["Status"]);
            obj.TestDate = Convert.ToDateTime(dt.Rows[row]["TestDate"]);
            obj.Payment = Convert.ToString(dt.Rows[row]["Payment"]);
            obj.Gender = Convert.ToString(dt.Rows[row]["Gender"]);
            obj.Age = Convert.ToString(dt.Rows[row]["Age"]);
            obj.TestRange = Convert.ToString(dt.Rows[row]["TestRange"]);
            obj.Result = Convert.ToString(dt.Rows[row]["Result"]);
            obj.Pathologist = Convert.ToString(dt.Rows[row]["Pathologist"]);
            obj.Technologist = Convert.ToString(dt.Rows[row]["Technologist"]);
            obj.LabNumber = Convert.ToString(dt.Rows[row]["LabNumber"]);
            obj.DeliveryDate = Convert.ToDateTime(dt.Rows[row]["DeliveryDate"]);
            obj.EnteredBy = Convert.ToString(dt.Rows[row]["EnteredBy"]);
            obj.UpdatedDate = Convert.ToDateTime(dt.Rows[row]["UpdatedDate"]);
            obj.UpdatedBy = Convert.ToString(dt.Rows[row]["UpdatedBy"]);
            obj.IsDeleted = Convert.ToInt32(dt.Rows[row]["IsDeleted"]);
            obj.DeletedDate = Convert.ToDateTime(dt.Rows[row]["DeletedDate"]);
            obj.DeletedBy = Convert.ToString(dt.Rows[row]["DeletedBy"]);
            return obj;
        }

        public List<clsPatientDiagnosticTest> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@Search", _Search),
                new SqlParameter("@ModeType", "SEARCH"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_PatientDisgnosticTest");
            List<clsPatientDiagnosticTest> list = new List<clsPatientDiagnosticTest>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsPatientDiagnosticTest obj = new clsPatientDiagnosticTest();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        #endregion
    }
}
