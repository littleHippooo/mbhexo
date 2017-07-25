---
title: Java OOP2
date: 2016-02-27 15:50:07
tags: Java
password: 465af3ec97365f9e17081f9ea40590e27472f946
---
## 访问控制修饰符：（修饰成员变量和方法）

1.public：公共的 -------- 任何类

2.protected：受保护的 --- 本类、同包类、子类 

3.默认：什么也不写 ------ 本类、同包类

4.private：私有的 ------- 本类

注意：类的访问控制只能是public和默认，public修饰的可以被任何一个类调用，默认访问控制的类只能被同一个包中的类使用。

## static关键字
**static修饰成员变量**（被static修饰的成员变量叫**静态变量**，没被其修饰的成员变量叫**实例变量**）。它所修饰的成员变量不属于对象的数据结构，而是属于类的变量，通常通过类名来引用static成员。

当创建对象后，成员变量是存储在堆中的，而static成员变量和类的信息一起存储在方法区，而不是在堆中，一个类的static成员变量只有“一份”（存储在方法区），无论该类创建了多少对象。

**static修饰方法**：由static修饰的方法叫**作静态方法**，常常通过类名点来进行访问，没有隐式的`this`传递。静态方法中不能直接访问实例成员。何时用？方法操作仅有参数相关而与对象无关。

**static修饰块**：`static{ }`属于类的代码块，在类被加载期间自动执行，只执行一次，可以用来在软件中加载静态资源（图像、音频等等）。
```java
package oo.day04_02;
public class StaticDemo {

    public static void main(String[] args) {
        Eoo o1=new Eoo();
        o1.show();
        Eoo o2=new Eoo();
        o2.show();
        System.out.println(Eoo.b); 
        System.out.println(o1.b);  
        
        Goo o3=new Goo(); //输出：静态块，构造方法
        Goo o4=new Goo(); //输出：构造方法
    }
}
class Goo{  //演示静态块
    static{ //加载类的时候被自动执行,静态块只执行一次
        System.out.println("静态块");
    }
    Goo(){
        System.out.println("构造方法");
    }
	
}
class Foo{ //演示静态方法
    int a;
    static int b;
    void show(){
        a++;
        b++;
    }
    static void say(){
        // a++; 编译错误，原因如下：
        b++;
    }
}
class Eoo{  //演示静态变量
    int a;   //实例变量，属于对象的，存在堆中，有几个对象有几份
    static int b;   //静态变量，属于类的，存在方法区，只有一份
    Eoo(){
        a++;
        b++;
    }
    void show(){
        System.out.println("a="+a);
        System.out.println("b="+b);
    }
}
```
## final
1.修饰变量：变量不可被改变。

2.修饰方法：方法不可被重写。

3.修饰类：类不可被继承。

```java
package oo.day04_02;
//final演示
public class FinalDemo {
    public static void main(String[] args) {	
    
    }
final class Koo{} //演示final修饰类
//class Loo extends Koo{} //编译错误，final的类不能被继承
class Moo{}
final class Noo extends Moo{} //

class Ioo{ //演示final修饰方法
    void say(){}
    final void show(){}
}
class Joo extends Ioo{
    void say(){}
    //void show(){} //编译错误，final修饰的show()不能被重写
}
class Hoo{ //演示final修饰变量
    final int a = 5; //1.声明同时初始化
    final int b;
    Hoo(){
        b = 8; //2.构造方法中初始化
    }
    void show(){
        final int c; //只要用之前初始化即可
        final int a=4;//正确，因为这里是局部变量，和上面的实例变量不一样
        //a = 55; //编译错误，不能被改变
    }
}
```
## static final常量
1.常量必须声明同时初始化。

2.由类名点来访问、不能被改变。

3.建议：所有字母都大写。

4.编译器在编译时被自动替换为具体的值，效率高。

## 抽象类和接口
**抽象类**：由abstract修饰的类。

1. 包含抽象方法的类必须是抽象类。不包含抽象方法的类也可以声明为抽象类---我愿意。

2. 抽象类不能被实例化。

3. 抽象类是需要被继承的，子类：

 - 重写父类的所有抽象方法。

 - 如果子类也声明为抽象类，就可以不用重写抽象方法。--但不建议。

4. 抽象类的意义：

 - 父类的意义：封装子类共有的数据和行为--代码的重用；为子类提供一种统一的类型--父类型。

 - 包含抽象方法，为所有子类提供了一个统一的入口

**接口**：是一个标准、规范--制定方，接口可以看成特殊的抽象类，即只包含抽象方法的抽象类。  

1. 由interface定义，只能包含常量和抽象方法。

2. 接口不能被实例化。

3. 接口需要被实现（implements）的，实现类：必须重写接口中的所有抽象方法。

4. 可以实现多个接口，用逗号分隔，若又继承，又实现时，先继承后实现。

5. 接口和接口间可以继承(extends)，一个接口可以继承多个接口；类和类之间继承(extneds)，一个子类只能继承一个父类，这是区别。

## 多态
同一类型的引用指向不同的对象时，有不同的实现-----行为的多态：
```java
人 p1 = new 理发师();  
人 p2 = new 外科医生();
人 p3 = new 演员();

p1.cut(); //剪发
p2.cut(); //开刀
p3.cut(); //停止表演

abstract class 人{
    abstract void cut();
}
class 理发师 extends 人{
    cut(){ 剪发 }
}
class 外科医生 extends 人{
    cut(){ 开刀 }
}
class 演员 extends 人{
    cut(){ 停止表演 }
}
```
同一个对象被造型为不同的类型时，有不同的功能-----对象的多态：
```java
我 me = new 我();
讲师       p1 = me;
孩子他妈   p2 = me;
老公的老婆 p3 = me;

me.讲课()/揍他()/咬他()/收工资();
p1.讲课();
p2.揍他();
p3.咬他()/收工资();

interface 讲师{
    讲课();
}
interface 孩子他妈{
    揍他();
}
interface 老公的老婆{
    咬他();
    收工资();
}
class 我 implemnets 讲师,孩子他妈,老公的老婆{
    讲师(){ }
    揍他(){ }
    咬他(){ }
    收工资(){ }
}
```
## 向上造型
1.父类型的引用指向子类的对象。

2.强制类型转换，成功的条件：

- 引用所指向的对象，就是该类型。

- 引用所指向的对象，实现了该接口。

3.强转之前建议先通过`instaceof`来判断引用指向的对象是否是某类型，强转成功的条件就是其为true的条件。

如：
```java
Aoo o1 = new Boo();     // 向上造型(自动类型转换)
Boo o2 = (Boo)o1;       // 引用指向的对象就是该类型
Inter1 o3 = (Inter1)o1; // 引用指向的对象实现了该接口
Coo o4 = (Coo)o1;       // 类型转换异常(ClassCastException)
if(o1 instanceof Coo){
    Coo o5 = (Coo)o1;
}

System.out.println(o1 instaceof Boo);    //true
System.out.println(o1 instaceof Inter1); //true
System.out.println(o1 instaceof Coo);    //false

interface Inter1{ }

class Aoo{ }

class Boo extends Aoo implements Inter1{ }

class Coo extends Aoo{ }
```
## 匿名内部类
想创建一个类的对象，并且对象只需创建一次，此时该类不必命名，称为匿名内部类。

匿名内部类中访问外部的数据，该数据必须是final的。
```java
public class foo{
    public static void main(String[] args) {
        //Inter2 o = new Inter2(); //编译错误
        
        //1.创建了Inter2的一个子类，但没有名字
        //2.创建了该子类的一个对象，叫o
        //3.大括号中的为该子类的类体
        Inter2 o = new Inter2(){
        };
        
        final int num = 5;
        Inter3 o3 = new Inter3(){
            public void show(){
                System.out.println("aaa");
                System.out.println(num);
            }
        };
        o3.show();	
	}
}
interface Inter3{
    void show();
}
interface Inter2{ }
```