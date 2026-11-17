#!/usr/bin/env bash
# 从 cv/cv.html 生成 site 上的 CV.pdf（source/attaches/CV.pdf）
# 用法：bash bin/build-cv.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/cv/cv.html"
OUT="$ROOT/source/attaches/CV.pdf"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

[ -x "$CHROME" ] || { echo "未找到 Google Chrome，无法生成 PDF"; exit 1; }
[ -f "$SRC" ]    || { echo "缺少 $SRC"; exit 1; }

mkdir -p "$(dirname "$OUT")"

PROFILE="${TMPDIR:-/tmp}/chrome-cv-profile"

# --no-sandbox / 独立 user-data-dir：在受限环境与已开 Chrome 的情况下都能稳定出图
"$CHROME" \
  --headless=new \
  --no-sandbox \
  --disable-gpu \
  --disable-dev-shm-usage \
  --no-first-run \
  --no-default-browser-check \
  --user-data-dir="$PROFILE" \
  --no-pdf-header-footer \
  --run-all-compositor-stages-before-draw \
  --virtual-time-budget=4000 \
  --print-to-pdf="$OUT" \
  "file://$SRC" 2>/dev/null

if [ -f "$OUT" ]; then
  echo "已生成: $OUT"
  echo "大小: $(du -h "$OUT" | cut -f1)"
  echo "页数: $(python3 -c "
import re,sys
d=open('$OUT','rb').read()
print(len(re.findall(rb'/Type\s*/Page[^s]', d)))
")"
else
  echo "生成失败"; exit 1
fi
