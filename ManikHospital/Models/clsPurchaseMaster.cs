using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MedicalStore.Models
{
    [Table("PurchaseMaster")]
    public class clsPurchaseMaster
    {
        clsConnection objconn = new clsConnection();

        #region private properties
        private int _PurchaseID;
        private string _InvioceNumber;
        private string _DrugAgency;
        private string _AgencyInvoiceNo;
        private DateTime _InvoiceDate;
        private string _Remarks;
        private string _EnteredBy;
        private string _UpdatedBy;
        private string _DeletedBy;
        private string _InvoiceImage;

        #endregion

        #region Public Properties

        public int PurchaseID { get { return _PurchaseID; } set { _PurchaseID = value; } }

        [Display(Name = "Invoice Number")]
        public string InvioceNumber { get { return _InvioceNumber; } set { _InvioceNumber = value; } }

        [Required(ErrorMessage = "Please Enter Agency Name"), Display(Name = "Agency Name")]
        public string DrugAgency { get { return _DrugAgency; } set { _DrugAgency = value; } }

        [Required(ErrorMessage = "Please Enter Agency Invoice Number"), Display(Name = "Agency Invoice Number")]
        public string AgencyInvoiceNo { get { return _AgencyInvoiceNo; } set { _AgencyInvoiceNo = value; } }

        [Required(ErrorMessage = "Please Enter Invoice Date"), Display(Name = "Invoice Date")]
        public DateTime InvoiceDate { get { return _InvoiceDate; } set { _InvoiceDate = value; } }

        public string Remarks { get { return _Remarks; } set { _Remarks = value; } }
        public string EnteredBy { get { return _EnteredBy; } set { _EnteredBy = value; } }
        public string UpdatedBy { get { return _UpdatedBy; } set { _UpdatedBy = value; } }
        public string DeletedBy { get { return _DeletedBy; } set { _DeletedBy = value; } }

        public string InvoiceImage { get { return _InvoiceImage; } set { _InvoiceImage = value; } }

        public HttpPostedFileBase ImageFile { get; set; }
        public decimal TotalAmount { get; set; }

        #endregion

        #region DML methods
        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@InvioceNumber",_InvioceNumber),
                new SqlParameter("@DrugAgency",_DrugAgency),
                new SqlParameter("@AgencyInvoiceNo",_AgencyInvoiceNo),
                new SqlParameter("@InvoiceDate",_InvoiceDate),
                new SqlParameter("@Remarks",_Remarks),
                new SqlParameter("@EnteredBy",_EnteredBy),    
                new SqlParameter("@InvoiceImage",_InvoiceImage),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_PurchaseMaster");
        }
        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PurchaseID",_PurchaseID),
                new SqlParameter("@InvioceNumber",_InvioceNumber),
                new SqlParameter("@DrugAgency",_DrugAgency),
                new SqlParameter("@AgencyInvoiceNo",_AgencyInvoiceNo),
                new SqlParameter("@InvoiceDate",_InvoiceDate),
                new SqlParameter("@Remarks",_Remarks),
                new SqlParameter("@UpdatedBy",_UpdatedBy),                
                new SqlParameter("@ModeType", "UPDATE"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_PurchaseMaster");
        }
        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PurchaseID",_PurchaseID),  
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_PurchaseMaster");
        }

        public int DeleteMethodCompleteDELETE()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@PurchaseID",_PurchaseID),  
                new SqlParameter("@ModeType", "DELETE_Complete"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_PurchaseMaster");
        }
        #endregion

        #region DDL
        public List<clsPurchaseMaster> GetAllData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {                  
                new SqlParameter("@ModeType", "GET_LIST"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "SP_PurchaseMaster");
            List<clsPurchaseMaster> list = new List<clsPurchaseMaster>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsPurchaseMaster obj = new clsPurchaseMaster();
                obj = AssignValuesView(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsPurchaseMaster AssignValuesView(clsPurchaseMaster obj, DataTable dt, int row)
        {
            obj.PurchaseID = Convert.ToInt32(dt.Rows[row]["PurchaseID"]);
            obj.InvioceNumber = dt.Rows[row]["InvioceNumber"].ToString();
            obj.DrugAgency = Convert.ToString(dt.Rows[row]["DrugAgency"]);
            obj.AgencyInvoiceNo = dt.Rows[row]["AgencyInvoiceNo"].ToString();
            obj.InvoiceDate = Convert.ToDateTime(dt.Rows[row]["InvoiceDate"].ToString());
            obj.Remarks = Convert.ToString(dt.Rows[row]["Remarks"]);
            obj.InvoiceImage = Convert.ToString(dt.Rows[row]["InvoiceImage"]);
            obj.TotalAmount = Convert.ToDecimal(dt.Rows[row]["TotalAmount"]);
            return obj;
        }

        public clsPurchaseMaster GetAllDataByID(int id)
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {                  
                new SqlParameter("@ModeType", "GET_FOR_EDIT"),
                new SqlParameter("@PurchaseID", id),
 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "SP_PurchaseMaster");
            clsPurchaseMaster obj = new clsPurchaseMaster();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        public string GetLastPurchaseINVNo(int Month, int Yearr, int Day)
        {
            DataTable dt = new DataTable();
            string PurchaseINVNo = "";
            SqlParameter[] sqlParams = new SqlParameter[]  
            {                  
                new SqlParameter("@Day", Day), 
                new SqlParameter("@Month", Month), 
                new SqlParameter("@Year", Yearr), 
                new SqlParameter("@ModeType", "GetLastPurchaseINVNo"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "SP_PurchaseMaster");
            List<clsPurchaseMaster> list = new List<clsPurchaseMaster>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                PurchaseINVNo = Convert.ToString(dt.Rows[0]["InvioceNumber"].ToString());
            }
            return PurchaseINVNo;


        }

        public string GetPurchaseInvoiceNumber()
        {
            DataTable dt = new DataTable();
            string PurchaseINVNo = "";
            SqlParameter[] sqlParams = new SqlParameter[]  
            {                   
                new SqlParameter("@ModeType", "GetNewPurchaseOrderInvoiceNumber"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "SP_PurchaseMaster");
            List<clsPurchaseMaster> list = new List<clsPurchaseMaster>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                PurchaseINVNo = Convert.ToString(dt.Rows[0]["PurchaseInvoiceNumber"].ToString());
            }
            return PurchaseINVNo;
        }


        protected clsPurchaseMaster AssignValues(clsPurchaseMaster obj, DataTable dt, int row)
        {
            obj.PurchaseID = Convert.ToInt32(dt.Rows[row]["PurchaseID"]);
            obj.InvioceNumber = dt.Rows[row]["InvioceNumber"].ToString();
            obj.DrugAgency = Convert.ToString(dt.Rows[row]["DrugAgency"]);
            obj.AgencyInvoiceNo = dt.Rows[row]["AgencyInvoiceNo"].ToString();
            obj.InvoiceDate = Convert.ToDateTime(dt.Rows[row]["InvoiceDate"].ToString());
            obj.Remarks = Convert.ToString(dt.Rows[row]["Remarks"]);
            return obj;
        }

        public int GetMaxPurchaseID()
        {
            DataTable dt = new DataTable();
            int maxpid = 0;
            SqlParameter[] sqlParams = new SqlParameter[]  
            {   
               
                new SqlParameter("@ModeType", "GetMaxPurchaseID"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "SP_PurchaseMaster");

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                maxpid = Convert.ToInt32(dt.Rows[0]["MaxPurchaseID"].ToString());
            }
            return maxpid;
        }

        public List<clsPurchaseMaster> GetAllDrugDistributors()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {                  
                new SqlParameter("@ModeType", "GetAllDrugAgencyName"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "SP_PurchaseMaster");
            List<clsPurchaseMaster> list = new List<clsPurchaseMaster>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsPurchaseMaster obj = new clsPurchaseMaster();
                obj = AssignValuesDistributor(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        protected clsPurchaseMaster AssignValuesDistributor(clsPurchaseMaster obj, DataTable dt, int row)
        {
            obj.DrugAgency = Convert.ToString(dt.Rows[row]["DrugAgency"]);
            return obj;
        }
               

        #endregion

    }
}