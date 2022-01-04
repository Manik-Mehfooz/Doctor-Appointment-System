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
    [Table("ExpensesType")]
    public class clsExpensesType
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _ExpensesTypeID;
        private string _ExpensesType;
        private string _ModeType;

        #endregion

        #region Properties

        public int ExpensesTypeID { get { return _ExpensesTypeID; } set { _ExpensesTypeID = value; } }
        [Required(ErrorMessage = "Please Enter Expenses Category"), Display(Name = "Expenses Category")]
        public string ExpensesType { get { return _ExpensesType; } set { _ExpensesType = value; } }
        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ExpensesType",_ExpensesType),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_ExpensesType");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ExpensesTypeID",_ExpensesTypeID),
                new SqlParameter("@ExpensesType",_ExpensesType),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_ExpensesType");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ExpensesTypeID",_ExpensesTypeID),  
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_ExpensesType");
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
                    new SqlParameter("@ExpensesType",_ExpensesType),  
                    new SqlParameter("@ModeType", "CHECK"), 
                };
                dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_ExpensesType");
            }
            else
            {
                SqlParameter[] sqlParams = new SqlParameter[]  
                {
                    new SqlParameter("@ExpensesTypeID",_ExpensesTypeID),
                    new SqlParameter("@ExpensesType",_ExpensesType),  
                    new SqlParameter("@ModeType", "CHECK"), 
                };
                dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_ExpensesType");

            }
            return !(dt.Rows.Count > 0);
        }

        public clsExpensesType GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ExpensesTypeID",_ExpensesTypeID),  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_ExpensesType");
            clsExpensesType obj = new clsExpensesType();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsExpensesType AssignValues(clsExpensesType obj, DataTable dt, int row)
        {
            obj.ExpensesTypeID = Convert.ToInt32(dt.Rows[row][0]);
            obj.ExpensesType = Convert.ToString(dt.Rows[row][1]);
            return obj;
        }

        public List<clsExpensesType> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ModeType", "GETALL"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_ExpensesType");
            List<clsExpensesType> list = new List<clsExpensesType>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsExpensesType obj = new clsExpensesType();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }


        public List<clsExpensesType> GetAllData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ModeType", "GETALL"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_ExpensesType");
            List<clsExpensesType> list = new List<clsExpensesType>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsExpensesType obj = new clsExpensesType();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        #endregion
    }
}
