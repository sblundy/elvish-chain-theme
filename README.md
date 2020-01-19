# Elvish Chain Theme

Chain/Powerline style theme for Elvish Shell. Derived from a theme by [Christian Muehlhaeuser](https://github.com/muesli/), it has an improved `rprompt` and finer control over the details of the prompts.

# Setup

To install, simply use `epm`
```bash
use epm
epm:install github.com/sblundy/elvish-chain-theme
```

And add this to your `~/.elvish/rc.elv`

```
use segments      # (Optional) Contains basic segments
use segments-git  # (Optional) Has git status segments
use chain

chain:prompt-segments = [
  $segments:segment-dir~
  $segments:segment-timestamp~
  $segments:segment-arrow~
]

chain:rprompt-segments = [
  $segments-git:pseudo-segment-init~
  $segments-git:segment-branch~
  $segments-git:segment-ahead~
  $segments-git:segment-behind~
  $segments-git:segment-staged~
  $segments-git:segment-dirty~
  $segments-git:segment-untracked~
]

```

## Custom Segment

Each segment is a function that returns 0 or more `styled` elements. 

# Acknowledgements

* [Christian Muehlhaeuser's Powerline Theme](https://github.com/muesli/elvish-libs/blob/master/theme/powerline.elv)
