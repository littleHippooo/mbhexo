title: jQuery工具函数
author: MrBird
tags: jQuery
date: 2017-05-10 15:27:00
---
## 数组和对象操作
### $.each()
用于遍历对象或数组：`jQuery.each(array,callback)`或`jQuery.each(object,callback)`。
例如，遍历数组：
```javascript
$.each([ 27, 41 ], function( index, value ) {
    console.log( index + ": " + value );
});
```
<!--more-->
遍历对象：
```javascript
var obj = {
    "name": "mrbird",
    "age": "24"
};
$.each( obj, function( key, value ) {
    console.log( key + ": " + value );
})
```
### $.extend()
将一个或多个对象的内容合并到第一个对象中。有两种构造函数：`jQuery.extend( target [, object1 ] [, objectN... ] )`和`jQuery.extend( [ deep ], target , object1 [, objectN... ] )`。如果多个对象具有相同的属性，则后者会覆盖前者的属性值。
<table>
        <tr>
            <th>
                参数
            </th>
            <th>
                描述
            </th>
        </tr>
        <tr>
            <td>
                deep
            </td>
            <td>
                <span class="notice">
                    可选Boolean类型
                </span>
                指示是否深度合并对象，默认为false，不能明写false。如果该值为true，且多个对象的某个同名属性也都是对象，则该"属性对象"的属性也将进行合并。
            </td>
        </tr>
        <tr>
            <td>
                target
            </td>
            <td>
                    Object类型目标对象，其他对象的成员属性将被复制到该对象上。
            </td>
        </tr>
        <tr>
            <td>
                object1
            </td>
            <td>
                    可选/Object类型第一个被合并的对象。
            </td>
        </tr>
        <tr>
            <td>
                objectN
            </td>
            <td>
                        可选/Object类型第N个被合并的对象。
            </td>
        </tr>
</table>
例如，合并两个对象，修改第一个对象：
```javascript
var object1 = {
  apple: 0,
  banana: { weight: 52, price: 100 },
  cherry: 97
};
var object2 = {
  banana: { price: 200 },
  durian: 100
};
$.extend( object1, object2 );
console.log(JSON.stringify( object1 )); 
// {"apple":0,"banana":{"price":200},"cherry":97,"durian":100}
```
递归合并两个对象，修改第一个对象：
```javascript
$.extend( true, object1, object2 );
// {"apple":0,"banana":{"weight":52,"price":200},"cherry":97,"durian":100}
```
### $.grep()
函数用于使用指定的函数过滤数组中的元素，并返回过滤后的数组。 源数组不会受到影响，过滤结果只反映在返回的结果数组中。语法如下：
```javascript
jQuery.grep( array, function [, invert ] )
```
<table>
        <tr>
            <th>
                参数
            </th>
            <th>
                描述
            </th>
        </tr>
        <tr>
            <td>
                array
            </td>
            <td>
                    Array类型
                将被过滤的数组。
            </td>
        </tr>
        <tr>
            <td>
                function
            </td>
            <td>
                    Function类型
                指定的过滤函数。
            </td>
        </tr>
        <tr>
            <td>
                invert
            </td>
            <td>
                    可选/Boolean类型
                默认值为
                    false
                。指定是否反转过滤结果。
            </td>
        </tr>
</table>
例如：
```javascript
$.grep( [ 0, 1, 2 ], function( n, i ) {
    return n > 0;
});
// [1, 2]
$.grep( [ 0, 1, 2 ], function( n, i ) {
    return n > 0;
},true);
// [0]
```
### $.makeArray()
将一个类数组对象转换为真正的数组对象。例如：
```javascript
var obj = { 0: "mrbird", 1: "blog", 2: true };
console.log(obj instanceof Array); // false
var arr = $.makeArray(obj);
console.log(arr instanceof Array); // true
```
### $.map()
用于处理数组中的每个元素(或对象的每个属性)，并将处理结果封装为新的数组返回。例如：

将数组中的每个值+4，并返回：
```javascript
var arr = $.map( [ 0, 1, 2 ], function( n ) {
    return n + 4;
});
console.log(arr); // [4, 5, 6]
```
数组中大于0的值+1，小于0的删除：
```javascript
var arr = $.map( [ -3, 0, 1, 5 ], function( n ) {
    return n > 0 ? n + 1 : null;
});
console.log(arr); // [2, 6]
```
将原始数组映射到新的数组，每个元素都加上其原始值和值加1：
```javascript
var arr = $.map( [ 0, 1, 2 ], function( n ) {
    return [ n, n + 1 ];
});
console.log(arr); // [ 0, 1, 1, 2, 2, 3 ]
```
将对象的键映射到数组：
```javascript
var obj = { width: 10, height: 15, length: 20 };
var keys = $.map( obj, function( value, key ) {
  return key;
});
console.log(obj); // [ "width", "height", "length" ]
```
### $.inArray()
用于在数组中搜索指定的值，并返回其索引值。如果数组中不存在该值，则返回 -1。
```javascript
var arr = [ 4, "Pete", 8, "John" ];
console.log($.inArray( "John", arr )); // 3
console.log($.inArray( 4, arr )); // 0
console.log($.inArray( "mrbird", arr )); // -1
```
### $merge()
将两个数组的内容合并到第一个数组中。例如：
```javascript
var arr = $.merge( [ 0, 1, 2 ], [ 2, 3, 4 ] )
console.log(arr); // [0, 1, 2, 2, 3, 4]
```
## 函数操作
### $.noop()
函数为一个空函数，什么也不做。其源码为：
```javascript
noop: function() {}
```
### $.proxy()
用于改变函数的上下文。你可以将指定函数传入该函数，该函数将返回一个新的函数，其执行代码不变，但函数内部的上下文`this`已经被更改为指定值。
例如：
```javascript
function test(){
    console.log(this); 
}
test(); // Window
 
var object = { name : "mrbird", age : 100 }
var proxy = $.proxy(test,object);
proxy(); // Object
```
## 测试操作
### $.contains()
用于判断指定元素内是否包含另一个元素。 简而言之，该函数用于判断另一个DOM元素是否是指定DOM元素的后代。
{% note danger %}`jQuery.contains()`仅用于比较两个DOM元素，不能用于比较nodeList或者jQuery对象。{% endnote %}
例如：
```html
<div id="n1">
    <p id="n2">
        <span id="n3">leanote</span>
    </p>
</div>
<p id="n4">mrbird's blog</p>
```
```javascript
var $n1 = $("#n1")[0];
var $n2 = $("#n2")[0];
var $n3 = $("#n3")[0];
var $n4 = $("#n4")[0];
 
console.log( $.contains( $n1, $n2 ) ); // true
console.log( $.contains( $n1, $n3 ) ); // true
console.log( $.contains( $n1, $n4 ) ); // false
```
### $.type()
用于确定JavaScript内置对象的类型，并返回小写形式的类型名称。JavaScript也自带有一个`typeof`运算符，可以确定数据的类型。不过对于绝大多数对象而言，`typeof`运算符都返回Object，无法区分具体的类型。`$.type()`可以更加精确地确定JS内置对象的类型。
```javascript
console.log( $.type( undefined ) ); // undefined
console.log( $.type( null ) ); // null
console.log( $.type( true ) ); // boolean
console.log( $.type( new Boolean(false) ) ); // boolean
console.log( $.type( 3 ) ); // number
console.log( $.type( new Number(3) ) ); // number
console.log( $.type( "test" ) ); // string
console.log( $.type( new String("test") ) ); // string
console.log( $.type( function(){} ) ); // function
console.log( $.type( new Function() ) ); // function
console.log( $.type( [] ) ); // array
console.log( $.type( new Array() ) ); // array
console.log( $.type( new Date() ) ); // date
console.log( $.type( new Error() ) ); // error
console.log( $.type( /test/ ) ); // regexp
console.log( $.type( new RegExp("\\d+") ) ); // regexp
 
/* 除上述类型的对象外，其他对象一律返回"object" */
console.log( $.type( {} ) ); // object
function User() { }
console.log( $.type( new User() ) ); // object
```
### $.isArray()
用于判断指定参数是否是一个数组。
### $.isFunction()
用于判断指定参数是否是一个函数。
### $.isEmptyObject()
用于判断指定参数是否是一个空对象。
```javascript
console.log( $.isEmptyObject( { } ) ); // true
console.log( $.isEmptyObject( new Object() ) ); // true
console.log( $.isEmptyObject( new Function() ) ); // true
```
### $.isPlainObject()
用于判断指定参数是否是一个纯粹的对象。 所谓“纯粹的对象”，就是该对象是通过`{}`或`new Object`创建的。
```javascript
console.log( $.isPlainObject( { } ) ); // true
console.log( $.isPlainObject( new Object() ) ); // true
console.log( $.isPlainObject( { name: "CodePlayer"} ) ); // true
console.log( $.isPlainObject( { sayHi: function(){} } ) ); // true
 
console.log( $.isPlainObject( new Function() ) ); // false
```
### $.isWindow()
判断当前对象是否为浏览器内置的Window对象。
```javascript
console.log( $.isWindow( this ) ); // true
console.log( $.isWindow( window ) ); // true
```
### $.isNumeric()
用于判断指定参数是否是一个数字值。
## 字符串操作
### $.trim()
该函数可以去除字符串开始和末尾两端的空白字符(直到遇到第一个非空白字符串为止)。它会清除包括换行符、空格、制表符等常见的空白字符。

如果参数str不是字符串类型，该函数将自动将其转为字符串（一般调用其`toString()`方法）。如果参数str为`null`或`undefined`，则返回空字符串。
## URL
### $.param()
用于将一个JS数组或纯粹的对象序列化为字符串值，以便用于URL查询字符串或AJAX请求。如果传入的不是数组或“纯粹的对象”，则返回空字符串；如果传入的是`null`、`undefined`等无法访问属性的值，则直接报错。

所谓“纯粹的对象”，就是通过`{}`或`new Object()`自行创建的对象。JS内置的`Boolean`、`Number`、`String`、`Date`、`RegExp`、`Function`、`Window`等类型的对象都不算是“纯粹的对象”。

返回的字符串已经过URL编码处理（采用的字符集为UTF-8）。看一些例子：
```javascript
// 字符串将被看作一个字符数组
console.log( $.param( "mrbird" )); // 0=m&1=r&2=b&3=i&4=r&5=d
console.log( $.param( { name:"mrbird", job:"Coder" } )); // name=mrbird&job=Coder
```
如果参数是一个数组Array，那么它的每个元素都必须是一个包含name属性和value属性的对象，其他属性不会被处理（value属性可以没有，默认其值为`undefined`，将被转换为空字符串）。例如：
```javascript
var array = [
    { name: "name", value: "mrbird" },
    { name: "age", value: 100, extra: "ignore" },
    { name: "grade" }
];
console.log( $.param( array )); // name=mrbird&age=100&grade=
```
## 编写插件
### $.error()
用于为每个匹配元素的`error`事件绑定处理函数。例如图片加载失败时，弹出框提醒：
```javascript
$("img").error( function(){
    alert( "图片加载失败!" );
} );
```
我们还可以为事件处理函数传递一些附加的数据，并用Event对象获取：
```javascript
var newImageURL = "../img/test.png";
 
$("img").error( newImageURL, function(event){
    this.src = event.data;
    console.log(event.data); // ../img/test.png
} );
```
### $.fn.jquery
用于返回当前jQuery库的版本号。
```javascript
console.log($.fn.jquery); // 1.11.1
```
或者使用任意jQuery对象的jquery属性访问：
```javascript
console.log($("body").jquery); // 1.11.1
```
> **参考网站**：</br>
http://www.365mini.com/</br>
http://jquery.com/</br>
http://caibaojian.com/jquery/</br>