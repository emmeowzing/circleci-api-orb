## `circleci-api` orb

This orb provides a set of commands that wrap [CircleCI's API](https://circleci.com/docs/api/v2/), allowing you to manage your CircleCI organization within jobs and workflows.

### Development

This orb has been developed in _unpacked_ form. You may view its packed source with

```shell
$ yarn orb:pack  # creates a file 'orb.yml'
```

and further validate the resulting orb definition with

```shell
$ yarn orb:validate
```

When you're done with your testing, you may clean up the packed source with

```shell
$ yarn orb:cleaup
```

#### `pre-commit`

This repository uses `pre-commit` to uphold certain code styling and standards. You may install the hooks listed in [`.pre-commit-config.yaml`](.pre-commit-config.yaml) with

```shell
$ yarn install:pre-commit-hooks
```
