# 数据存储路径修改说明

## 修改内容

已将数据文件存储路径从硬编码的绝对路径改为动态路径，支持 war 包部署到任意 Tomcat 环境。

## 修改的文件

### 1. DataFileUtil.java
- 移除硬编码路径 `D:\prototype\...`
- 添加 `initDataDir(String webAppPath)` 方法
- 数据文件现在存储在 `webapp/data/` 目录下

### 2. 所有 Servlet（6个）
- LoginServlet.java
- RegisterServlet.java
- PostJobServlet.java
- ApplyJobServlet.java
- UpdateApplicationStatusServlet.java
- UpdateProfileServlet.java

每个 Servlet 的 doPost 方法开头添加：
```java
DataFileUtil.initDataDir(getServletContext().getRealPath("/"));
```

### 3. 所有 JSP 页面（8个）
- student-dashboard.jsp
- student-jobs.jsp
- student-apply.jsp
- student-applications.jsp
- mo-dashboard.jsp
- mo-applications.jsp
- admin-dashboard.jsp
- admin-workload.jsp

每个 JSP 页面开头添加：
```jsp
DataFileUtil.initDataDir(application.getRealPath("/"));
```

### 4. 新增 DataInitListener.java
- 自动初始化数据目录
- 首次部署时创建默认数据文件
- 包含默认测试账号

## 部署方式

### 方式1：直接打包部署（推荐）

1. 打包 war 文件：
```bash
mvn clean package
```

2. 将生成的 `ta-recruitment-system.war` 复制到 Tomcat 的 `webapps` 目录

3. 启动 Tomcat，war 会自动解压

4. 数据文件会自动创建在：
```
tomcat/webapps/ta-recruitment-system/data/
```

### 方式2：保留现有数据

如果想保留当前的数据文件：

1. 先复制现有数据文件：
```
data/users.txt
data/staff_ids.txt
data/jobs.txt
data/applications.txt
```

2. 打包并部署 war

3. 将数据文件复制到：
```
tomcat/webapps/ta-recruitment-system/data/
```

## 默认测试账号

系统会自动创建以下测试账号：

| 角色 | 邮箱 | 密码 | 姓名 |
|------|------|------|------|
| Student | student@bupt.edu.cn | 123456 | Zhang San |
| Module Organiser | mo@bupt.edu.cn | 123456 | Li Si |
| Admin | admin@bupt.edu.cn | 123456 | Wang Wu |

Module Organiser registration requires a school-issued staff ID from `staff_ids.txt`.
Default valid staff IDs include `T1001`, `T1002`, and `T1003`.

## 数据文件位置

部署后，数据文件位于：
```
<TOMCAT_HOME>/webapps/ta-recruitment-system/data/
- users.txt
- staff_ids.txt
- jobs.txt
- applications.txt
```

## 注意事项

1. **数据持久化**：重新部署 war 包会覆盖数据文件，建议先备份
2. **权限问题**：确保 Tomcat 有权限在 webapps 目录下创建文件
3. **跨平台**：使用 `File.separator` 确保在 Windows/Linux/Mac 都能正常运行
4. **首次启动**：如果 data 目录不存在，会自动创建并初始化

## 验证部署

1. 启动 Tomcat
2. 访问 `http://localhost:8080/ta-recruitment-system/`
3. 使用测试账号登录
4. 检查 Tomcat 日志，应该看到：
```
Data directory initialized at: <path>/webapps/ta-recruitment-system/data/
```

## 故障排查

### 问题1：找不到数据文件
- 检查 Tomcat 日志中的数据目录路径
- 确认 data 目录已创建
- 检查文件权限

### 问题2：数据无法保存
- 检查 Tomcat 用户是否有写权限
- 查看 Tomcat 日志中的错误信息

### 问题3：重新部署后数据丢失
- 部署前备份 data 目录
- 或使用外部数据库替代文件存储
