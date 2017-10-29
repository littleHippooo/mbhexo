---
title: 上传下载demo
date: 2016-04-01 09:19:17
tags: Java
---
附件上传下载的基本过程主要包含两个步骤：

1.通过IO流将附件上传/下载到对应的文件夹内；

2.将附件对应的信息（经过处理后的附件名，格式，大小等）保存到数据库。

下图是此次demo的效果图（默认用户id为1）：
<!--more-->

![72187635-file_1487994298797_5113.gif](img/72187635-file_1487994298797_5113.gif)

数据库附件表SYS_ANNEX：
```sql
 create table SYS_ANNEX  (
   ANNEX_ID             VARCHAR2(20)         not null, --附件id
   AREA_ID              NUMBER(5),                                  
   BUSI_TYPE_ID         NUMBER(5),           --业务类型id，这里我们默认为1
   ANNEX_KEY            VARCHAR2(20)         not null,   
   NAME                 VARCHAR2(100)        not null, --附件名
   USER_ID              NUMBER(12)           not null, --用户id，这里我们默认为1
   CREATE_DATE          DATE                 not null, --创建时间
   STATE_ID             NUMBER(5)            not null,
   STATE_DATE           DATE                 not null,
   constraint PK_SYS_ANNEX primary key (ANNEX_ID)
);
```
Session工具类，用来创建查询：
```java
public class SessionUtil {
    private static SessionFactory sf;
    static{
    	Configuration conf=new Configuration();
    	conf.configure("hibernate.cfg.xml");
    	sf=conf.buildSessionFactory();
    }
    public static Session getSession(){
    	return sf.openSession();
    }
    public static SessionFactory getSf(){
    	return sf;
    }
}
```
上传模块servlet：
```java
public class UploadHandleServlet extends HttpServlet {
  public void service(HttpServletRequest request, HttpServletResponse response)
  throws ServletException, IOException {
    // 得到上传文件的保存目录，将上传的文件存放于WEB-INF目录下，不允许外界直接访问，
    // 保证上传文件的安全
    String savePath = this.getServletContext().getRealPath("/WEB-INF/upload");
    // 上传时生成的临时文件保存目录
    String tempPath = this.getServletContext().getRealPath("/WEB-INF/temp");
    File tmpFile = new File(tempPath);
    if (!tmpFile.exists()) {
    	// 创建临时目录
    	tmpFile.mkdir();
    }
    // 消息提示
    String message = "";
    try {
        // 使用Apache文件上传组件处理文件上传步骤：
        // 1、创建一个DiskFileItemFactory工厂
        DiskFileItemFactory factory = new DiskFileItemFactory();
        // 设置工厂的缓冲区的大小，当上传的文件大小超过缓冲区的大小时，就会生成一个
        // 临时文件存放到指定的临时目录当中。设置缓冲区的大小为100KB，如果不指定，
        // 那么缓冲区的大小默认是10KB
        factory.setSizeThreshold(1024 * 100);
        // 设置上传时生成的临时文件的保存目录
        factory.setRepository(tmpFile);
        // 2、创建一个文件上传解析器
        ServletFileUpload upload=new ServletFileUpload(factory);
        // 解决上传文件名的中文乱码
        upload.setHeaderEncoding("UTF-8");
        // 3、判断提交上来的数据是否是上传表单的数据
        if (!ServletFileUpload.isMultipartContent(request)) {
        	// 按照传统方式获取数据
        	return;
        }
        // 设置上传单个文件的大小的最大值，目前是设置为1024*1024*100字节，
        // 也就是100MB
        upload.setFileSizeMax(1024 * 1024 * 100);
        // 设置上传文件总量的最大值，最大值=同时上传的多个文件的大小的
        // 最大值的和，目前设置为1000MB
        upload.setSizeMax(1024 * 1024 * 1000);
        // 4、使用ServletFileUpload解析器解析上传数据，解析结果返回的
        // 是一个List<FileItem>集合，每一个FileItem对应一个Form表单的
        // 输入项
        List<FileItem> list = upload.parseRequest(request);
        for (FileItem item : list) {
        	// 如果fileitem中封装的是普通输入项的数据
        	if (item.isFormField()) {
            	String name = item.getFieldName();
            	// 解决普通输入项的数据的中文乱码问题
            	String value = item.getString("UTF-8");					
            } else {// 如果fileitem中封装的是上传文件
            	// 得到上传的文件名称，
            	String filename = item.getName();
            	System.out.println(filename);
            	if (filename == null || 
            	filename.trim().equals("")) {
            		continue;
            	}
                // 注意：不同的浏览器提交的文件名是不一样的，有些浏览器提交上来的
                // 文件名是带有路径的，如： c:\a\b\1.txt，而有些只是单纯的文件名，
                // 如：1.txt，处理获取到的上传文件的文件名的路径部分，只保留文件
                // 名部分
                filename = filename.substring(filename.lastIndexOf("\\") + 1);
                // 得到上传文件的扩展名
                String fileExtName
                    = filename.substring(filename.lastIndexOf(".") + 1);
                // 如果需要限制上传的文件类型，那么可以通过文件的扩展名来判断上传的
                // 文件类型是否合法
                System.out.println( "上传的文件的扩展名是：" + fileExtName);
                // 获取item中的上传文件的输入流
                InputStream in = item.getInputStream();
                // 得到文件保存的名称
                String saveFilename = makeFileName(filename);
                // 得到文件的保存目录
                String realSavePath = savePath;
                // 创建一个文件输出流
                FileOutputStream out 
                    = new FileOutputStream(realSavePath+ "\\"+ saveFilename);
                // 创建一个缓冲区
                byte buffer[] = new byte[1024];
                // 判断输入流中的数据是否已经读完的标识
                int len = 0;
                // 循环将输入流读入到缓冲区当中，(len=in.read(buffer))>0就
                // 表示in里面还有数据
                while ((len = in.read(buffer)) > 0) {
                	// 使用FileOutputStream输出流将缓冲区的数据写入到指定的
                	// 目录(savePath + "\\"+ filename)中
                	out.write(buffer, 0, len);
                }
                // 关闭输入流
                in.close();
                // 关闭输出流
            	out.close(); 
            	// 删除处理文件上传时生成的临时文件 
            	item.delete();
            	message = "文件上传成功！";
            	// 文件上传成功后，将对应的信息保存到数据库SYS_ANNEX表
                Integer userId 
                        = Integer.valueOf(request.getParameter("userId"));
            	Date date = new Date(System.currentTimeMillis());
            	String annexId = System.currentTimeMillis() + "";
            	String annexKey = userId + "";
            	Session session = SessionUtil.getSession();
            	String sql = "insert INTO SYS_ANNEX VALUES(ANNEX_SEQ.nextval,";
                       sql+="1,1,?,?,?,sysdate,1,sysdate)";
            	SQLQuery query = session.createSQLQuery(sql);
            	query.setString(0, annexKey);
            	query.setString(1, saveFilename);
            	query.setInteger(2, userId);
            	Transaction ts = session.beginTransaction();
            	try {
                    query.executeUpdate();
                    ts.commit();
                    System.out.println("插入成功");
            	} catch (HibernateException e) {
                    e.printStackTrace();
                    ts.rollback();
                    System.out.println("插入失败");
            	} finally {
                    session.close();
            	}
             }
            }
        } catch (FileUploadBase
            .FileSizeLimitExceededException e) {
        	e.printStackTrace();
        	request.setAttribute(
        	    "message", "单个文件超出最大值！");
        	return;
        } catch (FileUploadBase.SizeLimitExceededException e) {
        	e.printStackTrace();
        	request.setAttribute(
        	    "message","上传文件的总大小超出限制的最大值！");
        	return;
        } catch (Exception e) {
        	message = "文件上传失败！";
        	e.printStackTrace();
        }
        request.setAttribute("message", message);
        }
    /**
     * @Method: makeFileName
     * @Description: 生成上传文件的文件名，文件名以：uuid+"_"+文件的原始名称
     * @param filename文件的原始名称
     * @return uuid+"_"+文件的原始名称
     */
  private String makeFileName(String filename) {
     // 为防止文件覆盖的现象发生，要为上传文件产生一个唯一的文件名
     return UUID.randomUUID().toString() + "_" + filename;
  }
 
}    
```
展示当前（用户id为1，业务类型id为1）的所有附件的servlet：
```java
public class ListFileServlet extends HttpServlet {
  public void service(HttpServletRequest request, HttpServletResponse response)
  throws ServletException, IOException {
        Integer userId = Integer.valueOf(request.getParameter("userId"));
        Integer busiTypeId 
                    = Integer.valueOf(request.getParameter("busiTypeId"));
        // 获取上传文件的目录
        String uploadFilePath = this.getServletContext()
                        .getRealPath("/WEB-INF/upload");
        // 存储要下载的文件名
        Map<String, String> fileNameMap = new HashMap<String, String>();
        // 递归遍历filepath目录下的所有文件和目录，将文件的文件名存储到map集合中
        listfile(new File(uploadFilePath),fileNameMap,userId,busiTypeId);
        // File既可以代表一个文件也可以代表一个目录
        Iterator<Map.Entry<String, String>> it
                        = fileNameMap.entrySet().iterator();
        while (it.hasNext()) {
          Map.Entry<String, String> entry = it.next();
        }
        // 将Map集合发送到listfile.jsp页面进行显示
        request.setAttribute("fileNameMap", fileNameMap);
        request.getRequestDispatcher("/listfile.jsp").forward(request, response);
  }
 
    /**
     * @Method: listfile
     * @Description: 递归遍历指定目录下的所有文件
     * @param file：即代表一个文件，也代表一个文件目录
     * @param map：存储文件名的Map集合
     */
  public void listfile(File file, Map<String, String> map,Integer userId,
    Integer busiTypeId){
        Session session = SessionUtil.getSession();
        String sql = "select name from SYS_ANNEX where user_id=?"
               sql += "and busi_type_id=?";
        SQLQuery query = session.createSQLQuery(sql);
        query.setInteger(0, userId);
        query.setInteger(1, busiTypeId);
        List<String> list = query.list();
        for (String fileName : list) {
 
       /**
        * 处理文件名，上传后的文件是以uuid_文件名的形式去重新命
        * 名的，去除文件名的uuid_部分file.getName().indexOf("_")
        * 检索字符串中第一次出现"_"字符的位置，如果文件名
        * 类似于：9349249849-88343-8344_多啦A梦.avi那么
        * file.getName().substring(file.getName().indexOf("_")+1)
        * 处理之后就可以得到多啦A梦.avi部分
        */
        String realName = fileName.substring(fileName.indexOf("_") + 1);
        // file.getName()得到的是文件的原始名称，这个名称是
        // 唯一的，因此可以作为key，realName是处理过后的名称，
        // 有可能会重复
        map.put(fileName, realName);
        }
        session.close();
   }
 
}       
```
下载servlet：
```java
public class DownLoadServlet extends HttpServlet {
  public void service(HttpServletRequest request, HttpServletResponse response)
  throws ServletException, IOException {
        // 得到要下载的文件名
        String fileName = request.getParameter("filename");
        // 上传的文件都是保存在/WEB-INF/upload目录下的子目录当中
        String fileSaveRootPath = this.getServletContext()
                                .getRealPath("/WEB-INF/upload");
        // 通过文件名找出文件的所在目录
        String path = fileSaveRootPath;
        // 得到要下载的文件
        File file = new File(path + "\\" + fileName);
        // 如果文件不存在
        if (!file.exists()) {
        	request.setAttribute("message", "您要下载的资源已被删除！");
        	return;
        }
        // 处理文件名
        String realname = fileName.substring(fileName.indexOf("_") + 1);
        // 设置响应头，控制浏览器下载该文件
        response.setHeader("content-disposition", "attachment;filename="
        	+ URLEncoder.encode(realname, "UTF-8"));
        // 读取要下载的文件，保存到文件输入流
        FileInputStream in = new FileInputStream(path + "\\" + fileName);
        // 创建输出流
        OutputStream out = response.getOutputStream();
        // 创建缓冲区
        byte buffer[] = new byte[1024];
        int len = 0;
        // 循环将输入流中的内容读取到缓冲区当中
        while ((len = in.read(buffer)) > 0) {
        	// 输出缓冲区的内容到浏览器，实现文件下载
        	out.write(buffer, 0, len);
        }
        // 关闭文件输入流
        in.close();
        // 关闭输出流
        out.close();
  }
}       
```
删除servlet：
```java
public class DeleteFileServlet extends HttpServlet{
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
        //获取文件名
        String fileName = request.getParameter("fileName");
        // 数据库删除记录
        Session session=SessionUtil.getSession();
        String sql="delete from SYS_ANNEX where name=?";
        SQLQuery query=session.createSQLQuery(sql);
        query.setString(0,fileName);
        Transaction ts=session.beginTransaction();
        try{
            query.executeUpdate();
            ts.commit();
        }catch(HibernateException e){
            e.printStackTrace();
            ts.rollback();
            return;
        }finally{
            session.close();
        }
 
        // 数据库成功删除记录后，再从硬盘里删除文件
        //上传的文件都是保存在/WEB-INF/upload目录下的子目录当中
        String fileSaveRootPath = this.getServletContext()
                                .getRealPath("/WEB-INF/upload");
        //通过文件名找出文件的所在目录
        String path = fileSaveRootPath;
        //得到要删除的文件
        File file = new File(path + "\\" + fileName);
        //删除文件
        file.delete();
 
	}
}
```
上传页面upload.jsp：
```html
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="c_rt" uri="http://java.sun.com/jstl/core_rt" %>
 <!DOCTYPE HTML>
 <html>
 <style>
    table{
        margin:auto;
    }
 </style>
  <head>
   <title>文件上传</title>
   <script type="text/javascript" src="js/jquery.min.js"></script>
   <script type="text/javascript">
        $(function(){
            //页面一加载调用onLoad()函数读取附件
            onLoad();		   
            $("#submit").click(function(){
            //将form表单附件格式化
            var formData = new FormData($("#form")[0]);
            var userId=$("#userId").val().trim();
            var location="http://localhost:8080/file/servlet/";
            location+="UploadHandleServlet?userId="+userId;
            $.ajax({
                //调用上传servlet
                url:location,
                type:"post",  
                data:formData,
                async: false,  
                cache: false,  
                contentType: false,  
                processData: false,
                success:function(){
                    //成功后清除上传附件模块内容
                    $("#file").empty();
                    AddMore();
                    //调用onLoad()函数，刷新
                    onLoad();
                } 
            });
        });
        //onLoad()函数调用listfileServlet,读取当前用户下的所有附件
        function onLoad(){
        $.ajax({
            url:"http://localhost:8080/file/listfile",
            type:"post",
            //模拟用户id为1，业务类型id为1
            data:{"userId":1,"busiTypeId":1},
            success:function(fileNameMap){
                //将读取到的fileMap展示出来
                $("#fileLoad").html(fileNameMap);
            }
        });
    }
});  
    </script>
    <script type="text/javascript">
    function AddMore(){
        var more = document.getElementById("file");
        var br = document.createElement("br");
        var input = document.createElement("input");
        var button = document.createElement("input");
       
        input.type = "file";
        input.name = "file";
        input.id="file";
       
        button.type = "button";
        button.value = "删除";
        
        more.appendChild(input);
        more.appendChild(button);
        more.appendChild(br);
           
        button.onclick = function(){
        more.removeChild(br);
        more.removeChild(input);
        more.removeChild(button);
    };
}
    </script>
  </head>
  <body >
  <form action="http://localhost:8080/file/servlet/UploadHandleServlet" 
        enctype="multipart/form-data" method="post" id="form">
    <table border="1" >
        <tr>
            <td>用户ID:</td>
            <td><input type="text" name="userId" 
                       id="userId" value="1"/></td>
        </tr>
        <tr>
            <td>附件:</td>
            <td id="file"></td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                <input type="button" value="增加附件" onclick="AddMore()">
                <input type="button" value="提交" id="submit">
            </td>           
        </tr>
        <tr>
            <td>附件下载:</td>
            <td id="fileLoad"></td>
        </tr>
    </table>    
   </form>
    <script type="text/javascript">
        AddMore();
    </script>
</body>
</html>
```
展示页面listfile.jsp，供ajax调用：
```html
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="c_rt" uri="http://java.sun.com/jstl/core_rt" %>
<!DOCTYPE HTML>
<html>
<style>
    #method {
        float:right;
        margin-right:2px;
    }
</style>
<script type="text/javascript">
    $(function(){
        //删除
        $(".delete").click(function(){
            var name=$(this).attr("name");
            var location="http://localhost:8080/file/servlet/DeleteFileServlet";
            $.ajax({			 
                url:location,
                type:"post", 
                data:{"fileName":name},
                success:function(){      			
                    onLoad();
                } 
            });			
        });
    function onLoad(){
        $.ajax({
            url:"http://localhost:8080/file/listfile",
            type:"post",
            data:{"userId":1,"busiTypeId":1},
            success:function(fileNameMap){
                $("#fileLoad").html(fileNameMap);
            }
        });
    }
});
 
</script>
<head>
    <title>下载文件页面，供ajax返回调用</title>
</head>
 
<body>
<!-- 遍历fileNameMap集合 -->
<c_rt:forEach var="me" items="${fileNameMap}">
    <c_rt:url value="/servlet/DownLoadServlet" var="downurl">
        <c_rt:param name="filename" value="${me.key}"></c_rt:param>
    </c_rt:url>
    <c_rt:url value="/servlet/DeleteFileServlet" var="deleteurl">
        <c_rt:param name="filename" value="${me.key}"></c_rt:param>
    </c_rt:url>
    ${me.value}
    <span id="method">
        <a href="${downurl}" id="downLoad">下载</a> 
        <a href="javascript:void(0)" class="delete" name="${me.key}">删除</a>
    </span><br/>
</c_rt:forEach>
</body>
</html>
```
剩下的只需在web.xml中配置这几个servlet，以及配置hibernate.cfg.xml即可﻿。

jar包：链接:[百度网盘](http://pan.baidu.com/share/init?shareid=2856097935&uk=20446062)   密码：q75g