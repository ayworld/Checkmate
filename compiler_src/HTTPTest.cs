using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;

namespace compiler
{
    public partial class HTTPTest
    {
        /// <summary>
        /// Boolean to tell if there's an internet connection or not
        /// </summary>
        public bool IsConnected
        {
            get;
            private set;
        }

        /// <summary>
        /// URL of whatever you wish to test a connection to
        /// Private - Only accessible to this class
        /// </summary>
        private string URL;

        public HTTPTest(String url = "")
        {
            this.URL = (url.Length == 0) ? "http://www.google.com" : url;
            testConnection();
        }

        private void testConnection()
        {
            string url = this.URL;
            HttpWebRequest hwrq = (HttpWebRequest)HttpWebRequest.Create(url);
            hwrq.Timeout = 1000;

            try
            {
                HttpWebResponse hwrp = (HttpWebResponse)hwrq.GetResponse();
                if (hwrp.StatusCode == HttpStatusCode.OK)
                    IsConnected = true;
            }
            catch
            {
                IsConnected = false;
            }
        }
    }
}
