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
    [Table("PatientReg")]
    public class clsRptPatientReg
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _PatientID;
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
        private string _DateOfBirth;
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
        private string _Anaesthetist;
        private string _Diagnosis;
        private string _AdmissionDate;
        private string _SurgeryDate;
        private string _DischargeDate;
        private string _IsDischarge;
        private bool _IsSurgery;
        private string _Remarks;

        private string _ModeType;
        private string _PatientCategory ;      
        
        #endregion

        #region Properties

        public int PatientID { get { return _PatientID; } set { _PatientID = value; } }
        public string PatientCategory { get { return _PatientCategory; } set { _PatientCategory = value; } }
        public int DoctorID { get { return _DoctorID; } set { _DoctorID = value; } }
        public string PatientName { get; set; }
        public string DoctorName { get; set; }       
        public string PatientRegNo { get { return _PatientRegNo; } set { _PatientRegNo = value; } }
        public string TakeCareName { get { return _TakeCareName; } set { _TakeCareName = value; } }
        public string TakeCareRelation { get { return _TakeCareRelation; } set { _TakeCareRelation = value; } }
        public string PatientCNIC { get { return _PatientCNIC; } set { _PatientCNIC = value; } }
        public string DateOfBirth { get { return _DateOfBirth; } set { _DateOfBirth = value; } }        
        public string Gender { get { return _Gender; } set { _Gender = value; } }      
        public string Age { get { return _Age; } set { _Age = value; } }
        public string MaritalStatus { get { return _MaritalStatus; } set { _MaritalStatus = value; } }
        public string Address { get { return _Address; } set { _Address = value; } }
        public string City { get { return _City; } set { _City = value; } }
        public string Occupation { get { return _Occupation; } set { _Occupation = value; } }        
        public string Telephone { get { return _Telephone; } set { _Telephone = value; } }
        public string MobileNo { get { return _MobileNo; } set { _MobileNo = value; } }
        public string GuardianName { get { return _GuardianName; } set { _GuardianName = value; } }
        public string GuardianContactNo { get { return _GuardianContactNo; } set { _GuardianContactNo = value; } }
        public string ReferBy { get { return _ReferBy; } set { _ReferBy = value; } }
        public string Diagnosis { get { return _Diagnosis; } set { _Diagnosis = value; } }
        public string AdmissionDate { get { return _AdmissionDate; } set { _AdmissionDate = value; } }         
        public string Remarks { get { return _Remarks; } set { _Remarks = value; } }

        public string PharmacyBill { get; set; }
        public string RoomBill { get; set; }
        public string InvestigationTestBill { get; set; }
        public string BillingAmount { get; set; }
        public string SurgeryAmount { get; set; }
        public string DepositeAmount { get; set; }
        public string Discount { get; set; }
        public string BalanceOwing { get; set; }

        public string SurgeryDate { get { return _SurgeryDate; } set { _SurgeryDate = value; } }
        public string Anaesthetist { get { return _Anaesthetist; } set { _Anaesthetist = value; } }
        public string AnaesthetistType { get; set; }
        public string OTTechnician1 { get; set; }
        public string OTTechnician2 { get; set; }
        public string OTTechnician3 { get; set; }
        public string OTTechnician4 { get; set; }
        public string OTTechnician5 { get; set; }
        public string SurgeryType { get; set; }
        public string SurgeryProcedure { get; set; }
        public string SurgeryRemarks { get; set; }

        public string Room { get; set; }
        public string RoomType { get; set; }
        public string RoomCharges { get; set; }

        public string DischargeDate { get { return _DischargeDate; } set { _DischargeDate = value; } }
        public string Follow { get; set; }
        public string DischargeRemarks { get; set; }

        public string SecondaryDiagnosis { get; set; }
        public string BriefSummary { get; set; }
        public string InvestigationDrug { get; set; }
        public string Treatment { get; set; }
        public string Instructions { get; set; }
        public string TakeHomeMedicine { get; set; }


        private string _FromDate;
        private string _ToDate;
        public string FromDate { get { return _FromDate; } set { _FromDate = value; } }
        public string ToDate { get { return _ToDate; } set { _ToDate = value; } }


        public string SaleInvoiceNumber { get; set; }
        public string SaleDate { get; set; }
        public string ProductName { get; set; }
        public string ProductType { get; set; }
        public int Quantity { get; set; }
        public decimal Price { get; set; }
        public decimal Total { get; set; }

        public string TestName { get; set; }
        public string TestType { get; set; }
        public string TestDate { get; set; }
        public string DeliveryDate { get; set; }
        public string Pathologist { get; set; }
        public string Technologist { get; set; }
        public decimal Charges { get; set; }                
        

        #endregion

        #region DDL Methods

        public List<clsRptPatientReg> GetPatientRegInformationByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParam = new SqlParameter[]  
            {                  
                new SqlParameter("@PatientID", _PatientID), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParam, "sp_PatientRegistrationReport");
            List<clsRptPatientReg> list = new List<clsRptPatientReg>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsRptPatientReg obj = new clsRptPatientReg();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        protected clsRptPatientReg AssignValues(clsRptPatientReg obj, DataTable dt, int row)
        {
            obj.PatientID = Convert.ToInt32(dt.Rows[row]["PatientID"]);
            obj.DoctorName = Convert.ToString(dt.Rows[row]["DoctorName"]);
            obj.PatientName = Convert.ToString(dt.Rows[row]["PatientName"]);
            obj.PatientRegNo = Convert.ToString(dt.Rows[row]["PatientRegNo"]);
            obj.TakeCareName = Convert.ToString(dt.Rows[row]["TakeCareName"]);
            obj.TakeCareRelation = Convert.ToString(dt.Rows[row]["TakeCareRelation"]);
            obj.PatientCNIC = Convert.ToString(dt.Rows[row]["PatientCNIC"]);
            obj.DateOfBirth = Convert.ToString(dt.Rows[row]["DateOfBirth"]);
            obj.Gender = Convert.ToString(dt.Rows[row]["Gender"]);
            obj.Age = Convert.ToString(dt.Rows[row]["Age"]);
            obj.MaritalStatus = Convert.ToString(dt.Rows[row]["MaritalStatus"]);
            obj.Address = Convert.ToString(dt.Rows[row]["Address"]);
            obj.City = Convert.ToString(dt.Rows[row]["City"]);
            obj.Occupation = Convert.ToString(dt.Rows[row]["Occupation"]);
            obj.Telephone = Convert.ToString(dt.Rows[row]["Telephone"]);
            obj.MobileNo = Convert.ToString(dt.Rows[row]["MobileNo"]);
            obj.GuardianName = Convert.ToString(dt.Rows[row]["GuardianName"]);
            obj.GuardianContactNo = Convert.ToString(dt.Rows[row]["GuardianContactNo"]);
            obj.ReferBy = Convert.ToString(dt.Rows[row]["ReferBy"]);
            obj.Diagnosis = Convert.ToString(dt.Rows[row]["Diagnosis"]);
            obj.AdmissionDate = Convert.ToString(dt.Rows[row]["AdmissionDate"]);             
            obj.Remarks = Convert.ToString(dt.Rows[row]["Remarks"]);

            obj.PharmacyBill = Convert.ToString(dt.Rows[row]["PharmacyBill"]);
            obj.RoomBill = Convert.ToString(dt.Rows[row]["RoomBill"]);
            obj.InvestigationTestBill = Convert.ToString(dt.Rows[row]["InvestigationTestBill"]);
            obj.BillingAmount = Convert.ToString(dt.Rows[row]["BillingAmount"]);
            obj.SurgeryAmount = Convert.ToString(dt.Rows[row]["SurgeryAmount"]);
            obj.DepositeAmount = Convert.ToString(dt.Rows[row]["DepositeAmount"]);
            obj.Discount = Convert.ToString(dt.Rows[row]["Discount"]);
            obj.BalanceOwing = Convert.ToString(dt.Rows[row]["BalanceOwing"]);

            obj.SurgeryDate = Convert.ToString(dt.Rows[row]["SurgeryDate"]);
            obj.Anaesthetist = Convert.ToString(dt.Rows[row]["Anaesthetist"]);
            obj.AnaesthetistType = Convert.ToString(dt.Rows[row]["AnaesthetistType"]);
            obj.OTTechnician1 = Convert.ToString(dt.Rows[row]["OTTechnician1"]);
            obj.OTTechnician2 = Convert.ToString(dt.Rows[row]["OTTechnician2"]);
            obj.OTTechnician3 = Convert.ToString(dt.Rows[row]["OTTechnician3"]);
            obj.OTTechnician4 = Convert.ToString(dt.Rows[row]["OTTechnician4"]);
            obj.OTTechnician5 = Convert.ToString(dt.Rows[row]["OTTechnician5"]);
            obj.SurgeryType = Convert.ToString(dt.Rows[row]["SurgeryType"]);
            obj.SurgeryProcedure = Convert.ToString(dt.Rows[row]["SurgeryProcedure"]);
            obj.SurgeryRemarks = Convert.ToString(dt.Rows[row]["SurgeryRemarks"]);

            obj.Room = Convert.ToString(dt.Rows[row]["Room"]);
            obj.RoomType = Convert.ToString(dt.Rows[row]["RoomType"]);
            obj.RoomCharges = Convert.ToString(dt.Rows[row]["RoomCharges"]);

            obj.DischargeDate = Convert.ToString(dt.Rows[row]["DischargeDate"]);
            obj.Follow = Convert.ToString(dt.Rows[row]["Follow"]);
            obj.DischargeRemarks = Convert.ToString(dt.Rows[row]["DischargeRemarks"]);

            obj.SecondaryDiagnosis = Convert.ToString(dt.Rows[row]["SecondaryDiagnosis"]);
            obj.BriefSummary = Convert.ToString(dt.Rows[row]["BriefSummary"]);
            obj.InvestigationDrug = Convert.ToString(dt.Rows[row]["InvestigationDrug"]);
            obj.Treatment = Convert.ToString(dt.Rows[row]["Treatment"]);
            obj.Instructions = Convert.ToString(dt.Rows[row]["Instructions"]);
            obj.TakeHomeMedicine = Convert.ToString(dt.Rows[row]["TakeHomeMedicine"]);

            obj.PatientCategory = Convert.ToString(dt.Rows[row]["PatientCategory"]);

            return obj;
        }

        public List<clsRptPatientReg> GetIndoorPatientSummaryReport()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParam = new SqlParameter[]  
            {                  
                new SqlParameter("@DoctorID", _DoctorID), 
                new SqlParameter("@FromDate", _FromDate), 
                new SqlParameter("@ToDate", _ToDate), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParam, "sp_IndoorPatientSummaryReport");
            List<clsRptPatientReg> list = new List<clsRptPatientReg>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsRptPatientReg obj = new clsRptPatientReg();
                obj = AssignValuesIndoorSummary(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsRptPatientReg AssignValuesIndoorSummary(clsRptPatientReg obj, DataTable dt, int row)
        {
            obj.PatientRegNo = Convert.ToString(dt.Rows[row]["PatientRegNo"]);
            obj.PatientName = Convert.ToString(dt.Rows[row]["PatientName"]);
            obj.DoctorName = Convert.ToString(dt.Rows[row]["DoctorName"]);
            obj.Diagnosis = Convert.ToString(dt.Rows[row]["Diagnosis"]);
            obj.AdmissionDate = Convert.ToString(dt.Rows[row]["AdmissionDate"]);
            obj.BillingAmount = Convert.ToString(dt.Rows[row]["BillingAmount"]);           
            obj.DepositeAmount = Convert.ToString(dt.Rows[row]["DepositeAmount"]);
            obj.Discount = Convert.ToString(dt.Rows[row]["Discount"]);
            obj.BalanceOwing = Convert.ToString(dt.Rows[row]["BalanceOwing"]);
            obj.DischargeDate = Convert.ToString(dt.Rows[row]["DischargeDate"]);

            obj.PharmacyBill = Convert.ToString(dt.Rows[row]["PharmacyBill"]);
            obj.RoomBill = Convert.ToString(dt.Rows[row]["RoomBill"]);
            obj.InvestigationTestBill = Convert.ToString(dt.Rows[row]["InvestigationTestBill"]);
            obj.SurgeryAmount = Convert.ToString(dt.Rows[row]["SurgeryAmount"]);


            return obj;
        }

        public List<clsRptPatientReg> GetIndoorPatientMedicineReport()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParam = new SqlParameter[]  
            {                  
                new SqlParameter("@PatientID", _PatientID),               
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParam, "sp_IndoorPatientMedicineReport");
            List<clsRptPatientReg> list = new List<clsRptPatientReg>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsRptPatientReg obj = new clsRptPatientReg();
                obj = AssignValuesPatientMedicine(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsRptPatientReg AssignValuesPatientMedicine(clsRptPatientReg obj, DataTable dt, int row)
        {
            obj.PatientRegNo = Convert.ToString(dt.Rows[row]["PatientRegNo"]);
            obj.PatientName = Convert.ToString(dt.Rows[row]["PatientName"]);
            obj.DoctorName = Convert.ToString(dt.Rows[row]["DoctorName"]);
            obj.Diagnosis = Convert.ToString(dt.Rows[row]["Diagnosis"]);
            obj.Gender = Convert.ToString(dt.Rows[row]["Gender"]);
            obj.Age = Convert.ToString(dt.Rows[row]["Age"]);
            obj.SaleInvoiceNumber = Convert.ToString(dt.Rows[row]["SaleInvoiceNumber"]);
            obj.SaleDate = Convert.ToString(dt.Rows[row]["SaleDate"]);
            obj.ProductName = Convert.ToString(dt.Rows[row]["ProductName"]);
            obj.ProductType = Convert.ToString(dt.Rows[row]["ProductType"]);
            obj.Quantity = Convert.ToInt32(dt.Rows[row]["Quantity"]);
            obj.Price = Convert.ToDecimal(dt.Rows[row]["Price"]);
            obj.Total = Convert.ToDecimal(dt.Rows[row]["Total"]);
            obj.Discount = Convert.ToString(dt.Rows[row]["Discount"]);

            return obj;
        }


        public List<clsRptPatientReg> GetIndoorPatientInvestigationTestReport()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParam = new SqlParameter[]  
            {                  
                new SqlParameter("@PatientID", _PatientID),               
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParam, "sp_IndoorPatientInvestigationTestReport");
            List<clsRptPatientReg> list = new List<clsRptPatientReg>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsRptPatientReg obj = new clsRptPatientReg();
                obj = AssignValuesPatientTest(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsRptPatientReg AssignValuesPatientTest(clsRptPatientReg obj, DataTable dt, int row)
        {
            obj.PatientRegNo = Convert.ToString(dt.Rows[row]["PatientRegNo"]);
            obj.PatientName = Convert.ToString(dt.Rows[row]["PatientName"]);
            obj.DoctorName = Convert.ToString(dt.Rows[row]["DoctorName"]);
            obj.Diagnosis = Convert.ToString(dt.Rows[row]["Diagnosis"]);
            obj.Gender = Convert.ToString(dt.Rows[row]["Gender"]);
            obj.Age = Convert.ToString(dt.Rows[row]["Age"]);
            obj.TestName = Convert.ToString(dt.Rows[row]["TestName"]);
            obj.TestType = Convert.ToString(dt.Rows[row]["TestType"]);
            obj.TestDate = Convert.ToString(dt.Rows[row]["TestDate"]);
            obj.DeliveryDate = Convert.ToString(dt.Rows[row]["DeliveryDate"]);
            obj.Pathologist = Convert.ToString(dt.Rows[row]["Pathologist"]);
            obj.Technologist = Convert.ToString(dt.Rows[row]["Technologist"]);
            obj.PharmacyBill = Convert.ToString(dt.Rows[row]["PharmacyBill"]);           

            return obj;
        }
        #endregion
    }
}
