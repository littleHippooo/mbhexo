---
title: Apache POI导出Excel文件
date: 2016-04-14 09:31:26
tags: POI
---
Apache POI 是用Java编写的免费开源的跨平台的 Java API，Apache POI提供API给Java程式对Microsoft Office格式档案读和写的功能。
  
Apache POI 中提供的几大部分的作用：
    
1.HSSF － 提供读写Microsoft Excel XLS格式档案的功能。　　

2.XSSF － 提供读写Microsoft Excel OOXML XLSX格式档案的功能。　　

3.HWPF － 提供读写Microsoft Word DOC格式档案的功能。　　

4.HSLF － 提供读写Microsoft PowerPoint格式档案的功能。　　

5.HDGF － 提供读Microsoft Visio格式档案的功能。　　

6.HPBF － 提供读Microsoft Publisher格式档案的功能。　　

7.HSMF － 提供读Microsoft Outlook格式档案的功能。
<!--more-->

使用Apache POI导出Excel表格文件大致如下几个步骤：

1.创建新的Excel工作薄：
```java
HSSFWorkbook workbook = new HSSFWorkbook();﻿​ 
```
2.创建一个工作表，如“员工表”：
```java
HSSFSheet sheet = workbook.createSheet("员工表");﻿​  
```
3.创建行：
```java
HSSFRow row = sheet.createRow(0); //0表示索引为0的位置，也就是左上角
```
4.创建列（也就是每一行的单元格）:
```java
HSSFCell cell = row.createCell((short) 0);﻿​
```
5.创建文件流，输出Excel，输出后关闭流

以下是具体实例：

Excel工具类(ExcelUtil)：
```java
public class ExcelUtil {
   private HSSFWorkbook wb = null;
   private HSSFSheet sheet = null;
   /**
	* @param wb
	* @param sheet
	*/
   public ExcelUtil(HSSFWorkbook wb, HSSFSheet sheet) {
     super();
     this.wb = wb;
     this.sheet = sheet;
   }
   public HSSFSheet getSheet() {
     return sheet;
   }
   public void setSheet(HSSFSheet sheet) {
     this.sheet = sheet;
   }
   public HSSFWorkbook getWb() {
     return wb;
   }
   public void setWb(HSSFWorkbook wb) {
     this.wb = wb;
   }
   /**
    * 创建通用EXCEL头部
    * 
    * @param headString 头部显示的字符
    * @param colSum 该报表的列数
    */
   @SuppressWarnings("deprecation")
   public void createNormalHead(String headString, int colSum) {
     // 设置第一行
     HSSFRow row = sheet.createRow(0);
     HSSFCell cell = row.createCell(0);
     row.setHeight((short) 350);
     // 定义单元格为字符串类型
     cell.setCellType(HSSFCell.ENCODING_UTF_16);
     // 设置Excel表格标题
     cell.setCellValue(new HSSFRichTextString(headString));
     // 指定合并区域
     sheet.addMergedRegion(new Region(0,(short) 0,0,(short) colSum));
     // 设置单元格样式
     HSSFCellStyle cellStyle = wb.createCellStyle();
     // 指定单元格居中对齐
     cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
     cellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
     // 指定单元格自动换行
     cellStyle.setWrapText(true);
 
     // 设置单元格字体
     HSSFFont font = wb.createFont();
     font.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL);
     font.setFontName("微软雅黑");
     font.setFontHeight((short) 250);
     cellStyle.setFont(font);
     cell.setCellStyle(cellStyle);
   }
 
 /**
    * 创建单元格方法
    * 
    * @param wb HSSFWorkbook
    * @param row HSSFRow
    * @param col short型的列索引
    * @param align 对齐方式
    * @param val 列值
    */
   public void cteateCell(HSSFWorkbook wb, HSSFRow row, int col, String val) {
     HSSFCell cell = row.createCell(col);
     cell.setCellType(HSSFCell.ENCODING_UTF_16);
     cell.setCellValue(new HSSFRichTextString(val));
     HSSFCellStyle cellStyle = wb.createCellStyle();
     cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
     cellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
     HSSFFont font = wb.createFont();
     font.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL);
     font.setFontName("微软雅黑");
     cellStyle.setFont(font);
     cell.setCellStyle(cellStyle);
   }
 /**
    * 输入EXCEL文件
    * 
    * @param fileName 文件名
    */
   public void outputExcel(String fileName) {
     FileOutputStream fos = null;
     try {
         fos = new FileOutputStream(new File(fileName));
         wb.write(fos);
         fos.close();
     } catch (FileNotFoundException e) {
         e.printStackTrace();
     } catch (IOException e) {
         e.printStackTrace();
     }
   }
}
```
Excel表格文件生成类：
```java
public class ExportExcelClient {
   // 创建一个新的Excel工作簿
   private static HSSFWorkbook wb = new HSSFWorkbook();
   // 创建一个新的工作表
   private static HSSFSheet sheet = wb.createSheet();
   private static Session session = null;
 
   public static void main(String[] args) {
     ExcelUtil exportExcel = new ExcelUtil(wb, sheet);
     session = SessionUtil.getSession();
     // 查询列名
     String column_names = "select COLUMN_NAME from USER_TAB_COLS 
                            where TABLE_NAME = 'SYS_OBJECT_TYPE'";
     List<String> list = session.createSQLQuery(column_names).list();
     // 列数
     Integer column_nums = list.toArray().length;
     exportExcel.createNormalHead("查询结果表", column_nums - 1);
 
     // 1.设置Excel表表头
     HSSFRow row = sheet.createRow(1);
     HSSFCellStyle cellStyle = wb.createCellStyle();
     // 设置表头背景色
     cellStyle.setFillForegroundColor(HSSFColor.LIGHT_GREEN.index);
     cellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
     // 设置表头字体
     HSSFFont font = wb.createFont();
     font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
     font.setFontName("微软雅黑");
     cellStyle.setFont(font);
     // 设置表头列名
     for (int i = 0; i < column_nums; i++) {
        HSSFCell cell = row.createCell((short) i);
        cell.setCellType(HSSFCell.CELL_TYPE_STRING);
        cell.setCellValue(list.toArray()[i].toString());
        cell.setCellStyle(cellStyle);
   }
 
   // 2.填值
   // 统计总共有几行数据
   String count = "select count(*) from SYS_OBJECT_TYPE";
   Integer num = Integer.valueOf(session.createSQLQuery(count).uniqueResult().toString());
   // 查询出表格内容
   String sql = "select * from SYS_OBJECT_TYPE";
   Query q = session.createSQLQuery(sql);
   @SuppressWarnings("unchecked")
   List<Object> data = q.list();
   // 循环向Excel表格填充数据
   // 每一行
   for (int i = 2; i < num; i++) {
        HSSFRow row1 = sheet.createRow((short) i);
        // 每一列
        for (int j = 0; j < column_nums; j++) {
            ortExcel.cteateCell(wb, row1, (short) j,
            ((Object[]) data.get(i))[j] == null ? ""
            :((Object[]) data.get(i))[j].toString());
            // 设置列的宽度根据内容自适应
            sheet.autoSizeColumn((short) j);
        }
   }
   String out = new SimpleDateFormat("yyMMddhhmmss").format(new Date());
 
   // 3.输出xls
   exportExcel.outputExcel("d:\\查询结果" + out + ".xls");
   session.close();
   }
}
```
效果如下图所示：

![63752059-file_1487993875763_13631.png](https://www.tuchuang001.com/images/2017/06/11/63752059-file_1487993875763_13631.png)

**附录一**：相关jar包链接:[百度网盘](http://pan.baidu.com/share/init?shareid=1669410648&uk=20446062)  密码：wow5

附录二：HSSFColor颜色对照表：

![10517979-file_1487993916378_92ca.png](https://www.tuchuang001.com/images/2017/06/11/10517979-file_1487993916378_92ca.png)
![24441816-file_1487993947137_3dc9.png](https://www.tuchuang001.com/images/2017/06/11/24441816-file_1487993947137_3dc9.png)