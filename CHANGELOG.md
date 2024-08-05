# CHANGELOG

## v2.3.1 _2024-08-05_

- Update to Ruby 3.3.4
- Update dependencies

## v2.3.0 _2023-07-04_

- Update to Ruby 3.3.3
- Update to Alpine 20
- Update dependencies

## v2.2.0 _2023-02-13_

- Added a version endpoint
- New Relic now defaults to off
- Updated to Ruby 3.2.1

## v2.1.0 _2023-01-31_

- `mime_type` param is no longer required. The application will now determine the mime-type.
- `height` is now an optional parameter (default 800)
- `width` is now an optional parameter (default 800)
- svgs will now be optimised
- inputs now have better validation
- include newrelic_rpm

## v2.0.0 _2022-07-04_

- Add arm64 compatibility
- Dependency update
- Multistage build for a smaller image
