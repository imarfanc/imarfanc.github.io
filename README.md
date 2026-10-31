# Arfan's Blog

Source for <https://imarfanc.github.io>, a Jekyll blog based on the
[Beautiful Jekyll](https://github.com/daattali/beautiful-jekyll) theme. GitHub Pages builds and
publishes `master` on every push.

## Commands

Needs the Ruby version in `.ruby-version`, which is newer than the one macOS ships.

| Command        | What it does                                                 |
| -------------- | ------------------------------------------------------------ |
| `make install` | Install the gems GitHub Pages uses                           |
| `make serve`   | Preview at <http://localhost:4000>, reloading on changes     |
| `make drafts`  | Same, including posts in `_drafts/`                          |
| `make build`   | Build the production site into `_site/`                      |
| `make check`   | Build, then check posts, page metadata and internal links    |

## Writing a post

Copy `_drafts/EXAMPLE.md` to `_posts/YYYY-MM-DD-lowercase-slug.md`. The post is published at
`/lowercase-slug/`. Use tags from `_data/tags.yml`, and add `published: false` to keep a post in the
repo but off the site. The repo is public, so unpublished posts can still be read on GitHub.

## Updating the theme

```bash
git fetch upstream
```

```bash
git merge upstream/master
```

Files removed here that upstream later changes show up as conflicts. Keep them deleted.
