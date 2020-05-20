# Container image for `mdBook`

A container image for [mdBook][mdbook].


This image's entrypoint is set to the `mdbook` program:

```
$ docker run carletes/mdbook
mdbook v0.3.7
Mathieu David <mathieudavid@mathieudavid.org>
Creates a book from markdown files

USAGE:
    mdbook [SUBCOMMAND]

FLAGS:
    -h, --help       Prints help information
    -V, --version    Prints version information

SUBCOMMANDS:
    build    Builds a book from its markdown files
    clean    Deletes a built book
    help     Prints this message or the help of the given subcommand(s)
    init     Creates the boilerplate structure and files for a new book
    serve    Serves a book at http://localhost:3000, and rebuilds it on changes
    test     Tests that a book's Rust code samples compile
    watch    Watches a book's files and rebuilds it on changes

For more information about a specific command, try `mdbook <command> --help`
The source code for mdBook is available at: https://github.com/rust-lang/mdBook
```

By default `mdbook` runs as user `mdbook` (UID 1000), on directory
`/home/mdbook`, so you'll have to mount your source and destination
directories accordingly:


```
$ docker run \
  --volume=$(pwd):/home/mdbook \
  carletes/mdbook \
    build
```

If you want to run the `mdbook serve` subcommand, you'll need to publish the
listening ports, and ensure `mdbook serve` listens on the right addresses
inside the container:

```
$ docker run \
  --volume=$(pwd):/home/mdbook \
  --publish 3000:3000 \
  --publish 3001:30001 \
  carletes/mdbook \
    serve \
      --hostname 0.0.0.0
2020-05-20 09:57:27 [INFO] (mdbook::book): Book building has started
2020-05-20 09:57:27 [INFO] (mdbook::book): Running the html backend
2020-05-20 09:57:27 [INFO] (mdbook::cmd::serve): Serving on: http://0.0.0.0:3000
2020-05-20 09:57:27 [INFO] (ws): Listening for new connections on 0.0.0.0:3001.
2020-05-20 09:57:27 [INFO] (mdbook::cmd::watch): Listening for changes...
```


[mdbook]: https://github.com/rust-lang/mdBook
