#! /bin/sh

#SDK
SDK="iphoneos7.1"

# コンフィグレーション(「Debug」、「Release」、「Ad hoc」)
CONFIGURATION="Release"

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
IPA_FILE_NAME="${now}"

# ライセンス取得時の開発者名
DEVELOPPER_NAME="iPhone Distribution: hoge Developper"

# アプリのプロビジョニングファイルのパス
PROVISIONING_PATH="${HOME}/Library/MobileDevice/Provisioning\ Profiles/hoge.mobileprovision"

# 出力先ipaディレクトリ作成
# -------------------------
if [ ! -d ${OUT_IPA_DIR} ]; then
  mkdir "${OUT_IPA_DIR}"
fi


# クリーン
# -------------------------
xcodebuild clean -project "${PROJ_FILE_PATH}"

# ビルド
# -------------------------
xcodebuild -project "${PROJ_FILE_PATH}" -sdk "${SDK}" -configuration "${CONFIGURATION}" -target "${TARGET_NAME}" install DSTROOT="${OUT_APP_DIR}"

# Create ipa File
# -------------------------
xcrun -sdk "${SDK}" PackageApplication "${PWD}/${OUT_APP_DIR}/Applications/${PRODUCT_NAME}.app" -o "${PWD}/${OUT_IPA_DIR}/${IPA_FILE_NAME}.ipa" -embed "${PROVISIONING_PATH}"
