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
    public class clsErrorLog
    {
        clsConnection objconn = new clsConnection();

         private int _ErrorID;
         private string _ErrorDesc;

        public int ErrorID { get { return _ErrorID; } set { _ErrorID = value; } }
        public string ErrorDesc { get { return _ErrorDesc; } set { _ErrorDesc = value; } }

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ErrorDesc",_ErrorDesc),               
            };
            return objconn.SqlCommParam(sqlParams, "sp_ErrorLog");
        }
    }

    
}