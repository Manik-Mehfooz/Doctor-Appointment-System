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
    [Table("PatientSurgery")]
    public class clsPatientSurgery
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _SurgeryID;
        private int _PatientID;
        private string _SurgeryType;
        private DateTime _SurgeryDate;
        private string _Anaesthetist;
        private string _AnaesthetistType;
        private string _OTTechnician1;
        private string _OTTechnician2;
        private string _OTTechnician3;
        private string _OTTechnician4;
        private string _OTTechnician5;
        private string _SurgeryProcedure;
        private string _Remarks;
        private string _ModeType; 

        #endregion 

        #region Properties

        public int SurgeryID { get { return _SurgeryID; } set { _SurgeryID = value; } }

        [Display(Name = "Patient Name")]
        public int PatientID { get { return _PatientID; } set { _PatientID = value; } }

        [Required, Display(Name = "Surgery Type")]
        public string SurgeryType { get { return _SurgeryType; } set { _SurgeryType = value; } }

        [Required, Display(Name = "Surgery Date")]
        public DateTime SurgeryDate { get { return _SurgeryDate; } set { _SurgeryDate = value; } }

        [Display(Name = "Anaesthetist Name")]
        public string Anaesthetist { get { return _Anaesthetist; } set { _Anaesthetist = value; } }

        [Display(Name = "Anaesthetist Type")]
        public string AnaesthetistType { get { return _AnaesthetistType; } set { _AnaesthetistType = value; } }

        [Display(Name = "OT Technician 1")]
        public string OTTechnician1 { get { return _OTTechnician1; } set { _OTTechnician1 = value; } }
        [Display(Name = "OT Technician 2")]
        public string OTTechnician2 { get { return _OTTechnician2; } set { _OTTechnician2 = value; } }
        [Display(Name = "OT Technician 3")]
        public string OTTechnician3 { get { return _OTTechnician3; } set { _OTTechnician3 = value; } }
        [Display(Name = "OT Technician 4")]
        public string OTTechnician4 { get { return _OTTechnician4; } set { _OTTechnician4 = value; } }
        [Display(Name = "OT Technician 5")]
        public string OTTechnician5 { get { return _OTTechnician5; } set { _OTTechnician5 = value; } }
        [Display(Name = "Procedure")]
        public string SurgeryProcedure { get { return _SurgeryProcedure; } set { _SurgeryProcedure = value; } }
        [Display(Name = "Remarks")]
        public string Remarks { get { return _Remarks; } set { _Remarks = value; } }
        [Display(Name = "Doctor Name")]
        public string DoctorName { get; set; }
        [Display(Name = "Surgery Fees")]
        public decimal SurgeryAmount { get; set; }
        public string ModeType { get { return _ModeType; } set { _ModeType = value; } } 


        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            { 
                new SqlParameter("@PatientID",_PatientID),
                new SqlParameter("@SurgeryType",_SurgeryType),
                new SqlParameter("@SurgeryDate",_SurgeryDate),
                new SqlParameter("@Anaesthetist",_Anaesthetist),
                new SqlParameter("@AnaesthetistType",_AnaesthetistType),
                new SqlParameter("@OTTechnician1",_OTTechnician1),
                new SqlParameter("@OTTechnician2",_OTTechnician2),
                new SqlParameter("@OTTechnician3",_OTTechnician3),
                new SqlParameter("@OTTechnician4",_OTTechnician4),
                new SqlParameter("@OTTechnician5",_OTTechnician5),
                new SqlParameter("@SurgeryProcedure",_SurgeryProcedure),
                new SqlParameter("@Remarks",_Remarks),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_PatientSurgery");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@SurgeryID",_SurgeryID),
                new SqlParameter("@PatientID",_PatientID),
                new SqlParameter("@SurgeryType",_SurgeryType),
                new SqlParameter("@SurgeryDate",_SurgeryDate),
                new SqlParameter("@Anaesthetist",_Anaesthetist),
                new SqlParameter("@AnaesthetistType",_AnaesthetistType),
                new SqlParameter("@OTTechnician1",_OTTechnician1),
                new SqlParameter("@OTTechnician2",_OTTechnician2),
                new SqlParameter("@OTTechnician3",_OTTechnician3),
                new SqlParameter("@OTTechnician4",_OTTechnician4),
                new SqlParameter("@OTTechnician5",_OTTechnician5),
                new SqlParameter("@SurgeryProcedure",_SurgeryProcedure),
                new SqlParameter("@Remarks",_Remarks),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_PatientSurgery");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
               new SqlParameter("@SurgeryID",_SurgeryID),
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_PatientSurgery");
        }

        #endregion

        #region DDL Methods

        public clsPatientSurgery GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@SurgeryID",_SurgeryID), 
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_PatientSurgery");
            clsPatientSurgery obj = new clsPatientSurgery();            
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        public Decimal GetSurgeryAmount(int DoctorID, string SurgeryType)
        {
            string strQuery = "";

            strQuery = " SELECT df.Fees as SurgeryAmount ";
			strQuery += " FROM DoctorFee df JOIN FeesType ft ON df.FeeTypeID = ft.FeeTypeID JOIN Contact c ON df.DoctorID = c.ContactID ";
            strQuery += " WHERE df.DoctorID = '" + DoctorID + "' and ft.FeeType Like('%" + SurgeryType + "%') ";

            try
            {
                return Convert.ToDecimal(objconn.GetScaler(strQuery));
            }
            catch (Exception exp) { }
            return 0;
        }

        protected clsPatientSurgery AssignValues(clsPatientSurgery obj, DataTable dt, int row)
        {
            obj.SurgeryID = Convert.ToInt32(dt.Rows[row]["SurgeryID"]);
            obj.PatientID = Convert.ToInt32(dt.Rows[row]["PatientID"]); 
            obj.SurgeryType = Convert.ToString(dt.Rows[row]["SurgeryType"]);
            obj.SurgeryDate = Convert.ToDateTime(dt.Rows[row]["SurgeryDate"]);
            obj.Anaesthetist = Convert.ToString(dt.Rows[row]["Anaesthetist"]);
            obj.AnaesthetistType = Convert.ToString(dt.Rows[row]["AnaesthetistType"]);
            obj.OTTechnician1 = Convert.ToString(dt.Rows[row]["OTTechnician1"]);
            obj.OTTechnician2 = Convert.ToString(dt.Rows[row]["OTTechnician2"]);
            obj.OTTechnician3 = Convert.ToString(dt.Rows[row]["OTTechnician3"]);
            obj.OTTechnician4 = Convert.ToString(dt.Rows[row]["OTTechnician4"]);
            obj.OTTechnician5 = Convert.ToString(dt.Rows[row]["OTTechnician5"]);
            obj.DoctorName = Convert.ToString(dt.Rows[row]["DoctorName"]);
            obj.SurgeryAmount = Convert.ToDecimal(dt.Rows[row]["SurgeryAmount"]);
            obj.SurgeryProcedure = Convert.ToString(dt.Rows[row]["SurgeryProcedure"]);
            obj.Remarks = Convert.ToString(dt.Rows[row]["Remarks"]); 
            return obj;
        }

        public List<clsPatientSurgery> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {   
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_PatientSurgery");
            List<clsPatientSurgery> list = new List<clsPatientSurgery>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsPatientSurgery obj = new clsPatientSurgery();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }  
            return list;
        }

        #endregion
    }
}
