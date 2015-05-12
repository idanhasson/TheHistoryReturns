using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NasdaqApi
{
    public class StockByMinute
    {
        public string StockName { get; set; }
        public double Volume { get; set; }
        public DateTime Time { get; set; }

        public StockByMinute(string stockName, DateTime time, double volume)
        {
            StockName = stockName;
            Time = time;
            Volume = volume;
        }
    }
}
