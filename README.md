# ACE COMBAT 8 UEVR Profile (HUD fix)

ACE COMBAT 8 を [UEVR](https://github.com/praydog/UEVR-nightly/releases) で VR 化したときに、
**緑の飛行 HUD（中央計器・左下ミニマップ・右下の兵装 / 機体状態）が VR で見えない**問題を解決した UEVR プロファイルです。

- 飛行 HUD とメニューが UEVR の UI レイヤーに表示されます（頭追従・サイズ / 距離調整可）
- 中央計器（ピッチラダー / SPEED / ALT / コンパス）がミニマップ側に寄る問題を補正済み
- 動作確認環境: UEVR nightly **01143**（`1.05+195-4ee5c6b6`）/ Windows 11 / AMD Radeon RX 6700 XT / Virtual Desktop（OpenXR）

[English summary](#english)

---

<a id="launch"></a>
## ⚠️ はじめに必ず：アンチチートを通さずに起動する

AC8 を Steam から普通に起動すると、アンチチート（EasyAntiCheat）経由で起動されるため **UEVR を注入できません**。
UEVR を使うときは、次の手順で **`AceCombat8.exe` を直接起動**します。

1. AC8 のインストール先を開き、次のフォルダに移動します。
   ```
   <Steamライブラリ>\steamapps\common\ACE COMBAT 8\Game\Binaries\Win64
   ```
   例: `D:\SteamLibrary\steamapps\common\ACE COMBAT 8\Game\Binaries\Win64`
   （Steam でゲームを右クリック → **管理 → ローカルファイルを閲覧** で `ACE COMBAT 8` フォルダが開きます）
2. そのフォルダに **`steam_appid.txt`** というテキストファイルを作成します。
3. 中身に次の数字だけを入力して保存します（AC8 の Steam App ID）。
   ```
   2288340
   ```
   > 拡張子が `steam_appid.txt.txt` になっていないか注意してください（エクスプローラーの「表示 → ファイル名拡張子」をオンにすると確認できます）。
4. 以降は **同じフォルダの `AceCombat8.exe` をダブルクリックして起動**します（Steam クライアントは起動したままにしておきます）。

**注意**

- この方法ではアンチチートが無効になるため、**マルチプレイ（オンライン対戦）は利用できません**。UEVR はキャンペーンなどのオフラインモード専用です。
- マルチプレイを遊ぶときは、いつも通り **Steam から起動**してください（`steam_appid.txt` は置いたままで問題ありません）。
- `EasyAntiCheat` フォルダや `start_protected_game.exe` は削除・改変しないでください。

---

## 必要なもの

| もの | 入手先 |
|---|---|
| ACE COMBAT 8（Steam 版） | — |
| UEVR nightly（01143 以降推奨） | <https://github.com/praydog/UEVR-nightly/releases> |
| `ac8_ui_fix.lua`（HUD を VR に出すスクリプト） | <https://github.com/lovezzzxxx/ace-combat-8-uevr-ui-fix>（作者: lovezzzxxx 氏） |
| このリポジトリの `AceCombat8.zip` | [Releases](https://github.com/VTFLAB/ace-combat-8-uevr-profile/releases/latest) からダウンロード |

> `ac8_ui_fix.lua` はライセンス表記がないため同梱していません。必ず作者のリポジトリから入手してください。

---

## UEVR の基本的な使い方（はじめての人向け）

1. UEVR nightly の zip を好きなフォルダに展開します（例: `D:\uevr`）。
2. [上の手順](#launch)どおり **`AceCombat8.exe` を直接起動**し、タイトル画面まで進めます（Steam から起動すると注入できません）。
3. `UEVRInjector.exe` を起動します。
4. プロセス一覧から **`AceCombat8.exe`** を選びます。
5. ランタイムで **OpenXR** を選びます（Virtual Desktop / Quest Link / SteamVR いずれも OpenXR で可）。
6. **Inject** を押すと VR 化されます。
7. ゲーム中に **Insert キー**（ゲームパッドなら **L3 + R3**）で UEVR メニューが開きます。

### プロファイルとは

UEVR はゲームごとの設定を「プロファイル」として次のフォルダに保存します。

```
%APPDATA%\UnrealVRMod\AceCombat8\
├─ config.txt          … UEVR の設定（描画方式・UI 位置など）
├─ cameras.txt         … カメラ設定
├─ scripts\            … 自動で読み込まれる Lua スクリプト
└─ data\               … スクリプトの設定・ログ
```

UEVRInjector の **Open Game Dir** ボタンでこのフォルダを開けます。
プロファイルを入れ替えれば、他の人と全く同じ設定で遊べます。

---

## このプロファイルの導入手順

> 既に自分の AC8 プロファイルがある場合は、先に UEVRInjector の **Export Config** でバックアップを取ってください（上書きされます）。

### 方法 A: Import Config（おすすめ）

1. `AceCombat8.zip` をダウンロードします。**ファイル名は変えないでください**（UEVR は zip のファイル名をゲーム名として使います）。
2. UEVRInjector を起動し、**Import Config** を押して `AceCombat8.zip` を選びます。
3. `%APPDATA%\UnrealVRMod\AceCombat8\` に展開されます。
4. 作者のリポジトリから入手した **`ac8_ui_fix.lua`** を
   `%APPDATA%\UnrealVRMod\AceCombat8\scripts\` に置きます。

### 方法 B: 手動コピー

1. このリポジトリの `profile\` の中身を、`%APPDATA%\UnrealVRMod\AceCombat8\` にコピーします。
2. `ac8_ui_fix.lua` を同じく `scripts\` に置きます。

### 導入後のフォルダ

```
%APPDATA%\UnrealVRMod\AceCombat8\
├─ config.txt
├─ cameras.txt
├─ scripts\
│   ├─ ac8_ui_fix.lua       ← 作者リポジトリから入手
│   └─ ac8_hud_adjust.lua   ← このプロファイルに同梱
└─ data\
    └─ ac8_hud_adjust.json  ← 中央計器の位置補正値
```

Lua スクリプトは Inject 時に自動で読み込まれます。
UEVR メニュー → **LuaLoader → Main** の "Known scripts" に 2 つとも表示されていれば OK です。

---

## 仕組み

1. **AC8 の HUD は特殊**: 飛行 HUD とメニューは、ゲームのビューポートではなく独自の
   「ウィジェット → テクスチャ」経路で描かれるため、UEVR の UI キャプチャに映りません。
2. **`ac8_ui_fix.lua`**（lovezzzxxx 氏）が HUD ウィジェット
   （`WBP_HUD_Chronicle_MainFlight_000_C` など）をビューポートに戻し、UEVR が UI レイヤーとして表示できるようにします。
3. **Extreme Compatibility Mode をオフ**にすることで、UEVR の UI レンダーターゲットが作られ、
   HUD が頭追従 / サイズ / 距離を調整できる UI レイヤーに乗ります（オンだと画面に直接焼き込まれ、巨大で調整不可になります）。
4. **`ac8_hud_adjust.lua`**（このリポジトリ）が、中央計器一式
   （`WBP_ChroniclePersistent`: ピッチラダー・SPEED・ALT・コンパス・W マーク）だけを横にずらし、ミニマップとの重なりを解消します。

---

## 主な設定値

| 設定 | 値 | 説明 |
|---|---|---|
| Rendering Method | Native Stereo | |
| Native Stereo Fix / Use Same Stereo Pass | ON / ON | |
| **Extreme Compatibility Mode** | **OFF** | **HUD を UI レイヤーに出すために必須** |
| Ghosting Fix | ON | |
| Overlay Type | Cylinder（90°） | |
| UI Follows View | ON | HUD が頭に追従 |
| UI Distance / UI Size | 1.165 / 0.690 | |
| UI Offset (X / Y) | -0.001 / -0.226 | |
| OpenXR Resolution Scale | 0.796 | RX 6700 XT（VRAM 12GB）でのクラッシュ対策 |
| 中央計器の X 補正 | 675 | `data\ac8_hud_adjust.json` |

---

## 自分の環境に合わせた調整

### 中央計器の位置（ミニマップと被る / ずれる）

ヘッドセットの機種によって最適値が変わる可能性があります。

1. 出撃して HUD を表示させます。
2. UEVR メニュー → **LuaLoader → Script UI** を開きます。
3. **Child widget** 欄の Name が `WBP_ChroniclePersistent` になっていることを確認し、
   **X** スライダーで中央に来るよう調整します（右へはプラス）。
4. 値は `data\ac8_hud_adjust.json` に自動保存されます。

> Script UI 上部の `WBP_HUD_Chronicle_...` の X / Y は HUD 全体を動かすものです。通常は 0 のままにしてください。
> HUD 全体の位置・大きさは UEVR 本体の **VR → Runtime → Overlay Options**（UI Distance / UI Size / UI Offset）で調整します。

### 解像度 / 安定性

- **OpenXR Resolution Scale**（VR → Runtime）: GPU に余裕があれば上げられます。
  ミッション再開時などにクラッシュする場合は下げてください。
- **GPU ドライバーは「最新」ではなく、ゲームが指定する推奨バージョンを使ってください**（下記）。

<a id="gpu-driver"></a>
### GPU ドライバー（重要）

公式（Steam のお知らせ「[Product Notice](https://store.steampowered.com/news/app/2288340)」2026-09-29）では、クラッシュ対策として
**ゲーム起動時に表示される推奨グラフィックドライバーを使う**よう案内されています。
推奨と異なるドライバーだと、起動時に「AMDのグラフィックドライバーの最新バージョンにはD3D12の既知の問題があります」のような警告が出ます。

| GPU | 推奨ドライバー | 根拠 |
|---|---|---|
| AMD Radeon | **AMD Software: Adrenalin Edition 26.3.1** | ゲーム起動時の警告で指定される版（動作確認環境もこの版） |
| NVIDIA GeForce | ゲーム起動時に表示される版 | 公式に具体的な版数の公開を確認できていません |

- **Radeon で最新ドライバー（26.9.2 など）に上げると、起動時に警告が出ます。** 26.3.1 は AMD 公式の [リリースノート](https://www.amd.com/en/resources/support-articles/release-notes/RN-RAD-WIN-26-3-1.html) から入手できます。
- 公式はあわせて、**インストール先 SSD に 16GB 以上の空き**と、**Windows の仮想メモリを有効にしておく**ことを推奨しています。

---

## トラブルシューティング

| 症状 | 対処 |
|---|---|
| HUD がまったく見えない | `ac8_ui_fix.lua` が `scripts\` にあるか、LuaLoader → Main の Known scripts に出ているか確認 |
| HUD が巨大で画面中央に貼り付き、UI 設定が効かない | **Extreme Compatibility Mode を OFF** にしてゲームを再起動 |
| 中央計器がミニマップと被る | Script UI の Child widget **X** を調整 |
| ミッション再開 / 終了時にクラッシュ（「予期しないエラー（エラー01）」） | ゲーム指定の**推奨ドライバー**を使う（[上記](#gpu-driver)）、SSD 空き 16GB 以上・仮想メモリ有効を確認、Resolution Scale を下げる。Steam 起動オプションに `-dred` を付けるとクラッシュ原因が記録されます |
| ピッチラダーの一部や機銃照準が見えない | `ac8_ui_fix.lua` の既知の制限です |

---

## クレジット

- [UEVR](https://github.com/praydog/UEVR) — praydog
- [ace-combat-8-uevr-ui-fix](https://github.com/lovezzzxxx/ace-combat-8-uevr-ui-fix)（`ac8_ui_fix.lua`）— lovezzzxxx
- `ac8_hud_adjust.lua` / プロファイル設定 — このリポジトリ（MIT License）

---

<a id="english"></a>
## English

UEVR profile for **ACE COMBAT 8** that makes the green flight HUD (center instruments, minimap, weapons / damage panel) visible in VR.

**Requirements**: UEVR nightly 01143+, and `ac8_ui_fix.lua` from
<https://github.com/lovezzzxxx/ace-combat-8-uevr-ui-fix> (not bundled — no license).

**⚠️ First: launch without the anti-cheat**

Launching from Steam goes through EasyAntiCheat, and UEVR cannot inject. To use UEVR:

1. Open `<Steam library>\steamapps\common\ACE COMBAT 8\Game\Binaries\Win64`
   (Steam → right-click the game → Manage → Browse local files).
2. Create `steam_appid.txt` there containing only `2288340` (make sure it is not `steam_appid.txt.txt`).
3. Launch **`AceCombat8.exe` directly** from that folder (keep the Steam client running).

Anti-cheat is disabled this way, so **multiplayer is not available** — UEVR is for offline modes only.
Launch from Steam as usual when you want to play online. Do not delete or modify `EasyAntiCheat` / `start_protected_game.exe`.

**Install**

1. Back up your existing profile with **Export Config** in UEVRInjector (it will be overwritten).
2. Download `AceCombat8.zip` from [Releases](https://github.com/VTFLAB/ace-combat-8-uevr-profile/releases/latest) (**do not rename it** — UEVR uses the zip file name as the game name).
3. UEVRInjector → **Import Config** → select `AceCombat8.zip`.
4. Put `ac8_ui_fix.lua` into `%APPDATA%\UnrealVRMod\AceCombat8\scripts\`.
5. Launch `AceCombat8.exe` directly (see above), then in UEVRInjector select `AceCombat8.exe`, choose OpenXR, **Inject**.

**Key points**

- **Extreme Compatibility Mode must be OFF**, otherwise the HUD is burned into the eye images (huge, head-locked, not adjustable).
- `ac8_hud_adjust.lua` shifts only the center instrument cluster (`WBP_ChroniclePersistent`) by X=675 so it no longer overlaps the minimap.
  Tune it in UEVR menu → LuaLoader → **Script UI** → Child widget **X** (may differ per headset).
- OpenXR Resolution Scale is 0.796 for stability on a 12 GB GPU; raise it if you have headroom, lower it if the game crashes on mission restart.
- **GPU driver: use the version the game recommends at launch, not the latest.** The official Steam "Product Notice" (2026-09-29) advises using the recommended driver shown at launch, plus 16 GB+ free on the install SSD and Windows virtual memory enabled.
  - AMD Radeon: **Adrenalin 26.3.1** (named by the in-game warning; newer drivers such as 26.9.2 trigger a "known D3D12 issue" warning).
  - NVIDIA: use the version shown at launch (no official version number confirmed).

Tested: UEVR nightly 01143 (`1.05+195-4ee5c6b6`), Windows 11, Radeon RX 6700 XT, Virtual Desktop (OpenXR).
