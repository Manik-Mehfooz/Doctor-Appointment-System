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
    [Table("PatientRegistration")]
    public class clsPatientReg
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _PatientID;
        private string _PatientCategory;
        private string _PatientType;
        //private int _OrganizationID;
        private int _DoctorID;
        private int _RoomID;
        private string _PatientRegNo;
        private string _FirstName;
        private string _LastName;
        private string _MiddleName;
        private string _TakeCareName;
        private string _TakeCareRelation;
        private string _PatientCNIC;
        private string _TakeCareCNIC;
        private DateTime _DateOfBirth;
        private string _Gender;
        private string _Age;
        private string _MaritalStatus;
        private string _Address;
        private string _City;
        private string _State;
        private string _Country;
        private string _Occupation;
        private string _Telephone;
        private string _MobileNo;
        private string _GuardianName;
        private string _GuardianContactNo;
        private string _ReferBy;        
        private string _Diagnosis;
        private string _SecondaryDiagnosis;
        private DateTime _AdmissionDate;         
        private string _Remarks;

        private string _ModeType;
        private string _Search;

        private decimal _DiscountAmount;
        private decimal _BillingAmount;
        private decimal _DepositeAmount;
        private decimal _Discount;

        private int _ProductID;
        private string _ProductName;
        private decimal _UnitPrice;
        private int _Quantity;
        private int _CompanyID;
        
        #endregion

        #region Properties

        public int PatientID { get { return _PatientID; } set { _PatientID = value; } }

        [Display(Name="Category")]
        public string PatientCategory { get { return _PatientCategory; } set { _PatientCategory = value; } }

        [Display(Name = "Patient Type")]
        public string PatientType { get { return _PatientType; } set { _PatientType = value; } }
        //public int OrganizationID { get { return _OrganizationID; } set { _OrganizationID = value; } }

        [Required,Display(Name="Doctor Name")]
        public int DoctorID { get { return _DoctorID; } set { _DoctorID = value; } }

        public string PatientName { get; set; }
        public string DoctorName { get; set; }
       
        [Required, Display(Name = "Room No")]
        public int RoomID { get { return _RoomID; } set { _RoomID = value; } }
        
        public string Room { get; set; }
        
        [Required, Display(Name="MR #")]
        public string PatientRegNo { get { return _PatientRegNo; } set { _PatientRegNo = value; } }
        
        [Required, Display(Name = "First Name")]
        public string FirstName { get { return _FirstName; } set { _FirstName = value; } }
        
        [Required, Display(Name = "Last Name")]
        public string LastName { get { return _LastName; } set { _LastName = value; } }
        
        [Display(Name = "Middle Name")]
        public string MiddleName { get { return _MiddleName; } set { _MiddleName = value; } }
        
        [Display(Name = "Take Care Name")]
        public string TakeCareName { get { return _TakeCareName; } set { _TakeCareName = value; } }
        
        [Display(Name = "Take Care Relation")]
        public string TakeCareRelation { get { return _TakeCareRelation; } set { _TakeCareRelation = value; } }
        
        [Display(Name = "Patient CNIC")]
        public string PatientCNIC { get { return _PatientCNIC; } set { _PatientCNIC = value; } }
        
        [Display(Name = "Take Care CNIC")]
        public string TakeCareCNIC { get { return _TakeCareCNIC; } set { _TakeCareCNIC = value; } }
        
        [Display(Name = "Date Of Birth")]
        public DateTime DateOfBirth { get { return _DateOfBirth; } set { _DateOfBirth = value; } }
        
        public string Gender { get { return _Gender; } set { _Gender = value; } }
        
        [Required]
        public string Age { get { return _Age; } set { _Age = value; } }
        
        [Display(Name = "Marital Status")]
        public string MaritalStatus { get { return _MaritalStatus; } set { _MaritalStatus = value; } }
        
        public string Address { get { return _Address; } set { _Address = value; } }
        
        public string City { get { return _City; } set { _City = value; } }
        
        public string State { get { return _State; } set { _State = value; } }
        
        public string Country { get { return _Country; } set { _Country = value; } }
        
        public string Occupation { get { return _Occupation; } set { _Occupation = value; } }
        
        public string Telephone { get { return _Telephone; } set { _Telephone = value; } }
        
        [Display(Name = "Mobile No")]
        public string MobileNo { get { return _MobileNo; } set { _MobileNo = value; } }
        
        [Display(Name = "Guardian Name")]
        public string GuardianName { get { return _GuardianName; } set { _GuardianName = value; } }
        
        [Display(Name = "Guardian Contact No")]
        public string GuardianContactNo { get { return _GuardianContactNo; } set { _GuardianContactNo = value; } }
        
        [Display(Name = "Refer By")]
        public string ReferBy { get { return _ReferBy; } set { _ReferBy = value; } }
        
        //public string Anaesthetist { get { return _Anaesthetist; } set { _Anaesthetist = value; } }
        
       
        [Display(Name = "Primary Diagnosis"), Required(ErrorMessage = "Please enter Primary Diagnosis")]
        public string Diagnosis { get { return _Diagnosis; } set { _Diagnosis = value; } }

        [Display(Name = "Secondary Diagnosis")]
        public string SecondaryDiagnosis { get { return _SecondaryDiagnosis; } set { _SecondaryDiagnosis = value; } }
        
        [Required,Display(Name = "Admission Date")]
        public DateTime AdmissionDate { get { return _AdmissionDate; } set { _AdmissionDate = value; } }
        
        public string Remarks { get { return _Remarks; } set { _Remarks = value; } }
        
        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }
        public string Search { get { return _Search; } set { _Search = value; } }

        [Required, Display(Name = "Discount Amount")]
        public decimal DiscountAmount { get { return _DiscountAmount; } set { _DiscountAmount = value; } }

        [Display(Name = "Billing Amount")]
        public decimal BillingAmount { get { return _BillingAmount; } set { _BillingAmount = value; } }

        [Display(Name = "Deposite Amount")]
        public decimal DepositeAmount { get { return _DepositeAmount; } set { _DepositeAmount = value; } }

        [Display(Name = "Discount")]
        public decimal Discount { get { return _Discount; } set { _Discount = value; } }

        public string PatientFullName { get; set; }

        public Boolean IsDischarge { get; set; }
        public decimal BalanceOwing { get; set; }

        public int ProductID { get { return _ProductID; } set { _ProductID = value; } }
        public string ProductName { get { return _ProductName; } set { _ProductName = value; } }
        public decimal UnitPrice { get { return _UnitPrice; } set { _UnitPrice = value; } }
        public int Quantity { get { return _Quantity; } set { _Quantity = value; } }
        public int CompanyID { get { return _CompanyID; } set { _CompanyID = value; } }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@DoctorID",_DoctorID),
                new SqlParameter("@PatientCategory",_PatientCategory),
                new SqlParameter("@PatientType",_PatientType),
                //new SqlParameter("@OrganizationID",0),
                new SqlParameter("@RoomID",0),
                new SqlParameter("@PatientRegNo",_PatientRegNo),
                new SqlParameter("@FirstName",_FirstName),
                new SqlParameter("@LastName",_LastName),
                new SqlParameter("@MiddleName",_MiddleName),
                new SqlParameter("@TakeCareName",_TakeCareName),
                new SqlParameter("@TakeCareRelation",_TakeCareRelation),
                new SqlParameter("@PatientCNIC",_PatientCNIC),
                new SqlParameter("@TakeCareCNIC",_TakeCareCNIC),
                new SqlParameter("@DateOfBirth",(_DateOfBirth.Year > 1900) ? _DateOfBirth : Convert.ToDateTime("01/01/1900")),
                new SqlParameter("@Gender",_Gender),
                new SqlParameter("@Age",_Age),
                new SqlParameter("@MaritalStatus",_MaritalStatus),
                new SqlParameter("@Address",_Address),
                new SqlParameter("@City",_City),
                new SqlParameter("@State",_State),
                new SqlParameter("@Country",_Country),
                new SqlParameter("@Occupation",_Occupation),
                new SqlParameter("@Telephone",_Telephone),
                new SqlParameter("@MobileNo",_MobileNo),
                new SqlParameter("@GuardianName",_GuardianName),
                new SqlParameter("@GuardianContactNo",_GuardianContactNo),
                new SqlParameter("@ReferBy",_ReferBy), 
                new SqlParameter("@Diagnosis",_Diagnosis),
                new SqlParameter("@SecondaryDiagnosis", _SecondaryDiagnosis),
                new SqlParameter("@AdmissionDate",_AdmissionDate),              
                new SqlParameter("@Remarks",_Remarks),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_PatientReg");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@PatientID",_PatientID),
                new SqlParameter("@PatientCategory",_PatientCategory),
                new SqlParameter("@PatientType",_PatientType),
                //new SqlParameter("@OrganizationID",_OrganizationID),
                new SqlParameter("@DoctorID",_DoctorID),
                //new SqlParameter("@RoomID",_RoomID),
                new SqlParameter("@PatientRegNo",_PatientRegNo),
                new SqlParameter("@FirstName",_FirstName),
                new SqlParameter("@LastName",_LastName),
                new SqlParameter("@MiddleName",_MiddleName),
                new SqlParameter("@TakeCareName",_TakeCareName),
                new SqlParameter("@TakeCareRelation",_TakeCareRelation),
                new SqlParameter("@PatientCNIC",_PatientCNIC),
                new SqlParameter("@TakeCareCNIC",_TakeCareCNIC),
                new SqlParameter("@DateOfBirth",(_DateOfBirth.Year > 1900) ? _DateOfBirth : Convert.ToDateTime("01/01/1900")),
                new SqlParameter("@Gender",_Gender),
                new SqlParameter("@Age",_Age),
                new SqlParameter("@MaritalStatus",_MaritalStatus),
                new SqlParameter("@Address",_Address),
                new SqlParameter("@City",_City),
                new SqlParameter("@State",_State),
                new SqlParameter("@Country",_Country),
                new SqlParameter("@Occupation",_Occupation),
                new SqlParameter("@Telephone",_Telephone),
                new SqlParameter("@MobileNo",_MobileNo),
                new SqlParameter("@GuardianName",_GuardianName),
                new SqlParameter("@GuardianContactNo",_GuardianContactNo),
                new SqlParameter("@ReferBy",_ReferBy), 
                new SqlParameter("@Diagnosis",_Diagnosis),
                new SqlParameter("@SecondaryDiagnosis", _SecondaryDiagnosis),
                new SqlParameter("@AdmissionDate",_AdmissionDate),                 
                new SqlParameter("@Remarks",_Remarks),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_PatientReg");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PatientID",_PatientID),
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_PatientReg");
        }

        public int AddNewDiscountAfterPatientDischarge()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@PatientID",_PatientID),
                new SqlParameter("@Amount",_DiscountAmount),
                new SqlParameter("@ModeType", "AddDiscountToPatient"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_Transactions");
        }

        //public int DischargePatient()
        //{
        //    SqlParameter[] sqlParams = new SqlParameter[]  
        //    {
        //        new SqlParameter("@PatientID",_PatientID),
        //        new SqlParameter("@DischargeDate",_DischargeDate),
        //        new SqlParameter("@ModeType", "DISCHARGE"), 
        //    };
        //    return objconn.SqlCommParam(sqlParams, "sp_PatientReg");
        //}

        //public void UpdatePatientStatus(int PatientID, int Discharge)
        //{
        //    try
        //    {
        //        string Query = "UPDATE PatientRegistration set IsDischarge = '" + Discharge + "' where PatientID = '" + PatientID + "'";
        //        objconn.ExecuteNonQuery(Query);
        //    }
        //    catch (Exception exp) { }
        //}

        #endregion

        #region DDL Methods

        public string GetPatientNo()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ModeType", "GetPatientNo"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_PatientReg");
            if (dt.Rows.Count > 0)
            {
                return Convert.ToString(dt.Rows[0]["PatientNumber"]);
            }
            return "";
        }
        
        public decimal GetPatientRemainBalance(int PatientID)
        {
            try 
	        {	        
                DataTable dt = new DataTable();
                objconn.ExecuteNonQuery("exec sp_PatientBilling '" + PatientID + "'");
                dt = objconn.GetDataTable("select Round(BalanceOwing,0)as BalanceOwing from BalanceOwing where patientID = '" + PatientID + "'");
                return Convert.ToDecimal(dt.Rows[0]["BalanceOwing"]);
	        }
	        catch (Exception){}
            return 0;
        }

        public clsPatientReg GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PatientID",_PatientID),
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_PatientReg");
            clsPatientReg obj = new clsPatientReg();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsPatientReg AssignValues(clsPatientReg obj, DataTable dt, int row)
        {
            obj.PatientID = Convert.ToInt32(dt.Rows[row]["PatientID"]);
            obj.DoctorID = Convert.ToInt32(dt.Rows[row]["DoctorID"]);
            obj.DoctorName = Convert.ToString(dt.Rows[row]["DoctorName"]);
            obj.Room = Convert.ToString(dt.Rows[row]["Room"]);
            obj.RoomID = Convert.ToInt32(dt.Rows[row]["RoomID"]);
            obj.PatientRegNo = Convert.ToString(dt.Rows[row]["PatientRegNo"]);
            obj.FirstName = Convert.ToString(dt.Rows[row]["FirstName"]);
            obj.LastName = Convert.ToString(dt.Rows[row]["LastName"]);
            obj.MiddleName = Convert.ToString(dt.Rows[row]["MiddleName"]);
            obj.TakeCareName = Convert.ToString(dt.Rows[row]["TakeCareName"]);
            obj.TakeCareRelation = Convert.ToString(dt.Rows[row]["TakeCareRelation"]);
            obj.PatientCNIC = Convert.ToString(dt.Rows[row]["PatientCNIC"]);
            obj.TakeCareCNIC = Convert.ToString(dt.Rows[row]["TakeCareCNIC"]);
            obj.DateOfBirth = Convert.ToDateTime(dt.Rows[row]["DateOfBirth"]);
            obj.Gender = Convert.ToString(dt.Rows[row]["Gender"]);
            obj.Age = Convert.ToString(dt.Rows[row]["Age"]);
            obj.MaritalStatus = Convert.ToString(dt.Rows[row]["MaritalStatus"]);
            obj.Address = Convert.ToString(dt.Rows[row]["Address"]);
            obj.City = Convert.ToString(dt.Rows[row]["City"]);
            obj.State = Convert.ToString(dt.Rows[row]["State"]);
            obj.Country = Convert.ToString(dt.Rows[row]["Country"]);
            obj.Occupation = Convert.ToString(dt.Rows[row]["Occupation"]);
            obj.Telephone = Convert.ToString(dt.Rows[row]["Telephone"]);
            obj.MobileNo = Convert.ToString(dt.Rows[row]["MobileNo"]);
            obj.GuardianName = Convert.ToString(dt.Rows[row]["GuardianName"]);
            obj.GuardianContactNo = Convert.ToString(dt.Rows[row]["GuardianContactNo"]);
            obj.ReferBy = Convert.ToString(dt.Rows[row]["ReferBy"]);
            obj.Diagnosis = Convert.ToString(dt.Rows[row]["Diagnosis"]);
            obj.SecondaryDiagnosis = Convert.ToString(dt.Rows[row]["SecondaryDiagnosis"]);
            obj.AdmissionDate = Convert.ToDateTime(dt.Rows[row]["AdmissionDate"]);
            obj.Remarks = Convert.ToString(dt.Rows[row]["Remarks"]);
            obj.PatientName = Convert.ToString(dt.Rows[row]["PatientName"]);
            obj.PatientCategory = Convert.ToString(dt.Rows[row]["PatientCategory"]);
            obj.PatientType = Convert.ToString(dt.Rows[row]["PatientType"]);            
            obj.IsDischarge = Convert.ToBoolean(dt.Rows[row]["IsDischarge"]);

            return obj;
        }

        public List<clsPatientReg> GetAllData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_PatientReg");
            List<clsPatientReg> list = new List<clsPatientReg>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsPatientReg obj = new clsPatientReg();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        public List<clsPatientReg> GetAllAdmitPatientList()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ModeType", "GetAllAdmitPatientList"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_PatientReg");
            List<clsPatientReg> list = new List<clsPatientReg>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsPatientReg obj = new clsPatientReg();
                obj = AssignValuesAdmitPatient(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsPatientReg AssignValuesAdmitPatient(clsPatientReg obj, DataTable dt, int row)
        {
            obj.PatientID = Convert.ToInt32(dt.Rows[row]["PatientID"]);
            obj.DoctorID = Convert.ToInt32(dt.Rows[row]["DoctorID"]);
            obj.RoomID = Convert.ToInt32(dt.Rows[row]["RoomID"]);
            obj.PatientRegNo = Convert.ToString(dt.Rows[row]["PatientRegNo"]);
            obj.FirstName = Convert.ToString(dt.Rows[row]["FirstName"]);
            obj.LastName = Convert.ToString(dt.Rows[row]["LastName"]);
            obj.MiddleName = Convert.ToString(dt.Rows[row]["MiddleName"]);

            obj.PatientFullName = Convert.ToString(dt.Rows[row]["FirstName"]) + " " + Convert.ToString(dt.Rows[row]["LastName"]);

            obj.TakeCareName = Convert.ToString(dt.Rows[row]["TakeCareName"]);
            obj.TakeCareRelation = Convert.ToString(dt.Rows[row]["TakeCareRelation"]);
            obj.PatientCNIC = Convert.ToString(dt.Rows[row]["PatientCNIC"]);
            obj.TakeCareCNIC = Convert.ToString(dt.Rows[row]["TakeCareCNIC"]);
            obj.DateOfBirth = Convert.ToDateTime(dt.Rows[row]["DateOfBirth"]);
            obj.Gender = Convert.ToString(dt.Rows[row]["Gender"]);
            obj.Age = Convert.ToString(dt.Rows[row]["Age"]);
            obj.MaritalStatus = Convert.ToString(dt.Rows[row]["MaritalStatus"]);
            obj.Address = Convert.ToString(dt.Rows[row]["Address"]);
            obj.City = Convert.ToString(dt.Rows[row]["City"]);
            obj.State = Convert.ToString(dt.Rows[row]["State"]);
            obj.Country = Convert.ToString(dt.Rows[row]["Country"]);
            obj.Occupation = Convert.ToString(dt.Rows[row]["Occupation"]);
            obj.Telephone = Convert.ToString(dt.Rows[row]["Telephone"]);
            obj.MobileNo = Convert.ToString(dt.Rows[row]["MobileNo"]);
            obj.GuardianName = Convert.ToString(dt.Rows[row]["GuardianName"]);
            obj.GuardianContactNo = Convert.ToString(dt.Rows[row]["GuardianContactNo"]);
            obj.ReferBy = Convert.ToString(dt.Rows[row]["ReferBy"]);
            obj.Diagnosis = Convert.ToString(dt.Rows[row]["Diagnosis"]);
            obj.SecondaryDiagnosis = Convert.ToString(dt.Rows[row]["SecondaryDiagnosis"]);
            obj.AdmissionDate = Convert.ToDateTime(dt.Rows[row]["AdmissionDate"]);                
            obj.Remarks = Convert.ToString(dt.Rows[row]["Remarks"]);
            obj.IsDischarge = Convert.ToBoolean(dt.Rows[row]["IsDischarge"]);
            obj.PatientType = Convert.ToString(dt.Rows[row]["PatientType"]);
            
            return obj;
        }

        public List<clsPatientReg> GetPatientSearch()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@Search", _Search), 
                new SqlParameter("@ModeType", "SearchCriteria"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_PatientReg");
            List<clsPatientReg> list = new List<clsPatientReg>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsPatientReg obj = new clsPatientReg();
                //obj = AssignValuesSearch(obj, dt, i);
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsPatientReg AssignValuesSearch(clsPatientReg obj, DataTable dt, int row)
        {
            obj.PatientID = Convert.ToInt32(dt.Rows[row]["PatientID"]);           
            obj.PatientRegNo = Convert.ToString(dt.Rows[row]["PatientRegNo"]);
            obj.FirstName = Convert.ToString(dt.Rows[row]["FirstName"]);
            obj.LastName = Convert.ToString(dt.Rows[row]["LastName"]);
            obj.BalanceOwing = Convert.ToDecimal(dt.Rows[row]["BalanceOwing"]);

            return obj;
        }

        public int GetTotalAdmitPatientDashboard()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ModeType", "GetTotalAdmitedPatients"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_PatientReg");
            if (dt.Rows.Count > 0)
            {
                return Convert.ToInt32(dt.Rows[0]["TotalAdmitedPatients"]);
            }
            return 0;
        }

        public clsPatientReg GetPatientInfoForDiscount()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PatientID",_PatientID),
                new SqlParameter("@ModeType", "GetPatientInfoForDiscount"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_PatientReg");
            clsPatientReg obj = new clsPatientReg();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValuesDiscount(obj, dt, 0);
            }
            return obj;
        }
        protected clsPatientReg AssignValuesDiscount(clsPatientReg obj, DataTable dt, int row)
        {
            obj.PatientID = Convert.ToInt32(dt.Rows[row]["PatientID"]);
            obj.PatientRegNo = Convert.ToString(dt.Rows[row]["PatientRegNo"]);
            obj.FirstName = Convert.ToString(dt.Rows[row]["FirstName"]);
            obj.LastName = Convert.ToString(dt.Rows[row]["LastName"]);
            obj.BillingAmount = Convert.ToDecimal(dt.Rows[row]["BillingAmount"]);
            obj.DepositeAmount = Convert.ToDecimal(dt.Rows[row]["DepositeAmount"]);
            obj.Discount = Convert.ToDecimal(dt.Rows[row]["Discount"]);
            return obj;
        }

        public List<clsPatientReg> GetPatientOTProductList()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {                  
                new SqlParameter("@PatientID", _PatientID), 
                new SqlParameter("@ModeType", "GetPatientOTProducts"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_PatientReg");
            List<clsPatientReg> list = new List<clsPatientReg>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsPatientReg obj = new clsPatientReg();
                obj = AssignValuesOTProduct(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsPatientReg AssignValuesOTProduct(clsPatientReg obj, DataTable dt, int row)
        {
            obj.ProductID = Convert.ToInt32(dt.Rows[row]["ProductID"]);
            obj.ProductName = Convert.ToString(dt.Rows[row]["ProductName"]);
            obj.UnitPrice = Convert.ToDecimal(dt.Rows[row]["UnitPrice"]);
            obj.Quantity = Convert.ToInt32(dt.Rows[row]["Quantity"]);
            obj.CompanyID = Convert.ToInt32(dt.Rows[row]["CompanyID"]);
            return obj;
        }

        #endregion
    }
}
