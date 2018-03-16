---
title: jQuery Validate表单校验插件
date: 2018-01-14 09:41:41
tags: [Bootstrap,jQuery]
---
jQuery Validate 插件为表单提供了强大的验证功能，让客户端表单验证变得更简单，同时提供了大量的定制选项，满足应用程序各种需求。该插件捆绑了一套有用的验证方法，包括 URL 和电子邮件验证，同时提供了一个用来编写用户自定义方法的 API。官网地址为：[https://jqueryvalidation.org/](https://jqueryvalidation.org/)。
<!--more-->
## 引入依赖
引入Bootstrap（jQuery Validate并不依赖于Bootstap，这里引入Bootstrap是为了用于构建表单）：
```html
<link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/4.0.0/css/bootstrap.min.css">
<!-- jQuery -->
<script src="http://ajax.aspnetcdn.com/ajax/jquery/jquery-2.0.0.min.js"></script>
<!-- popper -->
<script src="https://cdn.bootcss.com/popper.js/1.12.9/umd/popper.min.js"></script>
<!-- bootstrap -->
<script src="https://cdn.bootcss.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
```
引入jQuery Validate依赖：
```html
<!-- jquery-validate -->
<script src="https://cdn.bootcss.com/jquery-validate/1.17.0/jquery.validate.js"></script>
<script src="https://cdn.bootcss.com/jquery-validate/1.17.0/additional-methods.js"></script>
<script src="https://cdn.bootcss.com/jquery-validate/1.17.0/localization/messages_zh.js"></script>
```
jquery.validate.js为核心代码；additional-methods.js为扩展的校验方法，一般我们自定义的校验方法都放到这个文件里；messages_zh.js为中文汉化包。
## 默认校验规则
jquery.validate.js为我们提供了一系列的默认校验规则：
<table>
<tbody><tr>
	<th width="10%">序号</th>
	<th width="30%">规则</th>
    <th width="60%">描述</th>
</tr>
<tr>
	<td>1</td>
    <td>required:true</td>
	<td>必须输入的字段。</td>
</tr>
<tr>
	<td>2</td>
    <td>remote:"check.php"</td>
	<td>使用 ajax 方法调用 check.php 验证输入值。</td>
</tr>
<tr>
	<td>3</td>
    <td>email:true</td>
	<td>必须输入正确格式的电子邮件。</td>
</tr>
<tr>
	<td>4</td>
    <td>url:true</td>
	<td>必须输入正确格式的网址。</td>
</tr>
<tr>
	<td>5</td>
    <td>date:true</td>
	<td>必须输入正确格式的日期。日期校验 ie6 出错，慎用。</td>
</tr>
<tr>
	<td>6</td>
    <td>dateISO:true</td>
	<td>必须输入正确格式的日期（ISO），例如：2009-06-23，1998/01/22。只验证格式，不验证有效性。</td>
</tr>
<tr>
	<td>7</td>
    <td>number:true</td>
	<td>必须输入合法的数字（负数，小数）。</td>
</tr>
<tr>
	<td>8</td>
    <td>digits:true</td>
	<td>必须输入整数。</td>
</tr>
<tr>
	<td>9</td>
    <td>creditcard:</td>
	<td>必须输入合法的信用卡号。</td>
</tr>
<tr>
	<td>10</td>
    <td>equalTo:"#field"</td>
	<td>输入值必须和 #field 相同。</td>
</tr>
<tr>
	<td>11</td>
    <td>accept:</td>
	<td>输入拥有合法后缀名的字符串（上传文件的后缀）。</td>
</tr>
<tr>
	<td>12</td>
    <td>maxlength:5</td>
	<td>输入长度最多是 5 的字符串（汉字算一个字符）。当为checkbox时，指选中个数。</td>
</tr>
<tr>
	<td>13</td>
    <td>minlength:10</td>
	<td>输入长度最小是 10 的字符串（汉字算一个字符）。当为checkbox时，指选中个数。</td>
</tr>
<tr>
	<td>14</td>
    <td>rangelength:[5,10]</td>
	<td>输入长度必须介于 5 和 10 之间的字符串（汉字算一个字符）。当为checkbox时，指选中个数。</td>
</tr>
<tr>
	<td>15</td>
    <td>range:[5,10]</td>
	<td>输入值必须介于 5 和 10 之间。</td>
</tr>
<tr>
	<td>16</td>
    <td>max:5</td>
	<td>输入值不能大于 5。</td>
</tr>
<tr>
	<td>17</td>
    <td>min:10</td>
	<td>输入值不能小于 10。</td>
</tr>
</tbody></table>

默认的提示（messages_zh.js）：
```javascript
$.extend($.validator.messages, {
    required: "这是必填字段",
    remote: "请修正此字段",
    email: "请输入有效的电子邮件地址",
    url: "请输入有效的网址",
    date: "请输入有效的日期",
    dateISO: "请输入有效的日期 (YYYY-MM-DD)",
    number: "请输入有效的数字",
    digits: "只能输入数字",
    creditcard: "请输入有效的信用卡号码",
    equalTo: "你的输入不相同",
    extension: "请输入有效的后缀",
    maxlength: $.validator.format("最多可以输入 {0} 个字符"),
    minlength: $.validator.format("最少要输入 {0} 个字符"),
    rangelength: $.validator.format("请输入长度在 {0} 到 {1} 之间的字符串"),
    range: $.validator.format("请输入范围在 {0} 到 {1} 之间的数值"),
    max: $.validator.format("请输入不大于 {0} 的数值"),
    min: $.validator.format("请输入不小于 {0} 的数值")
});
```
## 自定义校验
除了使用自带的校验方法外，我们也可以添加自己的校验方法，比如添加手机号码格式的校验方法：
```javascript
jQuery.validator.addMethod("checkPhone", function(value, element, params) {
    var checkPhone = /^0?(13[0-9]|15[012356789]|17[013678]|18[0-9]|14[57])[0-9]{8}$/;
    return this.optional(element) || (checkPhone.test(value));
}, "请输入正确的手机号");
```
value值当前校验的值，element为校验的元素，params为校验参数。

自定义的校验方法一般都添加到additional-methods.js。
## 错误信息提示
当校验不通过时，默认错误信息会插入到校验元素的后面，但当校验元素是radio或者checkbox的时候，错误信息的位置需要进行调整：

![QQ截图20180315163346.png](img/QQ截图20180315163346.png)

调整方法：
```javascript
errorPlacement: function(error, element) { //指定错误信息位置
    if (element.is(':radio') || element.is(':checkbox')) { //如果是radio或checkbox
        var eid = element.attr('name'); //获取元素的name属性
        error.appendTo(element.parent().parent()); //将错误信息添加当前元素的父元素的父元素后面(根据实际html结构进行调整)
    } else {
        error.insertAfter(element);
    }
}
```
调整后：
![QQ截图20180315163539.png](img/QQ截图20180315163539.png)
## 后端校验
remote选项用于后端校验，比如校验用户名的唯一性等：
```javascript
remote: {
    url: "user/checkUserName",
    type: "get",
    dataType: "json",
    data: {
        username: function() {
            return $("input[name='username']").val();
        }
    }
}
```
后端返回boolean类型即可。
## 实例
编写个form表单：
```html
<form class="form">
    <div class="form-group">
        <label>用户名</label>
        <input type="text" class="form-control" name="userName" placeholder="用户名">
    </div>
    <div class="form-group">
        <label>密码</label>
        <input type="password" class="form-control" name="password" placeholder="密码">
    </div>
    <div class="form-group">
        <label>确认密码</label>
        <input type="password" class="form-control" name="confirm_password" placeholder="请再次输入密码">
    </div>
    <div class="form-group">
        <label>手机号</label>
        <input type="text" class="form-control" name="phone" placeholder="手机号">
    </div>
    <div class="form-group">
        <label>邮箱</label>
        <input type="text" class="form-control" name="email" placeholder="邮箱">
    </div>
    <div class="form-group">
        <label>地址</label>
        <select class="form-control" name="address">
            <option value="">- 请选择 -</option>
            <option value="1">福州</option>
            <option value="2">厦门</option>
            <option value="3">龙岩</option>
        </select>
    </div>
    <div class="form-group">
        <label>爱好</label>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="checkbox" name="hobby" value="1">
            <label class="form-check-label">游泳</label>
        </div>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="checkbox" name="hobby" value="2">
            <label class="form-check-label">唱歌</label>
        </div>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="checkbox" name="hobby" value="3">
            <label class="form-check-label">睡觉</label>
        </div>
    </div>
    <div class="form-group">
        <label>性别</label>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="sex" value="1">
            <label class="form-check-label">男</label>
        </div>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="sex" value="2">
            <label class="form-check-label">女</label>
        </div>
    </div>
    <div class="form-group">
        <label>上传图片</label>
        <input type="file" class="form-control-file" name="file">
    </div>
    <div class="form-group">
        <div class="form-check form-check-inline">
            <input type="checkbox" class="form-check-input" name="subscribe">
            <label class="form-check-label">订阅</label>
        </div>
    </div>
    <div class="form-group">
        <label>订阅方式</label>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="stype" value="1">
            <label class="form-check-label">RSS</label>
        </div>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="stype" value="2">
            <label class="form-check-label">邮箱订阅</label>
        </div>
    </div>
</form>
<button id="submit" class="btn btn-primary">Submit</button>
<button id="reset" class="btn btn-danger">Reset</button>
```
绑定校验规则等：
```javascript
jQuery.validator.addMethod("checkPhone", function(value, element, params) {
    var checkPhone = /^0?(13[0-9]|15[012356789]|17[013678]|18[0-9]|14[57])[0-9]{8}$/;
    return this.optional(element) || (checkPhone.test(value));
}, "请输入正确的手机号");

$(function() {
    validateRule();
    $("#submit").on('click', function() {
        var validator = $(".form").validate();
        var flag = validator.form();
        if (flag) {
            alert("true");
        } else {
            alert("false");
        }
    });
    $("#reset").on('click', function() {
        var validator = $(".form").validate();
        validator.resetForm();
    });
});

function validateRule() {
    $(".form").validate({
        rules: {
            userName: {
                required: true,
                minlength: 3,
                maxlength: 10
            },
            password: {
                required: true,
                minlength: 5
            },
            confirm_password: {
                required: true,
                minlength: 5,
                equalTo: "[name='password']"
            },
            address: {
                required: true
            },
            phone: {
                checkPhone: true
            },
            email: {
                required: true,
                email: true
            },
            hobby: {
                required: true,
                minlength: 2
            },
            sex: {
                required: true
            },
            file: {
                required: true,
                accept: "image/jpg,image/jpeg,image/png,image/gif"
            },
            stype: {
                required: "[name='subscribe']:checked"
            }
        },
        messages: {
            userName: {
                required: "请输入用户名",
                minlength: "用户名长度不能少于{0}个字符",
                maxlength: "用户名长度不能超过{0}个字符"
            },
            password: {
                required: "请输入密码",
                minlength: "密码长度不能小于{0}个字母"
            },
            confirm_password: {
                required: "请输入密码",
                minlength: "密码长度不能小于{0}个字母",
                equalTo: "两次密码输入不一致"
            },
            address: {
                required: "请选择地址"
            },
            email: {
                required: "请输入邮箱",
                email: "邮箱格式不正确"
            },
            hobby: {
                required: "请选择爱好",
                minlength: "至少选择{0}项爱好"
            },
            sex: {
                required: "请选择性别"
            },
            file: {
                required: "请上传附件",
                accept: "只支持jpg，jpeg，png或gif后缀的图片"
            },
            stype: {
                required: "请选择订阅方式"
            }
        },
        errorPlacement: function(error, element) {
            if (element.is(':radio') || element.is(':checkbox')) { 
                var eid = element.attr('name'); 
                error.appendTo(element.parent().parent());
            } else {
                error.insertAfter(element);
            }
        }
    });
}
```
这里提下关于附件的格式问题，其限定的不是文件格式后缀，而是文件的**MIME**类型，具体可参考：[BootstrapValidator指南](/BootstrapValidator指南.html)中列举的**MIME**类型。

演示效果如下：
<p data-height="938" data-theme-id="30192" data-slug-hash="oqxJmq" data-default-tab="result" data-user="mrbird" data-embed-version="2" data-pen-title="jquery-validation" class="codepen">See the Pen <a href="https://codepen.io/mrbird/pen/oqxJmq/">jquery-validation</a> by wuyouzhuguli (<a href="https://codepen.io/mrbird">@mrbird</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

源码地址：[https://drive.google.com/open?id=1lyUVNyX5VkxN3GqQz0_y_oBX3twMxPAh](https://drive.google.com/open?id=1lyUVNyX5VkxN3GqQz0_y_oBX3twMxPAh)

其他使用事项可参考：

1. [http://www.runoob.com/jquery/jquery-plugin-validate.html](http://www.runoob.com/jquery/jquery-plugin-validate.html)

2. [https://jqueryvalidation.org/documentation/](https://jqueryvalidation.org/documentation/)