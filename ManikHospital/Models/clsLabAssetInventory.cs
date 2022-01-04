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
    [Table("LabAssetInventory")]
    public class clsLabAssetInventory
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables


        private int _InventoryID;
        private int _AssetID;
        private int _StockIn;
        private int _StockOut;
        private decimal _StockQty;

        private string _ModeType;

        #endregion

        #region Properties

        public int InventoryID { get { return _InventoryID; } set { _InventoryID = value; } }
        public int AssetID { get { return _AssetID; } set { _AssetID = value; } }
        public string AssetName { get; set; }
        public string AssetType { get; set; }
        public string AssetSize { get; set; }
        public int StockIn { get { return _StockIn; } set { _StockIn = value; } }
        public int StockOut { get { return _StockOut; } set { _StockOut = value; } }
        public decimal StockQty { get { return _StockQty; } set { _StockQty = value; } }

        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }

        #endregion

        #region DDL Methods

        protected clsLabAssetInventory AssignValues(clsLabAssetInventory obj, DataTable dt, int row)
        {
            obj.InventoryID = Convert.ToInt32(dt.Rows[row]["InventoryID"]);            
            obj.AssetType = Convert.ToString(dt.Rows[row]["AssetType"]);
            obj.AssetName = Convert.ToString(dt.Rows[row]["AssetName"]);
            obj.AssetSize = Convert.ToString(dt.Rows[row]["AssetSize"]);
            obj.StockIn = Convert.ToInt32(dt.Rows[row]["StockIn"]);
            obj.StockOut = Convert.ToInt32(dt.Rows[row]["StockOut"]);
            obj.StockQty = Convert.ToDecimal(dt.Rows[row]["StockQty"]);
            return obj;
        }

        public List<clsLabAssetInventory> GetAllData()
        {
            DataTable dt = new DataTable();
            string strQuery = "";
            strQuery += @"select * from LabAssetInventory lai join LabAssetType lat on lat.AssetTypeID = lai.AssetTypeID ";

            dt = objconn.GetDataTable (strQuery);
            List<clsLabAssetInventory> list = new List<clsLabAssetInventory>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsLabAssetInventory obj = new clsLabAssetInventory();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        #endregion
    }
}
