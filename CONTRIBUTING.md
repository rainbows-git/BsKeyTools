# 🤝 贡献指南

欢迎参与 BsKeyTools 的开发！无论是报告问题、分享脚本还是提交代码，我们都非常感谢。

## 🚀 快速导航

| 贡献方式 | 难度 | 说明 |
|---------|:----:|------|
| [🐞 报告 Bug](#-报告-bug) | ⭐ | 发现问题？告诉我们 |
| [💡 功能建议](#-功能建议) | ⭐ | 有好想法？提出来 |
| [📦 添加脚本](#-添加脚本) | ⭐⭐ | 分享你的脚本到 BsScriptHub |
| [🔧 提交代码](#-提交代码) | ⭐⭐⭐ | 直接贡献代码 |

---

## 🐞 报告 Bug

**[→ 点击这里提交 Bug](https://github.com/AniBullet/BsKeyTools/issues/new?template=bug_report.md)**

请包含：问题描述、复现步骤、环境信息（3ds Max 版本 + Windows 版本）、截图/报错。

## 💡 功能建议

**[→ 点击这里提交建议](https://github.com/AniBullet/BsKeyTools/issues/new?template=feature_request.md)**

请说明想要什么功能、解决什么问题。

---

## 📦 添加脚本

### 两种脚本类型

| 类型 | 说明 | script 字段示例 |
|-----|------|----------------|
| 🟢 **真实脚本** | 脚本文件在 BsScriptHub 内 | `"MyTool.ms"` |
| 🔵 **包装脚本** | 引用 BulletScripts 中的脚本，自动从仓库获取最新版 | `"BulletScripts/Quote/Tool.ms"` |

> 💡 **识别规则**：`script` 字段以 `BulletScripts/` 开头即为包装脚本。

### 添加流程

<details>
<summary><b>步骤 1️⃣：创建文件</b></summary>

**真实脚本**（需要 `.ms` + `.json`）：
```
BsScriptHub/02_建模工具/
├── MyTool.ms
└── MyTool.json
```

**包装脚本**（只需 `.json`）：
```
BsScriptHub/08_镜头相关/
└── 构图辅助.json
```
</details>

<details>
<summary><b>步骤 2️⃣：编写 JSON 配置</b></summary>

**真实脚本示例：**
```json
{
    "name": "我的工具",
    "version": "1.0.0",
    "description": "工具描述",
    "author": "你的名字",
    "script": "MyTool.ms"
}
```

**包装脚本示例：**
```json
{
    "name": "构图辅助",
    "version": "1.1.1",
    "description": "构图工具",
    "author": "原作者",
    "script": "BulletScripts/Quote/ImageCompHelper.ms"
}
```

**字段说明：**

| 字段 | 必填 | 说明 |
|-----|:---:|-----|
| `name` | ✓ | 脚本显示名称 |
| `version` | ✓ | 版本号（如 1.0.0） |
| `description` | ✓ | 功能描述 |
| `author` | ✓ | 原作者 |
| `script` | ✓ | 脚本路径（见上方类型说明） |
| `keywords` | | 搜索关键词数组 |
| `preview` | | 预览图文件名 |
| `url` / `tutorial` | | 链接地址 |

</details>

<details>
<summary><b>步骤 3️⃣：提交到 dev 分支</b></summary>

按照[提交代码](#-提交代码)流程提交到 `dev` 分支。

> 💡 **索引自动更新**：提交后 GitHub Actions 会自动运行 `generate_index.py` 更新索引，无需手动操作。

> 💡 **本地测试**（可选）：如果想在本地预览效果，可运行：
> ```bash
> cd _BsKeyTools/Scripts/BsScriptHub
> python generate_index.py
> ```

> 💡 分类文件夹格式：`数字_名称`（如 `01_选择工具`），显示时自动去掉数字。

</details>

---

## 🔧 提交代码

### 🚀 快速开始（推荐）

使用一键脚本自动化整个流程：

1. 下载项目根目录的 `setup-contribute.ps1`
2. 右键 → **使用 PowerShell 运行**
3. 按提示输入 GitHub 用户名、分支名、提交信息

> 💡 首次运行可能需要设置执行策略：`Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

### 📝 手动提交（详细步骤）

<details>
<summary><b>前置准备：安装 Git 和注册 GitHub</b></summary>

**安装 Git：**
- 官方：https://git-scm.com/download/win
- 国内镜像：https://mirrors.tuna.tsinghua.edu.cn/git-for-windows/
- 安装后在命令行输入 `git --version` 验证

**注册 GitHub：**
- 访问 https://github.com 注册账号
- 可选：配置 [SSH 密钥](https://docs.github.com/authentication/connecting-to-github-with-ssh) 实现免密提交

</details>

<details>
<summary><b>步骤 1️⃣：Fork 并 Clone 仓库</b></summary>

```bash
# 在 GitHub 上点击 Fork 按钮，然后：
git clone https://github.com/你的用户名/BsKeyTools.git
cd BsKeyTools
git remote add upstream https://github.com/AniBullet/BsKeyTools.git
git config --global user.name "你的名字"
git config --global user.email "你的邮箱"
```

</details>

<details>
<summary><b>步骤 2️⃣：创建分支并修改</b></summary>

```bash
# 创建新分支
git checkout dev
git pull upstream dev
git checkout -b feature/你的功能名  # 或 fix/修复说明

# 修改代码后提交
git add .
git commit -m "feat: 你的修改说明"
git push origin feature/你的功能名
```

**提交信息格式：**

| 类型 | 前缀 | 示例 |
|-----|------|------|
| 新功能 | `feat:` | `feat: 添加批量导出功能` |
| Bug修复 | `fix:` | `fix: 修复时间轴同步问题` |
| 文档 | `docs:` | `docs: 更新安装说明` |
| 重构 | `refactor:` | `refactor: 优化函数结构` |

> ⚠️ 首次推送需要 [Personal Access Token](https://github.com/settings/tokens)（勾选 `repo` 权限），不是登录密码！

</details>

<details>
<summary><b>步骤 3️⃣：创建 Pull Request</b></summary>

1. 打开你的仓库：`https://github.com/你的用户名/BsKeyTools`
2. 点击 **Compare & pull request**
3. **重要**：确保 base 是 `dev` 分支（不是 main！）
4. 填写描述并提交

</details>

### ❓ 常见问题

<details>
<summary><b>Q: Git 相关错误</b></summary>

- **"git: command not found"**: Git 未安装或未加入 PATH
- **"Permission denied"**: 检查仓库地址或配置 SSH
- **"Authentication failed"**: 使用 Personal Access Token，不是密码

</details>

<details>
<summary><b>Q: 如何同步上游最新代码？</b></summary>

```bash
git checkout dev
git pull upstream dev
git push origin dev
```

</details>

<details>
<summary><b>Q: 如何修改已提交的代码？</b></summary>

```bash
git add .
git commit --amend -m "新提交信息"
git push origin 分支名 --force  # ⚠️ 谨慎使用
```

</details>

<details>
<summary><b>Q: 如何撤销/删除？</b></summary>

```bash
# 撤销本地修改
git checkout .

# 删除分支
git branch -d 分支名                  # 本地
git push origin --delete 分支名       # 远程
```

</details>

---

## ✅ 提交检查清单

- [ ] 代码在 3ds Max 中测试通过
- [ ] PR 目标分支是 `dev`
- [ ] 提交信息符合规范（`feat:` / `fix:` / `docs:` 等）
- [ ] 没有提交临时文件或敏感信息

---

## 📮 需要帮助？

- **QQ 群**：[993590655](https://jq.qq.com/?_wv=1027&k=hmeHhTwu) / [907481113](https://qm.qq.com/q/FZ2gBKJeYE)
- **GitHub Issues**：[提问/讨论](https://github.com/AniBullet/BsKeyTools/issues)

---

<details>
<summary><b>👨‍💼 维护者指南（审核 PR）</b></summary>

### 审核流程

1. **查看变更**：PR 页面 → Files changed 标签
2. **沟通反馈**：在代码行或 Conversation 中留言
3. **合并 PR**：

```bash
# 方法 A：GitHub 网页（推荐）
# 点击 Merge pull request → Confirm merge

# 方法 B：GitHub CLI
gh pr list
gh pr view <PR编号>
gh pr merge <PR编号> --merge  # 或 --squash

# 方法 C：命令行
git fetch origin pull/<PR编号>/head:pr-test
git checkout pr-test
# 测试后
git checkout dev
git merge pr-test
git push origin dev
```

### 审核检查

- [ ] 代码逻辑正确
- [ ] 目标分支是 `dev`
- [ ] 提交信息符合规范
- [ ] 无敏感信息

</details>

---

**感谢你的贡献！** 🎉
