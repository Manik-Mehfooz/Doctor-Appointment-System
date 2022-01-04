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
    [Table("LabAsset")]
    public class clsLabAsset
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _AssetID;
        private int _AssetTypeID;
        private int _Quantity;
        private decimal _Price;
        private string _CompanyName;
        private string _InvoiceNo;
        private DateTime _InvoiceDate;
        private string _EnteredBy;
        //private DateTime _DeletedDate;
        //private bool _IsDeleted;
        private string _ModeType; 

        #endregion

        #region Properties

        public int AssetID { get { return _AssetID; } set { _AssetID = value; } }
        public int AssetTypeID { get { return _AssetTypeID; } set { _AssetTypeID = value; } }
        public int Quantity { get { return _Quantity; } set { _Quantity = value; } }
        public decimal Price { get { return _Price; } set { _Price = value; } }
        public string EnteredBy { get { return _EnteredBy; } set { _EnteredBy = value; } }
        [Display(Name = "Company Name")]        
        public string CompanyName { get { return _CompanyName; } set { _CompanyName = value; } }

        [Display(Name = "Invoice No")]
        public string InvoiceNo { get { return _InvoiceNo; } set { _InvoiceNo = value; } }

        [Display(Name = "Invoice Date")]
        public DateTime InvoiceDate { get { return _InvoiceDate; } set { _InvoiceDate = value; } }
        

        public string AssetType { get; set; }
        [Display(Name = "Asset Name")]
        public string AssetName { get; set; }
        [Display(Name = "Asset Size")]
        public string AssetSize { get; set; }
        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }

        public string AssetInvoiceDate { get; set; }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            { 
                new SqlParameter("@AssetTypeID",_AssetTypeID),
                new SqlParameter("@Quantity",_Quantity),
                new SqlParameter("@Price",_Price),
                new SqlParameter("@CompanyName",_CompanyName),
                new SqlParameter("@InvoiceNo",_InvoiceNo),
                new SqlParameter("@InvoiceDate",_InvoiceDate),
                new SqlParameter("@EnteredBy",_EnteredBy),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_LabAsset");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@AssetID",_AssetID),
                new SqlParameter("@AssetTypeID",_AssetTypeID),
                new SqlParameter("@Quantity",_Quantity),
                new SqlParameter("@Price",_Price),
                new SqlParameter("@CompanyName",_CompanyName),
                new SqlParameter("@InvoiceNo",_InvoiceNo),
                new SqlParameter("@InvoiceDate",_InvoiceDate),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_LabAsset");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@AssetID",_AssetID),
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_LabAsset");
        }

        #endregion

        #region DDL Methods

        public clsLabAsset GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@AssetID",_AssetID),
                new SqlParameter("@ModeType", "GetByID"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_LabAsset");
            clsLabAsset obj = new clsLabAsset();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsLabAsset AssignValues(clsLabAsset obj, DataTable dt, int row)
        {
            obj.AssetID = Convert.ToInt32(dt.Rows[row]["AssetID"]);
            obj.AssetType = Convert.ToString(dt.Rows[row]["AssetType"]);
            obj.AssetTypeID = Convert.ToInt32(dt.Rows[row]["AssetTypeID"]);
            obj.AssetName = Convert.ToString(dt.Rows[row]["AssetName"]);
            obj.AssetSize = Convert.ToString(dt.Rows[row]["AssetSize"]);
            obj.Quantity = Convert.ToInt32(dt.Rows[row]["Quantity"]);
            obj.Price = Convert.ToInt32(dt.Rows[row]["Price"]);
            obj.CompanyName = Convert.ToString(dt.Rows[row]["CompanyName"]);
            obj.InvoiceNo = Convert.ToString(dt.Rows[row]["InvoiceNo"]);
            obj.InvoiceDate = Convert.ToDateTime(dt.Rows[row]["InvoiceDate"]);
            return obj;
        }

        public List<clsLabAsset> GetAllData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {   
                new SqlParameter("@ModeType", "GetAll"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_LabAsset");
            List<clsLabAsset> list = new List<clsLabAsset>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsLabAsset obj = new clsLabAsset();
                obj = AssignValuesView(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsLabAsset AssignValuesView(clsLabAsset obj, DataTable dt, int row)
        {
            obj.AssetID = Convert.ToInt32(dt.Rows[row]["AssetID"]);
            obj.CompanyName = Convert.ToString(dt.Rows[row]["CompanyName"]);
            obj.InvoiceNo = Convert.ToString(dt.Rows[row]["InvoiceNo"]);
            obj.AssetInvoiceDate = Convert.ToString(dt.Rows[row]["InvoiceDate"]);
            obj.Quantity = Convert.ToInt32(dt.Rows[row]["Quantity"]);
            obj.Price = Convert.ToInt32(dt.Rows[row]["Price"]);
            obj.AssetType = Convert.ToString(dt.Rows[row]["AssetType"]);
            obj.AssetName = Convert.ToString(dt.Rows[row]["AssetName"]);
            obj.AssetSize = Convert.ToString(dt.Rows[row]["AssetSize"]);
            return obj;
        }

        #endregion
    }
}
