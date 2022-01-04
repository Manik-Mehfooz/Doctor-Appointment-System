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
    public class clsBarcodeImage
    {
        clsConnection objconn = new clsConnection();

        private string _ProductID;
        private string _ProductName;
        private string _BarcodeImage;

        public string ProductID { get { return _ProductID; } set { _ProductID = value; } }
        public string ProductName { get { return _ProductName; } set { _ProductName = value; } }
        public string BarcodeImage { get { return _BarcodeImage; } set { _BarcodeImage = value; } }
        public int CompanyID { get; set; }
        public string Company { get; set; }

        public List<clsBarcodeImage> DisplayAllBarCodeImages()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                //new SqlParameter("@PurchaseID", _PurchaseID), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_BarCodeImage");
            List<clsBarcodeImage> list = new List<clsBarcodeImage>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsBarcodeImage obj = new clsBarcodeImage();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsBarcodeImage AssignValues(clsBarcodeImage obj, DataTable dt, int row)
        {
            obj.ProductID = Convert.ToString(dt.Rows[row]["ProductID"]);
            obj.ProductName = Convert.ToString(dt.Rows[row]["ProductName"]);
            obj.BarcodeImage = Convert.ToString(dt.Rows[row]["BarcodeImage"]);
            obj.CompanyID = Convert.ToInt32(dt.Rows[row]["CompanyID"]);
            obj.Company = Convert.ToString(dt.Rows[row]["Company"]);

            return obj;
        }

        public DataTable PrintBarCode()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ProductID", _ProductID), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_BarCodeImage");
           
            return dt;
        }

        public List<clsBarcodeImage> GetAllBarCodesForReport()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ProductID", _ProductID), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_BarCodeImage");
            List<clsBarcodeImage> list = new List<clsBarcodeImage>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsBarcodeImage obj = new clsBarcodeImage();
                obj = AssignValuesReport(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }
        protected clsBarcodeImage AssignValuesReport(clsBarcodeImage obj, DataTable dt, int row)
        {
            obj.ProductID = Convert.ToString(dt.Rows[row]["ProductID"]);
            obj.ProductName = Convert.ToString(dt.Rows[row]["ProductName"]);
            //obj.BarcodeImage = Convert.ToString(dt.Rows[row]["BarcodeImage"]);

            Uri p = new Uri(System.Web.HttpContext.Current.Request.Url.ToString());
            string domain = p.Host.ToString();
            string h = p.Scheme.ToString();
            string pa = h + "://" + domain + "/Barcodes/" + Convert.ToString(dt.Rows[row]["BarcodeImage"]);
            
            Zen.Barcode.Code128BarcodeDraw barcode = Zen.Barcode.BarcodeDrawFactory.Code128WithChecksum;
            var image = barcode.Draw(Convert.ToString(dt.Rows[row]["ProductID"]), 20);
            obj.BarcodeImage = image.ToString();


            //obj.BarcodeImage = "http://localhost:5439/Barcodes/Lorifect.png";//pa;
           

            return obj;
        }
    }
}