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
    [Table("Departments")]
    public class clsDepartment
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _DeptID;
        private string _DeptName;
        private string _ModeType;

        #endregion

        #region Properties

        public int DeptID { get { return _DeptID; } set { _DeptID = value; } }
        [Required, Display(Name="Department Name")]
        public string DeptName { get { return _DeptName; } set { _DeptName = value; } }
        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@DeptName",_DeptName),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_Departments");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@DeptID",_DeptID),
                new SqlParameter("@DeptName",_DeptName),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_Departments");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@DeptID",_DeptID),  
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_Departments");
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
                    new SqlParameter("@DeptName",_DeptName),  
                    new SqlParameter("@ModeType", "CHECK"), 
                };
                dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Departments");
            }
            else
            {
                SqlParameter[] sqlParams = new SqlParameter[]  
                {
                    new SqlParameter("@DeptID",_DeptID),  
                    new SqlParameter("@DeptName",_DeptName),  
                    new SqlParameter("@ModeType", "CHECK"), 
                };
                dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Departments");
            }
            return !(dt.Rows.Count > 0);
        }

        public clsDepartment GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@DeptID",_DeptID),  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Departments");
            clsDepartment obj = new clsDepartment();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsDepartment AssignValues(clsDepartment obj, DataTable dt, int row)
        {
            obj.DeptID = Convert.ToInt32(dt.Rows[row]["DeptID"]);
            obj.DeptName = Convert.ToString(dt.Rows[row]["DeptName"]);
            return obj;
        }

        public List<clsDepartment> GetAllData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Departments");
            List<clsDepartment> list = new List<clsDepartment>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsDepartment obj = new clsDepartment();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        #endregion
    }
}
