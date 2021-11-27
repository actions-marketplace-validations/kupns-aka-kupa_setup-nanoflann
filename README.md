# Setup [nanoflann](https://github.com/jlblancoc/nanoflann) docker action

Set up your GitHub Actions workflow with a specific version of the nanoflann

## Inputs

## `version`

**Not Required** Version of nanoflann. Default `latest`.

## Example usage

```yml
      - name: Install nanoflann
        uses: kupns-aka-kupa/setup-nanoflann@v1
        with:
          version: 1.1.1
```

### Specify target platform

Env `CMAKE_GENERATOR`. Default depends on platform

```yml
      - name: Install nanoflann
        uses: kupns-aka-kupa/setup-nanoflann@v1
        env:
          CMAKE_GENERATOR: MinGW Makefiles
```

[More available generators](https://cmake.org/cmake/help/latest/manual/cmake-generators.7.html)
