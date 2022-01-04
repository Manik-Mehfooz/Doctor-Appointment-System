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
    [Table("InvoiceDetail")]
    public class clsInvoiceDetail
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _InvoiceDetailID;
        private int _InvoiceID;
        private int _TestID;
        private int _DoctorFeeID;
        private string _ModeType; 

        #endregion

        #region Properties

        public int InvoiceDetailID { get { return _InvoiceDetailID; } set { _InvoiceDetailID = value; } }
        public int InvoiceID { get { return _InvoiceID; } set { _InvoiceID = value; } }
        public int TestID { get { return _TestID; } set { _TestID = value; } }
        public string TestName { get; set; }
        public decimal Charges { get; set; }
        public int DoctorFeeID { get { return _DoctorFeeID; } set { _DoctorFeeID = value; } }
        public string DoctorFee { get; set; }
        public decimal FeeAmount { get; set; }
        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }

        

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@InvoiceID",_InvoiceID),
                new SqlParameter("@TestID",_TestID),
                new SqlParameter("@DoctorFeeID",_DoctorFeeID),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_InvoiceDetail");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@InvoiceDetailID",_InvoiceDetailID),
                new SqlParameter("@InvoiceID",_InvoiceID),
                new SqlParameter("@TestID",_TestID),
                new SqlParameter("@DoctorFeeID",_DoctorFeeID),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_InvoiceDetail");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@InvoiceDetailID",_InvoiceDetailID),
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_InvoiceDetail");
        }

        #endregion

        #region DDL Methods

        public clsInvoiceDetail GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@InvoiceDetailID",_InvoiceDetailID),
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_InvoiceDetail");
            clsInvoiceDetail obj = new clsInvoiceDetail();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsInvoiceDetail AssignValues(clsInvoiceDetail obj, DataTable dt, int row)
        {
            obj.InvoiceDetailID = Convert.ToInt32(dt.Rows[row]["InvoiceDetailID"]);
            obj.InvoiceID = Convert.ToInt32(dt.Rows[row]["InvoiceID"]);
            obj.TestID = Convert.ToInt32(dt.Rows[row]["TestID"]);
            obj.TestName = Convert.ToString(dt.Rows[row]["TestName"]);
            obj.Charges = Convert.ToDecimal(dt.Rows[row]["Charges"]);
            obj.DoctorFeeID = Convert.ToInt32(dt.Rows[row]["FeeID"]);
            obj.DoctorFee = Convert.ToString(dt.Rows[row]["FeeType"]);
            obj.FeeAmount = Convert.ToDecimal(dt.Rows[row]["Fees"]);
            return obj;
        }

        public List<clsInvoiceDetail> GetAllData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_InvoiceDetail");
            List<clsInvoiceDetail> list = new List<clsInvoiceDetail>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsInvoiceDetail obj = new clsInvoiceDetail();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        #endregion
    }
}
