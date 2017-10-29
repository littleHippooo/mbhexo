---
title: Spring multipart上传下载
date: 2017-01-24 19:15:42
tags: [Spring]
---
加入依赖Apache Commons FileUpload：
```xml
<dependency>
    <groupId>commons-fileupload</groupId>
    <artifactId>commons-fileupload</artifactId>
    <version>1.3.1</version>
</dependency>
```
<!--more-->
maven tomcat设置URI编码为UTF-8：
```xml
<plugin>
    <groupId>org.apache.tomcat.maven</groupId>
    <artifactId>tomcat7-maven-plugin</artifactId>
    <version>2.1</version>
    <configuration>
        <uriEncoding>UTF-8</uriEncoding>
        <port>8080</port>
    </configuration>
</plugin> 
```
## multipart解析器
```xml
<bean id="multipartResolver" 
    class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
    <property name="defaultEncoding" value="utf-8"/>
    <!-- 单位为字节,这里为100MB -->
    <property name="maxUploadSize" value="104857600"/>
    <!-- 临时目录 -->
    <property name="uploadTempDir" value="/WEB-INF/temp"/>
</bean>
```
## form表单
```html
<form action='<s:url value="/upload"/>' method="post"
    enctype="multipart/form-data">  
    选择文件:<input type="file" name="upload">
            <input type="submit" value="提交">   
</form> 
```
## 处理multipart请求  
```java
@Controller
@RequestMapping("/")
public class FileUploadController {
    @RequestMapping(value="upload",method=RequestMethod.GET)
    public String upload() {
        return "upload";
    }
  
    @RequestMapping(value="upload",method=RequestMethod.POST)
    //@RequestPart("upload")对于input框的name属性
    public String processUpload(@RequestPart("upload") MultipartFile file,
        HttpServletRequest request,Model model) {
        try{
            if(file != null && !file.isEmpty()){
                // 保存的文件名未UUID+上传文件名，并且过滤文件名特殊字符
                String fileName = makeFileName(StringFilter(file.getOriginalFilename()));
                String filePath = request.getSession().getServletContext()
                                    .getRealPath("/") + "/WEB-INF/upload/" + fileName; 
                File uploadFile = new File(filePath);
                if(!uploadFile.exists()){
                    uploadFile.mkdirs();
                }
                // 转存文件  
                file.transferTo(uploadFile);  
                model.addAttribute("name",file.getOriginalFilename());
                return "result";
            }else{
                return "fail";
            }
        }catch(Exception e){
            e.printStackTrace();
            return "fail";
        }
    } 
    String makeFileName(String filename) {
        return UUID.randomUUID().toString() + "_" + filename;
    }
    
    String StringFilter(String str) throws PatternSyntaxException   {         
        String regEx = "[`~!@#$%^&*+=|{}':; ',//[//]<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]";
        Pattern p = Pattern.compile(regEx);
        Matcher m = p.matcher(str);
        return m.replaceAll("").trim();
    }
}
```
多文件上传的话，只需将MultipartFile file改为MultipartFile[] files，input标签加上multiple="multiple"即可。
## 处理下载
当文件上传成功后，页面跳转到result.jsp：
```html
<p>上传成功</p>
<a href="<s:url value='/download?fileName=${name }'/>">${name }</a>  
```
现处理下载请求：
```java
@RequestMapping(value="download")
  public void processDownload(String fileName,HttpServletResponse response,
    HttpServletRequest request) throws UnsupportedEncodingException{
    String realFileName = fileName.substring(fileName.indexOf("_") + 1);
    try {
        response.setCharacterEncoding("utf-8");
        response.setContentType("multipart/form-data");
        response.setHeader("Content-Disposition", "attachment;fileName="
                    + java.net.URLEncoder.encode(realFileName,"utf-8"));
        String filePath = request.getSession().getServletContext().getRealPath("/") 
                    + "WEB-INF/upload/" + fileName; 
        InputStream inputStream = new FileInputStream(new File(filePath));
        OutputStream os = response.getOutputStream();
        byte[] b = new byte[2048];
        int length;
        while ((length = inputStream.read(b)) > 0) {
            os.write(b, 0, length);
        }
        os.close();
        inputStream.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
}
```
## 异步处理
异步处理multipart可以使用[jQuery.form.js](http://malsup.github.io/jquery.form.js)插件来完成：
```javascript
$("#form_id").ajaxSubmit({
    url: "url.do",
    type: "post",
    dataType: "json",
    success: function(r){
        // your code here.
    }
});
```
form表单代码：
```html
<form enctype="multipart/form-data">  
    选择文件:<input type="file" name="upload">  
</form> 
```
后端代码不变。