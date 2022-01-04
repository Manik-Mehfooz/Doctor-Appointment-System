using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MedicalStore.Models
{
    [Table("BarCodeGenerate")]
    public class clsBarcode
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _BarcodeID;
        private int _ProductID;
        private string _FolderName;
        private string _BarcodeImageName;
        private DateTime _GenerateDate;
        private string _ModeType;
        private string _Search;

        #endregion

        #region Properties

        public int BarcodeID { get { return _BarcodeID; } set { _BarcodeID = value; } }
        //[Required, Display(Name = "Company")]
        public int ProductID { get { return _ProductID; } set { _ProductID = value; } }
        //[Required, Display(Name = "Product Type")]
        public string FolderName { get { return _FolderName; } set { _FolderName = value; } }
        public string BarcodeImageName { get { return _BarcodeImageName; } set { _BarcodeImageName = value; } }


        //[Required, Display(Name = "Product Name")]
        public DateTime GenerateDate { get { return _GenerateDate; } set { _GenerateDate = value; } }
        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }
        public string Search { get { return _Search; } set { _Search = value; } }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
               
                new SqlParameter("@ProductID",_ProductID),
                new SqlParameter("@FolderName",_FolderName),
                new SqlParameter("@BarcodeImageName",_BarcodeImageName),
                new SqlParameter("@GenerateDate",DateTime.Now),
                new SqlParameter("@ModeType", "INSERT")
            };
            return objconn.SqlCommParam(sqlParams, "sp_BarCodeGenerate");
        }

        public int UpdateMethod(clsProduct prod)
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@BarcodeID",_BarcodeID),
                new SqlParameter("@ProductID",prod.ProductID),
                new SqlParameter("@FolderName",_FolderName),
                new SqlParameter("@BarcodeImageName",_BarcodeImageName),
                new SqlParameter("@GenerateDate",_GenerateDate),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_BarCodeGenerate");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@BarcodeID",_BarcodeID),
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_BarCodeGenerate");
        }

        #endregion

        #region DDL Methods

        public clsBarcode GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@BarcodeID",_BarcodeID),
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_BarCodeGenerate");
            clsBarcode obj = new clsBarcode();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsBarcode AssignValues(clsBarcode obj, DataTable dt, int row)
        {
            obj.BarcodeID = Convert.ToInt32(dt.Rows[row]["BarcodeID"]);
            obj.ProductID = Convert.ToInt32(dt.Rows[row]["ProductID"]);
            obj.FolderName = Convert.ToString(dt.Rows[row]["FolderName"]);
            obj.BarcodeImageName = Convert.ToString(dt.Rows[row]["BarcodeImageName"]);
            obj.GenerateDate = Convert.ToDateTime(dt.Rows[row]["GenerateDate"]);
            return obj;
        }


        public List<clsBarcode> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@Search", _Search),
                new SqlParameter("@ModeType", "SEARCH"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_BarCodeGenerate");
            List<clsBarcode> list = new List<clsBarcode>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsBarcode obj = new clsBarcode();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        #endregion
    }
}