# Characters/ — 英杰数据沉淀

本目录沉淀每位武将（英杰）的 wiki 数据，作为详情页和未来 DB seed 的真理之源。

> 当前 mock 数据仍在 [`../MockedHeroList.json`](../MockedHeroList.json)，本目录是它的**扩展超集**，承载现有 `HeroModel` 还不支持的丰富字段。等模型演进后会合并。

## 1. 文件命名约定

每位武将固定 **2 个文件**：

```
<heroEnumCaseName>.json   # 结构化字段（机器可解析）
<heroEnumCaseName>.md     # 攻略性长文（人/agent 阅读）
```

其中 `<heroEnumCaseName>` 必须与 [MusouHero.swift](../../Develop/HeroDefines/MusouHero.swift) 里对应的 enum case 名严格一致（小驼峰），例如：

| 英杰 number | enum case | 文件名 |
| --- | --- | --- |
| 201 | `zhaoYun` | `zhaoyun.json` / `zhaoyun.md` |
| 204 | `zhangFei` | `zhangfei.json` / `zhangfei.md` |
| 909 | `ginchiyoTachibana` | `ginchiyotachibana.json` / `ginchiyotachibana.md` |

> 文件名整体小写以方便跨平台/大小写不敏感的文件系统。

## 2. JSON Schema（顶层字段）

下列字段顺序即推荐书写顺序。`?` 表示可选。

```jsonc
{
  "meta": {
    "number": 201,                  // 对齐 MusouHero raw value
    "heroEnumCase": "zhaoYun",      // 对齐 MusouHero case name
    "name": "赵云",                  // 中文名（与 MockedHeroList.json 一致）
    "japaneseName": "趙雲",          // 日文 wiki 标题
    "courtesyName": "子龙",          // ? 字
    "japaneseCourtesyName": "子龍",  // ? 日文字
    "voiceActor": "田邊幸輔",        // ? CV
    "faction": "shu",               // 对齐 EmblemType case
    "factionEmblemRawValue": 1      // 对齐 EmblemType raw value
  },

  "possessions": {
    "base":       [ { "key": "skill", "rawValue": 4 }, ... ],
    "limitBreak": [ { "key": "power", "rawValue": 0, "note": "..." } ]
  },

  "emblems": {
    "base":       [ { "key": "shu", "rawValue": 1 }, ... ],
    "limitBreak": [ { "key": "kingsShield", "rawValue": 109, "note": "..." } ]
  },

  "mainEmblem": { "key": "shu", "rawValue": 1 },

  "operationTraits": [
    {
      "name": "忠勇兼備",
      "baseEffect": "...",
      "strengthenedEffect": "...",   // ? 强化版（与 base 不同时填）
      "strengthenDelta": "...",       // ? 强化前后差量说明
      "tags": ["蜀", "感電"]          // ? 检索 tag
    }
  ],

  "summonSkill": {
    "name": "飛剣・雷",
    "element": "thunder",
    "effect": "...",
    "cooldownSec": 36,
    "upgradeItem": "弾数",
    "upgradeCondition": {
      "heroes":      [ { "key": "...", "rawValue": ..., "japaneseName": "..." } ],
      "emblems":     [ { "key": "...", "rawValue": ..., "count": N } ],
      "possessions": [ { "key": "...", "rawValue": ..., "count": N } ]
    },
    "synergyNote": "..."            // ? 备注
  },

  "uniqueTactics": {                // 固有戦法（来自《固有戦法》总表）
    "name": null,                   // 多数武将无独立技名
    "baseEffect": "...",
    "strengthenedEffect": "...",
    "activationCondition": { /* 同 upgradeCondition 结构 */ },
    "wikiNote": "..."               // ?
  },

  "companionTraits": [              // ☆随行时特性，固定 3 条
    {
      "index": 1,
      "trait": "...",
      "activationCondition": null,  // 第 1 条多为无条件
      "tags": ["..."]
    }
  ],

  "combos": {                       // ? 攻撃 motion
    "specialAction": { "name": "...", "description": "..." },
    "moves": [
      { "id": "N", "name": "通常攻撃", "description": "..." },
      { "id": "C1", ... },
      { "id": "MusouRanbu", ... },
      { "id": "FormationRanbu", ... }
    ]
  },

  "recommendedBuild": {             // ? 推荐 build
    "name": "...",
    "rationale": "...",
    "windSide": { "core": [...], "candidates": [...] },
    "thunderSide": { ... },
    "priorityOrder": "...",
    "notes": "..."
  },

  "companionRecommendations": [     // ? ☆相性が良い随行武将
    {
      "key": "...", "rawValue": ..., "japaneseName": "...",
      "traits": [ { "index": 1, "effect": "...", "condition": "..." } ]
    }
  ],

  "playstyle": {                    // ? 立ち回り
    "early": "...", "mid": "...", "late": "...",
    "specialBuilds": "..."
  },

  "yamamaCho": {                    // ? 閻魔帳推奨効果
    "title": "...",
    "items": ["..."]
  },

  "lore": {                         // ? 英傑考察
    "summary": "...",
    "details": ["..."]
  },

  "wikiSource": {
    "characterPage": "https://wikiwiki.jp/musoabyss/...",
    "uniqueTacticsPage": "https://wikiwiki.jp/musoabyss/%E5%9B%BA%E6%9C%89%E6%88%A6%E6%B3%95",
    "summonSkillPage": "https://wikiwiki.jp/musoabyss/...",
    "lastFetchedAt": "YYYY-MM-DD"
  }
}
```

### 必填 vs 可选

| 字段 | 是否必填 | 说明 |
| --- | --- | --- |
| `meta`, `possessions`, `emblems`, `mainEmblem` | 必填 | 与 `HeroModel` 现有字段一一对应 |
| `operationTraits`, `summonSkill`, `uniqueTactics`, `companionTraits` | 必填 | 详情页 L3/L4 核心数据，缺则在 UI 显示"暂未录入" |
| 其余 | 可选 | 优先程度由各武将的资料完整度决定 |

### 枚举 raw value 速查

写入 `rawValue` 时务必参照下面三个枚举文件，避免漂移：

- 武将编号 / case name：[MusouHero.swift](../../Develop/HeroDefines/MusouHero.swift)
- 印（possessions）：[PossessionsType.swift](../../Develop/HeroDefines/PossessionsType.swift)
  - `power`=0, `wisdom`=1, `charm`=2, `speed`=3, `skill`=4, `shield`=5
  - `fire`=11, `ice`=12, `thunder`=13, `wind`=14, `slash`=15
- 特殊系（emblems）：[EmblemType.swift](../../Develop/HeroDefines/EmblemType.swift)
  - 势力：`wei`=0, `shu`=1, `wu`=2, `jin`=3, `yellowTurbans`=4 ...
  - 身份：`monarch`=101, `daimyo`=102, `braveGeneral`=103, `strategist`=104, `shinobi`=105 ...
  - 特性：`grace`=201, `talent`=202, `might`=203, `flowerOfWar`=204
  - 组合：`threeHeroes`=301, `fiveShuTigers`=302, `fiveWeiElite`=303 ...
  - 地区：`xiLiang`=401, `weaternRegion`=402

> **限界突破获得的印 / 特殊系** 放在 `limitBreak` 数组，并加 `note` 字段说明来源。详情页 UI 应区分显示（如打方框或灰底）。

## 3. Markdown 模板

```markdown
# <日文名> / <中文名> (#<number>)

> 攻略性长文资产。结构化字段请见同目录下 [<file>.json](./<file>.json)。
> 来源：[wikiwiki.jp / <name>](<URL>)
> 抓取日期：YYYY-MM-DD

## 概述
- 势力 / CV / 武器 / 主要印记 / 特殊系
- 1–2 段角色定位简述

## 操作时特性详解
（每条单独小节，含"基础 / 强化 / 设计要点"）

## 攻击 motion 详解
（按 N / C1 / C1EX / C2 / ... / 無双乱舞 / 陣形乱舞 顺序）

## 召唤技：<技名>
（表格形式）

## 固有戦法
（表格形式）

## 随行时特性
（表格 3 行）

## 推荐 Build：<build 名>
### 风側 / 雷側 / ...（表格）
### 印優先度
### 印管理のコツ

## 立ち回り
（早 / 中 / 晚期 + 補足）

## 閻魔帳の推奨効果

## 相性が良い随行武将
（每位武将一节，含 3 条特性表）

## 関連英傑
## 英傑考察（背景）
## 抓取记录
```

## 4. wiki 抓取注意点

1. **嵌套表格**：wiki 上的"操作時特性 / 召喚技 / 固有戦法"小节往往是嵌套表格 partial，单页 fetch 会被裁掉。需要二次 fetch [固有戦法总表](https://wikiwiki.jp/musoabyss/%E5%9B%BA%E6%9C%89%E6%88%A6%E6%B3%95) 等聚合页补全。
2. **方括号约定**：原 wiki 中  `[xxx]` 一般表示**限界突破后**获得的印/特殊系，或**强化版**效果。沉淀时务必保留这层区分（JSON 用 `limitBreak` / `strengthenedEffect` 字段，markdown 在原文里用 `[+xx]` 标注）。
3. **日语术语保留原文**：「無双ゲージ」「感電」「召喚待機時間」「階層の主」等术语保留原文，必要时在中文括号里加简注。这与项目本地化策略一致（[Localizable.xcstrings](../../Resource/Localizable.xcstrings) 有日/中/英三套）。
4. **超链接保留**：markdown 里对其他武将的引用一律保留为 wikiwiki 原始链接，便于读者跳查。
5. **不要捏造数据**：所有数值与效果文本必须有 wiki 原文实证。无法确定时填 `null` / TODO 标记，并在文件末尾"抓取记录"表里说明。

## 5. 与 HeroModel 的衔接

当前 [HeroModel.swift](../../Develop/Model/HeroModel.swift) 把 `summonSkill / uniqueTactics / playerHeroTrait` 都建模为单 String，**承载不了** 本目录的丰富字段。后续模型演进时建议：

- `playerHeroTrait: String` → `operationTraits: [OperationTrait]`
- `summonSkill: String` → `summonSkill: SummonSkill`（含 cooldown / upgrade 子结构）
- `uniqueTactics: String` → `uniqueTactics: UniqueTactics`（含激活条件子结构）
- 新增 `companionTraits: [CompanionTrait]`

详情见 [`Docs/HeroDetailPage_PRD.md`](../../../Docs/HeroDetailPage_PRD.md) §5 数据模型缺口。

## 6. 已沉淀清单

| number | enum case | JSON | MD |
| --- | --- | --- | --- |
| 201 | `zhaoYun` | [zhaoyun.json](./zhaoyun.json) | [zhaoyun.md](./zhaoyun.md) |

待补：其余 70+ 武将。
