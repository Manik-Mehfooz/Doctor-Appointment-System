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
    [Table("Expenses")]
    public class clsExpenses
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _ExpenseID;
        private int _ExpensesTypeID;
        private DateTime _ExpenseDate;
        private decimal _Amount;
        private string _GivenBy;
        private string _GivenTo;
        private string _Remarks;
        private string _EnteredBy;
        private DateTime _EnteredDate;
        private string _UpdatedBy;
        private DateTime _UpdatedDate;
        private string _DeletedBy;
        private DateTime _DeletedDate;
        private int _IsDeleted;
        private string _ModeType;
        private string _Search;

        #endregion

        #region Properties

        public int ExpenseID { get { return _ExpenseID; } set { _ExpenseID = value; } }
        
        [Required(ErrorMessage = "Please Select Expenses Type"),Display(Name="Expenses Type")]
        public int ExpensesTypeID { get { return _ExpensesTypeID; } set { _ExpensesTypeID = value; } }
        
        public string ExpensesType { get; set; }

        [Required(ErrorMessage = "Please Enter Date"), Display(Name = "Expense Date")]
        public DateTime ExpenseDate { get { return _ExpenseDate; } set { _ExpenseDate = value; } }

        [Required(ErrorMessage = "Please Enter Amount")]
        public decimal Amount { get { return _Amount; } set { _Amount = value; } }

        [Required(ErrorMessage = "Please Enter Full Name"), Display(Name = "Given By")]
        public string GivenBy { get { return _GivenBy; } set { _GivenBy = value; } }

        [Required(ErrorMessage = "Please Enter Full Name"), Display(Name = "Given To")]
        public string GivenTo { get { return _GivenTo; } set { _GivenTo = value; } }

        [Required(ErrorMessage = "Please Enter Description"), Display(Name = "Description")]
        public string Remarks { get { return _Remarks; } set { _Remarks = value; } }
        
        public DateTime EnteredDate { get { return _EnteredDate; } set { _EnteredDate = value; } }
        
        public string EnteredBy { get { return _EnteredBy; } set { _EnteredBy = value; } }
        
        public string UpdatedBy { get { return _UpdatedBy; } set { _UpdatedBy = value; } }
        
        public DateTime UpdatedDate { get { return _UpdatedDate; } set { _UpdatedDate = value; } }
        
        public string DeletedBy { get { return _DeletedBy; } set { _DeletedBy = value; } }
        
        public DateTime DeletedDate { get { return _DeletedDate; } set { _DeletedDate = value; } }
        
        public int IsDeleted { get { return _IsDeleted; } set { _IsDeleted = value; } }

        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }
        public string Search { get { return _Search; } set { _Search = value; } }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ExpensesTypeID",_ExpensesTypeID),
                new SqlParameter("@ExpenseDate",_ExpenseDate),
                new SqlParameter("@Amount",_Amount),
                new SqlParameter("@GivenBy",_GivenBy),
                new SqlParameter("@GivenTo",_GivenTo),
                new SqlParameter("@Remarks",_Remarks),
                new SqlParameter("@EnteredBy",_EnteredBy),
                new SqlParameter("@EnteredDate",_EnteredDate),
                new SqlParameter("@UpdatedBy",_UpdatedBy),
                new SqlParameter("@UpdatedDate",_UpdatedDate),
                new SqlParameter("@DeletedBy",_DeletedBy),
                new SqlParameter("@DeletedDate",_DeletedDate),
                new SqlParameter("@IsDeleted",_IsDeleted),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_Expenses");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ExpenseID",_ExpenseID),
                new SqlParameter("@ExpensesTypeID",_ExpensesTypeID),
                new SqlParameter("@ExpenseDate",_ExpenseDate),
                new SqlParameter("@Amount",_Amount),
                new SqlParameter("@GivenBy",_GivenBy),
                new SqlParameter("@GivenTo",_GivenTo),
                new SqlParameter("@Remarks",_Remarks),
                new SqlParameter("@EnteredBy",_EnteredBy),
                new SqlParameter("@EnteredDate",_EnteredDate),
                new SqlParameter("@UpdatedBy",_UpdatedBy),
                new SqlParameter("@UpdatedDate",_UpdatedDate),
                new SqlParameter("@DeletedBy",_DeletedBy),
                new SqlParameter("@DeletedDate",_DeletedDate),
                new SqlParameter("@IsDeleted",_IsDeleted),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_Expenses");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ExpenseID",_ExpenseID),
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_Expenses");
        }

        #endregion

        #region DDL Methods

        public clsExpenses GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ExpenseID",_ExpenseID),
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Expenses");
            clsExpenses obj = new clsExpenses();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsExpenses AssignValues(clsExpenses obj, DataTable dt, int row)
        {
            obj.ExpenseID = Convert.ToInt32(dt.Rows[row]["ExpenseID"]);
            obj.ExpensesTypeID = Convert.ToInt32(dt.Rows[row]["ExpensesTypeID"]);
            obj.ExpensesType = Convert.ToString(dt.Rows[row]["ExpensesType"]);
            obj.ExpenseDate = Convert.ToDateTime(dt.Rows[row]["ExpenseDate"]);
            obj.Amount = Convert.ToDecimal(dt.Rows[row]["Amount"]);
            obj.GivenBy = Convert.ToString(dt.Rows[row]["GivenBy"]);
            obj.GivenTo = Convert.ToString(dt.Rows[row]["GivenTo"]);
            obj.Remarks = Convert.ToString(dt.Rows[row]["Remarks"]);
            obj.EnteredBy = Convert.ToString(dt.Rows[row]["EnteredBy"]);
            obj.EnteredDate = Convert.ToDateTime(dt.Rows[row]["EnteredDate"]);
            obj.UpdatedBy = Convert.ToString(dt.Rows[row]["UpdatedBy"]);
            obj.UpdatedDate = Convert.ToDateTime(dt.Rows[row]["UpdatedDate"]);
            obj.DeletedBy = Convert.ToString(dt.Rows[row]["DeletedBy"]);
            obj.DeletedDate = Convert.ToDateTime(dt.Rows[row]["DeletedDate"]);
            obj.IsDeleted = Convert.ToInt32(dt.Rows[row]["IsDeleted"]);
            return obj;
        }

        public List<clsExpenses> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@Search", _Search),
                new SqlParameter("@ModeType", "SEARCH"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Expenses");
            List<clsExpenses> list = new List<clsExpenses>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsExpenses obj = new clsExpenses();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        #endregion
    }
}
