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
    [Table("PatientPanel")]
    public class clsPatientPanel
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _PanelID;
        private int _PatientID;
        private int _OrganizationID;
        private string _PanelLevel;
        private decimal _LimitAmount;
        private string _Services;

        private string _ModeType;


        #endregion 

        #region Properties

        public int PanelID { get { return _PanelID; } set { _PanelID = value; } }
        
        [Required]
        [Display(Name = "Patient Name")]
        public int PatientID { get { return _PatientID; } set { _PatientID = value; } }

        [Required]
        [Display(Name ="Organization Name")]
        public int OrganizationID { get { return _OrganizationID; } set { _OrganizationID = value; } }

        [Required]
        [Display(Name="Panel Level")]
        public string PanelLevel { get { return _PanelLevel; } set { _PanelLevel = value; } }

        [Required]
        [Display(Name = "Limit Amount")]
        public decimal LimitAmount { get { return _LimitAmount; } set { _LimitAmount = value; } }
        public string Services { get { return _Services; } set { _Services = value; } }

        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }
        
        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PanelID",_PanelID),
                new SqlParameter("@PatientID",_PatientID),
                new SqlParameter("@OrganizationID",_OrganizationID),
                new SqlParameter("@PanelLevel",_PanelLevel),
                new SqlParameter("@LimitAmount",_LimitAmount),
                new SqlParameter("@Services",_Services),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_PatientPanel");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@PanelID",_PanelID),
                new SqlParameter("@PatientID",_PatientID),
                new SqlParameter("@OrganizationID",_OrganizationID),
                new SqlParameter("@PanelLevel",_PanelLevel),
                new SqlParameter("@LimitAmount",_LimitAmount),
                new SqlParameter("@Services",_Services),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_PatientPanel");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PanelID",_PanelID),
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_PatientPanel");
        }

        #endregion

        #region DDL Methods

        public clsPatientPanel GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PanelID",_PanelID),
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_PatientPanel");
            clsPatientPanel obj = new clsPatientPanel();            
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsPatientPanel AssignValues(clsPatientPanel obj, DataTable dt, int row)
        {
            obj.PanelID = Convert.ToInt32(dt.Rows[row]["PanelID"]);
            obj.PatientID = Convert.ToInt32(dt.Rows[row]["PatientID"]);
            obj.OrganizationID = Convert.ToInt32(dt.Rows[row]["OrganizationID"]);
            obj.PanelLevel = Convert.ToString(dt.Rows[row]["PanelLevel"]);
            obj.LimitAmount = Convert.ToDecimal(dt.Rows[row]["LimitAmount"]);
            obj.Services = Convert.ToString(dt.Rows[row]["Services"]);
            return obj;
        }

        public List<clsPatientPanel> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_PatientPanel");
            List<clsPatientPanel> list = new List<clsPatientPanel>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsPatientPanel obj = new clsPatientPanel();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }  
            return list;
        }

        #endregion
    }
}
