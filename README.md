# Using ESLint and Prettier together

This repository contains my explorations on how ESLint and Prettier should be
used together.

## ESLint

* Home page: https://eslint.org/
* NPM package: https://www.npmjs.com/package/eslint

JavaScript linter with limited fixing capabilities via the `--fix` CLI option.

Pros:
* Supports rules that dictate and change the shape of the abstract syntax tree

Cons:
* Only handles JavaScript (+ TypeScript)
* Reports errors it can't fix

## Prettier

* Home page: https://prettier.io/
* NPM package: https://www.npmjs.com/package/prettier

Opinionated formatter for a variety of programming and markup languages.

Pros:
* Can handle JavaScript, TypeScript, JSON, CSS, HTML, and more
* Smarter than ESLint at fixing issues that it can handle

Cons:
* Will not modify the abstract syntax tree of the code

## Using ESLint and Prettier Together

Many ESLint rules are covered by Prettier. Running one after another will cause
them to needlessly double-check the same rules, or experience conflicts when
they have different policies about a rule.

There are several tools that can solve this problem.

### Favor Prettier

* [eslint-config-prettier]: Turns off all ESLint rules already covered by
  Prettier, so that ESLint can focus on rules only it can handle
* [eslint-plugin-prettier]: Integrates Prettier _into_ ESLint, so that ESLint
  reports formatting issues detected by Prettier. Running ESLint with `--fix`
  will make Prettier fix the issues.

### Favor ESLint

* [prettier-eslint]: Runs Prettier first, then passes its output to
  `eslint --fix`. Requires [prettier-eslint-cli] to run as a command-line tool.

[eslint-config-prettier]: https://github.com/prettier/eslint-config-prettier
[eslint-plugin-prettier]: https://github.com/prettier/eslint-plugin-prettier
[prettier-eslint]: https://github.com/prettier/prettier-eslint
[prettier-eslint-cli]: https://github.com/prettier/prettier-eslint-cli

### Further Considerations

ESLint supports a built-in configuration named `eslint:recommended`, which
enables a subset of core rules.

`eslint --init` also offers three presets based on popular 3rd-party style
guides:

* [Airbnb](https://github.com/airbnb/javascript)
* [Standard](https://github.com/standard/standard)
* [Google](https://github.com/google/eslint-config-google)

Of these, I personally prefer the Google Style Guide, because it is less
restrictive than Airbnb, and allows (enforces) semicolons. It also does not have
a misleading name.

However, I must wonder: if Prettier already checks the formatting of the code,
are these rules necessary?

[eslint-config-google]: https://github.com/google/eslint-config-google

## Experiment

The following ESLint configuration files are used in the experiment. I generated
them with `eslint --init` (using ESLint 7.6.0), then manually added
[eslint-config-prettier].

To generate the _result configurations_, I used ESLint's
[`--print-config` option](https://eslint.org/docs/user-guide/command-line-interface#-print-config).
The input file is not important here; I used an empty file named `dummy.js`.

The config files are:

* `google-prettier.eslintrc.yml`: Config file with [eslint-config-google] and
  [eslint-config-prettier]
* `recommended-prettier.eslintrc.yml`: Config file with `"eslint:recommended"`
  and [eslint-config-prettier]
* `recommended-google-prettier.eslintrc.yml`: Config file with
  `"eslint:recommended"`, [eslint-config-google] and [eslint-config-prettier]
    * Note: eslint-config-google [advises](https://github.com/google/eslint-config-google#using-the-google-config-with-eslintrecommended)
    that `google` should come _after_ `"eslint:recommended"` in the `extends`
    field.

I used `generate-config.sh` to generate the result config files.

### Results

`result-1.diff` contains the diff log between `config-google-prettier.json` and
`config-recommended-google-prettier.json`.

`result-2.diff` contains the diff log between `config-recommended-prettier.json`
and `config-recommended-google-prettier.json`.

In summary:

* [eslint-config-google] overrides or removes some rules in
  `eslint:recommended`, and adds several more
* `eslint:recommended` adds many rules not supplied by [eslint-config-google].
* Even with [eslint-config-prettier] active, [eslint-config-google] and
  `eslint:recommended` have non-overlapping rules.

## Verdict

Use `eslint:recommended`, [eslint-config-google], and [eslint-config-prettier]
together, _in this order_.
