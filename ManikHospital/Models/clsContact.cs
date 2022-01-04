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
    [Table("Contact")]
    public class clsContact
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _ContactID;
        private int _ContactTypeID;
        private string _FirstName;
        private string _LastName;
        private string _Email;
        private string _Address;
        private string _Address2;
        private string _City;
        private string _Province;
        private string _Country;
        private string _UserName;
        private string _Password;
        private string _Telephone;
        private string _Mobile;
        private string _Website;
        private DateTime _EnteredDate;
        private string _EnteredBy;
        private string _UpdatedBy;
        private DateTime _UpdatedDate;
        private string _DeletedBy;
        private DateTime _DeletedDate;
        private int _IsDeleted;
        private string _Status;
        private int _DepartmentID;
        private string _ModeType;
        private string _Search;

        private string _Qualification;
        private string _Experience;
        private DateTime _JoiningDate;

        private string _ShowName;


        #endregion

        #region Properties

        public int ContactID { get { return _ContactID; } set { _ContactID = value; } }

        [Required(ErrorMessage = "Please Select Contact Type"), Display(Name = "Contact Type")]
        public int ContactTypeID { get { return _ContactTypeID; } set { _ContactTypeID = value; } }

        public string ContactType { get; set; }

        [Required(ErrorMessage="Please Enter First Name"), Display(Name = "First Name")]
        public string FirstName { get { return _FirstName; } set { _FirstName = value; } }

        [Required(ErrorMessage = "Please Enter Last Name"), Display(Name = "Last Name")]
        public string LastName { get { return _LastName; } set { _LastName = value; } }

        [EmailAddress(ErrorMessage = "Invalid Email Address")]
        public string Email { get { return _Email; } set { _Email = value; } }

        [Display(Name = "Address 1")]
        public string Address { get { return _Address; } set { _Address = value; } }

        [Display(Name = "Address 2")]
        public string Address2 { get { return _Address2; } set { _Address2 = value; } }

       
        public string City { get { return _City; } set { _City = value; } }

        
        public string Province { get { return _Province; } set { _Province = value; } }

        
        public string Country { get { return _Country; } set { _Country = value; } }

        [Required(ErrorMessage = "Please Enter User Name"), Display(Name = "User Name")]
        public string UserName { get { return _UserName; } set { _UserName = value; } }

        [Required(ErrorMessage = "Please Enter Password"), Display(Name = "Password")]
        public string Password { get { return _Password; } set { _Password = value; } }

        //[Required]
        public string Telephone { get { return _Telephone; } set { _Telephone = value; } }

        [Required(ErrorMessage = "Please Enter Mobile Number"), Phone(ErrorMessage = "Invalid Mobile Number")]
        [Display(Name = "Mobile No")]
        //[RegularExpression(@"^03\d{9}$", ErrorMessage = "Invalid Mobile Number")]
        public string Mobile { get { return _Mobile; } set { _Mobile = value; } }

        //[Required, Url(ErrorMessage = "Please enter a valid url")]
        public string Website { get { return _Website; } set { _Website = value; } }

        [Display(Name = "Qualification")]
        public string Qualification { get { return _Qualification; } set { _Qualification = value; } }
        [Display(Name = "Total Experience")]
        public string Experience { get { return _Experience; } set { _Experience = value; } }
        [Display(Name = "Joining Date")]
        public DateTime JoiningDate { get { return _JoiningDate; } set { _JoiningDate = value; } }

        [Display(Name = "Entered Date")]
        public DateTime EnteredDate { get { return _EnteredDate; } set { _EnteredDate = value; } }

        [Display(Name = "Entered By")]
        public string EnteredBy { get { return _EnteredBy; } set { _EnteredBy = value; } }

        [Display(Name = "Updated By")]
        public string UpdatedBy { get { return _UpdatedBy; } set { _UpdatedBy = value; } }

        [Display(Name = "Updated Date")]
        public DateTime UpdatedDate { get { return _UpdatedDate; } set { _UpdatedDate = value; } }

        [Display(Name = "Deleted By")]
        public string DeletedBy { get { return _DeletedBy; } set { _DeletedBy = value; } }

        [Display(Name = "Deleted Date")]
        public DateTime DeletedDate { get { return _DeletedDate; } set { _DeletedDate = value; } }

        [Display(Name = "Is Deleted")]
        public int IsDeleted { get { return _IsDeleted; } set { _IsDeleted = value; } }

        public string FullName { get; set; }

        [Display(Name="Department")]
        public int DepartmentID { get { return _DepartmentID; } set { _DepartmentID = value; } }

        //[Required]
        public string Status { get { return _Status; } set { _Status = value; } }
        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }
        public string Search { get { return _Search; } set { _Search = value; } }

        public string ShowName { get { return _ShowName; } set { _ShowName = value; } }
        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ContactTypeID",_ContactTypeID),
                new SqlParameter("@FirstName",_FirstName),
                new SqlParameter("@LastName",_LastName),
                new SqlParameter("@Email",_Email),
                new SqlParameter("@Address",_Address),
                new SqlParameter("@Address2",_Address2),
                new SqlParameter("@City",_City),
                new SqlParameter("@Province",_Province),
                new SqlParameter("@Country",_Country),
                new SqlParameter("@UserName",_UserName),
                new SqlParameter("@Password",_Password),
                new SqlParameter("@Telephone",_Telephone),
                new SqlParameter("@Mobile",_Mobile),
                new SqlParameter("@Website",_Website),
                new SqlParameter("@Qualification",_Qualification),
                new SqlParameter("@Experience",_Experience),
                new SqlParameter("@JoiningDate",_JoiningDate),
                new SqlParameter("@EnteredBy",_EnteredBy),
                new SqlParameter("@IsDeleted",_IsDeleted),
                new SqlParameter("@Status",_Status),
                new SqlParameter("@DepartmentID",_DepartmentID),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_Contact");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ContactID",_ContactID),
                new SqlParameter("@ContactTypeID",_ContactTypeID),
                new SqlParameter("@FirstName",_FirstName),
                new SqlParameter("@LastName",_LastName),
                new SqlParameter("@Email",_Email),
                new SqlParameter("@Address",_Address),
                new SqlParameter("@Address2",_Address2),
                new SqlParameter("@City",_City),
                new SqlParameter("@Province",_Province),
                new SqlParameter("@Country",_Country),
                new SqlParameter("@UserName",_UserName),
                new SqlParameter("@Password",_Password),
                new SqlParameter("@Telephone",_Telephone),
                new SqlParameter("@Mobile",_Mobile),
                new SqlParameter("@Website",_Website),
                new SqlParameter("@Qualification",_Qualification),
                new SqlParameter("@Experience",_Experience),
                new SqlParameter("@JoiningDate",_JoiningDate),
                new SqlParameter("@UpdatedBy",_UpdatedBy),
                new SqlParameter("@Status",_Status),
                new SqlParameter("@DepartmentID",_DepartmentID),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_Contact");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ContactID",_ContactID), 
                new SqlParameter("@DeletedBy",_DeletedBy),
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_Contact");
        }

        #endregion

        #region DDL Methods

        public clsContact GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@ContactID",_ContactID),  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Contact");
            clsContact obj = new clsContact();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsContact AssignValues(clsContact obj, DataTable dt, int row)
        {
            obj.ContactID = Convert.ToInt32(dt.Rows[row]["ContactID"]);
            obj.ContactType = Convert.ToString(dt.Rows[row]["ContactType"]);
            obj.ContactTypeID = Convert.ToInt32(dt.Rows[row]["ContactTypeID"]);
            obj.FirstName = Convert.ToString(dt.Rows[row]["FirstName"]);
            obj.LastName = Convert.ToString(dt.Rows[row]["LastName"]);
            obj.FullName = Convert.ToString(dt.Rows[row]["FirstName"]) + " " + Convert.ToString(dt.Rows[row]["LastName"]);
            obj.Email = Convert.ToString(dt.Rows[row]["Email"]);
            obj.Address = Convert.ToString(dt.Rows[row]["Address"]);
            obj.Address2 = Convert.ToString(dt.Rows[row]["Address2"]);
            obj.City = Convert.ToString(dt.Rows[row]["City"]);
            obj.Province = Convert.ToString(dt.Rows[row]["Province"]);
            obj.Country = Convert.ToString(dt.Rows[row]["Country"]);
            obj.UserName = Convert.ToString(dt.Rows[row]["UserName"]);
            obj.Password = Convert.ToString(dt.Rows[row]["Password"]);
            obj.Telephone = Convert.ToString(dt.Rows[row]["Telephone"]);
            obj.Mobile = Convert.ToString(dt.Rows[row]["Mobile"]);
            obj.Website = Convert.ToString(dt.Rows[row]["Website"]);
            obj.EnteredDate = Convert.ToDateTime(dt.Rows[row]["EnteredDate"]);
            obj.EnteredBy = Convert.ToString(dt.Rows[row]["EnteredBy"]);
            obj.UpdatedBy = Convert.ToString(dt.Rows[row]["UpdatedBy"]);
            obj.UpdatedDate = Convert.ToDateTime(dt.Rows[row]["UpdatedDate"]);
            obj.DeletedBy = Convert.ToString(dt.Rows[row]["DeletedBy"]);
            obj.DeletedDate = Convert.ToDateTime(dt.Rows[row]["DeletedDate"]);
            obj.IsDeleted = Convert.ToInt32(dt.Rows[row]["IsDeleted"]);
            obj.DepartmentID = Convert.ToInt32(dt.Rows[row]["DepartmentID"]);
            obj.Status = Convert.ToString(dt.Rows[row]["Status"]);

            obj.Qualification = Convert.ToString(dt.Rows[row]["Qualification"]);
            obj.Experience = Convert.ToString(dt.Rows[row]["Experience"]);
            obj.JoiningDate = Convert.ToDateTime(dt.Rows[row]["JoiningDate"]);

            return obj;
        }

        public List<clsContact> GetSearchData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@Search", _Search),
                new SqlParameter("@ModeType", "SEARCH"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Contact");
            List<clsContact> list = new List<clsContact>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsContact obj = new clsContact();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        public DataTable GetAuthentication()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@UserName", _UserName),
                new SqlParameter("@Password",_Password),
                new SqlParameter("@ModeType", "AUTHENTICATION"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Contact");
            return dt;
        }

        public int UpdatePwdMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]
            {
                new SqlParameter("@ContactID",_ContactID),
                new SqlParameter("@Password",_Password),
                new SqlParameter("@ModeType","UPDATEPWD"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_Contact");
        }

        public List<clsContact> GetAllEmployeeDataNotDoctor()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {                 
                new SqlParameter("@ModeType", "GetAllEmployeeNotDoctor"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Contact");
            List<clsContact> list = new List<clsContact>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsContact obj = new clsContact();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }

        #endregion
    }
}
