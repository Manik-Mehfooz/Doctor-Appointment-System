using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MedicalStore.Models;
using System.Data;

namespace vtsMMC.Models
{
    public class clsRMForm
    {

        clsConnection objconn = new clsConnection();
        DataTable dt = new DataTable();
        
        // Private Variables
        #region Private Variables

        private int _FormId;
        private string _Name;
        private string _Description;
        private string _Link;

        #endregion

        // Public Properties
        #region Public Properties

        public int FormId { get { return _FormId; } set { _FormId = value; } }
        public string Name { get { return _Name; } set { _Name = value; } }
        public string Description { get { return _Description; } set { _Description = value; } }
        public string Link { get { return _Link; } set { _Link = value; } }

        #endregion

        // Public Methods
        #region DML Methods
            // nothing available
        #endregion

        #region DDL Methods

        public List<clsRMForm> GetParentLinks(int UserID, int FormRoleID = 0)
        {
            string query = "";
            if (FormRoleID > 0)
            {
                query = " SELECT a.FormRoleId as FormID, a.TextToDisplay as Name,c.Link ";
                query += " FROM RMForm c RIGHT OUTER JOIN RMFormRoles a ";
                query += " INNER JOIN RMUserRoles b  ON a.RoleId = b.RoleId ON c.Formid = a.FormId ";
                query += " WHERE b.UserId =" + UserID + " and a.ParentFormRoleId=" + FormRoleID + " and a.IsActive=1  ORDER BY a.Sequence";
            }
            else
            {
                query = " SELECT a.FormRoleId as FormID, a.TextToDisplay as Name,c.Link ";
                query += " FROM RMForm c RIGHT OUTER JOIN RMFormRoles a ";
                query += " INNER JOIN RMUserRoles b  ON a.RoleId = b.RoleId ON c.Formid = a.FormId ";
                query += " WHERE b.UserId =" + UserID + " and a.ParentFormRoleId=0 and a.IsActive=1  ORDER BY a.Sequence";
            }
            try
            {
                List<clsRMForm> OrmList = new List<clsRMForm>();
                dt = objconn.GetDataTable(query);
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    clsRMForm o = new clsRMForm();
                    o.FormId = Convert.ToInt32(dt.Rows[i]["FormId"]);
                    o.Name = dt.Rows[i]["Name"].ToString();
                    o.Link = dt.Rows[i]["Link"].ToString();
                    OrmList.Add(o);
                }
                return OrmList;
            }
            catch (Exception exp) { return null; }
        }

        #endregion
    }
}