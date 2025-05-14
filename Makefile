.DEFAULT_GOAL := all

# -----------------------------
# 📁 Privates 파일 다운로드 설정
# -----------------------------

# GitHub에서 private 파일을 가져올 repository 경로 (팀명/저장소명/브랜치)
Private_Repository=team-GitDeulida/CodeLounge-Private/main

# GitHub Raw URL 기본 경로
BASE_URL=https://raw.githubusercontent.com/$(Private_Repository)

# ✅ 파일 다운로드 함수 정의
# $(1): 디렉토리 경로
# $(2): GitHub Access Token
# $(3): 파일 이름
define download_file
	mkdir -p $(1)
	curl -H "Authorization: token $(2)" -o $(1)/$(3) $(BASE_URL)/$(1)/$(3)
endef

# 🏁 진입 지점: download-privates 명령 실행 시 동작
download-privates:

	# .env 파일이 없으면 GitHub Access Token을 사용자에게 입력받아 저장
	# Get GitHub Access Token
	@if [ ! -f .env ]; then \
		read -p "Enter your GitHub access token: " token; \
		echo "GITHUB_ACCESS_TOKEN=$$token" > .env; \
	else \
		echo "Homebrew가 이미 설치되어 있습니다."; \
	fi

	# 실제 다운로드 수행
	make _download-privates

# 🔽 내부 명령: 다운로드 로직 수행
_download-privates:

	# .env 파일에서 GITHUB_ACCESS_TOKEN을 읽어 환경 변수로 설정
	$(eval export $(shell cat .env))

	# 레포지토리의 최상위 디렉토리에서 Config.xcconfig 다운로드
	$(call download_file,.,$$GITHUB_ACCESS_TOKEN,Config.xcconfig)

# -------------------------
# Homebrew 설치 확인 및 설치
# -------------------------

install_homebrew:
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "Homebrew가 설치되어 있지 않습니다. 설치를 진행합니다..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	else \
		echo "Homebrew가 이미 설치되어 있습니다."; \
	fi

# -------------------------
# fastlane 및 인증서 관련 작업
# -------------------------

# Automatically manage signing 체크 해제해야함!!
# Homebrew로 fastlane 설치 (설치되어 있으면 업데이트)
install_fastlane: install_homebrew
	@echo "Updating Homebrew..."
	@brew update
	@echo "Installing fastlane via Homebrew..."
	@brew install fastlane || true
	@echo "✅ fastlane 설치 완료 (Homebrew 사용)"
	
# 인증서 다운로드 (readonly 모드)
fetch_certs: install_fastlane
	@echo "Fetching development certificates..."
	@fastlane match development --readonly
	@echo "Fetching appstore certificates..."
	@fastlane match appstore --readonly
	@echo "✅ 인증서 가져오기 완료"

# -------------------------
# 통합 기본 타겟: 필요한 경우 Private 파일과 인증서 모두 다운로드
# -------------------------
all: download-privates fetch_certs
	@echo "✅ 모든 작업 완료"
