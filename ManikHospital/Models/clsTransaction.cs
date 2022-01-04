using MedicalStore.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace vtsMMC.Models
{
    public class clsTransaction
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _TransactionID;
        private int _PatientID;
        private DateTime _TransDate;
        private string _CollectedBy;
        private decimal _Amount;
        private string _EnteredBy;
        private string _PaymentType;
        private string _ModeType;

        #endregion

        #region Properties

        public int TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }

        [Display (Name = "Patient Name")]
        public int PatientID { get { return _PatientID; } set { _PatientID = value; } }
        [Required, Display(Name = "Payment Date")]
        public DateTime TransDate { get { return _TransDate; } set { _TransDate = value; } }

        [Display(Name = "Collected By")]
        public string CollectedBy { get { return _CollectedBy; } set { _CollectedBy = value; } }

        [Required, Display(Name = "Amount")]
        public decimal Amount { get { return _Amount; } set { _Amount = value; } }
        public string EnteredBy { get { return _EnteredBy; } set { _EnteredBy = value; } }
        [Display(Name = "Payment Type")]
        public string PaymentType { get { return _PaymentType; } set { _PaymentType = value; } }
        public string ModeType { get { return _ModeType; } set { _ModeType = value; } } 

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PatientID",_PatientID),
                new SqlParameter("@TransDate",_TransDate),
                new SqlParameter("@CollectedBy", _CollectedBy),
                new SqlParameter("@Amount",_Amount),
                new SqlParameter("@EnteredBy",_EnteredBy),
                new SqlParameter("@PaymentType",_PaymentType),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_Transactions");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@TransactionID",_TransactionID),
                new SqlParameter("@PatientID",_PatientID),
                new SqlParameter("@TransDate",_TransDate),
                new SqlParameter("@CollectedBy", _CollectedBy),
                new SqlParameter("@Amount",_Amount),
                new SqlParameter("@EnteredBy",_EnteredBy),
                new SqlParameter("@PaymentType",_PaymentType),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_Transactions");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@TransactionID",_TransactionID),
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_Transactions");
        }

        #endregion

        #region DDL Methods

        public clsTransaction GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@TransactionID",_TransactionID),
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Transactions");
            clsTransaction obj = new clsTransaction();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        public List<clsTransaction> GetPatientPaymentsByPatID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PatientID",_PatientID),
                new SqlParameter("@ModeType", "GETPayments"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Transactions");
            List<clsTransaction> objList = new List<clsTransaction>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsTransaction objtrans = new clsTransaction();
                objtrans = AssignValues(objtrans, dt, i);
                objList.Add(objtrans);
            }
            return objList;
        }

        protected clsTransaction AssignValues(clsTransaction obj, DataTable dt, int row)
        {   
            obj.TransactionID = Convert.ToInt32(dt.Rows[row]["TransactionID"]); 
            obj.PatientID = Convert.ToInt32(dt.Rows[row]["PatientID"]);
            obj.TransDate = Convert.ToDateTime(dt.Rows[row]["TransDate"]);
            obj.CollectedBy = Convert.ToString(dt.Rows[row]["CollectedBy"]);
            obj.Amount = Convert.ToDecimal (dt.Rows[row]["Amount"]);
            obj.EnteredBy = Convert.ToString(dt.Rows[row]["EnteredBy"]);
            obj.PaymentType = Convert.ToString(dt.Rows[row]["PaymentType"]);
            
            return obj;
        }

        public List<clsTransaction> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Contact");
            List<clsTransaction> list = new List<clsTransaction>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsTransaction obj = new clsTransaction();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        public int DeleteTransactionUpdateBalanceOwing()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@TransactionID",_TransactionID),
                new SqlParameter("@ModeType", "UpdateTransaction"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_Transactions");
        }

        #endregion
    }
}