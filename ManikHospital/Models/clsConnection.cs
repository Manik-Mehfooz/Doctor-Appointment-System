using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace MedicalStore.Models
{
    public class clsConnection
    {
        public SqlConnection MyConnection(SqlConnection strConnection)
        {
            strConnection.ConnectionString = ConfigurationManager.ConnectionStrings["MedStoreDB"].ConnectionString;
            strConnection.Open();
            return strConnection;
        }
        public int SqlCommParam(SqlParameter[] param, string SPName)
        {
            SqlConnection objSqlConnection = new SqlConnection();
            SqlCommand objSqlCommand = new SqlCommand();
            SqlParameter objSqlParameter = new SqlParameter();
            SqlDataAdapter objDataAdapter = new SqlDataAdapter();
            DataTable objDataTable = new DataTable();
            try
            {
                this.MyConnection(objSqlConnection);
                objSqlCommand = new SqlCommand(SPName, objSqlConnection);
                objSqlCommand.CommandTimeout = 900;
                objSqlCommand.CommandType = CommandType.StoredProcedure;

                foreach (object x in param)
                {
                    objSqlCommand.Parameters.Add(x);
                }
                int result = objSqlCommand.ExecuteNonQuery();
                objSqlConnection.Close();
                return result;
            }
            catch (Exception ex)
            {
                objSqlConnection.Close();
                return 0;
            }
            finally
            {
                objSqlConnection.Close();
            }
        }

        // Function thar returns the Data Table after executing a particular query
        public DataTable GetDataTable(string strSql)
        {

            // Declare Objects locally
            SqlConnection objSqlConnection = new SqlConnection();
            SqlCommand objSqlCommand = default(SqlCommand);
            DataTable objDataTable = new DataTable();
            SqlDataAdapter objSqlDataAdapter = default(SqlDataAdapter);

            try
            {
                this.MyConnection(objSqlConnection);
                objSqlCommand = new SqlCommand(strSql, objSqlConnection);
                objSqlCommand.CommandTimeout = 5000;
                objSqlDataAdapter = new SqlDataAdapter(objSqlCommand);
                objSqlDataAdapter.Fill(objDataTable);
                return objDataTable;
            }
            catch (Exception ex)
            {
                return null;
            }
            finally
            {

                objSqlConnection.Close();
            }

        }

        // Function thar returns the Data Reader after executing a particular query
        protected SqlDataReader GetDataReader(string strSql)
        {

            // Declare Objects locally
            SqlConnection objSqlConnection = new SqlConnection();
            SqlCommand objSqlCommand = default(SqlCommand);
            SqlDataReader objSqlDataReader = default(SqlDataReader);

            try
            {
                this.MyConnection(objSqlConnection);
                objSqlCommand = new SqlCommand(strSql, objSqlConnection);
                objSqlDataReader = objSqlCommand.ExecuteReader(CommandBehavior.CloseConnection);
            }
            catch (Exception ex)
            {
            }
            finally
            {
                objSqlConnection.Close();
                objSqlCommand.Dispose();
            }

            return objSqlDataReader;
        }

        public string GetScaler(string strSql)
        {

            // Declare Objects locally
            SqlConnection objSqlConnection = new SqlConnection();
            SqlCommand objSqlCommand = default(SqlCommand);
            string strReturned = null;

            try
            {
                this.MyConnection(objSqlConnection);
                objSqlCommand = new SqlCommand(strSql, objSqlConnection);
                strReturned = objSqlCommand.ExecuteScalar().ToString();
                objSqlConnection.Close();
            }
            catch (Exception ex)
            {

            }
            finally
            {
                objSqlConnection.Close();
            }

            return strReturned;
        }

        public DataTable SqlFillDataStoreProcedure(SqlParameter[] param, string SPName)
        {
            SqlConnection objSqlConnection = new SqlConnection();
            SqlCommand objSqlCommand = new SqlCommand();
            SqlParameter objSqlParameter = new SqlParameter();
            SqlDataAdapter objDataAdapter = new SqlDataAdapter();
            DataTable objDataTable = new DataTable();

            try
            {               
                this.MyConnection(objSqlConnection);
                objSqlCommand = new SqlCommand(SPName, objSqlConnection);
                objSqlCommand.CommandTimeout = 900;
                objSqlCommand.CommandType = CommandType.StoredProcedure;

                foreach (object x in param)
                {
                    objSqlCommand.Parameters.Add(x);
                }
                objDataAdapter.SelectCommand = objSqlCommand;
                objDataAdapter.Fill(objDataTable);
                objSqlConnection.Close();
                objSqlCommand.Parameters.Clear();
            }
            catch (Exception ex)
            {
                objSqlConnection.Close();
            }
            finally
            {
                objSqlConnection.Close();
            }
            return objDataTable;
        }

        // Procedure that executes particular query without returning any value
        public void ExecuteNonQuery(string strSql)
        {
            // Declare Objects locally
            SqlConnection objSqlConnection = new SqlConnection();
            SqlCommand objSqlCommand = default(SqlCommand);
            try
            {
                this.MyConnection(objSqlConnection);
                objSqlCommand = new SqlCommand(strSql, objSqlConnection);
                objSqlCommand.CommandTimeout = 5000;
                objSqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
            }
            finally
            {
                objSqlCommand.Dispose();
                objSqlConnection.Close();
            }

        }
    }
}
