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
    [Table("PatientDischarge")]
    public class clsPatientDischarge
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _PDID;
        private int _PatientID;
        private DateTime _DischargeDate;
        private string _Follow;
        private string _Remarks;
        private string _BriefSummary;
        private string _InvestigationDrug;
        private string _Treatment;
        private string _Instructions;
        private string _TakeHomeMedicine;
        private string _ModeType;

        #endregion

        #region Properties

        public int PDID { get { return _PDID; } set { _PDID = value; } }

        [Display(Name = "Patient Name")]
        public int PatientID { get { return _PatientID; } set { _PatientID = value; } }

        [Required, Display(Name = "Discharge Date")]
        public DateTime DischargeDate { get { return _DischargeDate; } set { _DischargeDate = value; } }

        [Display(Name = "Finding")]
        public string Remarks { get { return _Remarks; } set { _Remarks = value; } }
        
        [Display(Name = "Brief Summary")]        
        public string BriefSummary { get { return _BriefSummary; } set { _BriefSummary = value; } }

        [Display(Name = "Investigation Drug Hospitalization")]
        public string InvestigationDrug { get { return _InvestigationDrug; } set { _InvestigationDrug = value; } }

        [Display(Name = "Treatment & Hospital Course")]
        public string Treatment { get { return _Treatment; } set { _Treatment = value; } }

        [Display(Name = "Instructions")]
        public string Instructions { get { return _Instructions; } set { _Instructions = value; } }

        [Display(Name = "Take Home Medicine")]
        public string TakeHomeMedicine { get { return _TakeHomeMedicine; } set { _TakeHomeMedicine = value; } }

        [Display(Name = "OPD Follow Up")]
        public string Follow { get { return _Follow; } set { _Follow = value; } }

        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PatientID",_PatientID),
                new SqlParameter("@DischargeDate",_DischargeDate),
                new SqlParameter("@Follow",_Follow),
                new SqlParameter("@Remarks",_Remarks),
                new SqlParameter("@BriefSummary",_BriefSummary),
                new SqlParameter("@InvestigationDrug",_InvestigationDrug),
                new SqlParameter("@Treatment",_Treatment),
                new SqlParameter("@Instructions",_Instructions),
                new SqlParameter("@TakeHomeMedicine",_TakeHomeMedicine),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_PatientDischarge");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PDID",_PDID),
                new SqlParameter("@PatientID",_PatientID),
                new SqlParameter("@DischargeDate",_DischargeDate),
                new SqlParameter("@Follow",_Follow),
                new SqlParameter("@Remarks",_Remarks),
                new SqlParameter("@BriefSummary",_BriefSummary),
                new SqlParameter("@InvestigationDrug",_InvestigationDrug),
                new SqlParameter("@Treatment",_Treatment),
                new SqlParameter("@Instructions",_Instructions),
                new SqlParameter("@TakeHomeMedicine",_TakeHomeMedicine),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_PatientDischarge");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PDID",_PDID),
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_PatientDischarge");
        }

        #endregion

        #region DDL Methods

        public clsPatientDischarge GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PDID",_PDID),
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_PatientDischarge");
            clsPatientDischarge obj = new clsPatientDischarge();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsPatientDischarge AssignValues(clsPatientDischarge obj, DataTable dt, int row)
        {
            obj.PDID = Convert.ToInt32(dt.Rows[row]["PDID"]);
            obj.PatientID = Convert.ToInt32(dt.Rows[row]["PatientID"]);
            obj.DischargeDate = Convert.ToDateTime(dt.Rows[row]["DischargeDate"]);
            obj.Follow = Convert.ToString(dt.Rows[row]["Follow"]);
            obj.Remarks = Convert.ToString(dt.Rows[row]["Remarks"]);
            obj.BriefSummary = Convert.ToString(dt.Rows[row]["BriefSummary"]);
            obj.InvestigationDrug = Convert.ToString(dt.Rows[row]["InvestigationDrug"]);
            obj.Treatment = Convert.ToString(dt.Rows[row]["Treatment"]);
            obj.Instructions = Convert.ToString(dt.Rows[row]["Instructions"]);
            obj.TakeHomeMedicine = Convert.ToString(dt.Rows[row]["TakeHomeMedicine"]);
            return obj;
        }

        public List<clsPatientDischarge> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_PatientDischarge");
            List<clsPatientDischarge> list = new List<clsPatientDischarge>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsPatientDischarge obj = new clsPatientDischarge();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        #endregion
    }
}
