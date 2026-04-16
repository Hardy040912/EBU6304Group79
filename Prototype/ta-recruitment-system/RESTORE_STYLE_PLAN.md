# 恢复原型样式计划

## 目标

将当前简化版的JSP页面恢复为原型的精美样式，同时保留V3的数据读取功能。

## 文件状态

### 当前文件
- `student-dashboard.jsp` - 简化版（201行）
- `mo-dashboard.jsp` - 简化版（158行）
- `admin-dashboard.jsp` - 简化版（158行）
- `student-dashboard-backup.jsp` - 原型样式备份（511行）✅

## 恢复方案

### 方案1：手动恢复（推荐）

#### 步骤1：恢复student-dashboard.jsp

```bash
# 1. 备份当前简化版（保留数据读取代码）
copy src\main\webapp\student-dashboard.jsp src\main\webapp\student-dashboard-v3-simple.jsp

# 2. 用backup替换当前文件
copy src\main\webapp\student-dashboard-backup.jsp src\main\webapp\student-dashboard.jsp

# 3. 手动添加数据读取代码到文件开头
```

在 `student-dashboard.jsp` 第1行后添加：
```jsp
<%@ page import="cn.bupt.ta.util.FileUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    // 检查登录状态
    String userEmail = (String) session.getAttribute("userEmail");
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    
    if (userEmail == null || !"student".equals(userRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    // 初始化数据
    FileUtil.initDefaultData(application.getRealPath("/"));
    
    // 读取职位数据
    List<String> jobLines = FileUtil.readAllLines("jobs.txt");
    List<String[]> jobs = new ArrayList<>();
    for (String line : jobLines) {
        if (line.startsWith("#") || line.trim().isEmpty()) continue;
        String[] parts = line.split("\\|");
        if (parts.length >= 11) jobs.add(parts);
    }
    
    // 读取申请数据
    List<String> appLines = FileUtil.readAllLines("applications.txt");
    List<String[]> myApplications = new ArrayList<>();
    for (String line : appLines) {
        if (line.startsWith("#") || line.trim().isEmpty()) continue;
        String[] parts = line.split("\\|");
        if (parts.length >= 7 && parts[2].equals(userEmail)) {
            myApplications.add(parts);
        }
    }
    
    int activeApplications = myApplications.size();
    int pendingCount = 0;
    for (String[] app : myApplications) {
        if ("pending".equals(app[5])) pendingCount++;
    }
%>
```

然后修改显示数据的地方：
- 第274行：`<p>Welcome, Alice Chen</p>` → `<p>Welcome, <%= userName %></p>`
- 第302行：`<div class="card-value">3</div>` → `<div class="card-value"><%= activeApplications %></div>`
- 第303行：`<p class="card-description">2 pending review</p>` → `<p class="card-description"><%= pendingCount %> pending review</p>`

#### 步骤2：恢复mo-dashboard.jsp和admin-dashboard.jsp

由于没有这两个文件的backup，需要：

**选项A：从Git恢复**
```bash
git checkout HEAD~5 -- src/main/webapp/mo-dashboard.jsp
git checkout HEAD~5 -- src/main/webapp/admin-dashboard.jsp
```

**选项B：从原型重新转换**
参考 `software_net(1)` 目录下的原型文件重新转换。

### 方案2：使用工具恢复（如果可以）

由于之前遇到文件系统问题，这个方案可能不可行。

## 需要修改的具体位置

### student-dashboard.jsp

**数据显示位置：**
1. 第274行：用户名
2. 第290行：工作量（暂时保持硬编码）
3. 第302行：申请数量
4. 第303行：待审核数量
5. 第338-410行：职位列表（需要改为循环）
6. 第420-470行：申请列表（需要改为循环）

### mo-dashboard.jsp

**需要从文件读取：**
1. 我的职位列表（过滤organiserId）
2. 申请列表（匹配jobId）
3. 统计数据

### admin-dashboard.jsp

**需要从文件读取：**
1. 所有学生列表
2. 所有职位列表
3. 所有申请列表
4. 系统统计数据

## 验证清单

恢复完成后检查：

- [ ] 页面样式与原型一致
- [ ] 所有CSS效果正常（阴影、过渡、hover等）
- [ ] 数据从文件正确读取
- [ ] 申请功能正常工作
- [ ] 统计数据正确显示
- [ ] 页面跳转正常
- [ ] 无JavaScript错误

## 时间估算

- student-dashboard.jsp：30分钟
- mo-dashboard.jsp：45分钟（需要从Git或原型恢复）
- admin-dashboard.jsp：45分钟（需要从Git或原型恢复）
- 测试验证：30分钟

**总计：约2.5小时**

## 建议

1. **优先恢复student-dashboard.jsp**，因为有完整的backup
2. **尝试从Git恢复mo和admin**，如果之前有提交
3. 如果Git没有，需要从原型重新转换这两个页面
4. 每恢复一个页面就测试一次，确保功能正常

## 我可以帮助的

由于文件系统限制，我无法直接修改文件，但我可以：
1. 提供完整的代码片段
2. 指出需要修改的具体行号
3. 提供数据读取的Java代码
4. 解答任何技术问题

你想从哪个页面开始恢复？
