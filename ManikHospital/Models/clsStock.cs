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

    public class clsStock
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _ProductID;
        private int _CompanyID;
        private string _ProductName;
        private string _Company;
        private string _PurchaseQuantity;
        private string _SaleQuantity;
        private string _StockQuantity;
        private string _OpeningStockQty;
        
        #endregion 

        #region Properties

        public int ProductID { get { return _ProductID; } set { _ProductID = value; } }
        public int CompanyID { get { return _CompanyID; } set { _CompanyID = value; } }
        public string ProductName { get { return _ProductName; } set { _ProductName = value; } }
        public string Company { get { return _Company; } set { _Company = value; } }
        public string PurchaseQuantity { get { return _PurchaseQuantity; } set { _PurchaseQuantity = value; } }
        public string SaleQuantity { get { return _SaleQuantity; } set { _SaleQuantity = value; } }
        public string StockQuantity { get { return _StockQuantity; } set { _StockQuantity = value; } }
        public string OpeningStockQty { get { return _OpeningStockQty; } set { _OpeningStockQty = value; } }
       


        #endregion
        

        #region DDL Methods       

        protected clsStock AssignValues(clsStock obj, DataTable dt, int row)
        {
            obj.ProductID = Convert.ToInt32(dt.Rows[row]["ProductID"]);            
            obj.ProductName = Convert.ToString(dt.Rows[row]["ProductName"]);
            obj.Company = Convert.ToString(dt.Rows[row]["Company"]);
            obj.PurchaseQuantity = Convert.ToString(dt.Rows[row]["PurchaseQuantity"]);
            obj.SaleQuantity = Convert.ToString(dt.Rows[row]["SaleQuantity"]);
            obj.StockQuantity = Convert.ToString(dt.Rows[row]["StockQuantity"]);
            obj.OpeningStockQty = Convert.ToString(dt.Rows[row]["OpeningStockQty"]);
            return obj;
        }

        public List<clsStock> GetAllProductStock()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {                  
                new SqlParameter("@CompanyID", _CompanyID), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_StockChecking");
            List<clsStock> list = new List<clsStock>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsStock obj = new clsStock();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }  
            return list;
        }

        #endregion
    }
}
