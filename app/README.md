# Image resizer

A Ruby app to resize images built with the Sinatra web framework and ImageMagic library.

```sh
cd app
bundle install
rackup
open http:localhost:9292
```

## Docker container

The `Dockerfile` creates the app's image based on Ruby Alpine. There are a few dependencies for the `image_processing` gem that are added to that and then the ruby gems and app code.

Here are the some commands for development and testing purposes based on the guide found [here](https://www.codewithjason.com/dockerize-sinatra-application/).

- `docker build -t sinatra-app . --no-cache`
- `docker run -p 80:4567 sinatra-app`
- `open http://localhost`

## Testing

Use `curl` to test sending requests to the host paths and download the returned images. Note that `.tif` format files are converted to `.png` files.

- `curl http://localhost/test/png --output ./resized-png.png`
- `curl http://localhost/test/tif --output ./resized-tif-converted-to-png.png`

Example command for sending a file to the service:

- `curl -X POST -H 'Content-Type: image/png' -d @"./app/test_images/test-png.png" http://localhost/image -o test.png`