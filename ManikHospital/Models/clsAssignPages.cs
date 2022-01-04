using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MedicalStore.Models;
using System.Data;
using System.Data.SqlClient;
using System.ComponentModel.DataAnnotations;

namespace vtsMMC.Models
{
    public class clsAssignPages
    {
        clsConnection objconn = new clsConnection();
        DataTable dt = new DataTable();
        
        // Private Variables
        #region Private Variables

        private int _AssignPageID;
        private int _PageID;
        private string _LabelName;
        private int _Sequence;
        private bool _IsActive;
        private int _ParentPageID;
        private int _ContactTypeID;

        //AssignPageID
        //PageID
        //LabelName
        //Sequence
        //IsActive
        //ParentPageID
        //ContactTypeID

        #endregion

        // Public Properties
        #region Public Properties

        public int AssignPageID { get { return _AssignPageID; } set { _AssignPageID = value; } }
        public int PageID { get { return _PageID; } set { _PageID = value; } }
        [Required]
        public string LabelName { get { return _LabelName; } set { _LabelName = value; } }
        public int Sequence { get { return _Sequence; } set { _Sequence = value; } }
        public bool IsActive { get { return _IsActive; } set { _IsActive = value; } }
        public int ParentPageID { get { return _ParentPageID; } set { _ParentPageID = value; } }
        [Required]
        public int ContactTypeID { get { return _ContactTypeID; } set { _ContactTypeID = value; } }
        public string PageLink { get; set; }
        public string ContactType { get; set; }
        public string PageWithLink { get; set; }
        public string ParentLabel { get; set; }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PageID",_PageID),
                new SqlParameter("@LabelName",_LabelName),
                new SqlParameter("@Sequence",_Sequence),
                new SqlParameter("@IsActive",_IsActive),
                new SqlParameter("@ParentPageID",_ParentPageID),
                new SqlParameter("@ContactTypeID",_ContactTypeID),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_AssignPages");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@AssignPageID",_AssignPageID),
                new SqlParameter("@PageID",_PageID),
                new SqlParameter("@LabelName",_LabelName),
                new SqlParameter("@Sequence",_Sequence),
                new SqlParameter("@IsActive",_IsActive),
                new SqlParameter("@ParentPageID",_ParentPageID),
                new SqlParameter("@ContactTypeID",_ContactTypeID),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_AssignPages");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@AssignPageID",_AssignPageID),
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_AssignPages");
        }

        #endregion

        #region DDL Methods

        public List<clsAssignPages> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {   
                new SqlParameter("@PageID", _PageID), 
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_AssignPages");
            List<clsAssignPages> list = new List<clsAssignPages>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsAssignPages obj = new clsAssignPages();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        public clsAssignPages GetDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {   
                new SqlParameter("@AssignPageID", _AssignPageID), 
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_AssignPages");
            clsAssignPages obj = new clsAssignPages();
            obj = AssignValues(obj, dt, 0);
            return obj;
        }

        public List<clsAssignPages> GetPages()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {   
                new SqlParameter("@ModeType", "GET_PAGES"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_AssignPages");
            List<clsAssignPages> list = new List<clsAssignPages>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsAssignPages obj = new clsAssignPages();
                obj = AssignValues_Pages(obj, dt, i);
                list.Add(obj);
            }
            return list;
        } 

        protected clsAssignPages AssignValues(clsAssignPages obj, DataTable dt, int row)
        {
            obj.AssignPageID = Convert.ToInt32(dt.Rows[row]["AssignPageID"]);
            obj.PageID = Convert.ToInt32(dt.Rows[row]["PageID"]);
            obj.LabelName = Convert.ToString(dt.Rows[row]["LabelName"]);
            obj.Sequence = Convert.ToInt32(dt.Rows[row]["Sequence"]);
            obj.IsActive = Convert.ToBoolean(dt.Rows[row]["IsActive"]);
            obj.ParentPageID = Convert.ToInt32(dt.Rows[row]["ParentPageID"]);
            obj.ContactTypeID = Convert.ToInt32(dt.Rows[row]["ContactTypeID"]);
            obj.ContactType = Convert.ToString(dt.Rows[row]["ContactType"]);
            obj.PageLink = Convert.ToString(dt.Rows[row]["PageLink"]);
            return obj;
        }

        protected clsAssignPages AssignValues_Pages(clsAssignPages obj, DataTable dt, int row)
        {
            obj.PageID = Convert.ToInt32(dt.Rows[row]["PageID"]);
            obj.LabelName = Convert.ToString(dt.Rows[row]["PageName"]);
            obj.PageWithLink = Convert.ToString(dt.Rows[row]["PageWithLink"]);
            obj.PageLink = Convert.ToString(dt.Rows[row]["PageLink"]);
            return obj;
        }

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