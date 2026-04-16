# V3 版本完成状态

## 完成时间
2024年

## V3 版本要求完成情况

### ✅ 1. 技术栈要求
- ✅ JSP + Servlet
- ✅ 数据使用文本文件（txt）
- ✅ 禁止数据库
- ✅ 禁止 Spring Boot / Vite / Vue / React

### ✅ 2. 所有页面已完成（11个页面）

#### 学生 TA 页面（6个）
1. ✅ `index.jsp` - 登录页
2. ✅ `student-dashboard.jsp` - 学生 Dashboard
3. ✅ `student-profile.jsp` - 简历上传页
4. ✅ `student-jobs.jsp` - 岗位列表页
5. ✅ `student-apply.jsp` - 岗位申请页
6. ✅ `student-applications.jsp` - 申请状态查看页

#### 课程负责人 MO 页面（3个）
7. ✅ `mo-dashboard.jsp` - MO Dashboard
8. ✅ `mo-post-job.jsp` - 发布岗位页
9. ✅ `mo-applications.jsp` - 查看申请者列表页

#### 管理员 Admin 页面（2个）
10. ✅ `admin-dashboard.jsp` - Admin Dashboard
11. ✅ `admin-workload.jsp` - 查看所有 TA 工作量页面

### ✅ 3. 功能实现

#### ① 页面跳转 100% 完整
- ✅ 登录 → 按角色进对应 Dashboard
  - `LoginServlet.java` 实现了角色验证和跳转
- ✅ 各个页面能正常跳转
  - 所有页面都有导航链接
  - Dashboard 有快速操作卡片
- ✅ 退出 → 返回登录
  - `LogoutServlet.java` 实现了登出功能

#### ② 表单能提交
- ✅ 简历上传页：能选文件、能提交
  - `student-profile.jsp` 实现了表单（演示模式）
- ✅ 发布岗位页：能填表单、能提交
  - `mo-post-job.jsp` + `PostJobServlet.java`
- ✅ 申请岗位页：能提交申请
  - `student-apply.jsp` + `ApplyJobServlet.java`

#### ③ 数据文件存储（V3 核心功能）
- ✅ 数据文件位置：`D:\prototype\EBU6304Group79\Prototype\ta-recruitment-system\data\`
- ✅ 三个数据文件：
  1. `users.txt` - 存账号角色
  2. `jobs.txt` - 存发布的岗位
  3. `applications.txt` - 存申请记录

- ✅ 数据读写功能：
  - `DataFileUtil.java` - 统一的文件读写工具类
  - 写入：表单提交 → 写到文件
  - 读取：页面打开 → 从文件读出来显示

### ✅ 4. Servlet 实现（7个）

1. ✅ `LoginServlet.java` - 登录验证（从 users.txt 读取）
2. ✅ `LogoutServlet.java` - 登出功能
3. ✅ `RegisterServlet.java` - 注册功能（写入 users.txt）
4. ✅ `PostJobServlet.java` - 发布岗位（写入 jobs.txt）
5. ✅ `ApplyJobServlet.java` - 申请岗位（写入 applications.txt）
6. ✅ `UpdateApplicationStatusServlet.java` - 更新申请状态
7. ✅ `DataFileUtil.java` - 数据文件工具类

### ✅ 5. 界面要求
- ✅ 所有 JSP 页面和原型 1:1 一样
- ✅ 文字、布局、数据展示位置相同
- ✅ 干净、能演示、不报错

### ✅ 6. 数据文件格式

#### users.txt
```
# 格式: email|password|role|name
alice.chen@bupt.edu.cn|123456|student|Alice Chen
dr.smith@bupt.edu.cn|123456|module-organiser|Dr. Smith
admin@bupt.edu.cn|123456|admin|Administrator
```

#### jobs.txt
```
# 格式: jobId|title|moduleCode|module|organiser|organiserId|description|skills|hoursPerWeek|duration|status
j1|Machine Learning Lab Assistant|CS401|Introduction to Machine Learning|Dr. Smith|dr.smith@bupt.edu.cn|Assist students with ML lab exercises|Python,Machine Learning,Teaching|8|12 weeks|open
```

#### applications.txt
```
# 格式: appId|jobId|studentEmail|studentName|coverLetter|status|applyDate
a1|j1|alice.chen@bupt.edu.cn|Alice Chen|I am interested in this position|pending|2024-03-20
```

## 如何编译和运行

### 编译项目
```bash
cd D:\prototype\EBU6304Group79\Prototype\ta-recruitment-system
mvn clean package
```

### 部署到 Tomcat
1. 将生成的 `target/ta-recruitment-system.war` 复制到 Tomcat 的 `webapps` 目录
2. 启动 Tomcat
3. 访问 `http://localhost:8080/ta-recruitment-system/`

### 测试账号
- 学生：alice.chen@bupt.edu.cn / 123456
- MO：dr.smith@bupt.edu.cn / 123456
- 管理员：admin@bupt.edu.cn / 123456

## 功能演示流程

### 学生流程
1. 登录 → 学生 Dashboard
2. 点击 "Browse Jobs" → 查看岗位列表
3. 点击 "Apply Now" → 填写申请表
4. 提交申请 → 查看申请状态

### MO 流程
1. 登录 → MO Dashboard
2. 点击 "Post New Job" → 填写岗位信息
3. 提交岗位 → 岗位发布成功
4. 点击 "View Applications" → 查看申请者
5. 接受/拒绝申请

### 管理员流程
1. 登录 → Admin Dashboard
2. 点击 "View Workload" → 查看所有 TA 工作量
3. 查看工作量统计和警告

## GitHub 提交建议

建议按以下顺序提交：

### Commit 1: 添加数据文件工具类
```bash
git add src/main/java/cn/bupt/ta/util/DataFileUtil.java
git commit -m "V3: 添加数据文件读写工具类"
```

### Commit 2: 更新 Servlet 支持文件读写
```bash
git add src/main/java/cn/bupt/ta/servlet/LoginServlet.java
git add src/main/java/cn/bupt/ta/servlet/RegisterServlet.java
git commit -m "V3: 更新登录和注册 Servlet 支持文件验证"
```

### Commit 3: 添加学生端页面
```bash
git add src/main/webapp/student-jobs.jsp
git add src/main/webapp/student-apply.jsp
git add src/main/webapp/student-applications.jsp
git add src/main/webapp/student-profile.jsp
git add src/main/java/cn/bupt/ta/servlet/ApplyJobServlet.java
git commit -m "V3: 完成学生端所有页面和功能"
```

### Commit 4: 添加 MO 端页面
```bash
git add src/main/webapp/mo-post-job.jsp
git add src/main/webapp/mo-applications.jsp
git add src/main/java/cn/bupt/ta/servlet/PostJobServlet.java
git add src/main/java/cn/bupt/ta/servlet/UpdateApplicationStatusServlet.java
git commit -m "V3: 完成 MO 端所有页面和功能"
```

### Commit 5: 添加管理员页面
```bash
git add src/main/webapp/admin-workload.jsp
git commit -m "V3: 完成管理员工作量查看页面"
```

### Commit 6: 更新 Dashboard 页面
```bash
git add src/main/webapp/student-dashboard.jsp
git add src/main/webapp/mo-dashboard.jsp
git add src/main/webapp/admin-dashboard.jsp
git add src/main/webapp/index.jsp
git commit -m "V3: 更新所有 Dashboard 添加快速操作链接"
```

## V3 版本特点

1. **完全符合要求**：使用 JSP + Servlet + 文本文件，无数据库
2. **功能完整**：所有 11 个页面全部实现
3. **数据持久化**：所有数据保存在 data 目录，重启不丢失
4. **页面跳转完整**：所有页面都能正常跳转
5. **表单提交可用**：发布岗位、申请岗位、注册等功能都能正常工作
6. **界面美观**：保持原型设计风格

## 注意事项

1. 数据文件路径是绝对路径：`D:\prototype\EBU6304Group79\Prototype\ta-recruitment-system\data\`
2. 如果部署到其他环境，需要修改 `DataFileUtil.java` 中的 `DATA_DIR` 常量
3. 简历上传功能为演示模式，实际文件上传未实现（V3 不要求）
4. 所有功能都已测试，可以正常运行

## 完成状态：100% ✅

所有 V3 要求的功能都已完成！
