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
    [Table("TransactionLedger")]
    public class clsSupplierLedger
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private long _TransactionLedgerID;
        private string _PartyName;
        private int _TransactionID;
        private int _AccountID;
        private string _TransactionDetail;
        private DateTime _TransactionDate;
        private decimal _Credit;
        private decimal _Debit;
        private decimal _Balance;
        private string _TransactionType;
        private string _PaymentType;
        private string _ChequeNo;
        private string _CustomerName;
        private string _SupplierName;
        private string _FromDate;
        private string _ToDate;

        private string _VoucherType;
        private string _VoucherNo;
        private string _TransType;
        private string _Description;
        private string _CityName;

        private string _PaymentDate;

        private string _ModeType;

        #endregion

        #region Properties

        public long TransactionLedgerID { get { return _TransactionLedgerID; } set { _TransactionLedgerID = value; } }

        public string PartyName { get { return _PartyName; } set { _PartyName = value; } }

        public int TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }

        [Required(ErrorMessage = "Please Select Account")]
        public int AccountID { get { return _AccountID; } set { _AccountID = value; } }

        public string TransactionDetail { get { return _TransactionDetail; } set { _TransactionDetail = value; } }

        public DateTime TransactionDate { get { return _TransactionDate; } set { _TransactionDate = value; } }

        public decimal Credit { get { return _Credit; } set { _Credit = value; } }

        public decimal Debit { get { return _Debit; } set { _Debit = value; } }

        public decimal Balance { get { return _Balance; } set { _Balance = value; } }

        public string TransactionType { get { return _TransactionType; } set { _TransactionType = value; } }

        public string PaymentType { get { return _PaymentType; } set { _PaymentType = value; } }

        public string ChequeNo { get { return _ChequeNo; } set { _ChequeNo = value; } }

        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }

        public string CustomerName { get { return _CustomerName; } set { _CustomerName = value; } }

        public string SupplierName { get { return _SupplierName; } set { _SupplierName = value; } }

        public string FromDate { get { return _FromDate; } set { _FromDate = value; } }

        public string ToDate { get { return _ToDate; } set { _ToDate = value; } }

        public string Amount { get; set; }

        public string VoucherType { get { return _ToDate; } set { _ToDate = value; } }
        public string VoucherNo { get { return _VoucherNo; } set { _VoucherNo = value; } }
        public string TransType { get { return _TransType; } set { _TransType = value; } }
        public string Description { get { return _Description; } set { _Description = value; } }
        public string CityName { get { return _CityName; } set { _CityName = value; } }

        public string PaymentDate { get { return _PaymentDate; } set { _PaymentDate = value; } }

        public List<clsContact> SuppliersList { get; set; }

        #endregion

        #region DML methods

        public int Insert_Distribution_Sale_Entry()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PartyName",_PartyName),
                new SqlParameter("@TransactionID",_TransactionID),
                new SqlParameter("@Debit",_Debit),
                new SqlParameter("@TransactionDetail",_TransactionDetail),
                new SqlParameter("@TransactionDate",_TransactionDate),
                new SqlParameter("@TransactionType","Sale"),
                new SqlParameter("@ModeType", "InsertDistributionSaleEntry"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_SupplierLedger");
        }

        public int Insert_Payments()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PartyName",_PartyName),
                new SqlParameter("@Credit",_Credit),
                new SqlParameter("@TransactionDetail",_TransactionDetail),
                //new SqlParameter("@TransactionType","Sales Payment"),
                new SqlParameter("@TransactionType", _TransactionType),
                new SqlParameter("@PaymentType",_PaymentType),
                new SqlParameter("@AccountID",_AccountID),
                new SqlParameter("@TransactionDate",_TransactionDate),
                new SqlParameter("@ModeType", "InsertPayments"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_SupplierLedger");
        }

        public int Insert_OpeningBalance_Payments()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PartyName",_PartyName),
                new SqlParameter("@Debit",_Debit),
                new SqlParameter("@TransactionDetail",_TransactionDetail),
                //new SqlParameter("@TransactionType","Sales Payment"),
                new SqlParameter("@TransactionType", _TransactionType),
                new SqlParameter("@PaymentType",_PaymentType),
                new SqlParameter("@AccountID",_AccountID),
                new SqlParameter("@TransactionDate",_TransactionDate),
                new SqlParameter("@ModeType", "InsertOpeningBalancePayment"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_SupplierLedger");
        }

        public int Insert_PurchaseOrder_Payments()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PartyName",_PartyName),
                new SqlParameter("@Debit",_Debit),
                new SqlParameter("@TransactionDetail",_TransactionDetail),
                //new SqlParameter("@TransactionType","Purchase Payment"),
                new SqlParameter("@TransactionType", _TransactionType),
                new SqlParameter("@PaymentType",_PaymentType),
                new SqlParameter("@AccountID",_AccountID),
                new SqlParameter("@TransactionDate",_TransactionDate),
                new SqlParameter("@ModeType", "InsertPO_Payments"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_SupplierLedger");
        }

        public int Distribution_Transfer_Sale_Entry()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PartyName",_PartyName),
                new SqlParameter("@TransactionID",_TransactionID),
                new SqlParameter("@Credit",_Credit),
                new SqlParameter("@TransactionDetail",_TransactionDetail),
                new SqlParameter("@TransactionDate",_TransactionDate),
                new SqlParameter("@TransactionType","Stock Transfer"),
                new SqlParameter("@ModeType", "TransferStockPayment"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_SupplierLedger");
        }

        public int Insert_Distribution_Purchase_Entry()
        {
            SqlParameter[] sqlParams = new SqlParameter[]
            {
                new SqlParameter("@PartyName",_PartyName),
                new SqlParameter("@TransactionID",_TransactionID),
                new SqlParameter("@Credit",_Credit),
                new SqlParameter("@TransactionDetail",_TransactionDetail),
                new SqlParameter("@TransactionDate",_TransactionDate),
                new SqlParameter("@TransactionType","Purchase"),
                new SqlParameter("@ModeType", "InsertDistributionPurchaseEntry"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_SupplierLedger");
        }

        

        public int UpdateTransactionLedgerBySupplier()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PartyName",_PartyName),
                new SqlParameter("@TransactionID",_TransactionID),
                new SqlParameter("@Credit",_Credit),                
                new SqlParameter("@TransactionType",_TransactionType),
                new SqlParameter("@TransactionDate",_TransactionDate),
                new SqlParameter("@ModeType", "UpdateTransactionLedgerBySupplier"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_SupplierLedger");
        }
        public int UpdateTransactionLedgerByDistributor()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PartyName",_PartyName),
                new SqlParameter("@TransactionID",_TransactionID),
                new SqlParameter("@Debit",_Debit),                
                new SqlParameter("@TransactionType",_TransactionType),
                new SqlParameter("@TransactionDate",_TransactionDate),
                new SqlParameter("@ModeType", "UpdateTransactionLedgerByDistributor"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_SupplierLedger");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@TransactionID",_TransactionID),
                //new SqlParameter("@PayableID",_PayableID),
                //new SqlParameter("@ReceiveableID",_ReceiveableID),
                new SqlParameter("@TransactionDate",_TransactionDate),
                new SqlParameter("@Credit",_Credit),
                new SqlParameter("@Debit",_Debit),
                new SqlParameter("@TransactionType",_TransactionType),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_SupplierLedger");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@LedgerID",_TransactionLedgerID),
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_SupplierLedger");
        }

        #endregion

        #region DDL Methods

        public clsSupplierLedger GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@TransactionID",_TransactionID),
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_SupplierLedger");
            clsSupplierLedger obj = new clsSupplierLedger();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsSupplierLedger AssignValues(clsSupplierLedger obj, DataTable dt, int row)
        {
            obj.TransactionID = Convert.ToInt32(dt.Rows[row]["TransactionID"]);
            //obj.PayableID = Convert.ToInt32(dt.Rows[row]["PayableID"]);
            //obj.ReceiveableID = Convert.ToInt32(dt.Rows[row]["ReceiveableID"]);
            obj.TransactionDate = Convert.ToDateTime(dt.Rows[row]["TransactionDate"]);
            obj.Credit = Convert.ToDecimal(dt.Rows[row]["Credit"]);
            obj.Debit = Convert.ToDecimal(dt.Rows[row]["Debit"]);
            obj.TransactionType = Convert.ToString(dt.Rows[row]["TransactionType"]);
            return obj;
        }

        public List<clsSupplierLedger> GetData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_SupplierLedger");
            List<clsSupplierLedger> list = new List<clsSupplierLedger>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsSupplierLedger obj = new clsSupplierLedger();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        public List<clsSupplierLedger> GetDataForLedgerReport()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@PartyName", _PartyName),
                new SqlParameter("@FromDate", _FromDate),
                new SqlParameter("@ToDate", _ToDate)
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_SupplierLedgerReport");
            List<clsSupplierLedger> list = new List<clsSupplierLedger>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsSupplierLedger obj = new clsSupplierLedger();
                obj = AssignValuesForLedgerReport(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        protected clsSupplierLedger AssignValuesForLedgerReport(clsSupplierLedger obj, DataTable dt, int row)
        {
            obj.TransactionDate = Convert.ToDateTime(dt.Rows[row]["TransactionDate"]);
            obj.TransactionDetail = Convert.ToString(dt.Rows[row]["TransactionDetail"]);
            obj.Credit = Convert.ToDecimal(dt.Rows[row]["Credit"]);
            obj.Debit = Convert.ToDecimal(dt.Rows[row]["Debit"]);
            obj.Balance = Convert.ToDecimal(dt.Rows[row]["Balance"]);
            obj.TransactionType = Convert.ToString(dt.Rows[row]["TransactionType"]);
            obj.PaymentType = Convert.ToString(dt.Rows[row]["PaymentType"]);
            obj.CustomerName = Convert.ToString(dt.Rows[row]["CustomerName"]);

            obj.VoucherType = Convert.ToString(dt.Rows[row]["VoucherType"]);
            obj.VoucherNo = Convert.ToString(dt.Rows[row]["VoucherNo"]);
            obj.TransType = Convert.ToString(dt.Rows[row]["TransType"]);
            obj.Description = Convert.ToString(dt.Rows[row]["Description"]);
            obj.CityName = Convert.ToString(dt.Rows[row]["CityName"]);

            return obj;
        }

        public bool CheckSaleIDAndPartyAlreadyExists(string pname, int sid, string ttype)
        {
            DataTable dt = new DataTable();
            bool ret = false;
            string qry = string.Format(@" select LedgerID from SupplierLedger where PartyName = '{0}' and TransactionID = {1} and TransactionType = '{2}' ", pname, sid, ttype);


            dt = objconn.GetDataTable(qry);
            if (dt != null && dt.Rows.Count > 0)
                ret = true;

            return ret;
        }

        public List<clsSupplierLedger> GetAllPayments()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ModeType", "GetAllPayments"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_SupplierLedger");
            List<clsSupplierLedger> list = new List<clsSupplierLedger>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsSupplierLedger obj = new clsSupplierLedger();
                obj = AssignValuesPayments(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsSupplierLedger AssignValuesPayments(clsSupplierLedger obj, DataTable dt, int row)
        {
            obj.TransactionLedgerID = Convert.ToInt32(dt.Rows[row]["LedgerID"]);
            obj.PaymentDate = Convert.ToString(dt.Rows[row]["TransactionDate"]);
            obj.TransactionType = Convert.ToString(dt.Rows[row]["TransactionType"]);
            obj.PaymentType = Convert.ToString(dt.Rows[row]["PaymentType"]);
            obj.Credit = Convert.ToDecimal(dt.Rows[row]["Credit"]);
            obj.Debit = Convert.ToDecimal(dt.Rows[row]["Debit"]);
            obj.TransactionDetail = Convert.ToString(dt.Rows[row]["TransactionDetail"]);
            obj.CustomerName = Convert.ToString(dt.Rows[row]["CustomerName"]);
            obj.VoucherType = Convert.ToString(dt.Rows[row]["VoucherType"]);
            obj.VoucherNo = Convert.ToString(dt.Rows[row]["VoucherNo"]);
            obj.TransType = Convert.ToString(dt.Rows[row]["TransType"]);
            obj.Description = Convert.ToString(dt.Rows[row]["Description"]);
            obj.CityName = Convert.ToString(dt.Rows[row]["CityName"]);

            return obj;
        }

        #endregion
    }
}

