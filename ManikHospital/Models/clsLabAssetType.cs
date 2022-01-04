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
    [Table("LabAssetType")]
    public class clsLabAssetType
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _AssetTypeID;
        private string _AssetType;
        private string _AssetName;
        private string _AssetSize;
        private string _ModeType; 

        #endregion

        #region Properties

        public int AssetTypeID { get { return _AssetTypeID; } set { _AssetTypeID = value; } }
        [Required, Display(Name="Asset Type")]
        public string AssetType { get { return _AssetType; } set { _AssetType = value; } }
        [Display(Name = "Asset Name")]
        public string AssetName { get { return _AssetName; } set { _AssetName = value; } }
        [Display(Name = "Asset Size")]
        public string AssetSize { get { return _AssetSize; } set { _AssetSize = value; } }
        public string ModeType { get { return _ModeType; } set { _ModeType = value; } } 

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            { 
                new SqlParameter("@AssetType",_AssetType),
                new SqlParameter("@AssetName",_AssetName),
                new SqlParameter("@AssetSize",_AssetSize),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_LabAssetType");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@AssetTypeID",_AssetTypeID),
                new SqlParameter("@AssetType",_AssetType),
                new SqlParameter("@AssetName",_AssetName),
                new SqlParameter("@AssetSize",_AssetSize),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_LabAssetType");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@AssetTypeID",_AssetTypeID),
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_LabAssetType");
        }

        #endregion

        #region DDL Methods

        public bool CheckExitData(int id)
        {
            DataTable dt = new DataTable();
            if (id == 0)
            {
                SqlParameter[] sqlParams = new SqlParameter[]  
                {
                    new SqlParameter("@AssetType",_AssetType),
                    new SqlParameter("@AssetName",_AssetName),
                    new SqlParameter("@AssetSize",_AssetSize),  
                    new SqlParameter("@ModeType", "CHECK"), 
                };
                dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_LabAssetType");
            }
            else
            {
                SqlParameter[] sqlParams = new SqlParameter[]  
                {
                    new SqlParameter("@AssetTypeID",_AssetTypeID),
                    new SqlParameter("@AssetType",_AssetType),
                    new SqlParameter("@AssetName",_AssetName),
                    new SqlParameter("@AssetSize",_AssetSize),  
                    new SqlParameter("@ModeType", "CHECK"), 
                };
                dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_LabAssetType");
            }
            return !(dt.Rows.Count > 0);
        }

        public clsLabAssetType GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@AssetTypeID",_AssetTypeID),
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_LabAssetType");
            clsLabAssetType obj = new clsLabAssetType();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsLabAssetType AssignValues(clsLabAssetType obj, DataTable dt, int row)
        {
            obj.AssetTypeID = Convert.ToInt32(dt.Rows[row]["AssetTypeID"]);
            obj.AssetType = Convert.ToString(dt.Rows[row]["AssetType"]);
            obj.AssetName = Convert.ToString(dt.Rows[row]["AssetName"]) + " (" + dt.Rows[row]["AssetSize"].ToString()+")";
            obj.AssetSize = Convert.ToString(dt.Rows[row]["AssetSize"]);
            return obj;
        }

        public List<clsLabAssetType> GetAllData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {   
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_LabAssetType");
            List<clsLabAssetType> list = new List<clsLabAssetType>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsLabAssetType obj = new clsLabAssetType();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        #endregion
    }
}
