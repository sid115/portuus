# Jellyfin

## Config (Web interface)

### Transcoding

- Hardware acceleration: VAAPI
- VAAPI device: `/dev/dri/renderD128`
- Enable hardware decoding for:
    - H264
    - HEVC
    - VC1
    - AV1
    - HEVC 10bit
    - VP9 10bit
- Encoding format options
    - HEVC
    - AV1
- Enable VPP Tone mapping
- Transcode path: `/data/jellyfin/transcodes`
```bash
sudo mkdir /data/jellyfin/transcodes
sudo chown jellyfin:jellyfin /data/jellyfin/transcodes
sudo chmod 700 /data/jellyfin/transcodes
```

## Libraries

### Movies

- Directory: `/data/jellyfin/libraries/movies`
- Do not create subdirectories
- Naming scheme: `title.year.file` (lower case ASCII, underscores instead of spaces)
    - For example: `the_matrix.1999.mkv`

### Music

*tbd*

### Shows

- Directory: `/data/jellyfin/libraries/shows`
- Create a subdirectory for every show and every season of it.
- Naming scheme: `title/s00/title.s00e00.file` (lower case ASCII, underscores instead of spaces)
    - For example: `game_of_thrones/s01/game_of_thrones.s01e01.mkv`
