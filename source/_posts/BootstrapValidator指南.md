---
title: BootstrapValidator指南
date: 2017-07-14 11:20:08
tags: Bootstrap
---
BootstrapValidator是一款基于jQuery的Bootstrap表单校验插件，提供了非常丰富的校验规则。
## 准备工作
要使用BootstrapValidator，需要先引入必要的文件：
```html
<link rel="stylesheet" type="text/css" href="bootstrap/css/bootstrap-3.0.3.min.css"/>
<link rel="stylesheet" type="text/css" href="bootstrap/css/bootstrapValidator-0.5.2.min.css"/>
<script type="text/javascript" src="js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="bootstrap/js/bootstrap-3.0.3.min.js"></script>
<script type="text/javascript" src="bootstrap/js/bootstrapValidator-0.5.2.min.js"></script>
```
其中需要注意的是jQuery版本必须大于1.9.1。文件下载地址：[click here](http://pan.baidu.com/s/1slJhf6d)
<!--more-->
需要校验的表单必须由`<form></form>`标签包裹，并且需要验证的字段由`<div class="form-group"></div>`包裹，并且有`name`属性。比如：
```html
<form>
    <div class="form-group">
        <label>labelName</label>
        <input type="text" class="form-control" name="fieldName"/>
    </div>
</form>
```
## 绑定校验规则
对`form`元素绑定校验规则：
```javascript
$("form").bootstrapValidator({
    // 生效规则
    // enabled:字段值发生变化就触发验证
    // disabled/submitted:点击提交时触发验证
    live: 'disabled',
    // 图标 
    feedbackIcons: {
        valid: 'glyphicon glyphicon-ok',
        valid: 'glyphicon glyphicon-remove', 
        validating: 'glyphicon glyphicon-refresh'
    },
    fields: {
        field1: { // 字段名
            validators: {
                // ...
            }
        },
        field2: {
            validators: {
                // ...
            }
        }
    }
});
```
下面具体介绍各种校验规则。
### 非空校验
非空校验是最常见的一种校验之一，比如对`name`属性为`userName`的字段进行非空校验：
```javascript
userName: { // name属性值
    validators: {
        notEmpty: { // 非空校验
            message: '用户名不能为空!'
        }
    }
},
```
### 文本长度校验
比如对`userName`的长度进行控制：
```javascript
userName: {
    validators: {
        stringLength: { // 长度校验
            min: 3,
            max: 10,
            message: '用户名长度%s~%s个字符！'
        }
    }
},
```
这里`userName`的长度被限制为3~10个字符（包含3和10）。`%s`分别表示3和10。
### 正则校验
BootstrapValidator支持正则表达式校验，比如：
```javascript
userName: {
    validators: {
        regexp: { //正则校验
            regexp: /^[a-zA-Z0-9_]+$/, 
            message:'用户名仅支数字，字母和下划线的组合'
        },
    }
},
```
### 远程校验
远程校验使用Ajax异步请求从服务端进行校验，比如校验`userName`的值是否已经存在。如：
```javascript
userName: {
    validators: {
        remote: {
            url: "user/confirmUserName.do",
            message: "用户名已存在",
            type: "get",
            data: function(){ // 额外的数据，默认为当前校验字段,不需要的话去掉即可
                return {
                    "name": $("input[name='userName']").val().trim()
                };
            }
        }
    }
},
```
假如`userName`字段填写的值为123，则参数格式为：`userName=123&name=123`，所以如果无需额外参数的话，`data`属性可以略去。

服务端：
```java
@RequestMapping("user/confirmUserName")
@ResponseBody
public Map<String,Boolean> confirmUserName(String name) {
    Map<String,Boolean> map = new HashMap<String, Boolean>();
    map.put("valid", true);
    // 模拟数据库中已经存在“Mike”
    if(name.equals("Mike")){
        // 设置校验不通过
        map.put("valid", false);
    }
    return map;
}
```
当`valid`为`true`的时候，表示Mike用户名可用；当`valid`为`false`的时候，表示Mike已被注册。
### 邮箱校验
BootstrapValidator提供了邮箱校验的方法，可以不用手动编写邮箱的正则表达式：
```javascript
email: {
    validators: {
        emailAddress: { // 可以不用自己写正则
            message: '邮箱格式不正确'
        }
    }
},
```
### 对比校验
对比校验就是指当前字段的值和别的字段的值相比较，产生校验结果。常用于密码字段，比如有如下`form`表单：
```html
<form>
    <div class="form-group">
        <label>请输入密码</label>
        <input type="text" class="form-control" name="password"/>
    </div>
    <div class="form-group">
        <label>请再次输入密码</label>
        <input type="text" class="form-control" name="confirmPassword"/>
    </div>
</form>
```
常用的校验规则如下：
```javascript
password: {
    validators: {
        notEmpty: {
            message: '请输入密码'
        },
        different: { // 比较是否不同，否的话校验不通过
            field: 'userName', // 和userName字段比较
            message: '密码不能与用户名相同！'	
        }
    }
},
confirmPassword: { 
    validators: {
        notEmpty: {
            message: '请再次确认密码！'
        },
        identical: { // 比较是否相同，否的话校验不通过
            field: 'password', // 和password字段比较
            message: '两次密码输入不一致'
        }
    }
},
```
### 复选框校验
复选框校验用于控制复选框的选中个数：
```html
<div class="form-group">
    <label>兴趣爱好</label>
    <div class="checkbox">
        <label>
            <input type="checkbox" name="hobbies" value="swimming" /> 游泳
        </label>
    </div>
    <div class="checkbox">
        <label>
            <input type="checkbox" name="hobbies" value="fitness" /> 健身
        </label>
    </div>
    <div class="checkbox">
        <label>
            <input type="checkbox" name="hobbies" value="football" /> 足球
        </label>
    </div>
    <div class="checkbox">
        <label>
            <input type="checkbox" name="hobbies" value="sleep" /> 睡觉
        </label>
    </div>
</div>
```
校验规则：
```javascript
hobbies: {
    validators: {
        choice: {
            min: 1,
            max: 3,
            message: '请选择1~3项兴趣爱好'
        }
    }
},
```
### 数字范围校验
数字范围校验类似与文本长度校验，不过其一般用于数字类型的长度校验，比如限制年龄范围为1~150：
```javascript
age: {
    validators: {
        between: {
            min: 0,
            max: 150,
            message: '请输入正常的年龄,范围为%s到%s',
        }
    }
},
```
除了使用`between`外，还可以使用`lessThan`和`greaterThan`来实现和`between`类似的效果：
```javascript
age: {
    validators: {
        lessThan: {
            value: 150,
            inclusive: true, // 是否包含150，true为包含
            message: '年龄必须小于等于%s'
        },
        greaterThan: {
            value: 0,
            inclusive: false, 不包含0
            message: '年龄必须大于%s'
        }
    }
},
```
### 文件校验
文件校验用于对上传的附件类型，大小等进行限制，常用的规则如下：
```javascript
files: {
    validators: {
        file:  {
            maxSize: 1024*1024, // 文件大小，单位为b，这里为1mb
            extension: 'jpg,png', // 格式
            type: 'image/jpeg,image/png', // 对应的MIME type
            message: '文件不合法，必须小于1MB，并且格式为jpg或png'
        }
    }
},
```
更详细的校验规则如下表所示：

  <table> 
    <tr> 
     <th>选项</th> 
     <th>HTML属性</th> 
     <th>类型</th> 
     <th>描述</th> 
    </tr> 
    <tr> 
     <td>extension</td> 
     <td>data-fv-file-extension</td> 
     <td>String</td> 
     <td>允许的扩展名，用逗号分隔</td> 
    </tr> 
    <tr> 
     <td>maxFiles</td> 
     <td>data-fv-file-maxfiles</td> 
     <td>Number</td> 
     <td>最大文件数</td> 
    </tr> 
    <tr> 
     <td>maxSize</td> 
     <td>data-fv-file-maxsize</td> 
     <td>Number</td> 
     <td>最大文件大小（以字节为单位）</td> 
    </tr> 
    <tr> 
     <td>maxTotalSize</td> 
     <td>data-fv-file-maxtotalsize</td> 
     <td>Number</td> 
     <td>所有文件的最大大小（以字节为单位）</td> 
    </tr> 
    <tr> 
     <td>minFiles</td> 
     <td>data-fv-file-minfiles</td> 
     <td>Number</td> 
     <td>文件的最小数量</td> 
    </tr> 
    <tr> 
     <td>minSize</td> 
     <td>data-fv-file-minsize</td> 
     <td>Number</td> 
     <td>最小文件大小（以字节为单位）</td> 
    </tr> 
    <tr> 
     <td>minTotalSize</td> 
     <td>data-fv-file-mintotalsize</td> 
     <td>Number</td> 
     <td>所有文件的最小大小（以字节为单位）</td> 
    </tr> 
    <tr> 
     <td>message</td> 
     <td>data-fv-file-message</td> 
     <td>String</td> 
     <td>错误消息</td> 
    </tr> 
    <tr> 
     <td>type</td> 
     <td>data-fv-file-type</td> 
     <td>String</td> 
     <td> 允许的**MIME**类型，以逗号分隔。例如：设置<br>image/jpeg,image/png,application/pdf只允许上传JPEG，PNG图像和PDF文档。</td> 
    </tr> 
  </table>
下表显示了常见的**MIME**类型。对于其他**MIME**类型，可以参考[https://www.sitepoint.com/mime-types-complete-list/](https://www.sitepoint.com/mime-types-complete-list/)。

  <table>  
    <tr> 
     <th>MIME类型</th> 
     <th>文件扩展名</th> 
    </tr> 
    <tr> 
     <td>application/msword</td> 
     <td>doc</td> 
    </tr> 
    <tr> 
     <td>application/pdf</td> 
     <td>pdf</td> 
    </tr> 
    <tr> 
     <td>application/rtf</td> 
     <td>rtf</td> 
    </tr> 
    <tr> 
     <td>application/vnd.ms-excel</td> 
     <td>xls</td> 
    </tr> 
    <tr> 
     <td>application/vnd.ms-powerpoint</td> 
     <td>ppt</td> 
    </tr> 
    <tr> 
     <td>application/x-rar-compressed</td> 
     <td>rar</td> 
    </tr> 
    <tr> 
     <td>application/x-shockwave-flash</td> 
     <td>swf</td> 
    </tr> 
    <tr> 
     <td>application/zip</td> 
     <td>zip</td> 
    </tr> 
    <tr> 
     <td>audio/midi</td> 
     <td>mid midi kar</td> 
    </tr> 
    <tr> 
     <td>audio/mpeg,audio/mp3</td> 
     <td>mp3</td> 
    </tr> 
    <tr> 
     <td>audio/ogg</td> 
     <td>ogg</td> 
    </tr> 
    <tr> 
     <td>audio/x-m4a</td> 
     <td>m4a</td> 
    </tr> 
    <tr> 
     <td>audio/x-realaudio</td> 
     <td>ra</td> 
    </tr> 
    <tr> 
     <td>image/gif</td> 
     <td>gif</td> 
    </tr> 
    <tr> 
     <td>image/jpeg</td> 
     <td>jpeg jpg</td> 
    </tr> 
    <tr> 
     <td>image/png</td> 
     <td>png</td> 
    </tr> 
    <tr> 
     <td>image/tiff</td> 
     <td>tif tiff</td> 
    </tr> 
    <tr> 
     <td>image/vnd.wap.wbmp</td> 
     <td>wbmp</td> 
    </tr> 
    <tr> 
     <td>image/x-icon</td> 
     <td>ico</td> 
    </tr> 
    <tr> 
     <td>image/x-jng</td> 
     <td>jng</td> 
    </tr> 
    <tr> 
     <td>image/x-ms-bmp</td> 
     <td>bmp</td> 
    </tr> 
    <tr> 
     <td>image/svg+xml</td> 
     <td>svg svgz</td> 
    </tr> 
    <tr> 
     <td>image/webp</td> 
     <td>webp</td> 
    </tr> 
    <tr> 
     <td>text/css</td> 
     <td>css</td> 
    </tr> 
    <tr> 
     <td>text/html</td> 
     <td>html htm shtml</td> 
    </tr> 
    <tr> 
     <td>text/plain</td> 
     <td>txt</td> 
    </tr> 
    <tr> 
     <td>text/xml</td> 
     <td>xml</td> 
    </tr> 
    <tr> 
     <td>video/3gpp</td> 
     <td>3gpp 3gp</td> 
    </tr> 
    <tr> 
     <td>video/mp4</td> 
     <td>mp4</td> 
    </tr> 
    <tr> 
     <td>video/mpeg</td> 
     <td>mpeg mpg</td> 
    </tr> 
    <tr> 
     <td>video/quicktime</td> 
     <td>mov</td> 
    </tr> 
    <tr> 
     <td>video/webm</td> 
     <td>webm</td> 
    </tr> 
    <tr> 
     <td>video/x-flv</td> 
     <td>flv</td> 
    </tr> 
    <tr> 
     <td>video/x-m4v</td> 
     <td>m4v</td> 
    </tr> 
    <tr> 
     <td>video/x-ms-wmv</td> 
     <td>wmv</td> 
    </tr> 
    <tr> 
     <td>video/x-msvideo</td> 
     <td>avi</td> 
    </tr> 
  </table>

### callback验证
callback用于校验验证码等类型，比如要实现下面这样的效果：

![578a01ef884cd58e02669a5ed868d593.png](https://www.tuchuang001.com/images/2017/07/14/578a01ef884cd58e02669a5ed868d593.png)

HTML代码：
```html
<div class="form-group">
    <label id="question"></label>
    <input type="text" class="form-control" name="answer" />
</div>
```
生成数学算式：
```javascript
function randomNumber(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
};
$('#question').html([randomNumber(1, 100), '+', randomNumber(1, 200), '='].join(' '));
```
校验规则：
```javascript
answer: {
    validators: {
        callback: {
            message: "答案不正确！",
            callback: function(value, validator){ // 验证答案是否正确，value为用户输入的值
                var items = $('#question').html().split(' ');
                var sum = parseInt(items[0]) + parseInt(items[2]);
                return value == sum;
            }
        }
    }
}
```
实际中，可以将上面的校验规则组合在一起，实现更复杂的校验。
## 常用事件
### 手动触发校验
手动触发校验包含触发单个字段和触发整个表单：
```javascript
// 整个表单
$("form").bootstrapValidator('validate');
// 单个字段
$("form").data('bootstrapValidator').validateField('fieldName');
```
### 获取当前表单校验结果
获取当前表单校验状态，校验通过返回true，否则返回false：
```javascript
var bootstrapValidators = $("form").data('bootstrapValidator');
if(bootstrapValidators.isValid()) {
    // todo
}
```
### 重置校验
```javascript
$('form').data('bootstrapValidator').resetForm(true); // 重置校验
$('form')[0].reset();// 表单清空
```