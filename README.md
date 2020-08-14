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

## Experiment: ESLint + Prettier vs ESLint + Google

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

_Edited 2020-08-14: I examined the diff logs again, and discovered that my previous analysis was significantly misguided. Added new info._

Note that many "changes" are not changes at all. Some changes change the rule notation without altering their meaning (e.g. replacing `"error"` with `2`, or vice versa). Other changes modify rules that are already disabled (`0` or `"off"`).

#### What does `eslint:recommended` add to Google Style + Prettier?

`eslint:recommended` adds 47 rules not covered by eslint-config-google or Prettier:

* [for-direction](https://eslint.org/docs/rules/for-direction)
* [getter-return](https://eslint.org/docs/rules/getter-return)
* [no-async-promise-executor](https://eslint.org/docs/rules/no-async-promise-executor)
* [no-case-declarations](https://eslint.org/docs/rules/no-case-declarations)
* [no-class-assign](https://eslint.org/docs/rules/no-class-assign)
* [no-compare-neg-zero](https://eslint.org/docs/rules/no-compare-neg-zero)
* [no-const-assign](https://eslint.org/docs/rules/no-const-assign)
* [no-constant-condition](https://eslint.org/docs/rules/no-constant-condition)
* [no-control-regex](https://eslint.org/docs/rules/no-control-regex)
* [no-debugger](https://eslint.org/docs/rules/no-debugger)
* [no-delete-var](https://eslint.org/docs/rules/no-delete-var)
* [no-dupe-args](https://eslint.org/docs/rules/no-dupe-args)
* [no-dupe-class-members](https://eslint.org/docs/rules/no-dupe-class-members)
* [no-dupe-else-if](https://eslint.org/docs/rules/no-dupe-else-if)
* [no-dupe-keys](https://eslint.org/docs/rules/no-dupe-keys)
* [no-duplicate-case](https://eslint.org/docs/rules/no-duplicate-case)
* [no-empty](https://eslint.org/docs/rules/no-empty)
* [no-empty-character-class](https://eslint.org/docs/rules/no-empty-character-class)
* [no-empty-pattern](https://eslint.org/docs/rules/no-empty-pattern)
* [no-ex-assign](https://eslint.org/docs/rules/no-ex-assign)
* [no-extra-boolean-cast](https://eslint.org/docs/rules/no-extra-boolean-cast)
* [no-fallthrough](https://eslint.org/docs/rules/no-fallthrough)
* [no-func-assign](https://eslint.org/docs/rules/no-func-assign)
* [no-global-assign](https://eslint.org/docs/rules/no-global-assign)
* [no-import-assign](https://eslint.org/docs/rules/no-import-assign)
* [no-inner-declarations](https://eslint.org/docs/rules/no-inner-declarations)
* [no-invalid-regexp](https://eslint.org/docs/rules/no-invalid-regexp)
* [no-misleading-character-class](https://eslint.org/docs/rules/no-misleading-character-class)
* [no-obj-calls](https://eslint.org/docs/rules/no-obj-calls)
* [no-octal](https://eslint.org/docs/rules/no-octal)
* [no-prototype-builtins](https://eslint.org/docs/rules/no-prototype-builtins)
* [no-redeclare](https://eslint.org/docs/rules/no-redeclare)
* [no-regex-spaces](https://eslint.org/docs/rules/no-regex-spaces)
* [no-self-assign](https://eslint.org/docs/rules/no-self-assign)
* [no-setter-return](https://eslint.org/docs/rules/no-setter-return)
* [no-shadow-restricted-names](https://eslint.org/docs/rules/no-shadow-restricted-names)
* [no-sparse-arrays](https://eslint.org/docs/rules/no-sparse-arrays)
* [no-undef](https://eslint.org/docs/rules/no-undef)
* [no-unreachable](https://eslint.org/docs/rules/no-unreachable)
* [no-unsafe-finally](https://eslint.org/docs/rules/no-unsafe-finally)
* [no-unsafe-negation](https://eslint.org/docs/rules/no-unsafe-negation)
* [no-unused-labels](https://eslint.org/docs/rules/no-unused-labels)
* [no-useless-catch](https://eslint.org/docs/rules/no-useless-catch)
* [no-useless-escape](https://eslint.org/docs/rules/no-useless-escape)
* [require-yield](https://eslint.org/docs/rules/require-yield)
* [use-isnan](https://eslint.org/docs/rules/use-isnan)
* [valid-typeof](https://eslint.org/docs/rules/valid-typeof)

#### What does Google Style add to `eslint:recommended` + Prettier?

eslint-config-google enables 21 rules not covered by `eslint:recommended` and Prettier:

* [camelcase](https://eslint.org/docs/rules/camelcase)
* [guard-for-in](https://eslint.org/docs/rules/guard-for-in)
* [new-cap](https://eslint.org/docs/rules/new-cap)
* [no-array-constructor](https://eslint.org/docs/rules/no-array-constructor)
* [no-caller](https://eslint.org/docs/rules/no-caller)
* [no-extend-native](https://eslint.org/docs/rules/no-extend-native)
* [no-extra-bind](https://eslint.org/docs/rules/no-extra-bind)
* [no-invalid-this](https://eslint.org/docs/rules/no-invalid-this)
* [no-multi-str](https://eslint.org/docs/rules/no-multi-str)
* [no-new-object](https://eslint.org/docs/rules/no-new-object)
* [no-new-wrappers](https://eslint.org/docs/rules/no-new-wrappers)
* [no-throw-literal](https://eslint.org/docs/rules/no-throw-literal)
* [no-var](https://eslint.org/docs/rules/no-var)
* [one-var](https://eslint.org/docs/rules/one-var)
* [prefer-const](https://eslint.org/docs/rules/prefer-const)
* [prefer-promise-reject-errors](https://eslint.org/docs/rules/prefer-promise-reject-errors)
* [prefer-rest-params](https://eslint.org/docs/rules/prefer-rest-params)
* [prefer-spread](https://eslint.org/docs/rules/prefer-spread)
* [require-jsdoc](https://eslint.org/docs/rules/require-jsdoc)
* [spaced-comment](https://eslint.org/docs/rules/spaced-comment)
* [valid-jsdoc](https://eslint.org/docs/rules/valid-jsdoc)

It relaxes or disables 2 rules:

* [no-cond-assign](https://eslint.org/docs/rules/no-cond-assign) (_disabled_)
* [no-unused-vars](https://eslint.org/docs/rules/no-unused-vars) (is _disabled_ for function arguments)

It changes the notation for 4 rules, but doesn't alter their effect:

* [no-irregular-whitespace](https://eslint.org/docs/rules/no-irregular-whitespace)
* [no-new-symbol](https://eslint.org/docs/rules/no-new-symbol)
* [no-this-before-super](https://eslint.org/docs/rules/no-this-before-super)
* [no-with](https://eslint.org/docs/rules/no-with)

eslint-config-google modifies 15 rules that are already disabled by eslint-config-prettier, and therefore have no effect:

* [array-bracket-spacing](https://eslint.org/docs/rules/array-bracket-spacing)
* [arrow-parens](https://eslint.org/docs/rules/arrow-parens)
* [block-spacing](https://eslint.org/docs/rules/block-spacing)
* [comma-dangle](https://eslint.org/docs/rules/comma-dangle)
* [curly](https://eslint.org/docs/rules/curly)
* [generator-star-spacing](https://eslint.org/docs/rules/generator-star-spacing)
* [indent](https://eslint.org/docs/rules/indent)
* [max-len](https://eslint.org/docs/rules/max-len)
* [no-multiple-empty-lines](https://eslint.org/docs/rules/no-multiple-empty-lines)
* [operator-linebreak](https://eslint.org/docs/rules/operator-linebreak)
* [padded-blocks](https://eslint.org/docs/rules/padded-blocks)
* [quote-props](https://eslint.org/docs/rules/quote-props)
* [quotes](https://eslint.org/docs/rules/quotes)
* [space-before-function-paren](https://eslint.org/docs/rules/space-before-function-paren)
* [yield-star-spacing](https://eslint.org/docs/rules/yield-star-spacing)

### Summary

* [eslint-config-google] overrides or removes some rules in
  `eslint:recommended`, and adds several more
* `eslint:recommended` adds many rules not supplied by [eslint-config-google].
* Even with [eslint-config-prettier] active, [eslint-config-google] and
  `eslint:recommended` have non-overlapping rules.

## Verdict

Use `eslint:recommended`, [eslint-config-google], and [eslint-config-prettier]
together, _in this order_.
