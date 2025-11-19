# 1. 베이스 이미지: 우분투 20.04
FROM ubuntu:20.04

# 2. 빌드 중 사용자 입력을 방지 (Timezone 설정 등 멈춤 방지)
ENV DEBIAN_FRONTEND=noninteractive

# 3. 필수 패키지 설치
RUN apt-get update && \
    apt-get install -y git build-essential wget dos2unix && \
    rm -rf /var/lib/apt/lists/*

# 4. Darknet 소스 다운로드 및 작업 폴더 이동
RUN git clone https://github.com/pjreddie/darknet.git /darknet
WORKDIR /darknet

# 5. Makefile 수정 (CPU 전용 모드로 설정)
# GPU=0, CUDNN=0, OPENCV=0 (서버/도커 환경에서는 창을 띄우지 못하므로 OpenCV 0이 안정적입니다)
RUN sed -i 's/OPENCV=1/OPENCV=0/; s/GPU=1/GPU=0/; s/CUDNN=1/CUDNN=0/' Makefile && \
    make

# 6. 컴파일 (Make)
RUN make

# 7. YOLOv3 가중치 파일 다운로드
# 공식 사이트가 느릴 경우를 대비해 타임아웃을 넉넉히 주거나 미러 사이트를 고려해야 하지만, 일단 공식 링크를 유지합니다.
RUN wget https://pjreddie.com/media/files/yolov3.weights

# 8. 실행 스크립트 복사 및 권한 부여
COPY run.sh /run.sh

RUN chmod +x /run.sh

# 9. 컨테이너 실행 시 기본 명령어
ENTRYPOINT ["/run.sh"]
