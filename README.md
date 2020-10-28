# Image Resizer

A Ruby app to resize images built with the Sinatra web framework and ImageMagic library.

## Setup and run

```sh
bundle install
rackup
open http:localhost:9292
```

## Docker container

The `Dockerfile` creates the app's image based on Ruby Alpine. There are a few dependencies for the `image_processing` gem that are added to that and then the ruby gems and app code.

Here are the some commands for development and testing purposes based on the guide found [here](https://www.codewithjason.com/dockerize-sinatra-application/).

```sh
docker build -t image-resizer . --no-cache
docker run -p 80:4567 image-resizer
```

If you want to use an internet browser to test the app is running you can visit the url `http://localhost`


The docker build and run commands above are available as scripts in the `docker` folder. These are designed for development and testing purposes only.

- `./docker/build.sh`
- `./docker/start.sh`


## Testing

Use `curl` to test sending requests to the host paths and download the returned images. Note that `.tif` format files are converted to `.png` files.

Example command for sending a file to the service:

```sh
curl -X POST -F mime_type='image/png' -F image=@"./test_images/test-png.png" http://localhost/image --output test-image-resizer.png
```