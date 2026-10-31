# imarfanc.github.io

Personal Jekyll blog on the Beautiful Jekyll theme. GitHub Pages builds `master`, so a push to
`master` publishes.

- Run `make check` after changes. It builds the site, then runs `scripts/check.rb`.
- Posts are `_posts/YYYY-MM-DD-lowercase-slug.md` with `title`, `share-description`, and `tags` from
  `_data/tags.yml`. `_drafts/EXAMPLE.md` shows the format.
- Only use plugins GitHub Pages allows. The `github-pages` gem sets the versions.
- Theme colors are CSS variables in `assets/css/beautifuljekyll.css`. Keep the dark mode block at the
  end of that file in step with any new colors.
- Keep the changes to theme files small so `git merge upstream/master` stays easy.
- `published: false` posts remain readable in this public repo. Don't treat them as private.
