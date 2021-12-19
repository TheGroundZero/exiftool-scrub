# exiftool-scrub

Docker image with exiftool to recursively scrub all exif data

```bash
git clone https://github.com/TheGroundZero/exiftool-scrub
cd exiftool-scrub
docker build .
docker run -v $TARGET_DIR:/src exiftool-scrub
```
