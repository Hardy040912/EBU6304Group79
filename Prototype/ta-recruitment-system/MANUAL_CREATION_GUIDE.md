# 手动创建MO和Admin Dashboard说明

## 问题说明

由于文件系统缓存问题，无法通过工具直接创建 `mo-dashboard.jsp` 和 `admin-dashboard.jsp`。

## 解决方案

我已经将完整代码保存到以下文件：

1. **MO-DASHBOARD-CODE.txt** - MO Dashboard完整代码
2. **ADMIN-DASHBOARD-CODE.txt** - Admin Dashboard完整代码

## 手动创建步骤

### 方法1：复制粘贴（推荐）

1. 打开 `MO-DASHBOARD-CODE.txt`
2. 复制全部内容
3. 在 `src/main/webapp/` 目录下创建新文件 `mo-dashboard.jsp`
4. 粘贴内容并保存

5. 打开 `ADMIN-DASHBOARD-CODE.txt`
6. 复制全部内容
7. 在 `src/main/webapp/` 目录下创建新文件 `admin-dashboard.jsp`
8. 粘贴内容并保存

### 方法2：使用命令行

```bash
cd D:\prototype\EBU6304Group79\Prototype\ta-recruitment-system

# 复制MO Dashboard
copy MO-DASHBOARD-CODE.txt src\main\webapp\mo-dashboard.jsp

# 复制Admin Dashboard
copy ADMIN-DASHBOARD-CODE.txt src\main\webapp\admin-dashboard.jsp
```

### 方法3：使用IDE

1. 在IDE中右键 `src/main/webapp/` 文件夹
2. 选择 New → File
3. 文件名：`mo-dashboard.jsp`
4. 打开 `MO-DASHBOARD-CODE.txt`，复制内容到新文件
5. 保存

6. 重复步骤创建 `admin-dashboard.jsp`

## 创建后验证

创建完成后，检查文件是否存在：

```
src/main/webapp/
├── index.jsp
├── register.jsp
├── student-dashboard.jsp
├── mo-dashboard.jsp          ← 新创建
├── admin-dashboard.jsp       ← 新创建
└── data-location.jsp
```

## 功能说明

### mo-dashboard.jsp
- ✅ 从 jobs.txt 读取我的职位（根据organiserId过滤）
- ✅ 从 applications.txt 读取申请（根据jobId匹配）
- ✅ Create Job 表单提交到 JobServlet
- ✅ Accept/Reject 按钮提交到 ApplicationServlet
- ✅ 显示统计数据：活跃职位、待审核申请、已接受TA

### admin-dashboard.jsp
- ✅ 从 users.txt 读取所有学生
- ✅ 从 jobs.txt 读取所有职位
- ✅ 从 applications.txt 读取所有申请
- ✅ 显示系统统计：学生数、职位数、申请数、待审核数
- ✅ 4个标签页：Overview, Students, Jobs, Applications
- ✅ 显示最近活动记录

## 测试步骤

### 测试MO Dashboard

1. 用MO账号登录：`dr.smith@bupt.edu.cn / 123456`
2. 应该看到：
   - 2个活跃职位
   - 待审核申请数量
   - 已接受TA数量
3. 点击 "Create Job" 创建新职位
4. 切换到 Applications 标签
5. 点击 Accept/Reject 按钮更新申请状态

### 测试Admin Dashboard

1. 用管理员账号登录：`admin@bupt.edu.cn / 123456`
2. 应该看到：
   - 所有学生数量
   - 所有职位数量
   - 所有申请数量
   - 待审核数量
3. 切换各个标签页查看详细信息

## 完成后删除

创建完成并验证无误后，可以删除这两个临时文件：

```bash
del MO-DASHBOARD-CODE.txt
del ADMIN-DASHBOARD-CODE.txt
```

## Git提交

创建完成后提交：

```bash
git add src/main/webapp/mo-dashboard.jsp
git add src/main/webapp/admin-dashboard.jsp
git commit -m "V3: 添加MO和Admin Dashboard从文件读取数据"
```

## 总结

完成这两个文件后，V3版本就100%完成了！

- ✅ 文件存储系统
- ✅ 注册登录
- ✅ 学生Dashboard
- ✅ MO Dashboard（手动创建）
- ✅ Admin Dashboard（手动创建）

所有功能都从文件读取真实数据！
