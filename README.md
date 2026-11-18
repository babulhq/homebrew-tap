# babulhq/tap

Homebrew formulae for [Babul](https://babul.dev).

The desktop app (preview, Apple silicon):

```sh
brew install --cask babulhq/tap/babul-app
```

The command line that runs Babul's own company:

```sh
brew install babulhq/tap/babul
brew tap coleam00/archon && brew install coleam00/archon/archon
brew install --cask claude-code
babul setup
```

`babul setup` links Babul's workflows into Archon and starts the scheduler and the app (http://localhost:4100) at login. Run it again after `brew upgrade babul`. Archon has its own tap, and Homebrew only trusts taps you add yourself, so it is a separate step. Your data stays in `~/.babul`.

Babul's own repo is private for now, so Homebrew clones it over SSH with your GitHub key: `ssh -T git@github.com` must greet you first.
