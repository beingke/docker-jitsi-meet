#!/bin/bash

# $1 receives the directory where the recording is
# (e.g /config/recordings/azozsjxbvjtvdzkz)
# This folder contains two files:
#
# 1. roomName_DATE_TIME.mp4 (e.g ethnicbishopsnegotiateextra_2020-10-27-15-39-44.mp4)
# 2. metadata.json: {
#     "meeting_url":"https://meet.antidote.gg/roomName",
#     "participants":[],
#     "share":true
# }
#

echo -e "Executing Finalize Script"

RECORDINGS_DIR=$1
VIDEO_FILE_PATH=$(find $RECORDINGS_DIR -name *.mp4)
VIDEO_FILE_NAME=${VIDEO_FILE_PATH:36}
ROOM_NAME=`cat $1/metadata.json | jq -r '.meeting_url' | awk -F/ '{print $4}'`
RENAMED_VIDEO=$RECORDINGS_DIR/$ROOM_NAME.mp4

echo -e "Environment Variables"
printenv

echo -e "Renaming Video..."
mv $VIDEO_FILE_PATH $RENAMED_VIDEO

echo -e "Video Path: $VIDEO_FILE_PATH"
echo -e "Video File Name: $VIDEO_FILE_NAME"
echo -e "Renamed Video: $RENAMED_VIDEO"

echo -e "Uploading..."
aws s3 cp $RENAMED_VIDEO s3://$JIBRY_S3_BUCKET_NAME/ --debug 2>&1 >> /config/logs/upload.0.txt
