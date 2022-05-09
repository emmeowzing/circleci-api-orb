## `circleci-api` orb

This orb provides a set of commands that wrap [CircleCI's API](https://circleci.com/docs/api/v2/), allowing you to manage your CircleCI organization within jobs and workflows.

### Development

This orb has been developed in _unpacked_ form. You may view its packed source with

```shell
$ ./scripts/pre-pack.sh
$ circleci orb pack src/ > orb.yml
```

and further validate the resulting orb definition with

```shell
$ circleci orb validate orb.yml
```

#### `pre-commit`

This repository uses `pre-commit` to uphold certain code styling and standards. You may install the hooks listed in [`.pre-commit-config.yaml`](.pre-commit-config.yaml) with

```shell
$ yarn install:pre-commit-hooks
```
