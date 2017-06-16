---
title: dom4j解析和生成xml文件
date: 2016-08-29 19:23:44
tags: [Java,xml]
---
解析xml大致步骤：   

1: 创建SAXReader；

2: 使用SAXReader解析指定的xml文档信息，并返回对应Document对象。Document对象中就包含了该xml文中的所有信息以及结构了。
     
3: 根据文档结构将xml描述的树状信息读取到 。

<!--more-->
现有emp.xml文件，内容如下：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<list>
  <emp id="1">
    <name>提利昂·兰尼斯特</name>
    <age>25</age>
    <gender>男</gender>
    <salary>5000</salary>
  </emp>
  <emp id="2">
    <name>卡丽熙</name>
    <age>27</age>
    <gender>女</gender>
    <salary>6000</salary>
  </emp>
  <emp id="3">
    <name>琼恩·雪诺</name>
    <age>28</age>
    <gender>男</gender>
    <salary>7000</salary>
  </emp>
  <emp id="4">
    <name>布兰·斯塔克</name>
    <age>22</age>
    <gender>男</gender>
    <salary>8000</salary>
  </emp>
  <emp id="5">
    <name>nightKing</name>
    <age>26</age>
    <gender>未知</gender>
    <salary>9000</salary>
  </emp>
</list> 
```
新建一个emp实体类，用于接收解析数据：
```java
public class Emp {
    private int id;
    private String name;
    private int age;
    private String gender;
    private int salary;
    public Emp(){
    	
    }
  public Emp(int id,String name,int age,String gender,int salary){
        super();
        this.id = id;
        this.name = name;
        this.age = age;
        this.gender = gender;
        this.salary = salary;
  }
  //get,set略
}
```
```java
public class ParseXmlDemo {
  public static List getXml(){
   try {
       SAXReader reader=new SAXReader();
       Document doc=reader.read(new File("emp.xml"));
       List<Emp> list=new ArrayList<Emp>();
       /*
        * 解析第一步，获取根标签（根元素）
        * 这里获取的根标签就相当于是<list>...</list>
        * 那对标签。
        */
       Element root=doc.getRootElement();
       //获取名为"emp"的标签
       List<Element> elementList=root.elements("emp");
       //遍历每一个emp标签
       for(Element empEle:elementList){
        //获取name
        String name=empEle.elementText("name");
        int age=Integer.parseInt(empEle.elementText("age"));
        String gender=empEle.elementText("gender");
        int salary=Integer.parseInt(empEle.elementText("salary"));
        //属性
        Attribute attr=empEle.attribute("id");
        int id=Integer.parseInt(attr.getValue());
        Emp emp=new Emp(id,name,age,gender,salary);
        list.add(emp);
       }
       return list;
    } catch (Exception e) {
       // TODO: handle exception
       System.out.println(e.toString());
   }
	return null;
}
  public static void main(String[] args) {
    List list=ParseXmlDemo.getXml();
    System.out.println(list.toString());
  }
}        
```
输出结果：
```xml
1,提利昂·兰尼斯特,25,男,5000, 
2,卡丽熙,27,女,6000,
3,琼恩雪诺,28,男,7000, 
4,布兰斯塔克,22,男,8000, 
5,nightKing,26,未知,9000
```
生成xml大致步骤：

1: 创建一个Document对象，表示一个空的xml文档；

2: 向Document中添加根元素；

3: 按照目标xml文档的结构顺序向根元素中添加子元素来组建该结构；

4: 创建XMLWriter；

5: 设置低级流；

6: 使用XMLWriter将Document写出来生成 该文档 。 
```java
public class WriteXmlDemo {
  public static void main(String[] args) {
    try {
      List<Emp> list= new ArrayList<Emp>();
      list.add(new Emp(1,"鸣人",25,"男",4000));
      list.add(new Emp(2,"小樱",27,"女",6000));
      list.add(new Emp(3,"佐助",28,"男",7000));
      list.add(new Emp(4,"雏田",22,"女",8000));
      list.add(new Emp(5,"卡卡西",26,"男",90001));
      Document doc = DocumentHelper.createDocument();
      //生成根元素
      Element root = doc.addElement("list");
      for(Emp emp : list){
         //根标签下添加子标签
         Element empEle= root.addElement("emp");
         //向emp标签中添加子标签name
         Element nameEle= empEle.addElement("name");
         //标签赋值
         nameEle.addText(emp.getName());				
         Element ageEle = empEle.addElement("age");
         ageEle.addText(emp.getAge()+"");
         Element genderEle = empEle.addElement("gender");
         genderEle.addText(emp.getGender());
         Element salaryEle = empEle.addElement("salary");
         salaryEle.addText(emp.getSalary()+"");
         //添加属性
         empEle.addAttribute("id", emp.getId()+"");
     }
     //org.dom4j.XMLWriter
     XMLWriter writer = new XMLWriter(
     OutputFormat.createPrettyPrint());
 
     /*
      * 向文件myemp.xml中写出数据
      */
     FileOutputStream fos= new FileOutputStream("myemp.xml");
     writer.setOutputStream(fos);
     writer.write(doc);
     writer.close();
    } catch (Exception e) {
     e.printStackTrace();
   }
 }
}
```
生成myemp.xml：
```xml
<?xml version="1.0" encoding="UTF-8"?>
 
<list>
  <emp id="1">
    <name>鸣人</name>
    <age>25</age>
    <gender>男</gender>
    <salary>4000</salary>
  </emp>
  <emp id="2">
    <name>小樱</name>
    <age>27</age>
    <gender>女</gender>
    <salary>6000</salary>
  </emp>
  <emp id="3">
    <name>佐助</name>
    <age>28</age>
    <gender>男</gender>
    <salary>7000</salary>
  </emp>
  <emp id="4">
    <name>雏田</name>
    <age>22</age>
    <gender>女</gender>
    <salary>8000</salary>
  </emp>
  <emp id="5">
    <name>卡卡西</name>
    <age>26</age>
    <gender>男</gender>
    <salary>90001</salary>
  </emp>
</list>        
```