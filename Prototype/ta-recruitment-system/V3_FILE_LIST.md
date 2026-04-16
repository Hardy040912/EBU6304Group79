# V3 版本文件清单

## 新增文件

### Java 类（8个）

#### 工具类
1. `src/main/java/cn/bupt/ta/util/DataFileUtil.java` - 数据文件读写工具类

#### Servlet
2. `src/main/java/cn/bupt/ta/servlet/PostJobServlet.java` - 发布岗位
3. `src/main/java/cn/bupt/ta/servlet/ApplyJobServlet.java` - 申请岗位
4. `src/main/java/cn/bupt/ta/servlet/UpdateApplicationStatusServlet.java` - 更新申请状态

### JSP 页面（6个）

#### 学生页面
5. `src/main/webapp/student-jobs.jsp` - 岗位列表页
6. `src/main/webapp/student-apply.jsp` - 岗位申请页
7. `src/main/webapp/student-applications.jsp` - 申请状态查看页
8. `src/main/webapp/student-profile.jsp` - 简历上传页

#### MO 页面
9. `src/main/webapp/mo-post-job.jsp` - 发布岗位页
10. `src/main/webapp/mo-applications.jsp` - 查看申请者列表页

#### 管理员页面
11. `src/main/webapp/admin-workload.jsp` - 查看所有 TA 工作量页面

### 文档
12. `V3_COMPLETION_REPORT.md` - V3 完成报告
13. `V3_TEST_GUIDE.md` - V3 测试指南
14. `V3_FILE_LIST.md` - 本文件

## 修改的文件（5个）

1. `src/main/java/cn/bupt/ta/servlet/LoginServlet.java`
   - 添加了从 users.txt 读取用户信息
   - 添加了密码验证
   - 添加了登录失败跳转

2. `src/main/java/cn/bupt/ta/servlet/RegisterServlet.java`
   - 添加了将用户信息写入 users.txt
   - 添加了字符编码设置

3. `src/main/webapp/index.jsp`
   - 添加了登录错误提示

4. `src/main/webapp/student-dashboard.jsp`
   - 添加了快速操作卡片（Browse Jobs, My Applications, Profile & CV）

5. `src/main/webapp/mo-dashboard.jsp`
   - 添加了快速操作卡片（Post New Job, View Applications）

6. `src/main/webapp/admin-dashboard.jsp`
   - 添加了快速操作卡片（View Workload）

## 数据文件（已存在）

位置：`D:\prototype\EBU6304Group79\Prototype\ta-recruitment-system\data\`

1. `data/users.txt` - 用户账号数据
2. `data/jobs.txt` - 岗位信息数据
3. `data/applications.txt` - 申请记录数据

## 文件统计

- 新增 Java 类：4 个
- 新增 JSP 页面：7 个
- 修改的文件：6 个
- 文档文件：3 个
- **总计：20 个文件**

## 代码行数统计（估算）

- Java 代码：约 500 行
- JSP 页面：约 1500 行
- 总计：约 2000 行

## 目录结构

```
ta-recruitment-system/
├── src/
│   └── main/
│       ├── java/
│       │   └── cn/
│       │       └── bupt/
│       │           └── ta/
│       │               ├── servlet/
│       │               │   ├── LoginServlet.java (修改)
│       │               │   ├── LogoutServlet.java
│       │               │   ├── RegisterServlet.java (修改)
│       │               │   ├── PostJobServlet.java (新增)
│       │               │   ├── ApplyJobServlet.java (新增)
│       │               │   └── UpdateApplicationStatusServlet.java (新增)
│       │               └── util/
│       │                   └── DataFileUtil.java (新增)
│       └── webapp/
│           ├── WEB-INF/
│           │   └── web.xml
│           ├── css/
│           │   └── theme.css
│           ├── index.jsp (修改)
│           ├── register.jsp
│           ├── student-dashboard.jsp (修改)
│           ├── student-jobs.jsp (新增)
│           ├── student-apply.jsp (新增)
│           ├── student-applications.jsp (新增)
│           ├── student-profile.jsp (新增)
│           ├── mo-dashboard.jsp (修改)
│           ├── mo-post-job.jsp (新增)
│           ├── mo-applications.jsp (新增)
│           ├── admin-dashboard.jsp (修改)
│           └── admin-workload.jsp (新增)
├── data/
│   ├── users.txt
│   ├── jobs.txt
│   └── applications.txt
├── pom.xml
├── V3_COMPLETION_REPORT.md (新增)
├── V3_TEST_GUIDE.md (新增)
└── V3_FILE_LIST.md (新增)
```

## Git 提交建议

按功能模块分 6 次提交：

1. **Commit 1**: 数据工具类
2. **Commit 2**: Servlet 更新
3. **Commit 3**: 学生端页面
4. **Commit 4**: MO 端页面
5. **Commit 5**: 管理员页面
6. **Commit 6**: Dashboard 更新

详细提交命令见 `V3_COMPLETION_REPORT.md`
