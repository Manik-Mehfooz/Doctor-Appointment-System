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
    [Table("Organization")]
    public class clsOrganization
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _OrganizationID;
        private string _OrgName;
        private string _OrgAddress;
        private string _OrgContactNo;
        private string _OrgEmail;
        private string _ContactPerson;
        private Boolean _IsActive;
        private string _ModeType;

        #endregion

        #region Properties

        public int OrganizationID { get { return _OrganizationID; } set { _OrganizationID = value; } }
        
        [Display(Name = "Organization Name")]
        [Required]
        public string OrgName { get { return _OrgName; } set { _OrgName = value; } }
        [Display(Name = "Organization Address")]
        public string OrgAddress { get { return _OrgAddress; } set { _OrgAddress = value; } }
        [Display(Name = "Contact No")]
        [Required]
        public string OrgContactNo { get { return _OrgContactNo; } set { _OrgContactNo = value; } }
        [Display(Name = "Email")]
        public string OrgEmail { get { return _OrgEmail; } set { _OrgEmail = value; } }
        [Display(Name = "Contact Person")]
        public string ContactPerson { get { return _ContactPerson; } set { _ContactPerson = value; } }
        public Boolean IsActive { get { return _IsActive; } set { _IsActive = value; } }

        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@OrgName",_OrgName),
                new SqlParameter("@OrgAddress",_OrgAddress),
                new SqlParameter("@OrgContactNo",_OrgContactNo),
                new SqlParameter("@OrgEmail",_OrgEmail),
                new SqlParameter("@ContactPerson",_ContactPerson),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_Organization");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@OrganizationID",_OrganizationID),
                new SqlParameter("@OrgName",_OrgName),
                new SqlParameter("@OrgAddress",_OrgAddress),
                new SqlParameter("@OrgContactNo",_OrgContactNo),
                new SqlParameter("@OrgEmail",_OrgEmail),
                new SqlParameter("@ContactPerson",_ContactPerson),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_Organization");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@OrganizationID",_OrganizationID),
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_Organization");
        }

        #endregion

        #region DDL Methods

        public clsOrganization GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@OrganizationID",_OrganizationID),
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Organization");
            clsOrganization obj = new clsOrganization();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsOrganization AssignValues(clsOrganization obj, DataTable dt, int row)
        {
            obj.OrganizationID = Convert.ToInt32(dt.Rows[row]["OrganizationID"]);
            obj.OrgName = Convert.ToString(dt.Rows[row]["OrgName"]);
            obj.OrgAddress = Convert.ToString(dt.Rows[row]["OrgAddress"]);
            obj.OrgContactNo = Convert.ToString(dt.Rows[row]["OrgContactNo"]);
            obj.OrgEmail = Convert.ToString(dt.Rows[row]["OrgEmail"]);
            obj.ContactPerson = Convert.ToString(dt.Rows[row]["ContactPerson"]);
            //obj.IsActive = Convert.ToBoolean(dt.Rows[row]["IsActive"]);
            return obj;
        }

        public List<clsOrganization> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Organization");
            List<clsOrganization> list = new List<clsOrganization>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsOrganization obj = new clsOrganization();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        #endregion
    }
}
