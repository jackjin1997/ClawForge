# 发布 DDD Skill 到 GitHub

## 发布步骤

### 方法一：通过 GitHub 网页创建仓库

1. **在 GitHub 上创建仓库**
   - 访问 https://github.com/new
   - 仓库名称：`ddd-skill`
   - 描述：`Domain-Driven Design modeling and architecture guidance skill for AI agents`
   - 设置为 **Public**（公开）
   - **不要**勾选 "Initialize this repository with a README"
   - 点击 "Create repository"

2. **添加远程仓库并推送**

   ```powershell
   cd "C:\Users\kuang\.claude\skills\ddd"
   
   # 添加远程仓库（替换 YOUR_USERNAME 为你的 GitHub 用户名）
   git remote add origin https://github.com/YOUR_USERNAME/ddd-skill.git
   
   # 推送代码
   git branch -M main
   git push -u origin main
   ```

3. **创建版本标签（可选但推荐）**

   ```powershell
   git tag -a v1.0.0 -m "DDD Skill v1.0.0 - Initial release"
   git push origin v1.0.0
   ```

### 方法二：安装 GitHub CLI 后自动创建

1. **安装 GitHub CLI**
   
   ```powershell
   # 使用 winget 安装
   winget install GitHub.cli
   
   # 或使用 scoop 安装
   scoop install gh
   ```

2. **登录 GitHub**
   
   ```powershell
   gh auth login
   ```

3. **创建仓库并推送**
   
   ```powershell
   cd "C:\Users\kuang\.claude\skills\ddd"
   gh repo create ddd-skill --public --description "Domain-Driven Design modeling and architecture guidance skill for AI agents" --source=. --push
   ```

## 安装技能

发布成功后，其他人可以通过以下方式安装：

```bash
# 通过 GitHub URL 安装
npx openskills install https://github.com/YOUR_USERNAME/ddd-skill.git

# 或简写形式
npx openskills install YOUR_USERNAME/ddd-skill
```

## 更新技能

修改文件后更新版本：

```powershell
# 1. 更新版本号（在 SKILL.md 和 package.json 中）

# 2. 提交更改
git add .
git commit -m "Update: version 1.0.1 - description of changes"

# 3. 创建新标签
git tag -a v1.0.1 -m "DDD Skill v1.0.1"

# 4. 推送
git push origin main
git push origin v1.0.1
```

## 验证发布

发布后访问以下地址验证：
- 仓库地址：`https://github.com/YOUR_USERNAME/ddd-skill`
- 确认 SKILL.md 文件存在
- 确认 README.md 正确显示
