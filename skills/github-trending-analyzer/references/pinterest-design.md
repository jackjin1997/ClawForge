# Pinterest Design System — HTML 输出规范

生成 GitHub Trending HTML 报告时，遵循此设计规范。HTML 必须是**单文件自包含**，所有 CSS 内联在 `<style>` 标签中，无外部依赖。

## Colors

```css
:root {
  --red: #e60023;            /* Pinterest Red — 仅用于主 CTA */
  --plum-black: #211922;     /* 主文字 — 暖色，不用纯黑 */
  --olive-gray: #62625b;     /* 二级文字 */
  --warm-silver: #91918c;    /* 禁用/静音文字 */
  --sand-gray: #e5e5e0;      /* 边框、二级表面 — 暖色 */
  --warm-light: #e0e0d9;     /* 圆形按钮、徽章 */
  --fog: #f6f6f3;            /* 浅色背景表面 */
  --dark-surface: #33332e;   /* 深色区域 — 暖黑 */
  --white: #ffffff;          /* 页面背景 */
  --focus-blue: #435ee5;     /* 焦点环 */
  --green-700: #103c25;      /* 成功/正增长 */
}
```

## Typography

- **字体栈**: `-apple-system, system-ui, 'Segoe UI', Roboto, 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', sans-serif`
- **Hero 标题**: `clamp(36px, 6vw, 70px)`, weight 600
- **板块标题**: 28px, weight 700, letter-spacing -1.2px
- **正文**: 16px/14px, weight 400
- **标签/注释**: 11-13px

## Border Radius

| 用途 | 圆角 |
|------|------|
| 标准卡片 | 20px |
| 按钮/输入框 | 16px |
| 小标签 | 12px |
| 圆形元素 | 50% |

## 页面布局结构

```
[ 悬浮 Mini-TOC (右侧 fixed, 220px 宽) ] —— 长报告必备
HERO (日期红色徽章 + 标题 + 副标题 + 统计芯片行)
→ Day-over-Day 变化芯片 (水平 flex 排列，可选)
→ Vibe 横幅 (一句话总结, 深色 plum-black 背景)
→ Daily 表格 (红点) / Weekly 表格 (蓝点) / Monthly 表格 (绿点)
→ 分层分类区:
  - L1 Macro Section (黑色 4px 顶部分隔 + 36px 大标题 + 项目计数)
    - L2 Sub-bucket (18px 子标题 + 细线下划线 + 计数徽章)
      - L3 Pin 瀑布流 (CSS columns: 4→3→2→1 响应式)
→ 战略洞察网格 (fog 背景卡片)
→ 今日新面孔 (深色区域 #33332e)
→ 页脚
```

### 分层布局的视觉密度递减

| 层级 | 字号 | 间距 | 装饰 |
|------|------|------|------|
| L1 Macro | 36px / -1.5px tracking | 60px 上 padding | 4px 黑色顶部分隔 |
| L2 Sub-bucket | 18px / -0.5px tracking | 40px 下 margin | 1px sand-gray 下划线 |
| L3 Pin | 13px name / 12px desc | 14px gap | 20px radius 卡片 |

读者扫读时眼睛应该立刻知道"我在哪一层"。如果 L1/L2/L3 视觉差异不够，整页会扁平化。

## 悬浮 Mini-TOC（长报告必备）

当报告含 ≥ 6 个 macro section 时，**必须**用悬浮 TOC 替代内联目录。

### 桌面（≥ 1101px）

- 右侧 `position: fixed; right: 16px; top: 24px;`，220px 宽，max-height: calc(100vh - 48px)
- body 加 `padding-right: 252px` 让出空间——比改 `.container` max-width 简单（因为 footer 是全宽，container 调宽改不动它）
- 7 个 macro 项默认折叠，点 ▾ 展开 sub-buckets
- IntersectionObserver scroll-spy：滚到 macro 中部时高亮（`rootMargin: '-30% 0px -60% 0px'` 避免高亮闪烁）

### 手机（≤ 1100px）

- 默认隐藏 TOC，右下角 `position: fixed` 的 📑 浮动按钮（44px 圆形）
- 点按钮显示 TOC，从底部弹出，280px 宽 × 70vh 高
- 关闭按钮 ✕ 切换 `body.toc-hidden`

### 关键 CSS 片段

```css
.floating-toc {
  position: fixed; right: 16px; top: 24px;
  width: 220px; max-height: calc(100vh - 48px);
  background: var(--white); border: 1px solid var(--sand-gray);
  border-radius: 16px; padding: 12px; overflow-y: auto; z-index: 50;
  font-size: 12px;
  box-shadow: 0 2px 12px rgba(33,25,34,0.04);
}
@media (min-width: 1101px) {
  body:not(.toc-hidden) { padding-right: 252px; }
}
@media (max-width: 1100px) {
  .floating-toc { display: none; }
  body.toc-open .floating-toc { display: block; bottom: 72px; top: auto; }
}
.ft-group .ft-subs { max-height: 0; overflow: hidden; transition: max-height 0.2s; }
.ft-group.open .ft-subs { max-height: 600px; }
.ft-macro.active { background: var(--warm-light); color: var(--red); }
```

### scroll-spy JS 样板

```js
const macros = document.querySelectorAll('section.macro-section');
const links = document.querySelectorAll('.ft-macro');
const linkByMacro = {};
links.forEach(a => linkByMacro[a.getAttribute('href').replace('#macro-','')] = a);
const obs = new IntersectionObserver((entries) => {
  entries.forEach(e => {
    if (e.isIntersecting) {
      Object.values(linkByMacro).forEach(l => l.classList.remove('active'));
      const link = linkByMacro[e.target.id.replace('macro-','')];
      if (link) link.classList.add('active');
    }
  });
}, { rootMargin: '-30% 0px -60% 0px' });
macros.forEach(s => obs.observe(s));
```

## Pin 卡片结构

```html
<div class="pin">
  <div class="pin-header">
    <div class="pin-name"><a href="URL">owner/repo</a></div>
    <div class="pin-stars">⭐ 28K</div>
  </div>
  <div class="pin-desc">描述文字</div>
  <div class="pin-footer">
    <span class="tag lang">Go</span>
    <span class="tag new">NEW</span>
    <span class="tag span-d">Daily</span>
    <span class="tag span-w">Weekly</span>
    <span class="tag span-m">Monthly</span>
  </div>
</div>
```

## 标签颜色映射

```css
.tag.lang    { background: #e5e5e0; color: #211922; }  /* 语言 */
.tag.new     { background: #e60023; color: #ffffff; }  /* 新项目 */
.tag.span-d  { background: #fde8ec; color: #e60023; }  /* Daily */
.tag.span-w  { background: #e8eafd; color: #435ee5; }  /* Weekly */
.tag.span-m  { background: #e8f5ed; color: #103c25; }  /* Monthly */
```

## 核心设计规则

- **无阴影**: 卡片默认无 box-shadow，hover 时添加微弱阴影
- **暖色中性调**: 全部用橄榄/沙色灰，绝不用冷钢灰
- **Pinterest Red 克制使用**: 仅用于日期徽章、NEW 标签、主按钮、active TOC 项
- **瀑布流**: 分类区域用 CSS `columns` 属性实现 masonry 布局——比 grid 更自然，卡片高度自由（content-fit）
- **深色对比区**: "今日新面孔"用 `#33332e` 暖黑底色；Vibe banner 也用 plum-black
- **链接**: 梅子黑色，hover 变红
- **响应式**: 4 列 → 3 列 → 2 列 → 1 列
- **文字**: 用梅子黑 `#211922`，比纯黑更温暖
- **卡片**: 20px 圆角, 1px solid sand-gray 边框；分层模式下用 16px 更紧凑
- **表格**: 简洁，hover 行变 fog 背景
- **诚实失败原则**: 如果数据没有"星标增量"（GitHub Search API 不提供），就不要画 Day-over-Day 芯片——宁可缺一块也不要画错

## Anti-patterns（v1 复盘）

- ❌ **内联占整页的目录区块**：占据 150px+ 首屏空间，用户得滚才能看到内容
- ❌ **"其它"万能桶 > 10 项**：等于没分类；强制拆细分桶
- ❌ **关键词 heuristic 规则**：维护成本随项目数指数上升，命中率永远卡在 75%
- ❌ **L1/L2/L3 视觉密度相近**：用户分不清"我在哪一层"，整页扁平化
- ❌ **Pinterest Red 滥用**：变成"主题红"而非"信号红"，失去强调作用
