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
    [Table("DoctorFee")]
    public class clsDoctorFee
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _FeeID;
        private int _FeeTypeID;
        private int _DoctorID;
        private decimal _Fees;
        private bool _IsActive;
        private string _ModeType;

        #endregion 

        #region Properties

        public int FeeID { get { return _FeeID; } set { _FeeID = value; } }

        [Required(ErrorMessage = "Please Select Field Type"), Display(Name ="Field Type")]
        public int FeeTypeID { get { return _FeeTypeID; } set { _FeeTypeID = value; } }

        [Required(ErrorMessage = "Please Select Doctor Name"), Display(Name = "Doctor Name")]
        public int DoctorID { get { return _DoctorID; } set { _DoctorID = value; } }

        [Required(ErrorMessage = "Please Enter Fee"), Display(Name = "Charges")]
        public decimal Fees { get { return _Fees; } set { _Fees = value; } }
        public bool IsActive { get { return _IsActive; } set { _IsActive = value; } }
        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }

        public string DoctorName { get; set; }
        public string FeeType { get; set; }


        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@FeeTypeID",_FeeTypeID),
                new SqlParameter("@DoctorID",_DoctorID),
                new SqlParameter("@Fees",_Fees),
                new SqlParameter("@IsActive",_IsActive),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_DoctorFee");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@FeeID",_FeeID),
                new SqlParameter("@FeeTypeID",_FeeTypeID),
                new SqlParameter("@DoctorID",_DoctorID),
                new SqlParameter("@Fees",_Fees),
                new SqlParameter("@IsActive",_IsActive),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_DoctorFee");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@FeeID",_FeeID),  
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_DoctorFee");
        }

        #endregion

        #region DDL Methods

        
        public clsDoctorFee GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@FeeID",_FeeID),  
                new SqlParameter("@ModeType", "GETDATA"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DoctorFee");
            clsDoctorFee obj = new clsDoctorFee();            
            if (dt.Rows.Count > 0)
            {
                obj = AssignValuesEdit(obj, dt, 0);
            }
            return obj;
        }
        public List<clsDoctorFee> GetAllData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ModeType", "GETDATA"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_DoctorFee");
            List<clsDoctorFee> list = new List<clsDoctorFee>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsDoctorFee obj = new clsDoctorFee();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsDoctorFee AssignValues(clsDoctorFee obj, DataTable dt, int row)
        {
            obj.FeeID = Convert.ToInt32(dt.Rows[row]["FeeID"]);
            obj.FeeTypeID = Convert.ToInt32(dt.Rows[row]["FeeTypeID"]);
            obj.DoctorID = Convert.ToInt32(dt.Rows[row]["DoctorID"]);
            obj.Fees = Convert.ToDecimal(dt.Rows[row]["Fees"]);
            obj.IsActive = Convert.ToBoolean(dt.Rows[row]["IsActive"]);
            obj.DoctorName = Convert.ToString(dt.Rows[row]["DoctorName"]);
            obj.FeeType = Convert.ToString(dt.Rows[row]["FeeType"]);
            return obj;
        }

        protected clsDoctorFee AssignValuesEdit(clsDoctorFee obj, DataTable dt, int row)
        {
            obj.FeeID = Convert.ToInt32(dt.Rows[row]["FeeID"]);
            obj.FeeTypeID = Convert.ToInt32(dt.Rows[row]["FeeTypeID"]);
            obj.DoctorID = Convert.ToInt32(dt.Rows[row]["DoctorID"]);
            obj.Fees = Convert.ToDecimal(dt.Rows[row]["Fees"]);
            obj.IsActive = Convert.ToBoolean(dt.Rows[row]["IsActive"]);
            return obj;
        }

       

        #endregion
    }
}
