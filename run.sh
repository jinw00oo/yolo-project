#!/bin/bash
set -e

# 첫 번째 인자로 URL을 받음
URL=$1

# [수정됨] URL이 입력되지 않았을 경우 에러 처리
if [ -z "$URL" ]; then
    echo "Error: Image URL is missing."
    echo "Usage: docker run <image_name> <image_url>"
    exit 1
fi

IMG="/darknet/input.jpg"

# 이미지 다운로드 (파일명 변경하여 저장)
echo "Downloading image from $URL..."
wget -O "$IMG" "$URL" -q

# YOLO 실행
echo "Running YOLOv3 detection..."
/darknet/darknet detect /darknet/cfg/yolov3.cfg /darknet/yolov3.weights "$IMG"
