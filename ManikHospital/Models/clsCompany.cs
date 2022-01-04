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
    [Table("Company")]
    public class clsCompany
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _CompanyID;
        private string _Company;
        private string _ModeType;
        private string _Search;

        #endregion 

        #region Properties

        public int CompanyID { get { return _CompanyID; } set { _CompanyID = value; } }

        [Required(ErrorMessage = "Please Enter Company")]
        public string Company { get { return _Company; } set { _Company = value; } }
        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }
        public string Search { get { return _Search; } set { _Search = value; } }
       


        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@Company",_Company),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_Company");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@CompanyID",_CompanyID),
                new SqlParameter("@Company",_Company),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_Company");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@CompanyID",_CompanyID),  
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_Company");
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
                    new SqlParameter("@Company",_Company),  
                    new SqlParameter("@ModeType", "CHECK"), 
                };
                dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Company");
            }
            else
            {
                SqlParameter[] sqlParams = new SqlParameter[]  
                {
                    new SqlParameter("@CompanyID",_CompanyID),
                    new SqlParameter("@Company",_Company),  
                    new SqlParameter("@ModeType", "CHECK"), 
                };
                dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Company");

            }
            return !(dt.Rows.Count > 0);
        }

        public clsCompany GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@CompanyID",_CompanyID),  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Company");
            clsCompany obj = new clsCompany();            
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsCompany AssignValues(clsCompany obj, DataTable dt, int row)
        {
            obj.CompanyID = Convert.ToInt32(dt.Rows[row][0]);
            obj.Company = Convert.ToString(dt.Rows[row][1]);
            return obj;
        }

        public List<clsCompany> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@Search", _Search),
                new SqlParameter("@ModeType", "SEARCH"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Company");
            List<clsCompany> list = new List<clsCompany>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsCompany obj = new clsCompany();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }  
            return list;
        }

        #endregion
    }
}
