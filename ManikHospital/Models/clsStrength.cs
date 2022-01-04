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
    [Table("Strength")]
    public class clsStrength
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _StrengthID;
        private string _Strength;
        private string _ModeType;
        private string _Search;

        #endregion

        #region Properties

        public int StrengthID { get { return _StrengthID; } set { _StrengthID = value; } }
        [Required(ErrorMessage = "Please Enter Strength")]
        public string Strength { get { return _Strength; } set { _Strength = value; } }
        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }
        public string Search { get { return _Search; } set { _Search = value; } }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@Strength",_Strength),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_Strength");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@StrengthID",_StrengthID),
                new SqlParameter("@Strength",_Strength),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_Strength");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@StrengthID",_StrengthID),  
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_Strength");
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
                    new SqlParameter("@Strength",_Strength),  
                    new SqlParameter("@ModeType", "CHECK"), 
                };
                dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Strength");
            }
            else
            {
                SqlParameter[] sqlParams = new SqlParameter[]  
                {
                    new SqlParameter("@StrengthID",_StrengthID),  
                    new SqlParameter("@Strength",_Strength),  
                    new SqlParameter("@ModeType", "CHECK"), 
                };
                dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Strength");

            }
            return !(dt.Rows.Count > 0);
        }


        public clsStrength GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@StrengthID",_StrengthID),  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Strength");
            clsStrength obj = new clsStrength();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsStrength AssignValues(clsStrength obj, DataTable dt, int row)
        {
            obj.StrengthID = Convert.ToInt32(dt.Rows[row][0]);
            obj.Strength = Convert.ToString(dt.Rows[row][1]);
            return obj;
        }

        public List<clsStrength> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@Search", _Search),
                new SqlParameter("@ModeType", "SEARCH"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Strength");
            List<clsStrength> list = new List<clsStrength>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsStrength obj = new clsStrength();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        #endregion
    }
}
