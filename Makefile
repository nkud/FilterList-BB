
SDK=iphoneos8.0

CONFIGURATION=AdHoc

# Xcodeのプロジェクト名
PROJ_FILE_PATH=FilterList.xcodeproj

TARGET_NAME=FilterList

#「Build Settings」にある、プロダクト名
PRODUCT_NAME=FilterList

OUT_APP_DIR=out_app
OUT_IPA_DIR=out_ipa

PWD=$(shell pwd)

# now:=` date +%y%m%d-%H%M%S`
# IPA_FILE_NAME=$(now)
IPA_FILE_NAME=FilterList

# ライセンス取得時の開発者名
DEVELOPPER_NAME="iPhone Distribution: Naoki Ueda"

PROVISIONING_PATH="${HOME}/Desktop/heart/su104003_adhoc.mobileprovision"

# UPLOAD ==================================
API_TOKEN="0cbc5439c46d06d22144ff8f33478aea_MTY5NTAwNDIwMTQtMDMtMDUgMDA6MzI6MjMuOTQ5MjI4"
TEAM_TOKEN="7a1814733a79dc887c960b4ce1addefb_MzQ4NjIxMjAxNC0wMy0wNSAwMTo0Nzo1MC43MjM2NTk"

NOTIFY="False"

DISTRIBUTION_LISTS="FilterList"


.PHONY: all build clean ipa upload

all: build ipa upload

$(OUT_IPA_DIR)/$(IPA_FILE_NAME).ipa: build ipa


ipa: $(OUT_APP_DIR)/Applications/$(PRODUCT_NAME).app
	@[ -d $(OUT_IPA_DIR) ] || $(MKDIR) $(OUT_IPA_DIR)
	@xcrun -sdk "$(SDK)" PackageApplication "$(PWD)/$(OUT_APP_DIR)/Applications/$(PRODUCT_NAME).app" -o "$(PWD)/$(OUT_IPA_DIR)/$(IPA_FILE_NAME).ipa" -embed $(PROVISIONING_PATH)


build: clean
	@[ -d $(OUT_APP_DIR) ] || $(MKDIR) $(OUT_APP_DIR)
	@xcodebuild -project "$(PROJ_FILE_PATH)" -sdk "$(SDK)" -configuration "$(CONFIGURATION)" -target "$(TARGET_NAME)" install DSTROOT="$(OUT_APP_DIR)"
clean:
	@xcodebuild clean -project "$(PROJ_FILE_PATH)"


upload: $(OUT_IPA_DIR)/$(IPA_FILE_NAME).ipa
	curl http://testflightapp.com/api/builds.json \
	  -F file=@$(OUT_IPA_DIR)/$(IPA_FILE_NAME).ipa \
	  -F api_token=$(API_TOKEN) \
	  -F team_token=${TEAM_TOKEN} \
	  -F notes='upload from testflight API.' \
	  -F notify=${NOTIFY} \
	  -F distribution_lists="${DISTRIBUTION_LISTS}" \
	  -v
