using System;
using System.Collections.Generic;
using System.Data.SQLite;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NasdaqApi
{
    public class DbHandler
    {
        private SQLiteConnection mDbConnection;

        public DbHandler(string connectionString)
        {
            mDbConnection = new SQLiteConnection(connectionString);
        }

        public void Insert(string table, List<string> fields, List<string> values)
        {
            string paramsString = string.Empty;
            for (var i = 0; i < values.Count; i++)
            {
                paramsString += "?";
                if (i != values.Count - 1)
                {
                    paramsString += ",";
                }
            }

            string command = string.Format("INSERT INTO {0} ({1}) VALUES ({2})", table, string.Join(",", fields),
                paramsString);

            using (SQLiteCommand insertSQL = new SQLiteCommand(command, mDbConnection))
            {
                foreach (var value in values)
                {
                    var param = new SQLiteParameter();
                    param.Value = value;
                    insertSQL.Parameters.Add(param);
                }
                try
                {
                    insertSQL.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    throw new Exception("Error in inserting the data", ex);
                }
            }
        }

        public void InsertWithTransaction(string table, List<string> fields, List<List<string>> values)
        {
            string paramsString = string.Empty;
            for (var i = 0; i < fields.Count; i++)
            {
                paramsString += "?";
                if (i != fields.Count - 1)
                {
                    paramsString += ",";
                }
            }

            using (SQLiteCommand insertSQL = new SQLiteCommand(mDbConnection))
            {
                using (var transaction = mDbConnection.BeginTransaction())
                {
                    
                    insertSQL.CommandText = string.Format("INSERT INTO {0} ({1}) VALUES ({2})", table,
                        string.Join(",", fields), paramsString);

                    foreach (var value in values)
                    {
                        foreach (var insertValue in value)
                        {
                            var param = new SQLiteParameter();
                            param.Value = insertValue;
                            insertSQL.Parameters.Add(param); 
                        }

                        insertSQL.ExecuteNonQuery();
                        insertSQL.Parameters.Clear();
                    }

                    transaction.Commit();
                }
            }
        }

        public SQLiteDataReader SelectStocks(string command, List<string> parameters)
        {
            SQLiteCommand selectSql = new SQLiteCommand(command, mDbConnection);
            foreach (var parameter in parameters)
            {
                var param = new SQLiteParameter();
                param.Value = parameter;
                selectSql.Parameters.Add(param);
            }
            return selectSql.ExecuteReader();
        }

        public void Connect()
        {
            mDbConnection.Open();
        }

        public void Disconnect()
        {
            mDbConnection.Close();
        }
    }
}
