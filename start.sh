#!/usr/bin/env sh

VLC=$(command -v vlc)
CONVERT=$(command -v convert)

if [ -z "${VLC_SOURCE_1X1}" ]; then
    echo "Source 1,1 not defined (VLC_SOURCE_1X1)"
    exit 1
fi

if [ -z "${VLC_SOURCE_2X1}" ]; then
    echo "Source 2,1 not defined (VLC_SOURCE_2X1)"
    exit 1
fi

if [ -z "${VLC_SOURCE_3X1}" ]; then
    echo "Source 3,1 not defined (VLC_SOURCE_3X1)"
    exit 1
fi

if [ -z "${VLC_SOURCE_1X2}" ]; then
    echo "Source 1,2 not defined (VLC_SOURCE_1X2)"
    exit 1
fi

if [ -z "${VLC_SOURCE_2X2}" ]; then
    echo "Source 2,2 not defined (VLC_SOURCE_2X2)"
    exit 1
fi

if [ -z "${VLC_SOURCE_3X2}" ]; then
    echo "Source 3,2 not defined (VLC_SOURCE_3X2)"
    exit 1
fi

if [ -z "${VLC_SOURCE_1X3}" ]; then
    echo "Source 1,3 not defined (VLC_SOURCE_1X3)"
    exit 1
fi

if [ -z "${VLC_SOURCE_2X3}" ]; then
    echo "Source 2,3 not defined (VLC_SOURCE_2X3)"
    exit 1
fi

if [ -z "${VLC_SOURCE_3X3}" ]; then
    echo "Source 3,3 not defined (VLC_SOURCE_3X3)"
    exit 1
fi

if [ -z "${VLC_THREADS}" ]; then
    VLC_THREADS=$(nproc --all)
fi

if [ -z "${VLC_MOSAIC_WIDTH}" ]; then
    VLC_MOSAIC_WIDTH=1280
fi

if [ -z "${VLC_MOSAIC_HEIGHT}" ]; then
    VLC_MOSAIC_HEIGHT=720
fi

if [ -z "${VLC_MULTICAST_IP}" ]; then
    VLC_MULTICAST_IP=234.0.0.255
fi

if [ -z "${VLC_MULTICAST_PORT}" ]; then
    VLC_MULTICAST_PORT=1234
fi

if [ -z "${VLC_MAXRATE}" ]; then
    VLC_MAXRATE=1200
fi

if [ -z "${VLC_BUFSIZE}" ]; then
    VLC_BUFSIZE=1200
fi

if [ -z "${VLC_SAP_GROUP}" ]; then
    VLC_SAP_GROUP=3x3
fi

if [ -z "${VLC_SAP_NAME}" ]; then
    VLC_SAP_NAME=Mosaic
fi

if [ -z "${VLC_ADAPTIVE_WIDTH}" ]; then
    VLC_ADAPTIVE_WIDTH=1280
fi

if [ -z "${VLC_ADAPTIVE_HEIGHT}" ]; then
    VLC_ADAPTIVE_HEIGHT=720
fi

if [ -z "${VLC_ADAPTIVE_BITRATE}" ]; then
    VLC_ADAPTIVE_BITRATE=100000
fi

if [ -z "${VLC_ADAPTIVE_LOGIC}" ]; then
    VLC_ADAPTIVE_LOGIC=highest
fi

if [ -z "${VLC_X264}" ]; then
    VLC_X264="preset=ultrafast,tune=zerolatency,keyint=30,bframes=0,ref=1,level=30,profile=baseline,hrd=cbr,crf=20,ratetol=1.0,vbv-maxrate=${VLC_MAXRATE},vbv-bufsize=${VLC_BUFSIZE},lookahead=0"
fi

if [ -z "${VLC_FPS}" ]; then
    VLC_FPS=15
fi

if [ -z "${PORT}" ]; then
    PORT=4212
fi

if [ -z "${PASSWORD}" ]; then
    PASSWORD=vlcmulticast
fi

if [ -z "${VLC_RC_PORT}" ]; then
    VLC_RC_PORT=10101
fi

if [ -z "${VLC_VERBOSE}" ]; then
    VLC_VERBOSE=0
fi

VLC_AVCODEC_OPTIONS="--avcodec-dr 0 --avcodec-corrupted 1 --avcodec-hurry-up 1 --avcodec-skip-frame 0 --avcodec-skip-idct 0 --avcodec-fast 1 --avcodec-threads ${VLC_THREADS} --sout-avcodec-strict -2"

mkdir -p ./vlc

${CONVERT} -size ${VLC_MOSAIC_WIDTH}x${VLC_MOSAIC_HEIGHT} xc:#000000 ./vlc/mosaic_background.png
SOURCE_WIDTH="$((${VLC_MOSAIC_WIDTH}/3))"
SOURCE_HEIGHT="$((${VLC_MOSAIC_HEIGHT}/3))"

cat << EOF > ./vlc/mosaic.vlm
del all

new 1x1 broadcast enabled
setup 1x1 input ${VLC_SOURCE_1X1} loop
setup 1x1 output #duplicate{dst='mosaic-bridge{id=1,width=${SOURCE_WIDTH},height=${SOURCE_HEIGHT}},select=video,dst=bridge-out{id=0},select=audio'}

new 2x1 broadcast enabled
setup 2x1 input ${VLC_SOURCE_2X1} loop
setup 2x1 output #duplicate{dst='mosaic-bridge{id=2,width=${SOURCE_WIDTH},height=${SOURCE_HEIGHT}},select=video,dst=bridge-out{id=1}'}

new 3x1 broadcast enabled
setup 3x1 input ${VLC_SOURCE_3X1} loop
setup 3x1 output #duplicate{dst='mosaic-bridge{id=3,width=${SOURCE_WIDTH},height=${SOURCE_HEIGHT}},select=video,dst=bridge-out{id=2}'}

new 1x2 broadcast enabled
setup 1x2 input ${VLC_SOURCE_1X2} loop
setup 1x2 output #duplicate{dst='mosaic-bridge{id=4,width=${SOURCE_WIDTH},height=${SOURCE_HEIGHT}},select=video,dst=bridge-out{id=3}'}

new 2x2 broadcast enabled
setup 2x2 input ${VLC_SOURCE_2X2} loop
setup 2x2 output #duplicate{dst='mosaic-bridge{id=5,width=${SOURCE_WIDTH},height=${SOURCE_HEIGHT}},select=video,dst=bridge-out{id=4}'}

new 3x2 broadcast enabled
setup 3x2 input ${VLC_SOURCE_3X2} loop
setup 3x2 output #duplicate{dst='mosaic-bridge{id=6,width=${SOURCE_WIDTH},height=${SOURCE_HEIGHT}},select=video,dst=bridge-out{id=5}'}

new 1x3 broadcast enabled
setup 1x3 input ${VLC_SOURCE_1X3} loop
setup 1x3 output #duplicate{dst='mosaic-bridge{id=7,width=${SOURCE_WIDTH},height=${SOURCE_HEIGHT}},select=video,dst=bridge-out{id=6}'}

new 2x3 broadcast enabled
setup 2x3 input ${VLC_SOURCE_2X3} loop
setup 2x3 output #duplicate{dst='mosaic-bridge{id=8,width=${SOURCE_WIDTH},height=${SOURCE_HEIGHT}},select=video,dst=bridge-out{id=7}'}

new 3x3 broadcast enabled
setup 3x3 input ${VLC_SOURCE_3X3} loop
setup 3x3 output #duplicate{dst='mosaic-bridge{id=9,width=${SOURCE_WIDTH},height=${SOURCE_HEIGHT}},select=video,dst=bridge-out{id=8}'}

## MOSAIC ##
new mosaic broadcast enabled 
setup mosaic option image-duration=-1
setup mosaic input ./vlc/mosaic_background.png
setup mosaic output #transcode{sfilter=mosaic{width=${VLC_MOSAIC_WIDTH},height=${VLC_MOSAIC_HEIGHT},cols=3,rows=3,position=1,order="1,2,3,4,5,6,7,8,9",keep-aspect-ratio=enabled,keep-picture=1,mosaic-align=5},venc=x264{${VLC_X264}},fps=${VLC_FPS},vcodec=h264,threads=${VLC_THREADS}}:duplicate{dst='rtp{access=udp,mux=ts,ttl=15,dst=${VLC_MULTICAST_IP},port=${VLC_MULTICAST_PORT},sdp=sap://,group="${VLC_SAP_GROUP}",name="${VLC_SAP_NAME}"}'}

control 1x1 play
control 2x1 play
control 3x1 play
control 1x2 play
control 2x2 play
control 3x2 play
control 1x3 play
control 2x3 play
control 3x3 play
control mosaic play
EOF

cat << EOF
Streaming Mosaic: ${VLC_SAP_GROUP}/${VLC_SAP_NAME}
Mosaic Dimensions: ${VLC_MOSAIC_WIDTH}x${VLC_MOSAIC_HEIGHT}
Video Dimensions: ${SOURCE_WIDTH}x${SOURCE_HEIGHT}
Multicast: ${VLC_MULTICAST_IP}:${VLC_MULTICAST_PORT}
Sources:
 1,1 ${VLC_SOURCE_1X1}
 2,1 ${VLC_SOURCE_2X1}
 3,1 ${VLC_SOURCE_3X1}
 1,2 ${VLC_SOURCE_1X2}
 2,2 ${VLC_SOURCE_2X2}
 3,2 ${VLC_SOURCE_3X2}
 1,3 ${VLC_SOURCE_1X3}
 2,3 ${VLC_SOURCE_2X3}
 3,3 ${VLC_SOURCE_3X3}
EOF

# /usr/bin/vlc -I telnet --telnet-password="${PASSWORD}" --telnet-port=${PORT} ${VLC_AVCODEC_OPTIONS} --drop-late-frames --skip-frames --play-and-exit --no-daemon --adaptive-logic="${VLC_ADAPTIVE_LOGIC}" --adaptive-maxwidth=${VLC_ADAPTIVE_WIDTH} --adaptive-maxheight=${VLC_ADAPTIVE_HEIGHT} --adaptive-bw=${VLC_ADAPTIVE_BITRATE} --vlm-conf=/vlc/mosaic.vlm
${VLC} -I dummy --verbose ${VLC_VERBOSE} --vlm-conf=./vlc/mosaic.vlm --no-disable-screensaver ${VLC_AVCODEC_OPTIONS} --no-repeat --no-loop --network-caching=${VLC_CACHE} --drop-late-frames --skip-frames --no-daemon --adaptive-logic="${VLC_ADAPTIVE_LOGIC}" --adaptive-maxwidth=${VLC_ADAPTIVE_WIDTH} --adaptive-maxheight=${VLC_ADAPTIVE_HEIGHT} --adaptive-bw=${VLC_ADAPTIVE_BITRATE}

cat << EOF
Mosaic Finished: ${VLC_SAP_GROUP}/${VLC_SAP_NAME}
EOF