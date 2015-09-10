using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Xml.Serialization;
using System.Data.SqlClient;
using System.Web.Script.Serialization;

namespace AFNetworkingJSON
{
    public partial class PiangAnTable : System.Web.UI.Page
    {
        public class ReadCardRecordClass
        {
            public DateTime CreateDate;
            public string StudentName;
            public string GradeName;
            public string ClassesName;
            public string InOut;

            public ReadCardRecordClass()
            {

            }
            public ReadCardRecordClass(DateTime CreateDate, string StudentName, string GradeName,
                string ClassesName, string InOut)
            {
                this.CreateDate = CreateDate;
                this.StudentName = StudentName;
                this.GradeName = GradeName;
                this.ClassesName = ClassesName;
                this.InOut = InOut;

            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            this.GetCardRecordList();
        
        }

        class PinAnJson
       {
            public IList result;
        }

        public void GetCardRecordList()
        {
            //连接SQL数据库
            SqlConnection SqlCnn = new SqlConnection("Data Source=192.168.20.5;Initial Catalog=RjtSchool;User ID=sa;Password=jsb@2015;");
            //打开数据库连接
            SqlCnn.Open();

            //加入SQL语句，实现数据库功能
            SqlDataAdapter SqlCardRecord = new SqlDataAdapter("select * from dbo.hx_tblCardRecord", SqlCnn);
            //创建缓存
            DataSet DSCardRecord = new DataSet();
            //将SQL语句放入缓存
            SqlCardRecord.Fill(DSCardRecord);
            //获取第一张表
            DataTable dt = DSCardRecord.Tables[0];

            SqlDataAdapter SqlGrade = new SqlDataAdapter("select * from dbo.hx_tblGrade", SqlCnn);
            DataSet DSGrade = new DataSet();
            //将SQL语句放入缓存
            SqlGrade.Fill(DSGrade);
            //获取第一张表
            DataTable dtGrade = DSGrade.Tables[0];

            SqlDataAdapter SqlClass = new SqlDataAdapter("select * from dbo.hx_tblClasses", SqlCnn);
            DataSet DSClass = new DataSet();
            //将SQL语句放入缓存
            SqlClass.Fill(DSClass);
            //获取第一张表
            DataTable dtClass = DSClass.Tables[0];

            PinAnJson pinAnJson = new PinAnJson();
            pinAnJson.result = new ArrayList();

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                int ID = (int)dt.Rows[i][0];
                DateTime CreateDate = (DateTime)dt.Rows[i][1];
                bool IsAvailable = (bool)dt.Rows[i][2];
                string StudentName = (string)dt.Rows[i][4];
                string Grade = (string)dt.Rows[i][6];
                int intGrade = Convert.ToInt32(Grade);
                string Classes = (string)dt.Rows[i][7];
                int intClasses = Convert.ToInt32(Classes);
                string GradeName = null;
                string ClassesName = null;
                string InOut = (string)dt.Rows[i][11];

                for (int j = 0; j < dtGrade.Rows.Count; j++)
                {
                    if (intGrade == (int)dtGrade.Rows[j][0])
                    {
                        GradeName = (string)dtGrade.Rows[j][6];
                    }
                }

                for (int j = 0; j < dtClass.Rows.Count; j++)
                {
                    if (intClasses == (int)dtClass.Rows[j][0])
                    {
                        ClassesName = (string)dtClass.Rows[j][7];
                    }
                }

                if (IsAvailable)
                {
                    pinAnJson.result.Add(new ReadCardRecordClass(CreateDate, StudentName,
                           GradeName, ClassesName, InOut));
                }
            }

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            var json = serializer.Serialize(pinAnJson);
            Context.Response.Write(json);
            Context.Response.End();
        }

    }
}