# yuhang.live — 个人学术主页与 CV

Hexo + Academia 主题，构建产物由 GitHub Actions 自动发布到 GitHub Pages，域名 `yuhang.live`。

## 站点结构

```
source/_posts/index.md     主页全部内容（单页 CV，改这一个文件即可）
themes/academia/           主题，_config.yml 管侧栏签名、菜单、下载入口
.github/workflows/deploy.yml  推送到 src 分支即自动构建并发布
```

站点上**不提供简历下载**（`cv_dl.enable: false`，`source/attaches/` 不存在的状态）。

简历的排版源码（`cv/cv.html`）和生成脚本（`bin/build-cv.sh`）**不在本仓库**，
已移到本机 `~/WorkBuddy/求职/简历与材料/`，避免 PDF 与简历正文随公开仓库外泄。

## 改内容

1. 编辑 `source/_posts/index.md`（论文、项目、教育经历都在这里）。
2. 本地预览：`npx hexo clean && npx hexo server`，打开 http://localhost:4000
3. 提交并推送，剩下的交给 Actions：

```bash
git add -A && git commit -m "update: 说明改了什么" && git push
```

推送到 `src` 后，Actions 会构建并把产物推到 `master`，Pages 从 `master` 发布。
一般 2 分钟内生效，进度看 <https://github.com/YuleYu/YuleYu.github.io/actions>。

## 改 CV（PDF）

简历工具链不在本仓库，在 `~/WorkBuddy/求职/简历与材料/`：

```
cv/cv.html           A4 打印版排版
bin/build-cv.sh      从 cv.html 生成 build-cv/CV.pdf
```

改完 `cv.html` 后在该目录运行：

```bash
bash bin/build-cv.sh      # 输出 build-cv/CV.pdf，留在本机
```

PDF 依赖本机 Google Chrome 的 headless 打印，脚本已带 `--no-sandbox` 与独立 profile，
避免在受限环境或 Chrome 已开启时崩溃。

**简历默认不上线。** 要公开下载入口得手动做两步，且两步都要本人确认后再做：

1. `cp ~/WorkBuddy/求职/简历与材料/build-cv/CV.pdf source/attaches/CV.pdf`
2. `themes/academia/_config.yml` 里 `cv_dl.enable: true`

`source/attaches/CV.pdf` 与 `build-cv/` 都写在 `.gitignore` 里，不会误提交。

## 几个坑（都踩过了）

- **`hexo deploy` 没有启用**，别再纠结 `deploy.type` 为空；发布由 Actions 负责。
- **`themes/academia/source/attaches/CV.pdf` 是主题自带的占位文件**（内容是一句测试文案），
  曾长期占用 `/attaches/CV.pdf` 这个 URL。已删除，同名文件请只放在 `source/attaches/`，
  因为主题的 `source` 会覆盖站点的同名文件。
- **不要改仓库的 Pages 发布源**（保持 `master` 分支）。切到 GitHub Actions 发布时
  自定义域名常被清空，`yuhang.live` 会短时无法访问。当前方案完全绕开了这个风险。
- 推送偶发 `CONNECT tunnel failed, response 502`，是代理抖动，重试即可。
- token 需要 `Contents` + `Workflows` 两项写权限，否则推不动 `.github/workflows/`。

## 域名

`yuhang.live` A 记录指向 GitHub Pages 四个 IP，`www` CNAME 到 `yuleyu.github.io`，
仓库根目录 `CNAME` 文件由 Actions 每次部署自动写入（`cname: yuhang.live`）。
