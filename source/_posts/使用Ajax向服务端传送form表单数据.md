---
title: 使用Ajax向服务端传送form表单数据
date: 2016-03-18 18:55:47
tags: ajax
---
今天在做附件Demo的时候，发现form表单的submit按钮会自动刷新页面，但在很多情况下，页面的刷新会很大程度影响体验。于是想到用Ajax来代替submit向服务端发送数据，网络上的说法是通过JQuery的`serialize()`方法序列化表单，但实验之后发现该方法只能传递一般的参数，上传的文件并不能被序列化传递到服务端。

继续查找资料发现可以使用formData方法来使用Ajax请求向服务端上传form表单附件：
HTML代码：
```html
<form action="http://localhost:8080/file/servlet/UploadHandleServlet"
	enctype="multipart/form-data" method="post" id="form">  
   <table border="1" >  
      <tr>  
         <td>用户名:</td>  
         <td><input type="text" name=userName/></td>  
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
```
<!--more-->  
JS代码：
```javascript
$("#submit").click(function(){  
    var formData = new FormData($("#form")[0]);
    $.ajax({  
        url:"http://localhost:8080/file/servlet/UploadHandleServlet",  
        type:"post",    
        data:formData,  
        async: false,    
        cache: false,    
        contentType: false,    
        processData: false,  
        success:function(){  
            // something to do... 
        }   
    });  
});  
```
