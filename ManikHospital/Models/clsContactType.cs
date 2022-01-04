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
    [Table("ContactType")]
    public class clsContactType
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _ContactTypeID;
        private string _ContactType;
        private string _ModeType;
        private string _Search;

        #endregion

        #region Properties

        public int ContactTypeID { get { return _ContactTypeID; } set { _ContactTypeID = value; } }
        [Required, Display(Name="Contact Type")]
        public string ContactType { get { return _ContactType; } set { _ContactType = value; } }
        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }
        public string Search { get { return _Search; } set { _Search = value; } }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ContactType",_ContactType),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_ContactType");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ContactTypeID",_ContactTypeID),
                new SqlParameter("@ContactType",_ContactType),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_ContactType");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ContactTypeID",_ContactTypeID),  
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_ContactType");
        }

        #endregion

        #region DDL Methods

        public bool CheckExitData(int id)
        {
            DataTable dt = new DataTable();
            if (id == 0)
            {
                SqlParameter[] sqlParams = new SqlParameter[]  
                {
                    new SqlParameter("@ContactType",_ContactType),  
                    new SqlParameter("@ModeType", "CHECK"), 
                };
                dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_ContactType");
            }
            else
            {
                SqlParameter[] sqlParams = new SqlParameter[]  
                {
                    new SqlParameter("@ContactTypeID",_ContactTypeID),  
                    new SqlParameter("@ContactType",_ContactType),  
                    new SqlParameter("@ModeType", "CHECK"), 
                };
                dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_ContactType");
            }
            return !(dt.Rows.Count > 0);
        }

        public clsContactType GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ContactTypeID",_ContactTypeID),  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_ContactType");
            clsContactType obj = new clsContactType();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsContactType AssignValues(clsContactType obj, DataTable dt, int row)
        {
            obj.ContactTypeID = Convert.ToInt32(dt.Rows[row][0]);
            obj.ContactType = Convert.ToString(dt.Rows[row][1]);
            return obj;
        }

        public List<clsContactType> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@Search", _Search),
                new SqlParameter("@ModeType", "SEARCH"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_ContactType");
            List<clsContactType> list = new List<clsContactType>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsContactType obj = new clsContactType();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        #endregion
    }
}
