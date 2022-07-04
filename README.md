# Image Resizer

A Ruby app to resize images built with the Sinatra web framework and ImageMagick library.

## Setup

You will need to install the dependencies for the Ruby `image_processing` gem. Here is the homebrew command for installing `imagemagick` on a mac.

```sh
brew install imagemagick
```

Then you can install the Ruby gems and start the app locally.

```sh
bundle install
```

## Run the app

If you are running the app locally outside of Docker then you can run it using:

```rb
rackup
```

## Building the image

```bash
# Build
docker build -t citizensadvice/image-resizer .

# Test
docker-compose run --rm app bundle exec rspec

# Start
docker-compose up
```

The url is http://localhost:4567

Visiting this in a web browser displays a liveness message to confirm the service is running.

## Resizing images

The endpoint for resizing images is `/image` and it requires the params posted as multi-part form data.

- `mime_type` for example `image/png`
- `image_file` for example an image in the format `.png, .jpg, .gif, and .tif`

Image files in the format `TIFF` are converted to `PNG` automatically.

The returned images are only resized if they have dimensions larger than `800px`, in which case they are resized maintaining their aspect ratio so their dimensions are a maximum of `900px`.

## Testing

The automated tests are in the `spec` folder and there are test image files in the `spec/fixtures/image_files` folder. To run the Ruby tests use the command:

```rb
bundle exec rspec
```

They can also be run inside a Docker container using the scripts in the `docker` folder.

```sh
docker/build.sh
docker/test.sh
```

To manually test the image resizer app, you can run the app locally and then use `curl` via the command line. Here are some example commands that send image files to the app and then save the resized image that is returned.

### `PNG`

```sh
curl -X POST -F mime_type='image/png' -F image_file=@"./spec/fixtures/image_files/test-png-1102x1287px.png" http://localhost:4567/image --output test-png-image-resized.png
```

### `GIF`

```sh
curl -X POST -F mime_type='image/gif' -F image_file=@"./spec/fixtures/image_files/test-gif-1102x1287px.gif" http://localhost:4567/image --output test-gif-image-resized.gif
```

### `JPEG`

```sh
curl -X POST -F mime_type='image/jpeg' -F image_file=@"./spec/fixtures/image_files/test-jpg-1102x1287px.jpg" http://localhost:4567/image --output test-jpg-image-resized.jpg
```

### `TIFF`

For images in the `TIFF` format they are automatically converted to `PNG`, so here is an example for this scenario.

```sh
curl -X POST -F mime_type='image/tiff' -F image_file=@"./spec/fixtures/image_files/test-bad-tif-800x1000px.tif" http://localhost:4567/image --output test-tif-image-resizer.png
``` 
