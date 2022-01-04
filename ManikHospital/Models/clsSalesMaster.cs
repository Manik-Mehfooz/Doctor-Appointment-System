using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MedicalStore.Models
{
    [Table("SalesMaster")]
    public class clsSalesMaster
    {
        clsConnection objconn = new clsConnection();

        #region Private

        private int _SaleID;
        private string _SaleInvoiceNumber;
        private int _PatientID;
        private int _DoctorID;
        private DateTime _SaleDate;
        private string _Remarks;
        private string _EnteredBy;
        private string _Search;
        private string _ModeType;

        private string _SaleType;
        private string _PatientName;
        private string _ContactNo;
        private string _GuardianName;
        private string _GuardianContactNo;
        private string _RoomNo;
        private string _Diagnostics;

        private string _NetAmount;

        #endregion

        #region Public
        public int SaleID { get { return _SaleID; } set { _SaleID = value; } }
        public int PatientID { get { return _PatientID; } set { _PatientID = value; } }
        public int DoctorID { get { return _DoctorID; } set { _DoctorID = value; } }
        public string SaleInvoiceNumber { get { return _SaleInvoiceNumber; } set { _SaleInvoiceNumber = value; } }
        public DateTime SaleDate { get { return _SaleDate; } set { _SaleDate = value; } }
        public string Remarks { get { return _Remarks; } set { _Remarks = value; } }
        public string EnteredBy { get { return _EnteredBy; } set { _EnteredBy = value; } }
        public string Search { get { return _Search; } set { _Search = value; } }
        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }

        public string SaleType { get { return _SaleType; } set { _SaleType = value; } }
        [Required, Display(Name = "Patient Name")]
        public string PatientName { get { return _PatientName; } set { _PatientName = value; } }
        [Required, Display(Name = "Contact Number")]
        public string ContactNo { get { return _ContactNo; } set { _ContactNo = value; } }
        [Required, Display(Name = "Guardian Name")]
        public string GuardianName { get { return _GuardianName; } set { _GuardianName = value; } }
        [Display(Name = "Guardian Contact Number")]
        public string GuardianContactNo { get { return _GuardianContactNo; } set { _GuardianContactNo = value; } }
        [Required, Display(Name = "Room #")]
        public string RoomNo { get { return _RoomNo; } set { _RoomNo = value; } }

        [Required, Display(Name = "Diagnostics")]
        public string Diagnostics { get { return _Diagnostics; } set { _Diagnostics = value; } }
        

        public string NetAmount { get { return _NetAmount; } set { _NetAmount = value; } }

        public string PatientRegNo { get; set; }

        public int SaleDetailID { get; set; }
        public string ProductName { get; set; }
        public decimal Price { get; set; }
        public int Quantity { get; set; }
        public decimal Total { get; set; }
        public int ProductID { get; set; }

        public decimal Amount { get; set; }
        public int Discount { get; set; }
        public decimal DiscountAmount { get; set; }
        public decimal InvoiceAmount { get; set; }
        public string DoctorName { get; set; }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@SaleInvoiceNumber",_SaleInvoiceNumber),
                new SqlParameter("@PatientID",_PatientID),
                new SqlParameter("@DoctorID",_DoctorID),
                new SqlParameter("@SaleDate",_SaleDate),
                new SqlParameter("@SaleType",_SaleType),
                new SqlParameter("@EnteredBy",_EnteredBy),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "SP_SalesMaster");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@SaleInvoiceNumber",_SaleInvoiceNumber),
                new SqlParameter("@PatientID",_PatientID),
                new SqlParameter("@DoctorID",_DoctorID),
                new SqlParameter("@SaleDate",_SaleDate),
                new SqlParameter("@SaleType",_SaleType),               
                new SqlParameter("@UpdatedBy",_EnteredBy),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "SP_SalesMaster");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@SaleID",_SaleID),  
                new SqlParameter("@DeletedBy",_EnteredBy), 
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "SP_SalesMaster");
        }

        public int DeleteMethodForCancel(int id)
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@SaleID",id),  
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "SP_SalesMaster");
        }

        public int UpdateDoctorIDMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@SaleID",_SaleID),
                new SqlParameter("@DoctorID",_DoctorID),
                new SqlParameter("@UpdatedBy",_EnteredBy),
                new SqlParameter("@ModeType", "UPDATEDoctor"), 
            };
            return objconn.SqlCommParam(sqlParams, "SP_SalesMaster");
        }

        #endregion

        #region DDL Methods

        //public bool CheckExitData(int id)
        //{
        //    DataTable dt = new DataTable();
        //    if (id == 0)
        //    {
        //        SqlParameter[] sqlParams = new SqlParameter[]  
        //        {
        //            new SqlParameter("@Company",_Company),  
        //            new SqlParameter("@ModeType", "CHECK"), 
        //        };
        //        dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Company");
        //    }
        //    else
        //    {
        //        SqlParameter[] sqlParams = new SqlParameter[]  
        //        {
        //            new SqlParameter("@CompanyID",_CompanyID),
        //            new SqlParameter("@Company",_Company),  
        //            new SqlParameter("@ModeType", "CHECK"), 
        //        };
        //        dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Company");

        //    }
        //    return !(dt.Rows.Count > 0);
        //}

        public clsSalesMaster GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@CompanyID",_SaleID),  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "SP_SalesMaster");
            clsSalesMaster obj = new clsSalesMaster();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }


        public int GetMaxID()
        {
            int maxid = 0;
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {               
                new SqlParameter("@ModeType", "GetMaxID"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "SP_SalesMaster");

            if (dt.Rows.Count > 0)
            {
                maxid = Convert.ToInt32(dt.Rows[0]["MAXSaleID"].ToString());
            }
            return maxid;
        }

        public string GetLastINVNo(int Month, int Yearr, int Day)
        {
            string ret = "";
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@Day", Day), 
                new SqlParameter("@Month", Month), 
                new SqlParameter("@Year", Yearr), 
                new SqlParameter("@ModeType", "GetLastINVNO"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "SP_SalesMaster");

            if (dt.Rows.Count > 0)
            {
                ret = dt.Rows[0]["MaxSaleInvNo"].ToString();
            }
            return ret;
        }

        protected clsSalesMaster AssignValues(clsSalesMaster obj, DataTable dt, int row)
        {
            obj.SaleID = Convert.ToInt32(dt.Rows[row][0]);
            obj.SaleInvoiceNumber = Convert.ToString(dt.Rows[row][1]);
            obj.SaleDate = Convert.ToDateTime(dt.Rows[row][1]);
            obj.Remarks = Convert.ToString(dt.Rows[row][1]);
            return obj;
        }

        public List<clsSalesMaster> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@Search", _Search),
                new SqlParameter("@ModeType", "SEARCH"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "SP_SalesMaster");
            List<clsSalesMaster> list = new List<clsSalesMaster>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsSalesMaster obj = new clsSalesMaster();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        public List<clsSalesMaster> GetAllAdmitPatientList()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {                  
                new SqlParameter("@ModeType", "GetAdmitPatientList"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "SP_SalesMaster");
            List<clsSalesMaster> list = new List<clsSalesMaster>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsSalesMaster obj = new clsSalesMaster();
                obj = AssignValuesAdmitPatient(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        protected clsSalesMaster AssignValuesAdmitPatient(clsSalesMaster obj, DataTable dt, int row)
        {
            obj.SaleID = Convert.ToInt32(dt.Rows[row]["SaleID"]);
            obj.SaleInvoiceNumber = Convert.ToString(dt.Rows[row]["SaleInvoiceNumber"]);
            obj.PatientID = Convert.ToInt32(dt.Rows[row]["PatientID"]);
            obj.PatientName = Convert.ToString(dt.Rows[row]["PatientName"]);
            obj.ContactNo = Convert.ToString(dt.Rows[row]["ContactNo"]);
            obj.GuardianName = Convert.ToString(dt.Rows[row]["GuardianName"]);
            obj.GuardianContactNo = Convert.ToString(dt.Rows[row]["GuardianContactNo"]);
            obj.RoomNo = Convert.ToString(dt.Rows[row]["RoomNo"]);
            obj.Diagnostics = Convert.ToString(dt.Rows[row]["Diagnostics"]);
            obj.NetAmount = Convert.ToString(dt.Rows[row]["NetAmount"]);
            obj.PatientRegNo = Convert.ToString(dt.Rows[row]["PatientRegNo"]);
            return obj;
        }

        public DataTable GetSalesMasterByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@SaleID",_SaleID),  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "SP_SalesMaster");
            
            return dt;
        }

        public List<clsSalesMaster> GetAllOPDSaleList()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {                  
                new SqlParameter("@ModeType", "GetOPDSaleList"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "SP_SalesMaster");
            List<clsSalesMaster> list = new List<clsSalesMaster>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsSalesMaster obj = new clsSalesMaster();
                obj = AssignValuesOPDSale(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsSalesMaster AssignValuesOPDSale(clsSalesMaster obj, DataTable dt, int row)
        {
            obj.SaleID = Convert.ToInt32(dt.Rows[row]["SaleID"]);
            obj.SaleInvoiceNumber = Convert.ToString(dt.Rows[row]["SaleInvoiceNumber"]);
            obj.PatientID = Convert.ToInt32(dt.Rows[row]["PatientID"]);
            obj.PatientName = Convert.ToString(dt.Rows[row]["PatientName"]);
            obj.ContactNo = Convert.ToString(dt.Rows[row]["ContactNo"]);
            obj.GuardianName = Convert.ToString(dt.Rows[row]["GuardianName"]);
            obj.GuardianContactNo = Convert.ToString(dt.Rows[row]["GuardianContactNo"]);
            obj.RoomNo = Convert.ToString(dt.Rows[row]["RoomNo"]);
            obj.Diagnostics = Convert.ToString(dt.Rows[row]["Diagnostics"]);
            obj.NetAmount = Convert.ToString(dt.Rows[row]["NetAmount"]);
            obj.PatientRegNo = Convert.ToString(dt.Rows[row]["PatientRegNo"]);
            obj.SaleDate = Convert.ToDateTime(dt.Rows[row]["SaleDate"]);
            obj.DoctorName = Convert.ToString(dt.Rows[row]["DoctorName"]);

            return obj;
        }

        public List<clsSalesMaster> GetSaleInvoiceByInvoiceNumber()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@SaleInvoiceNumber", _SaleInvoiceNumber),   
                new SqlParameter("@ModeType", "GetSaleInvoiceByInvoiceNumber"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "SP_SalesMaster");
            List<clsSalesMaster> list = new List<clsSalesMaster>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsSalesMaster obj = new clsSalesMaster();
                obj = AssignValuesReturn(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsSalesMaster AssignValuesReturn(clsSalesMaster obj, DataTable dt, int row)
        {
            obj.SaleID = Convert.ToInt32(dt.Rows[row]["SaleID"]);
            obj.SaleDetailID = Convert.ToInt32(dt.Rows[row]["SaleDetailID"]);
            obj.ProductName = Convert.ToString(dt.Rows[row]["ProductName"]);
            obj.Price = Convert.ToDecimal(dt.Rows[row]["Price"]);
            obj.Quantity = Convert.ToInt32(dt.Rows[row]["Quantity"]);
            obj.Total = Convert.ToInt32(dt.Rows[row]["Total"]);
            obj.ProductID = Convert.ToInt32(dt.Rows[row]["ProductID"]);

            return obj;
        }

        public List<clsSalesMaster> GetInvoiceInfoByInvNo()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@SaleInvoiceNumber", _SaleInvoiceNumber),   
                new SqlParameter("@ModeType", "GetInvoiceInfor"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "SP_SalesMaster");
            List<clsSalesMaster> list = new List<clsSalesMaster>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsSalesMaster obj = new clsSalesMaster();
                obj = AssignValuesInfo(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsSalesMaster AssignValuesInfo(clsSalesMaster obj, DataTable dt, int row)
        {
            obj.SaleID = Convert.ToInt32(dt.Rows[row]["SaleID"]);
            obj.PatientName = Convert.ToString(dt.Rows[row]["PatientName"]);
            obj.ContactNo = Convert.ToString(dt.Rows[row]["ContactNo"]);
            obj.Amount = Convert.ToDecimal(dt.Rows[row]["Amount"]);
            obj.Discount = Convert.ToInt32(dt.Rows[row]["Discount"]);
            obj.DiscountAmount = Convert.ToDecimal(dt.Rows[row]["DiscountAmount"]);
            obj.InvoiceAmount = Convert.ToDecimal(dt.Rows[row]["InvoiceAmount"]);

            return obj;
        }

        #endregion

    }
}