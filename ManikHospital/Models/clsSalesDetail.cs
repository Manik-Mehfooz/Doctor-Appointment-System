using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MedicalStore.Models
{
    [Table("SalesDetail")]
    public class clsSalesDetail
    {
        clsConnection objconn = new clsConnection();

        #region Private

        private int _SaleDetailID;
        private int _SaleID;
        private int _CompanyID;
        private int _ProductID;
        private int _Quantity;
        private decimal _Price;
        private int _Discount;
        private decimal _DiscountAmount;
        private int _SpecialDiscount;
        private decimal _SpecialDisAmount;
        private decimal _Total;
        private decimal _SubTotal;

        private string _Search;
        private string _ModeType;

        #endregion

        #region Public

        public decimal Total
        {
            get { return _Total; }
            set { _Total = value; }
        }

        public decimal SpecialDisAmount
        {
            get { return _SpecialDisAmount; }
            set { _SpecialDisAmount = value; }
        }

        public int SpecialDiscount
        {
            get { return _SpecialDiscount; }
            set { _SpecialDiscount = value; }
        }

        public decimal DiscountAmount
        {
            get { return _DiscountAmount; }
            set { _DiscountAmount = value; }
        }

        public int Discount
        {
            get { return _Discount; }
            set { _Discount = value; }
        }


        public decimal Price
        {
            get { return _Price; }
            set { _Price = value; }
        }

        public int Quantity
        {
            get { return _Quantity; }
            set { _Quantity = value; }
        }

        public int ProductID
        {
            get { return _ProductID; }
            set { _ProductID = value; }
        }

        public int CompanyID
        {
            get { return _CompanyID; }
            set { _CompanyID = value; }
        }

        public int SaleID
        {
            get { return _SaleID; }
            set { _SaleID = value; }
        }

        public int SaleDetailID
        {
            get { return _SaleDetailID; }
            set { _SaleDetailID = value; }
        }

        public decimal SubTotal
        {
            get { return _SubTotal; }
            set { _SubTotal = value; }
        }


        public string Search
        {
            get { return _Search; }
            set { _Search = value; }
        }

        public string ModeType
        {
            get { return _ModeType; }
            set { _ModeType = value; }
        }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@SaleID",_SaleID),
                new SqlParameter("@CompanyID",_CompanyID),
                new SqlParameter("@ProductID",_ProductID),
                new SqlParameter("@Quantity",_Quantity),
                new SqlParameter("@Price",_Price),
                new SqlParameter("@Discount",_Discount),
                new SqlParameter("@DiscountAmount",_DiscountAmount),
                new SqlParameter("@SpecialDiscount",_SpecialDiscount),
                new SqlParameter("@SpecialDisAmount",_SpecialDisAmount),
                new SqlParameter("@Total",_Total),

                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "SP_SalesDetail");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@SaleDetailID",_SaleDetailID),
                new SqlParameter("@SaleID",_SaleID),
                new SqlParameter("@CompanyID",_CompanyID),
                new SqlParameter("@ProductID",_ProductID),
                new SqlParameter("@Quantity",_Quantity),
                new SqlParameter("@Price",_Price),
                new SqlParameter("@Discount",_Discount),
                new SqlParameter("@DiscountAmount",_DiscountAmount),
                new SqlParameter("@SpecialDiscount",_SpecialDiscount),
                new SqlParameter("@SpecialDisAmount",_SpecialDisAmount),
                new SqlParameter("@Total",_Total),

                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "SP_SalesDetail");
        }

        public int UpdateMethodForQuantity()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@SaleDetailID",_SaleDetailID),
                new SqlParameter("@SaleID",_SaleID),
                new SqlParameter("@Quantity",_Quantity),
                new SqlParameter("@Total",_Total),

                new SqlParameter("@ModeType", "UPDATE_Quantity"), 
            };
            return objconn.SqlCommParam(sqlParams, "SP_SalesDetail");
        }

        public int UpdateSaleForReturnMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@SaleDetailID",_SaleDetailID),
                new SqlParameter("@Quantity",_Quantity),
                new SqlParameter("@Discount",_Discount),
                new SqlParameter("@ModeType", "SaleReturnByDetailID"), 
            };
            return objconn.SqlCommParam(sqlParams, "SP_SalesDetail");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@SaleDetailID",_SaleDetailID),  
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "SP_SalesDetail");
        }

        public int DeleteWithSaleID(int id)
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@SaleID",id),  
                new SqlParameter("@ModeType", "DELETE_WithSaleID"), 
            };
            return objconn.SqlCommParam(sqlParams, "SP_SalesDetail");
        }

        #endregion

        #region DDL Methods

        //public bool CheckExitData(int id)
        //{
        //    DataTable dt = new DataTable();
        //    if (id == 0)
        //    {
        //        SqlParameter[] sqlParams = new SqlParameter[]  
        //        {
        //            new SqlParameter("@Company",_Company),  
        //            new SqlParameter("@ModeType", "CHECK"), 
        //        };
        //        dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Company");
        //    }
        //    else
        //    {
        //        SqlParameter[] sqlParams = new SqlParameter[]  
        //        {
        //            new SqlParameter("@CompanyID",_CompanyID),
        //            new SqlParameter("@Company",_Company),  
        //            new SqlParameter("@ModeType", "CHECK"), 
        //        };
        //        dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Company");

        //    }
        //    return !(dt.Rows.Count > 0);
        //}

        public clsSalesDetail GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@SaleDetailID",_SaleDetailID),  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "SP_SalesDetail");
            clsSalesDetail obj = new clsSalesDetail();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        //public decimal GetSubTotal(int id)
        //{
        //    string connection = ConfigurationManager.ConnectionStrings["MedStoreDB"].ConnectionString;
        //    SqlConnection con = new SqlConnection(connection);
        //    SqlCommand cmd = new SqlCommand("SP_SalesDetail", con);
        //    cmd.CommandType = CommandType.StoredProcedure;
        //    cmd.Parameters.AddWithValue("@SaleID", id);
        //    cmd.Parameters.AddWithValue("@ModeType", "GET_SUB_TOTAL");

        //    decimal Result = 0;
        //    // cmd.Parameters.AddWithValue("@Result", 100);
        //    con.Open();
        //    SqlDataReader dr = cmd.ExecuteReader();
        //    while (dr.Read())
        //    {
        //        Result = Convert.ToDecimal(dr["SubTotal"]);
        //    }
        //    return Result;
        //}

        public decimal GetSubTotal(int id)
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@SaleID",id),  
                new SqlParameter("@ModeType", "GET_SUB_TOTAL"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "SP_SalesDetail");
            
            decimal Result = 0;
            if (dt.Rows.Count > 0)
            {
                Result = Convert.ToDecimal(dt.Rows[0]["SubTotal"].ToString());
            }
            return Result;
        }

        protected clsSalesDetail AssignValues(clsSalesDetail obj, DataTable dt, int row)
        {
            obj.SaleDetailID = Convert.ToInt32(dt.Rows[row][0]);
            obj.SaleID = Convert.ToInt32(dt.Rows[row][0]);
            obj.CompanyID = Convert.ToInt32(dt.Rows[row][1]);
            obj.ProductID = Convert.ToInt32(dt.Rows[row][1]);
            obj.Quantity = Convert.ToInt32(dt.Rows[row][1]);
            obj.Price = Convert.ToDecimal(dt.Rows[row][1]);
            obj.Discount = Convert.ToInt32(dt.Rows[row][1]);
            obj.DiscountAmount = Convert.ToDecimal(dt.Rows[row][1]);
            obj.SpecialDiscount = Convert.ToInt32(dt.Rows[row][1]);
            obj.SpecialDisAmount = Convert.ToDecimal(dt.Rows[row][1]);
            obj.Total = Convert.ToDecimal(dt.Rows[row][1]);
            return obj;
        }

        public List<clsSalesDetail> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@Search", _Search),
                new SqlParameter("@ModeType", "SEARCH"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "SP_SalesDetail");
            List<clsSalesDetail> list = new List<clsSalesDetail>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsSalesDetail obj = new clsSalesDetail();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        public decimal GetOPDDiscountBySaleID(int id)
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@SaleID",id),  
                new SqlParameter("@ModeType", "GET_Discount"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "SP_SalesDetail");

            decimal Result = 0;
            if (dt.Rows.Count > 0)
            {
                Result = Convert.ToDecimal(dt.Rows[0]["Discount"].ToString());
            }
            return Result;
        }

        #endregion

    }
}