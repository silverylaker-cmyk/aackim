#!/bin/bash
# 자폐 아동 AAC 앱 — 로컬 자동 디자인 개선 스크립트
# 
# 사용법:
#   chmod +x scripts/improve-design.sh
#   ./scripts/improve-design.sh
#
# 크론 등록 (매일 새벽 3시):
#   crontab -e
#   0 3 * * * /절대경로/aackim/scripts/improve-design.sh
#
# Windows (WSL/Git Bash) Task Scheduler:
#   작업: wsl /절대경로/aackim/scripts/improve-design.sh
#   트리거: 매일 03:00

set -euo pipefail

BRANCH="claude/childrens-program-design-il636m"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
LOG_FILE="$SCRIPT_DIR/improve-design.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

log "==============================="
log "디자인 개선 시작"
log "==============================="

cd "$REPO_DIR"

# 브랜치 확인 및 최신 동기화
git checkout "$BRANCH" 2>/dev/null || git checkout -b "$BRANCH" --track "origin/$BRANCH"
log "git pull 중..."
git pull origin "$BRANCH"

# Claude Code 실행 (Pro 구독 OAuth 사용, 추가 비용 없음)
log "Claude Code 실행 중..."
claude --dangerouslySkipPermissions -p \
"Review the children's AAC app design in this repository (styles.css, index.html, app.js).
This is a picture-based communication app for children with autism — simplicity, clarity,
and child-friendliness are the top priorities.

Make ONE focused, well-reasoned improvement to styles.css (and index.html only if truly needed).
Choose from areas not yet addressed, such as:
- Larger / more distinct tap targets
- Better visual hierarchy between image and label areas
- Friendlier typography (size, weight, line-height)
- Improved color contrast for accessibility
- More cheerful but calm color palette adjustments
- Smoother transitions and feedback animations
- Better spacing / breathing room between cards

After making the change, commit with a clear Korean commit message describing WHAT changed
and WHY it helps children, then push to branch: $BRANCH"

log "완료!"
log "==============================="
