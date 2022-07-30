# Dockerized visidata

## Usage

Build:

```
docker build -t void:visidata .
```

Open file:
```
./visidata.sh {file}
```

or PostgreSQL database:
```
./visidata.sh postgresql://{database spec}
```

Currently script covers only these two cases of visidata usage.
