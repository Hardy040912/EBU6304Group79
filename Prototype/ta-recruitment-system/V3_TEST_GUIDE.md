# V3 版本测试指南

## 快速测试步骤

### 1. 编译项目
在项目根目录执行：
```bash
mvn clean package
```

### 2. 部署
将 `target/ta-recruitment-system.war` 部署到 Tomcat

### 3. 测试账号
- 学生：`alice.chen@bupt.edu.cn` / `123456`
- MO：`dr.smith@bupt.edu.cn` / `123456`
- 管理员：`admin@bupt.edu.cn` / `123456`

## 功能测试清单

### ✅ 登录功能
- [ ] 使用正确账号密码登录成功
- [ ] 使用错误账号密码显示错误提示
- [ ] 不同角色跳转到对应 Dashboard

### ✅ 学生功能
- [ ] Dashboard 显示统计信息
- [ ] 点击 "Browse Jobs" 查看岗位列表
- [ ] 点击 "Apply Now" 进入申请页面
- [ ] 填写 Cover Letter 提交申请
- [ ] 在 "My Applications" 查看申请状态
- [ ] 访问 "Profile & CV" 页面

### ✅ MO 功能
- [ ] Dashboard 显示统计信息
- [ ] 点击 "Post New Job" 发布新岗位
- [ ] 填写岗位信息并提交
- [ ] 点击 "View Applications" 查看申请
- [ ] 接受或拒绝申请

### ✅ 管理员功能
- [ ] Dashboard 显示系统统计
- [ ] 点击 "View Workload" 查看工作量
- [ ] 查看所有 TA 的工作时长统计

### ✅ 数据持久化
- [ ] 发布的岗位保存到 `data/jobs.txt`
- [ ] 提交的申请保存到 `data/applications.txt`
- [ ] 注册的用户保存到 `data/users.txt`
- [ ] 重启服务器后数据不丢失

## 页面列表（11个）

1. `index.jsp` - 登录页
2. `register.jsp` - 注册页
3. `student-dashboard.jsp` - 学生 Dashboard
4. `student-jobs.jsp` - 岗位列表
5. `student-apply.jsp` - 申请岗位
6. `student-applications.jsp` - 我的申请
7. `student-profile.jsp` - 个人资料
8. `mo-dashboard.jsp` - MO Dashboard
9. `mo-post-job.jsp` - 发布岗位
10. `mo-applications.jsp` - 查看申请
11. `admin-dashboard.jsp` - 管理员 Dashboard
12. `admin-workload.jsp` - 工作量统计

## 数据文件位置
`D:\prototype\EBU6304Group79\Prototype\ta-recruitment-system\data\`

- `users.txt` - 用户账号
- `jobs.txt` - 岗位信息
- `applications.txt` - 申请记录
