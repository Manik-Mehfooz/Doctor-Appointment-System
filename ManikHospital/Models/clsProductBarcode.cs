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
    [Table("OpeningStock")]
    public class clsProductBarcode
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _ID;        
        private int _ProductID;
        private string _Barcode;        

        #endregion

        #region Properties

        public int ID { get { return _ID; } set { _ID = value; } }

        [Required(ErrorMessage = "Please Select Product Name"), Display(Name = "Product Name")]
        public int ProductID { get { return _ProductID; } set { _ProductID = value; } }

        [Display(Name = "Barcode")]
        public string Barcode { get { return _Barcode; } set { _Barcode = value; } }
       

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ProductID",_ProductID),
                new SqlParameter("@Barcode",_Barcode),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_ProductBarcode");
        }


        #endregion

        #region DDL Methods


        #endregion
    }
}
