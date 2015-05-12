using System;
using System.Collections.Generic;
using System.Data.SQLite;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NasdaqApi
{
    public class DAL:IDisposable
    {
        private DbHandler mDbHandler;
        private List<string> mFields;

        public DAL(string mConnectionString)
        {
            mDbHandler = new DbHandler(mConnectionString);
            mDbHandler.Connect();
            mFields = new List<string>() { "Stock_Name", "Time", "Volume" };
        }

        public void InsertStock(string name, DateTime time, double volume)
        {
            var values = new List<string> {name, time.ToString(), volume.ToString()};
            mDbHandler.Insert("Stocks", mFields, values);
        }

        public void InsertBulk(List<StockByMinute> stocks)
        {
            var values = new List<List<string>>();
            foreach (var stockByMinute in stocks)
            {
                List<string> singleValue = new List<string>();
                singleValue.Add(stockByMinute.StockName);
                singleValue.Add(stockByMinute.Time.ToString());
                singleValue.Add(stockByMinute.Volume.ToString());

                values.Add(singleValue);
            }

            mDbHandler.InsertWithTransaction("Stocks", mFields, values);
        }

        public List<StockByMinute> GetStockByRange(string stock, DateTime begin, DateTime end)
        {
            List<StockByMinute> stocks = new List<StockByMinute>();

            string commandStr = "Select Time, Volume From Stocks Where Stock_Name=? And Time Between ? And ?";
            var reader = mDbHandler.SelectStocks(commandStr,
                new List<string>() {stock, begin.ToString(), end.ToString()});

            while (reader.Read())
            {
                var time = reader[0];
                stocks.Add(new StockByMinute(stock, Convert.ToDateTime(reader[0]),
                    Convert.ToDouble(reader["Volume"])));
            }
            return stocks;
        }

        public void Dispose()
        {
            mDbHandler.Disconnect();
        }
    }
}
