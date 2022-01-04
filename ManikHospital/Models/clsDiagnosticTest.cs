using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace MedicalStore.Models
{
    public class clsDiagnosticTest
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _TestID;
        private string _TestName;
        private decimal _Charges;
        private string _TestType;
        private string _TestGroup;
        private string _ModeType;
        private string _Search;

        #endregion

        #region Properties

        public int TestID { get { return _TestID; } set { _TestID = value; } }
        
        [Required(ErrorMessage = "Please Enter Test Name"),Display(Name="Test Name")]
        public string TestName { get { return _TestName; } set { _TestName = value; } }
        
        [Required(ErrorMessage = "Please Enter Charges")]
        public decimal Charges { get { return _Charges; } set { _Charges = value; } }

        [Required(ErrorMessage="please Select Test Type"),Display(Name="Test Type")]
        public string TestType { get { return _TestType; } set { _TestType = value; } }

        [Required(ErrorMessage = "Please Enter Group"), Display(Name="Test Group")]
        public string TestGroup { get { return _TestGroup; } set { _TestGroup = value; } }

        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }
        public string Search { get { return _Search; } set { _Search = value; } }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@TestName",_TestName),
                new SqlParameter("@Charges",_Charges),
                new SqlParameter("@TestType",_TestType),
                new SqlParameter("@TestGroup",_TestGroup),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_DiagnosticTest");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@TestID",_TestID),
                new SqlParameter("@TestName",_TestName),
                new SqlParameter("@Charges",_Charges),
                new SqlParameter("@TestType",_TestType),
                new SqlParameter("@TestGroup",_TestGroup),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_DiagnosticTest");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@TestID",_TestID),  
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_DiagnosticTest");
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
                    new SqlParameter("@TestName",_TestName),  
                    new SqlParameter("@ModeType", "CHECK"), 
                };
                dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DiagnosticTest");
            }
            else
            {
                SqlParameter[] sqlParams = new SqlParameter[]  
                {
                    new SqlParameter("@TestID",_TestID),  
                    new SqlParameter("@TestName",_TestName),  
                    new SqlParameter("@ModeType", "CHECK"), 
                };
                dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DiagnosticTest");
            }
            return !(dt.Rows.Count > 0);
        }


        public clsDiagnosticTest GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@TestID",_TestID),  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DiagnosticTest");
            clsDiagnosticTest obj = new clsDiagnosticTest();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        public List<clsDiagnosticTest> GetTestType()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@TestType",_TestType),  
                new SqlParameter("@ModeType", "TESTTYPE"),  
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DiagnosticTest");
            List<clsDiagnosticTest> list = new List<clsDiagnosticTest>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsDiagnosticTest obj = new clsDiagnosticTest();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }


        protected clsDiagnosticTest AssignValues(clsDiagnosticTest obj, DataTable dt, int row)
        {
            obj.TestID = Convert.ToInt32(dt.Rows[row]["TestID"]);
            obj.TestName = Convert.ToString(dt.Rows[row]["TestName"]);
            obj.Charges = Convert.ToDecimal(dt.Rows[row]["Charges"]);
            obj.TestType = Convert.ToString(dt.Rows[row]["TestType"]);
            obj.TestGroup = Convert.ToString(dt.Rows[row]["TestGroup"]);
            return obj;
        }

        public List<clsDiagnosticTest> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@Search", _Search),
                new SqlParameter("@ModeType", "SEARCH"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DiagnosticTest");
            List<clsDiagnosticTest> list = new List<clsDiagnosticTest>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsDiagnosticTest obj = new clsDiagnosticTest();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        #endregion
    }
}
