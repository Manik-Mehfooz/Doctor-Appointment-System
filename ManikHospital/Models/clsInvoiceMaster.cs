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
    [Table("InvoiceMaster")]
    public class clsInvoiceMaster
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _InvoiceID;
        private int _PatientID;
        private int _DoctorID;
        private string _InvoiceNumber;
        private string _PatientName;
        private string _ContactNo;
        private string _InvoiceType;
        private decimal _DepositeAmount;
        private decimal _Discount;
        private DateTime _InvoiceDate;
        private string _InvoiceStatus;
         
        private string _ModeType; 

        #endregion

        #region Properties

        public int InvoiceID { get { return _InvoiceID; } set { _InvoiceID = value; } }
        public int PatientID { get { return _PatientID; } set { _PatientID = value; } }
        public int DoctorID { get { return _DoctorID; } set { _DoctorID = value; } }
        public string InvoiceNumber { get { return _InvoiceNumber; } set { _InvoiceNumber = value; } }
        public string PatientName { get { return _PatientName; } set { _PatientName = value; } }
        public string ContactNo { get { return _ContactNo; } set { _ContactNo = value; } }
        public string InvoiceType { get { return _InvoiceType; } set { _InvoiceType = value; } }
        public decimal DepositeAmount { get { return _DepositeAmount; } set { _DepositeAmount = value; } }
        public decimal Discount { get { return _Discount; } set { _Discount = value; } }
        public DateTime InvoiceDate { get { return _InvoiceDate; } set { _InvoiceDate = value; } }
        public string InvoiceStatus { get { return _InvoiceStatus; } set { _InvoiceStatus = value; } }
        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }
    
        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PatientID",_PatientID),
                new SqlParameter("@DoctorID",_DoctorID),
                new SqlParameter("@InvoiceNumber",_InvoiceNumber),
                new SqlParameter("@PatientName",_PatientName),
                new SqlParameter("@ContactNo",_ContactNo),
                new SqlParameter("@InvoiceType",_InvoiceType),
                new SqlParameter("@DepositeAmount",_DepositeAmount),
                new SqlParameter("@Discount",_Discount),
                new SqlParameter("@InvoiceDate",_InvoiceDate),
                new SqlParameter("@InvoiceStatus",_InvoiceStatus),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_InvoiceMaster");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@InvoiceID",_InvoiceID),
                new SqlParameter("@PatientID",_PatientID),
                new SqlParameter("@DoctorID",_DoctorID),
                new SqlParameter("@InvoiceNumber",_InvoiceNumber),
                new SqlParameter("@PatientName",_PatientName),
                new SqlParameter("@ContactNo",_ContactNo),
                new SqlParameter("@InvoiceType",_InvoiceType),
                new SqlParameter("@DepositeAmount",_DepositeAmount),
                new SqlParameter("@Discount",_Discount),
                new SqlParameter("@InvoiceDate",_InvoiceDate),
                new SqlParameter("@InvoiceStatus",_InvoiceStatus),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_InvoiceMaster");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
               new SqlParameter("@InvoiceID",_InvoiceID),
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_InvoiceMaster");
        }

        #endregion

        #region DDL Methods

        public clsInvoiceMaster GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@InvoiceID",_InvoiceID),
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_InvoiceMaster");
            clsInvoiceMaster obj = new clsInvoiceMaster();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsInvoiceMaster AssignValues(clsInvoiceMaster obj, DataTable dt, int row)
        {
            obj.InvoiceID = Convert.ToInt32(dt.Rows[row]["InvoiceID"]);
            obj.PatientID = Convert.ToInt32(dt.Rows[row]["PatientID"]);
            obj.DoctorID = Convert.ToInt32(dt.Rows[row]["DoctorID"]);
            obj.InvoiceNumber = Convert.ToString(dt.Rows[row]["InvoiceNumber"]);
            obj.PatientName = Convert.ToString(dt.Rows[row]["PatientName"]);
            obj.ContactNo = Convert.ToString(dt.Rows[row]["ContactNo"]);
            obj.InvoiceType = Convert.ToString(dt.Rows[row]["InvoiceType"]);
            obj.DepositeAmount = Convert.ToDecimal(dt.Rows[row]["DepositeAmount"]);
            obj.Discount = Convert.ToDecimal(dt.Rows[row]["Discount"]);
            obj.InvoiceDate = Convert.ToDateTime(dt.Rows[row]["InvoiceDate"]);
            obj.InvoiceStatus = Convert.ToString(dt.Rows[row]["InvoiceStatus"]);
            return obj;
        }

        public List<clsInvoiceMaster> GetAllData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {   
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_InvoiceMaster");
            List<clsInvoiceMaster> list = new List<clsInvoiceMaster>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsInvoiceMaster obj = new clsInvoiceMaster();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        public int GetMaxID()
        {
            try
            {
                return Convert.ToInt32(objconn.GetScaler("SELECT MAX(InvoiceID) as InvoiceID from InvoiceMaster"));

            }
            catch (Exception) { }
            return 0;
        }




        #endregion
    }
}
