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
    [Table("Rooms")]
    public class clsRoom
    {
        clsConnection objconn = new clsConnection();

        #region Private Variables

        private int _RoomID;
        private string _Room;
        private string _RoomType;
        private decimal _RoomCharges;
        private string _ModeType;

        #endregion

        #region Properties

        public int RoomID { get { return _RoomID; } set { _RoomID = value; } }
        public string Room { get { return _Room; } set { _Room = value; } }
        public string RoomType { get { return _RoomType; } set { _RoomType = value; } }
        public string RoomStatus { get; set; }
        public decimal RoomCharges { get { return _RoomCharges; } set { _RoomCharges = value; } }
        public string ModeType { get { return _ModeType; } set { _ModeType = value; } }

        #endregion

        #region DML methods

        public int SaveMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@Room",_Room),
                new SqlParameter("@RoomType",_RoomType),
                new SqlParameter("@RoomCharges",_RoomCharges),
                new SqlParameter("@ModeType", "INSERT"),
            };
            return objconn.SqlCommParam(sqlParams, "sp_Room");
        }

        public int UpdateMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@RoomID",_RoomID),
                new SqlParameter("@Room",_Room),
                new SqlParameter("@RoomType",_RoomType),
                new SqlParameter("@RoomCharges",_RoomCharges),
                new SqlParameter("@ModeType", "UPDATE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_Room");
        }

        public int DeleteMethod()
        {
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@RoomID",_RoomID), 
                new SqlParameter("@ModeType", "DELETE"), 
            };
            return objconn.SqlCommParam(sqlParams, "sp_Room");
        }

        #endregion

        #region DDL Methods

        public clsRoom GetAllDataByID()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {
                new SqlParameter("@RoomID",_RoomID),
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Room");
            clsRoom obj = new clsRoom();
            if (dt.Rows.Count > 0)
            {
                obj = AssignValues(obj, dt, 0);
            }
            return obj;
        }

        protected clsRoom AssignValues(clsRoom obj, DataTable dt, int row)
        {
            obj.RoomID = Convert.ToInt32(dt.Rows[row]["RoomID"]);
            obj.Room = Convert.ToString(dt.Rows[row]["Room"]);
            obj.RoomType = Convert.ToString(dt.Rows[row]["RoomType"]);
            obj.RoomStatus = Convert.ToString(dt.Rows[row]["RoomStatus"]);
            obj.RoomCharges = Convert.ToDecimal(dt.Rows[row]["RoomCharges"]);
            return obj;
        }

        public List<clsRoom> GetAllData()
        {
            DataTable dt = new DataTable();
            SqlParameter[] sqlParams = new SqlParameter[]  
            {  
                new SqlParameter("@ModeType", "GET"), 
            };
            dt = objconn.SqlFillDataStoreProcedure(sqlParams, "sp_Room");
            List<clsRoom> list = new List<clsRoom>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsRoom obj = new clsRoom();
                obj = AssignValues(obj, dt, i);
                list.Add(obj);
            }
            return list;
        }


        public List<clsRoom> GetRoomsForAlloted()
        {
            DataTable dt = new DataTable();
            string strQuery = "  SELECT r.RoomID,(r.RoomType +' '+r.Room ) as Room, rs.RoomStatus FROM Rooms r ";
            strQuery += " JOIN RoomStatus rs on rs.RoomID = r.RoomID ";
            strQuery += " UNION (select 0 as RoomID , 'SELECT' as RoomNo, 'Available' as RoomStatus)";
            dt = objconn.GetDataTable(strQuery);
            List<clsRoom> list = new List<clsRoom>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsRoom obj = new clsRoom();
                //obj = AssignValues(obj, dt, i);
                //list.Add(obj);
                obj.RoomID = Convert.ToInt32(dt.Rows[i]["RoomID"]);
                obj.Room = Convert.ToString(dt.Rows[i]["Room"]);
                obj.RoomStatus = Convert.ToString(dt.Rows[i]["RoomStatus"]);
                list.Add(obj);
            }
            return list;
        }

        public List<clsRoom> GetRoomsForAllotedByPatientID(int patientID)
        {
            DataTable dt = new DataTable();

            string strQuery = " SELECT r.RoomID,(r.RoomType +' '+r.Room ) as Room, rs.RoomStatus FROM Rooms r ";
            strQuery += " JOIN RoomStatus rs on rs.RoomID = r.RoomID ";
            strQuery += " where rs.RoomStatus = 'Available' or ";
            strQuery += " rs.RoomID in (select RoomID from PatientRegistration where PatientID = '" + patientID + "') ";
           // strQuery += " UNION (select 0 as RoomID , 'SELECT' as RoomNo, 'Available' as RoomStatus) ";
            dt = objconn.GetDataTable(strQuery);
            List<clsRoom> list = new List<clsRoom>();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                clsRoom obj = new clsRoom();
                //obj = AssignValues(obj, dt, i);
                //list.Add(obj);
                obj.RoomID = Convert.ToInt32(dt.Rows[i]["RoomID"]);
                obj.Room = Convert.ToString(dt.Rows[i]["Room"]);
                obj.RoomStatus = Convert.ToString(dt.Rows[i]["RoomStatus"]);
                list.Add(obj);
            }
            return list;
        }
        #endregion
    }
}
