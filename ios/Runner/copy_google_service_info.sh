#!/bin/sh

# Set the path to the GoogleService-Info.plist files
FIREBASE_CONFIG_PATH="${PROJECT_DIR}/Firebase"

# Determine the environment based on the bundle ID
if [[ "${BUNDLE_ID}" == *'.dev'* ]]; then
    ENVIRONMENT='dev'
elif [[ "${BUNDLE_ID}" == *'.uat'* ]]; then
    ENVIRONMENT='uat'
else
    ENVIRONMENT='prod'
fi

# Set the source and destination paths
SOURCE_PATH="${FIREBASE_CONFIG_PATH}/${ENVIRONMENT}/GoogleService-Info.plist"
DESTINATION_PATH="${PROJECT_DIR}/Runner/GoogleService-Info.plist"

# Copy the file
if [ -f "${SOURCE_PATH}" ]; then
    cp "${SOURCE_PATH}" "${DESTINATION_PATH}"
    echo "Copied ${SOURCE_PATH} to ${DESTINATION_PATH}"
else
    echo "Error: ${SOURCE_PATH} not found"
fi
