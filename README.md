# copier-templates

Five independent [Copier](https://copier.readthedocs.io) templates that stack on top of each other to scaffold a
project's tooling.

## Usage

All templates share the repository's root `copier.yml`: pick one with `-d template=<name>` and give each its own answers
file with `-a .copier-answers.<name>.yml`. Their questions and tasks live in `templates/<name>/questions.yml` and
`templates/<name>/tasks.yml`.

### Apply just `base`

```bash
mkdir my-project && cd my-project
git init
copier copy --trust -a .copier-answers.base.yml -d template=base gh:aacebedo/copier-templates .
git add . && git commit -m 'Apply base template'
```

### Stack `base` + `rust` (or `python`)

```bash
mkdir my-project && cd my-project
git init

# 1. Base tooling
copier copy --trust -a .copier-answers.base.yml -d template=base gh:aacebedo/copier-templates .
git add . && git commit -m 'Apply base template'

# 2. Rust tooling on top of it
copier copy --trust -a .copier-answers.rust.yml -d template=rust gh:aacebedo/copier-templates .
git add . && git commit -m 'Apply rust template'

mise install
mise run rust:build
mise run rust:run:tests

mise run lint
```

### Updating later

Because each template tracks its own answers file, `copier update` works per template:

```bash
copier update -a .copier-answers.base.yml
copier update -a .copier-answers.rust.yml
```
