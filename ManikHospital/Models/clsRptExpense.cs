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
    [Table("sp_MonthlyExpensesReport")]
    public class clsRptExpense
    {
        clsConnection objconn = new clsConnection();

        #region Properties

        private string _ExpensesTypeID;
        private string _ExpensesType;
        private string _ExpenseID;
        private string _ExpenseDate;
        private decimal _Amount;
        private string _GivenBy;
        private string _GivenTo;
        private string _Remarks;
        private string _EnteredBy;

        private string _FromDate;
        private string _ToDate;

        public string ExpensesTypeID { get { return _ExpensesTypeID; } set { _ExpensesTypeID = value; } }
        public string ExpensesType { get { return _ExpensesType; } set { _ExpensesType = value; } }
        public string ExpenseID { get { return _ExpenseID; } set { _ExpenseID = value; } }
        public string ExpenseDate { get { return _ExpenseDate; } set { _ExpenseDate = value; } }
        public decimal Amount { get { return _Amount; } set { _Amount = value; } }
        public string GivenBy { get { return _GivenBy; } set { _GivenBy = value; } }
        public string GivenTo { get { return _GivenTo; } set { _GivenTo = value; } }
        public string Remarks { get { return _Remarks; } set { _Remarks = value; } }
        public string EnteredBy { get { return _EnteredBy; } set { _EnteredBy = value; } }
        public string FromDate { get { return _FromDate; } set { _FromDate = value; } }
        public string ToDate { get { return _ToDate; } set { _ToDate = value; } }
        

        #endregion

        public List<clsRptExpense> ExpensesReport()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
               new SqlParameter("@FromDate", _FromDate),
                new SqlParameter("@ToDate", _ToDate), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_MonthlyExpensesReport");
            List<clsRptExpense> list = new List<clsRptExpense>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsRptExpense obj = new clsRptExpense();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsRptExpense AssignValues(clsRptExpense obj, DataTable dt, int row)
        {
            obj.ExpensesType = Convert.ToString(dt.Rows[row]["ExpensesType"]);
            obj.ExpensesType = Convert.ToString(dt.Rows[row]["ExpensesType"]);
            obj.ExpenseID = Convert.ToString(dt.Rows[row]["ExpenseID"]);
            obj.ExpenseDate = Convert.ToString(dt.Rows[row]["ExpenseDate"]);
            obj.Amount = Convert.ToDecimal(dt.Rows[row]["Amount"]);
            obj.GivenBy = Convert.ToString(dt.Rows[row]["GivenBy"]);
            obj.GivenTo = Convert.ToString(dt.Rows[row]["GivenTo"]);
            obj.Remarks = Convert.ToString(dt.Rows[row]["Remarks"]);
            obj.EnteredBy = Convert.ToString(dt.Rows[row]["EnteredBy"]);

            return obj;
        }
    }
}