using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;

namespace FeedBackDemo
{
    /// <summary>
    /// WebService1 的摘要说明
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // 若要允许使用 ASP.NET AJAX 从脚本中调用此 Web 服务，请取消注释以下行。 
    // [System.Web.Script.Services.ScriptService]
    public class WebService1 : System.Web.Services.WebService
    {
        [WebMethod]
        public bool feedbackInsertInfo(string txt,int starnum)
        {
            //连接SQL数据库
            System.Data.SqlClient.SqlConnection SqlCnn = new System.Data.SqlClient.SqlConnection("Data Source=JOHN;Initial Catalog=webservice;User ID=sa;Password=12345678;");
            //打开数据库连接
            SqlCnn.Open();
            string sqlstr = "insert into dbo.feedback (txtcontent,starnumber) values('" + txt + "','" + starnum +"')";
            System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand();
            cmd.Connection = SqlCnn;
            cmd.CommandType = System.Data.CommandType.Text;
            cmd.CommandText = sqlstr;
            //执行 
            cmd.ExecuteNonQuery();
            //关闭数据库
            SqlCnn.Close();
            return true;

        }


    }
}
