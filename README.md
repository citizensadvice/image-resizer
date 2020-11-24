# Image Resizer

A Ruby app to resize images built with the Sinatra web framework and ImageMagick library.

## Setup and run

You will need to install the dependencies for the ruby image processing gem. Here is the homebrew command for installing `imagemagick` on a mac:

```sh
brew install imagemagick
```

Then you can install the ruby gems and start the app locally.

```sh
bundle install
rackup
```

The url is `http:localhost:4567`

Visiting this in a web browser displays a liveness message to confirm the service is running.

The endpoint for resizing images is `/image` and it requires the params posted as multi-part form data.

- `mime_type` for example "image/png"
- `image_file` for example an image in the format `.png`


## Docker container

The `Dockerfile` creates the app's image based on Ruby Alpine. There are a few dependencies for the `image_processing` gem that are added to that and then the ruby gems and app code.

There are some docker build, run, and test scripts in the `docker` folder. These are designed for development and testing purposes only.

- `docker/build.sh`
- `docker/start.sh`
- `docker/test.sh` (runs the ruby tests)


## Testing

Use `curl` to test sending requests to the host paths and download the returned images. Note that `.tif` format files are converted to `.png` files.

Example command for sending a png file to the service:

```sh
curl -X POST -F mime_type='image/png' -F image_file=@"./spec/fixtures/image_files/test-png-1102x1287px.png" http://localhost:4567/image --output test-png-image-resizer.png
```

Sometimes we have to process images in bad formats so as well as resizing an image
it may have to reformat it as another image type, such as `.tif` to `.png`.

Here is a command for testing a badly formatted `.tif` image file that will return
a resized version as a `.png` image file:

```sh
curl -X POST -F mime_type='image/tiff' -F image_file=@"./spec/fixtures/image_files/test-bad-tif-800x1000px.tif" http://localhost:4567/image --output test-tif-image-resizer.png
``` 