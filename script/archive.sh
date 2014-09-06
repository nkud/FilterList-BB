#! /bin/sh

#SDK
SDK="iphoneos7.1"

# コンフィグレーション(「Debug」、「Release」、「Ad hoc」)
CONFIGURATION="AdHoc"

# Xcodeのプロジェクト名
PROJ_FILE_PATH="InboxList.xcodeproj"

# ターゲット名
TARGET_NAME="InboxList"

#「Build Settings」にある、プロダクト名
PRODUCT_NAME="InboxList"

# app出力先ディレクトリ名
OUT_APP_DIR="out_app"

# 出力先ipaディレクトリ名
OUT_IPA_DIR="out_ipa"

# 出力されるipaファイル名
now=` date +%y%m%d-%H%M%S`
# IPA_FILE_NAME="${now}"
IPA_FILE_NAME="FilterList"

# ライセンス取得時の開発者名
DEVELOPPER_NAME="iPhone Distribution: Naoki Ueda"

# アプリのプロビジョニングファイルのパス
# PROVISIONING_PATH="${HOME}/Library/MobileDevice/Provisioning\ Profiles/hoge.mobileprovision"
PROVISIONING_PATH="${HOME}/Desktop/heart/su104003_adhoc.mobileprovision"

# 出力先ipaディレクトリ作成
# -------------------------
if [ ! -d ${OUT_IPA_DIR} ]; then
  mkdir "${OUT_IPA_DIR}"
fi


# Clean
xcodebuild clean -project "${PROJ_FILE_PATH}"

# Build
xcodebuild -project "${PROJ_FILE_PATH}" -sdk "${SDK}" -configuration "${CONFIGURATION}" -target "${TARGET_NAME}" install DSTROOT="${OUT_APP_DIR}"

# Create ipa File
xcrun -sdk "${SDK}" PackageApplication "${PWD}/${OUT_APP_DIR}/Applications/${PRODUCT_NAME}.app" -o "${PWD}/${OUT_IPA_DIR}/${IPA_FILE_NAME}.ipa" -embed "${PROVISIONING_PATH}"
