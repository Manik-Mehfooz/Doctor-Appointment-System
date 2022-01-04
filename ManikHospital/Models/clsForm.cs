using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MedicalStore.Models
{
    public class clsForm
    {

        clsConnection objconn = new clsConnection();
        DataTable dt = new DataTable();
        
        // Private Variables
        #region Private Variables

        #endregion

        // Public Properties
        #region Public Properties

        public int FormRoleID { get; set; }
        public int FormID { get; set; }
        public string LabelName { get; set; }
        public string LabelLink { get; set; }
        public int Sequence { get; set; }
        public bool IsActive { get; set; }
        public int ParentFormID { get; set; }
        public int ContactTypeID { get; set; }

        #endregion

        // Public Methods
        #region DML Methods
            // nothing available
        #endregion

        #region DDL Methods

        public List<clsForm> GetParentLinks(int UserTypeID, int? FormRoleID = 0)
        {
            string query = "";

            query = @"select ISNULL(f.FormLink,'#') as LabelLink, fr.*
                    from formrole fr 
                    left join form f on f.formid = fr.formid
                    left join ContactType ct on ct.ContactTypeID = fr.Contacttypeid
                        where fr.isactive = 1  and fr.parentFormID = '" + FormRoleID +"' ";
            if (UserTypeID > 0)
            {
                query += " and ct.ContactTypeID = '" + UserTypeID + "' ";
            }
                query += "order by fr.sequence asc ";
            try
            {
                List<clsForm> OrmList = new List<clsForm>();
                dt = objconn.GetDataTable(query);
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    clsForm o = new clsForm();
                    o.FormRoleID = Convert.ToInt32(dt.Rows[i]["FormRoleID"]);
                    o.FormID = Convert.ToInt32(dt.Rows[i]["FormID"]);
                    o.LabelName = Convert.ToString(dt.Rows[i]["LabelName"]);
                    o.LabelLink = Convert.ToString(dt.Rows[i]["LabelLink"]);
                    o.Sequence = Convert.ToInt32(dt.Rows[i]["Sequence"]);
                    o.IsActive = Convert.ToBoolean(dt.Rows[i]["IsActive"]);
                    o.ParentFormID = Convert.ToInt32(dt.Rows[i]["ParentFormID"]);
                    o.ContactTypeID = Convert.ToInt32(dt.Rows[i]["ContactTypeID"]);
                    OrmList.Add(o);
                }
                return OrmList;
            }
            catch (Exception exp) { return null; }
        }

        #endregion
    }
}