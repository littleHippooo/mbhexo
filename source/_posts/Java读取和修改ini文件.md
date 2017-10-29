---
title: Java读取和修改ini文件
date: 2016-08-29 19:20:17
tags: Java
---
项目开发中，一般将系统级的配置放在ini配置文件里，项目启动时，通过java读取ini里的变量值，然后发送到页面上。

如红色警戒的ra2.ini配置文件：

<!--more-->
```xml
[MultiPlayer]
PreferredGameTypeID = 111111 
PreferredScenarioIndex=0
Locale=0
StoreNick=yes
PortBase=1255
PortPool=9415
PhoneIndex=-1
WOLLimitResolution=no
LastNickSlot=-1
Handle=5b,4e,65,77,20,50,6c,61,79,65,72,5d,
Color=2
ColorEx=-1
Side=Americans
SideEx=-1
GameMode=2
 
[Options]
GameSpeed=0
Difficulty=0
ScrollMethod=0
ScrollRate=0
AutoScroll=yes
DetailLevel=2
SidebarCameoText=yes
UnitActionLines=yes
ShowHidden=yes
ToolTips=yes
```
读取和修改方法：
```java
public final class javaReadIniUtil {  
    /** 
     * 从ini配置文档中读取变量的值 
     * @param file 配置文档的路径 
     * @param section 要获取的变量所在段名称 
     * @param variable  要获取的变量名称 
     * @param defaultValue 变量名称不存在时的默认值 
     * @return 变量的值 
     * @throws IOException 抛出文档操作可能出现的io异常 
     */  
 public static String getProfileString(String file, String section,  
        String variable, String defaultValue) throws IOException {  
        String strLine, value = "";  
        BufferedReader bufferedReader
                            = new BufferedReader(new FileReader(file));  
        boolean isInSection = false;  
        try {  
            while ((strLine = bufferedReader.readLine()) != null) {  
                strLine = strLine.trim();  
                Pattern p;  
                Matcher m;  
                p = Pattern.compile("\\["+section+"\\]");  
                m = p.matcher((strLine));  
                if (m.matches()) {  
                    p = Pattern.compile("\\["+section+"\\]");  
                    m = p.matcher(strLine);  
                    if (m.matches()) {  
                        isInSection = true;  
                    } else {  
                        isInSection = false;  
                    }  
                }  
                if (isInSection == true) {  
                    strLine = strLine.trim();  
                    String[] strArray = strLine.split("=");  
                    if (strArray.length == 1) {  
                        value = strArray[0].trim();  
                        if (value.equalsIgnoreCase(variable)) {  
                            value = "";  
                            return value;  
                        }  
                    } else if (strArray.length == 2) {  
                        value = strArray[0].trim();  
                        if (value.equalsIgnoreCase(variable)) {  
                            value = strArray[1].trim();  
                            return value;  
                        }  
                    } else if (strArray.length > 2) {  
                        value = strArray[0].trim();  
                        if (value.equalsIgnoreCase(variable)) {  
                            value = strLine
                                .substring(strLine.indexOf("=") + 1).trim();   
                            return value;  
                        }  
                    }  
                }  
            }  
        } finally {  
            bufferedReader.close();  
        }  
        return defaultValue;  
    }  
  
    /** 
     * 修改ini配置文档中变量的值 
     * @param file 配置文档的路径 
     * @param section 要修改的变量所在段名称 
     * @param variable 要修改的变量名称 
     * @param value 变量的新值 
     * @throws IOException 抛出文档操作可能出现的io异常 
     */  
  public static boolean setProfileString(String file,
        String section,String variable, String value)throws IOException{  
        String fileContent, allLine, strLine, newLine, remarkStr;  
        String getValue;  
        BufferedReader bufferedReader
                            = new BufferedReader(new FileReader(file));  
        boolean isInSection = false;  
        fileContent = "";  
        try {  
            while ((allLine = bufferedReader.readLine()) != null) {  
                allLine = allLine.trim();  
                strLine = allLine;  
                Pattern p;  
                Matcher m;  
                p = Pattern.compile("\\["+section+"\\]");  
                m = p.matcher((strLine));  
                if (m.matches()) {  
                    p = Pattern.compile("\\["+section+"\\]");  
                    m = p.matcher(strLine);  
                    if (m.matches()) {  
                        isInSection = true;  
                    } else {  
                        isInSection = false;  
                    }  
                }  
                if (isInSection == true) {  
                    strLine = strLine.trim();  
                    String[] strArray = strLine.split("=");  
                    getValue = strArray[0].trim();  
                    if (getValue.equalsIgnoreCase(variable)) {  
                        newLine = getValue + " = " + value + " ";  
                        fileContent += newLine + "\r\n";  
                        while((allLine = bufferedReader.readLine())!= null){  
                            fileContent += allLine + "\r\n";  
                        }  
                        bufferedReader.close();  
                        BufferedWriter bufferedWriter
                            = new BufferedWriter(new FileWriter(file, false));  
                        bufferedWriter.write(fileContent);  
                        bufferedWriter.flush();  
                        bufferedWriter.close();  
  
                        return true;  
                    }  
                }  
                fileContent += allLine + "\r\n";  
            }  
        } catch (IOException ex) {  
            throw ex;  
        } finally {  
            bufferedReader.close();  
        }  
        return false;  
    }  
}  
```
测试程序：
```java
    // 修改ini值
    public static void main(String[] args) {  
        try {  
            javaReadIniUtil.setProfileString(
                            "resource/ra2.ini",
                            "MultiPlayer", 
                            "GameMode",
                            "mr_bird"));  
        } catch (IOException e) {  
           e.printStackTrace();   
        }  
    } 
```
值已被改变：
```xml
[MultiPlayer]
PreferredGameTypeID = 111111
PreferredScenarioIndex=0
Locale=0
StoreNick=yes
PortBase=1255
PortPool=9415
PhoneIndex=-1
WOLLimitResolution=no
LastNickSlot=-1
Handle=5b,4e,65,77,20,50,6c,61,79,65,72,5d,
Color=2
ColorEx=-1
Side=Americans
SideEx=-1
GameMode = mr_bird 
```
读取[MultiPlayer]的GameMode变量值
```java
public static void main(String[] args) { 
 try { 
    System.out.println( 
        readIniUtil.getProfileString(
                "resource/ra2.ini",
                "MultiPlayer", 
                "GameMode", 
                "default"));  //mr_bird
 } catch (IOException e) { 
    e.printStackTrace(); 
     } 
}﻿​
```