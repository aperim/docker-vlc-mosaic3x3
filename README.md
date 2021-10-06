# VLC to 3x3 Mosaic

## What does it do?

Creates a 3x3 mosaic and multicasts it

## Who is it for?

You, I guess?!

## How do I do?

```bash
docker run -it --rm --network host \
    -e VLC_SOURCE_1X1="http://example.com/stream/exciting_video" \
    -e VLC_SOURCE_2X1="http://example.com/stream/exciting_video" \
    -e VLC_SOURCE_3X1="http://example.com/stream/exciting_video" \
    -e VLC_SOURCE_1X2="http://example.com/stream/exciting_video" \
    -e VLC_SOURCE_2X2="http://example.com/stream/exciting_video" \
    -e VLC_SOURCE_3X2="http://example.com/stream/exciting_video" \
    -e VLC_SOURCE_1X3="http://example.com/stream/exciting_video" \
    -e VLC_SOURCE_2X3="http://example.com/stream/exciting_video" \
    -e VLC_SOURCE_3X3="http://example.com/stream/exciting_video" \
    ghcr.io/aperim/vlc-matrix3x3:latest
```

## That's it?

Yes.

## Important

This is multicast - make sure you set `network` to `host`.
