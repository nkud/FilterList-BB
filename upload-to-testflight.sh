#! /bin/sh

API_TOKEN='0cbc5439c46d06d22144ff8f33478aea_MTY5NTAwNDIwMTQtMDMtMDUgMDA6MzI6MjMuOTQ5MjI4'

TEAM_TOKEN='7a1814733a79dc887c960b4ce1addefb_MzQ4NjIxMjAxNC0wMy0wNSAwMTo0Nzo1MC43MjM2NTk'

NOTIFY='True'

DISTRIBUTION_LISTS='Naoki Ueda'

IPA_FILE='out_ipa/test.ipa'

curl http://testflightapp.com/api/builds.json \
  -F file=@${IPA_FILE} \
  -F api_token=${API_TOKEN} \
  -F team_token=${TEAM_TOKEN} \
  -F notes='upload from testflight API.' \
  -F notify="${NOTIFY}" \
  -F distribution_lists="${DISTRIBUTION_LISTS}"
