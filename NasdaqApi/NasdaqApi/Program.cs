using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NasdaqApi
{
    class Program
    {
        // Date,Time,Price
        private static void CsvToDb(string connection, string csvPath, string stockName)
        {
            List<string> lines = File.ReadAllLines(csvPath).ToList();
            
            using (var dal = new DAL(connection))
            {
                List<StockByMinute> stocks = new List<StockByMinute>();
                foreach (var line in lines)
                {
                    var data = line.Split(',');
                    var time = DateTime.Parse(data[0] + " " + data[1], new CultureInfo("en-us"));
                    var volume = double.Parse(data[2]);
                    stocks.Add(new StockByMinute(stockName, time, volume));
                    Console.WriteLine(time);

                    //dal.InsertStock(stockName, time, double.Parse(data[2]));
                }

                dal.InsertBulk(stocks);
            }
        }

        static void Main(string[] args)
        {
            string connection = @"Data Source=C:\Users\עידן\Desktop\הקאתון\DB\StocksByMinutes.db;FailIfMissing=True;";
            string stockName = "IBM";
            string csvFile = @"C:\Users\עידן\Desktop\הקאתון\DB\IBM_unadjusted.txt";
            CsvToDb(connection, csvFile, stockName);
        }
    }
}
