---
title: MyBatis级联
date: 2017-01-05 10:38:12
tags: MyBatis
---
MyBatis中的级联分为3种：association，collection和discriminator：

1.`association`：代表一对一关系，比如学生和学生证是一对一关系。

2.`collection`：代表一对多关系，比如学生和课程是一对多关系，一个学生可以有多个课程。

3.`discriminator`：鉴别器，它可以根据实际选择采用哪个类作为实例，允许你根据特定的条件去关联不同的结果集。

为了学习这些东东，设计一个模型关系：  
<!--more-->

![89371248-file_1487995784939_c58d.png](https://www.tuchuang001.com/images/2017/06/14/89371248-file_1487995784939_c58d.png)

根据模型新建库表：
```sql
CREATE TABLE t_lecture(
    id int(20) not null auto_increment comment '编号',
    lecture_name VARCHAR(60) not null comment '课程名称',
    PRIMARY KEY (id)
);
 
CREATE table t_student(
    id int(20) not null auto_increment comment '编号',
    cnname VARCHAR(60) not null comment '学生姓名',
    sex TINYINT(4) not null COMMENT '性别',
    selfcard_no int(20) not NULL COMMENT '学生证号',
    note VARCHAR(1024) COMMENT '备注',
    PRIMARY KEY (id)
);
 
CREATE table t_student_health_female(
    id int(20) not null auto_increment comment '编号',
    student_id VARCHAR(60) not null comment '学生编号',
    check_date VARCHAR(60) not NULL COMMENT '检查日期',
    heart VARCHAR(60) not NULL COMMENT '心',
    liver VARCHAR(60) not NULL COMMENT '肝',
    spleen VARCHAR(60) not NULL COMMENT '脾',
    lung VARCHAR(60) not NULL COMMENT '肺',
    kidney VARCHAR(60) not NULL COMMENT '肾',
    uterus VARCHAR(60) not NULL COMMENT '子宫',
    note VARCHAR(1024) not NULL comment '备注',
    PRIMARY KEY (id)
);
 
CREATE table t_student_health_male(
    id int(20) not null auto_increment comment '编号',
    student_id VARCHAR(60) not null comment '学生编号',
    check_date VARCHAR(60) not NULL COMMENT '检查日期',
    heart VARCHAR(60) not NULL COMMENT '心',
    liver VARCHAR(60) not NULL COMMENT '肝',
    spleen VARCHAR(60) not NULL COMMENT '脾',
    lung VARCHAR(60) not NULL COMMENT '肺',
    kidney VARCHAR(60) not NULL COMMENT '肾',
    prostate VARCHAR(60) not NULL COMMENT '前列腺',
    note VARCHAR(1024) not NULL comment '备注',
    PRIMARY KEY (id)
);
 
create table t_student_lecture(
    id int(20) not null auto_increment COMMENT '编号',
    student_id int(20) not null comment '学生编号',
    lecture_id int(20) not null comment '课程编号',
    grade DECIMAL(16,2) not null comment '评分',
    note VARCHAR(1024) comment '备注',
    PRIMARY KEY (id)
);
 
create table t_student_selfcard(
    id int(20) not null auto_increment COMMENT '编号',
    student_id int(20) not null comment '学生编号',
    native VARCHAR(60) not NULL COMMENT '籍贯',
    issue_date date NOT NULL comment '发证日期',
    end_date date not NULL COMMENT '结束日期',
    note VARCHAR(1024) comment '备注',
    PRIMARY KEY (id)
); 
```
## association
用t_student和t_student_selfcard演示一对一级联。

新增Student POJO：
```java
public class Student {
    private Long id;
    private String cnName;
    private Sex sex;
    private Long selfCardNo;
    private String note;
    //一对一关系
    private StudentSelfcard selfCard;
    // getter，setter略
}
```
StudentSelfcard POJO：
```java
public class StudentSelfcard {
    private Long id;
    private Long studentId;
    private String natives;
    private Date issueDate;
    private Date endDate;
    private String note;
    // getter，setter略
}
```
定义接口StudentSelfcardMapper：
```java
public interface StudentSelfcardMapper {
    public StudentSelfcard findStudentSelfcardByStudentId(Long id);
    public int insertStudentSelfcard(StudentSelfcard selfCard);
}
```
创建对应的映射文件StudentSelfcardMapper.xml：
```xml
<?xml version="1.0" encoding="UTF-8" ?>    
    <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"   
"http://mybatis.org/dtd/mybatis-3-mapper.dtd">     
<mapper namespace="mrbird.leanote.mapper.StudentSelfcardMapper">  
    <sql id="studentSelfcard_column">
        id,student_id as studentId,native as natives,issue_date as issueDate,
        end_date as endDate,note
    </sql>
    <select id="findStudentSelfcardByStudentId" parameterType="long" 
        resultType="studentSelfcard">
        select <include refid="studentSelfcard_column"/> 
        from t_student_selfcard where student_id = #{studentId}
    </select>
    <insert id="insertStudentSelfcard" parameterType="studentSelfcard">
        insert into t_student_selfcard (student_id,native,issue_date,end_date,
        note) values (#{studentId},#{natives},#{issueDate},#{endDate},#{note})
    </insert>
</mapper> 
```
接着定义接口StudentMapper：
```java
public interface StudentMapper {
    public Student findStudentById(Long id);
    public int createStudent(Student s);
}   
```
其相对于的映射文件StudentMapper.xml：
```xml
<?xml version="1.0" encoding="UTF-8" ?>    
    <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"   
"http://mybatis.org/dtd/mybatis-3-mapper.dtd">     
<mapper namespace="mrbird.leanote.mapper.StudentMapper">  
    <resultMap type="student" id="studentList">
        <id column="id" property="id"/>
        <result column="cnname" property="cnName"/>
        <result column="sex" property="sex"
            typeHandler="org.apache.ibatis.type.EnumTypeHandler"/>
        <result column="selfcard_no" property="selfCardNo"/>
        <result column="note" property="note"/>
        <!-- 一对一关联，column指定用哪列的值作为select查询的条件，如果有多个值用
            逗号隔开，select指定查询方法-->
        <association property="selfCard" column="id" 
            select="mrbird.leanote.mapper.StudentSelfcardMapper.findStudentSelfcardByStudentId"/>
    </resultMap>
    <sql id="student_column">
        id,cnname as cnName,sex,selfcard_no as selfCardNo,note 
    </sql>
    <select id="findStudentById" parameterType="long" resultMap="studentList">
        select 
        <include refid="student_column"/> 
        from t_student where id = #{id}
    </select>
    <!-- 设置主键回填，供t_student_selfcard的student_id字段使用 -->
    <insert id="createStudent" parameterType="student" useGeneratedKeys="true" 
        keyProperty="id">
        insert into t_student(cnname,sex,selfcard_no,note) values (#{cnName},
        #{sex,typeHandler=org.apache.ibatis.type.EnumTypeHandler},
        #{selfCardNo},#{note})
    </insert>
</mapper> 
```
设置别名，指定mapper略。       

先往库表插入值：
```java
...
sqlSession = SqlSessionFactoryUtil.openSqlSession();
StudentMapper studentMapper = sqlSession.getMapper(StudentMapper.class);
StudentSelfcardMapper selfcardMapper = sqlSession.getMapper(StudentSelfcardMapper.class);
Student student = new Student();
student.setCnName("辛久奈");
student.setNote("旋涡辛久奈");
student.setSelfCardNo(10000L);
student.setSex(Sex.FEMALE);
int n = studentMapper.createStudent(student);
if( n == 1){
    StudentSelfcard selfCard = new StudentSelfcard();
    selfCard.setStudentId(student.getId());
    selfCard.setNatives("福州");
    selfCard.setIssueDate(new Date());
    selfCard.setEndDate(new Date());
    selfCard.setNote("旋涡辛久奈的学生证");
    selfcardMapper.insertStudentSelfcard(selfCard);
}
sqlSession.commit();
...
```
查询库表：
```sql
mysql> select * from t_student;
+----+--------+--------+-------------+------------+
| id | cnname | sex    | selfcard_no | note       |
+----+--------+--------+-------------+------------+
| 10 | 辛久奈  | FEMALE |   10000    | 旋涡辛久奈  |
+----+--------+--------+-------------+------------+
1 row in set (0.00 sec)
 
mysql> select * from t_student_selfcard;
+----+------------+--------+------------+------------+--------------------+
| id | student_id | native | issue_date | end_date   | note               |
+----+------------+--------+------------+------------+--------------------+
|  2 |         10 | 福州   | 2017-01-06 | 2017-01-06 | 旋涡辛久奈的学生证   |
+----+------------+--------+------------+------------+--------------------+
1 row in set (0.00 sec)
```
插入成功，现测试级联获取：
```java
...
sqlSession = SqlSessionFactoryUtil.openSqlSession();
StudentMapper studentMapper = sqlSession.getMapper(StudentMapper.class);
Student student = studentMapper.findStudentById(10L);
System.out.println(student.getSelfCard().getNote());
sqlSession.commit();
...
```
控制台输出：
```xml
旋涡辛久奈的学生证
```
success.
## collection
学生和学生成绩是一对多的关系，所以用t_student和t_student_lecture表练习一对多级联。

修改Student POJO：
```java
public class Student {
    private Long id;
    private String cnName;
    private Sex sex;
    private Long selfCardNo;
    private String note;
    //一对多关联
    private List<StudentLecture> lectures;
    // getter，setter略
}
```
新增StudentLecture POJO：
```java
public class StudentLecture {
    private Long id;
    private Long studentId;
    private Long lectureId;
    private Double grade;
    private String note;
    // getter，setter略
}
```
新建StudentLectureMapper接口：
```java
public interface StudentLectureMapper {
    public List<StudentLecture> getLecturesByStudentId(Long studentId);
    public int insertStudentLecture(StudentLecture lecture);
}
```
其对应的映射文件StudentLectureMapper.xml：
```xml
<?xml version="1.0" encoding="UTF-8" ?>    
    <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"   
"http://mybatis.org/dtd/mybatis-3-mapper.dtd">     
<mapper namespace="mrbird.leanote.mapper.StudentLectureMapper">  
    <resultMap type="studentLecture" id="lectures">
        <id column="id" property="id"/>
        <result column="student_id" property="studentId"/>
        <result column="lecture_id" property="lectureId"/>
        <result column="grade" property="grade"/>
        <result column="note" property="note"/>
    </resultMap>
    <sql id="student_lecture_column">
        id,student_id as studentId,lecture_id as lectureId,grade,note 
    </sql>
    <select id="getLecturesByStudentId" parameterType="long" 
        resultMap="lectures">
        select <include refid="student_lecture_column"/> 
        from t_student_lecture where student_id = #{studentId}
    </select>
    <insert id="insertStudentLecture" parameterType="student">
        <![CDATA[
            insert into t_student_lecture(student_id,lecture_id,grade,note) 
            values (#{studentId},#{lectureId},#{grade},#{note})
        ]]>
    </insert>
</mapper>
```
修改StudentMapper.xml：
```xml
<?xml version="1.0" encoding="UTF-8" ?>    
    <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"   
"http://mybatis.org/dtd/mybatis-3-mapper.dtd">     
<mapper namespace="mrbird.leanote.mapper.StudentMapper">  
    <resultMap type="student" id="studentList">
        <id column="id" property="id"/>
        <result column="cnname" property="cnName"/>
        <result column="sex" property="sex"
            typeHandler="org.apache.ibatis.type.EnumTypeHandler"/>
        <result column="selfcard_no" property="selfCardNo"/>
        <result column="note" property="note"/>
        <!-- 一对多关联，column指定用哪列的值作为select查询的条件，如果由多个值用
            逗号隔开，select指定查询方法-->
        <collection property="lectures" column="id" 
            select="mrbird.leanote.mapper.StudentLectureMapper.getLecturesByStudentId"/>
    </resultMap>
    <sql id="student_column">
        id,cnname as cnName,sex,selfcard_no as selfCardNo,note 
    </sql>
    <select id="findStudentById" parameterType="long" resultMap="studentList">
        select <include refid="student_column"/> 
        from t_student where id = #{id}
    </select>
    <!-- 设置主键回填，供t_student_selfcard的student_id字段使用 -->
    <insert id="createStudent" parameterType="student" useGeneratedKeys="true" 
        keyProperty="id">
        insert into t_student(cnname,sex,selfcard_no,note) values (#{cnName},
        #{sex,typeHandler=org.apache.ibatis.type.EnumTypeHandler},
        #{selfCardNo},#{note})
    </insert>
</mapper>
```
先插入一些测试数据：
```java
...
sqlSession = SqlSessionFactoryUtil.openSqlSession();
StudentMapper studentMapper = sqlSession.getMapper(StudentMapper.class);
StudentLectureMapper lectureMapper = sqlSession.getMapper(StudentLectureMapper.class);
Student student = new Student();
student.setCnName("水门");
student.setSelfCardNo(11111L);
student.setNote("波风水门");
student.setSex(Sex.MALE);
int n = studentMapper.createStudent(student);
if(n == 1){
    Long studentId = student.getId();
    String[] noteArr = new String[]{"语文成绩","数学成绩","英语成绩"};
    Double[] gradeArr = new Double[]{99.0,100.0,98.0};
    for(int i=0;i<noteArr.length;i++){
        StudentLecture lecture = new StudentLecture();
        lecture.setStudentId(studentId);
        lecture.setLectureId(Long.valueOf(i));
        lecture.setGrade(gradeArr[i]);
        lecture.setNote(noteArr[i]);
        lectureMapper.insertStudentLecture(lecture);
    }
}
sqlSession.commit();
...
```
查询数据库：
```sql
mysql> select * from t_student;
+----+--------+--------+-------------+------------+
| id | cnname | sex    | selfcard_no | note       |
+----+--------+--------+-------------+------------+
| 10 | 辛久奈 | FEMALE |       10000 | 旋涡辛久奈  |
| 12 | 水门   | MALE   |       11111 | 波风水门    |
+----+--------+--------+-------------+------------+
2 rows in set (0.01 sec)
 
mysql> select * from t_student_lecture;
+----+------------+------------+--------+----------+
| id | student_id | lecture_id | grade  | note     |
+----+------------+------------+--------+----------+
|  1 |         12 |          0 |  99.00 | 语文成绩  |
|  2 |         12 |          1 | 100.00 | 数学成绩  |
|  3 |         12 |          2 |  98.00 | 英语成绩  |
+----+------------+------------+--------+----------+
3 rows in set (0.00 sec)
```
插入成功，现测试级联获取lectures：
```java
...
sqlSession = SqlSessionFactoryUtil.openSqlSession();
StudentMapper studentMapper = sqlSession.getMapper(StudentMapper.class);
Student student = studentMapper.findStudentById(12L);
List<StudentLecture> lectures = student.getLectures();
for(StudentLecture l : lectures){
    System.out.println(l.getNote()+"："+l.getGrade());
} 
...
```
控制台输出：
```xml
语文成绩：99.0
数学成绩：100.0
英语成绩：98.0
```
success.
## discriminator
鉴别器其实同其他级联一样，只不过是多了个鉴别的过程罢了。

为了学习鉴别器，我们向t_student_health_female和t_student_health_male中插入一组数据：
```sql
INSERT INTO `t_student_health_female`
VALUES(
    1,
    '10',
    '2017-1-6',
    '心正常',
    '肝正常',
    '脾正常',
    '肺正常',
    '肾正常',
    '子宫正常',
    '健康');
 
INSERT INTO `t_student_health_male`
VALUES(
    1,
    '12',
    '2017-1-6',
    '心脏良好',
    '肝良好',
    '脾良好',
    '肺良好',
    '肾良好',
    '前列腺良好',
    '健康');
```
其对应的实体类StudentHealthFemale和StudentHealthMale略。

新增两个POJO：MaleStudent和FemaleStudent均继承自Student：
```java
public class MaleStudent extends Student{
    private List<StudentHealthMale> studentHealthMaleList;
   // getter，setter略
}
```
```java
public class FemaleStudent extends Student{
    private List<StudentHealthFemale> studentHealthFemaleList;
    // getter，setter略
}
```
接着编写两个接口StudentHealthMaleMapper和StudentHealthFemaleMapper，包含一个根据studentId获取health的抽象方法：
```java
import mrbird.leanote.pojo.StudentHealthMale;
 
public interface StudentHealthMaleMapper {
    public StudentHealthMale findStudentHealthMaleByStudentId(Long studentId);
}    
```
```java
import mrbird.leanote.pojo.StudentHealthFemale;
 
public interface StudentHealthFemaleMapper {
    public StudentHealthFemale findStudentHealthFemaleByStudentId(Long studentId);
}
```
各自对应的映射器：

StudentHealthMaleMapper.xml：
```xml
<?xml version="1.0" encoding="UTF-8" ?>    
    <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"   
"http://mybatis.org/dtd/mybatis-3-mapper.dtd">     
<mapper namespace="mrbird.leanote.mapper.StudentHealthMaleMapper">  
	<select id="findStudentHealthMaleByStudentId" parameterType="long"
            resultType="studentHealthMale">
        select * from t_student_health_male where student_id = #{studentId}
	</select>	
</mapper>
```
因为在MyBatis配置文件中配置了`<setting name="mapUnderscoreToCamelCase" value="true"/>`，并且数据库命名规范，所以这里可以用select * from...

studentHealthFemaleMapper.xml：
```xml
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"   
"http://mybatis.org/dtd/mybatis-3-mapper.dtd">     
<mapper namespace="mrbird.leanote.mapper.StudentHealthFemaleMapper">  
	<select id="findStudentHealthFemaleByStudentId" parameterType="long"
            resultType="studentHealthFemale">
        select * from t_student_health_female where student_id = #{studentId}
	</select>	
</mapper>
```
接下来就是重点了，我们修改StudentMapper.xml：
```xml
<?xml version="1.0" encoding="UTF-8" ?>    
    <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"   
"http://mybatis.org/dtd/mybatis-3-mapper.dtd">     
<mapper namespace="mrbird.leanote.mapper.StudentMapper"> 
    <!-- 定义maleStudentList，类型为“maleStudent”。这是一个一对多关联，一个学生可以体检多次。
        调用的方法为findStudentHealthMaleByStudentId。
        正如其POJO继承Student那样，resultMap也同样继承自studentList--> 
    <resultMap type="maleStudent" id="maleStudentList" extends="studentList">
        <collection property="studentHealthMaleList" column="id"
            select="mrbird.leanote.mapper.StudentHealthMaleMapper
                .findStudentHealthMaleByStudentId"/>
    </resultMap>
    <resultMap type="femaleStudent" id="femaleStudentList" extends="studentList">
        <collection property="studentHealthFemaleList" column="id" 
            select="mrbird.leanote.mapper.StudentHealthFemaleMapper
                .findStudentHealthFemaleByStudentId"/>
    </resultMap>
    <resultMap type="student" id="studentList">
        <id column="id" property="id"/>
        <result column="cnname" property="cnName"/>
        <result column="sex" property="sex"/>
        <result column="selfcard_no" property="selfCardNo"/>
        <result column="note" property="note"/>
        <!-- 配置鉴别器，类似于switch，用于鉴别的列为“sex”，
            值为MALE时结果集为maleStudentList
            值为FEMALE时结果集为femaleStudentList -->
        <discriminator javaType="string" column="sex">
            <case value="MALE" resultMap="maleStudentList"></case>
            <case value="FEMALE" resultMap="femaleStudentList"></case>
        </discriminator>
    </resultMap>
    <sql id="student_column">
        id,cnname as cnName,sex,selfcard_no as selfCardNo,note 
    </sql>
    <select id="findStudentById" parameterType="long" resultMap="studentList">
        select <include refid="student_column"/> 
        from t_student where id = #{id}
    </select>
</mapper>
```
测试一下：
```java
...
sqlSession = SqlSessionFactoryUtil.openSqlSession();
StudentMapper studentMapper = sqlSession.getMapper(StudentMapper.class);
MaleStudent student = (MaleStudent) studentMapper.findStudentById(12L);
System.out.println(student.getCnName()+"的"+
    student.getStudentHealthMaleList().get(0).getProstate());
...
```
页面输出：
```xml
水门的前例腺良好
```
(≖ ‿ ≖)✧
## 延迟加载
假如一次性将所有与Student有关的信息都加载出来，这必定会造成性能的问题，如：
```xml
<?xml version="1.0" encoding="UTF-8" ?>    
    <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"   
"http://mybatis.org/dtd/mybatis-3-mapper.dtd">     
<mapper namespace="mrbird.leanote.mapper.StudentMapper">  
    <resultMap type="student" id="studentList">
        <id column="id" property="id"/>
        <result column="cnname" property="cnName"/>
        <result column="sex" property="sex"/>
        <result column="selfcard_no" property="selfCardNo"/>
        <result column="note" property="note"/>
        <association property="selfCard" column="id" 
            select="mrbird.leanote.mapper.StudentSelfcardMapper
                .findStudentSelfcardByStudentId"/>
        <collection property="lectures" column="id" 
            select="mrbird.leanote.mapper.StudentLectureMapper
                .getLecturesByStudentId"/>
        <discriminator javaType="string" column="sex">
            <case value="MALE" resultMap="maleStudentList"></case>
            <case value="FEMALE" resultMap="femaleStudentList"></case>
        </discriminator>
    </resultMap>
  ...  
</mapper>   
```
MyBatis的延迟加载策略可以很好的应对这种情况。只需在mybatis-config.xml中配置：
```xml
<settings>
    ...
    <!-- 开启延迟加载 -->
    <setting name="lazyLoadingEnabled" value="true"/>
    <!-- 关闭按层级加载 -->
    <setting name="aggressiveLazyLoading" value="false"/>
</settings>
```
然后我们在级联标签上可以自由的配置fetchType="lazy"或者fetchType="eager"来改变加载策略。

> eager 英[ˈi:gə(r)] 美[ˈiɡɚ] adj. 急切; 渴望的; 热心的; 热切的，热情洋溢的;

## 另外一种级联
所谓的另外一种级联就是用一条sql查出所有学生的信息，没有性能问题。

在StudentMapper中定义一个查找所有学生信息的抽象方法：
```java
public List<Student> finAllStudentMsg();   
```
其映射文件如下：
```xml
<?xml version="1.0" encoding="UTF-8" ?>    
    <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"   
"http://mybatis.org/dtd/mybatis-3-mapper.dtd">     
<mapper namespace="mrbird.leanote.mapper.StudentMapper"> 
    <select id="finAllStudentMsg" resultMap="allStudentList">
        select s.id,s.cnname,s.sex,s.selfcard_no,s.note as snote,
        IF (s.sex = 'MALE',shm.id,shf.id) as hid,
        IF (s.sex = 'MALE',shm.check_date,shf.check_date) as checkDate,
        IF (s.sex = 'MALE',shm.heart,shf.heart) as heart,
        IF (s.sex = 'MALE',shm.liver,shf.liver) as liver,
        IF (s.sex = 'MALE',shm.spleen,shf.spleen) as spleen,
        IF (s.sex = 'MALE',shm.lung,shf.lung) as lung,
        IF (s.sex = 'MALE',shm.kidney,shf.kidney) as kidney,
        IF (s.sex = 'MALE',shm.note,shf.note) as hnote,
        shm.prostate,shf.uterus,
        ss.id as ssid,ss.native as natives,
        ss.issue_date as issueDate,ss.end_date as endDate,
        ss.note as ssNote,
        sl.id as slid,sl.lecture_id as lectureId,sl.grade,
        sl.note as slNote 
        FROM t_student s 
        LEFT JOIN t_student_health_male shm on s.id = shm.student_id 
        LEFT JOIN t_student_health_female shf on s.id = shf.student_id 
        LEFT JOIN t_student_selfcard ss on s.id = ss.student_id 
        LEFT JOIN t_student_lecture sl on s.id = sl.student_id 
    </select>
    <resultMap type="student" id="allStudentList">
        <id column="id" property="id"/>
        <result column="cnname" property="cnName"/>
        <result column="sex" property="sex"/>
        <result column="selfcard_no" property="selfCardNo"/>
        <result column="snote" property="note"/>
        <!-- javaType属性告诉MyBtis用哪个类去映射这些字段 -->
        <association property="selfCard" column="id" javaType="studentSelfcard">
            <result property="id" column="ssid"/>
            <result property="studentId" column="id"/>
            <result property="natives" column="natives"/>
            <result property="issueDate" column="issueDate"/>
            <result property="endDate" column="endDate"/>
            <result property="note" column="ssNote"/>
        </association>
        <collection property="lectures" ofType="studentLecture">
            <result property="id" column="slid"/>
            <result property="studentId" column="id"/>
            <result property="lectureId" column="lectureId"/>
            <result property="grade" column="grade"/>
            <result property="note" column="slNote"/>
        </collection>
        <discriminator javaType="string" column="sex">
            <case value="MALE" resultMap="maleStudentList"></case>
            <case value="FEMALE" resultMap="femaleStudentList"></case>
        </discriminator>
    </resultMap>
    <resultMap type="maleStudent" id="maleStudentList" extends="allStudentList">
        <!-- ofType属性指定了其泛型 -->
    	<collection property="studentHealthMaleList" ofType="studentHealthMale">
            <id property="id" column="hid"/>
            <result property="studentId" column="id"/>
            <result property="checkDate" column="checkDate"/>
            <result property="heart" column="heart"/>
            <result property="liver" column="liver"/>
            <result property="spleen" column="spleen"/>
            <result property="lung" column="lung"/>
            <result property="kidney" column="kidney"/>
            <result property="prostate" column="prostate"/>
            <result property="note" column="hnote"/>
    	</collection>
    </resultMap>
    <resultMap type="femaleStudent" id="femaleStudentList" extends="allStudentList">
    	<collection property="studentHealthFemaleList" ofType="studentHealthFemale">
            <id property="id" column="hid"/>
            <result property="studentId" column="id"/>
            <result property="checkDate" column="checkDate"/>
            <result property="heart" column="heart"/>
            <result property="liver" column="liver"/>
            <result property="spleen" column="spleen"/>
            <result property="lung" column="lung"/>
            <result property="kidney" column="kidney"/>
            <result property="uterus" column="uterus"/>
            <result property="note" column="hnote"/>
    	</collection>
    </resultMap>
</mapper> 
```
测试finAllStudentMsg方法：
```xml
...
sqlSession = SqlSessionFactoryUtil.openSqlSession();
StudentMapper studentMapper = sqlSession.getMapper(StudentMapper.class);
List<Student> students = studentMapper.finAllStudentMsg();
for(Student student : students){
    if("MALE".equalsIgnoreCase(student.getSex().toString())){
        MaleStudent male = (MaleStudent) student;
        System.out.println(male.getCnName()+"的卡号："+male.getSelfCardNo());
        StudentSelfcard selfcard = male.getSelfCard();
        System.out.println("来自："+selfcard.getNatives()+","+selfcard.getNote());
        List<StudentLecture> lectures = male.getLectures();
        for(StudentLecture le : lectures){
            System.out.println(le.getNote()+"："+le.getGrade());
        }
        List<StudentHealthMale> healthMales = male.getStudentHealthMaleList();
        for(StudentHealthMale healthMale : healthMales){
            System.out.println(healthMale.getCheckDate()+"，"+healthMale.getProstate());
        }
    }else{
    	FemaleStudent female = (FemaleStudent) student;
    	System.out.println(female.getCnName()+"的卡号："+female.getSelfCardNo());
    	StudentSelfcard selfcard = female.getSelfCard();
    	System.out.println("来自："+selfcard.getNatives()+","+selfcard.getNote());
    	List<StudentLecture> lectures = female.getLectures();
    	for(StudentLecture le : lectures){
            System.out.println(le.getNote()+"："+le.getGrade());
    	}
    	List<StudentHealthFemale> healthFemales = female.getStudentHealthFemaleList();
    	for(StudentHealthFemale healthfemale : healthFemales){
            System.out.println(healthfemale.getCheckDate()+"，"+healthfemale.getUterus());
    	}
    }
}
...
```
控制台输出：
```xml
辛久奈的卡号：10000
来自：福州,旋涡辛久奈的学生证
语文成绩：99.0
数学成绩：99.0
英语成绩：99.0
2017-1-6，子宫正常
水门的卡号：11111
来自：厦门,波风水门的学生证
语文成绩：99.0
数学成绩：100.0
英语成绩：98.0
2017-1-6，前例腺良好
```
这种方式比较直观明了，但是SQL编写起来较为繁琐。

> [《深入浅出MyBatis技术原理与实战》](https://book.douban.com/subject/26858114/)读书笔记   