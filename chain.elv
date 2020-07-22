use github.com/sblundy/elvish-chain-theme/styling
prompt-segments   = [ ]
rprompt-segments  = [ ]

config = [
    &prefix= ""
    &suffix= ""
    &segment-prefix= " "
    &segment-suffix= " "
  &default-style=(styling:create-style color0 color11)
]

prompt-config = [
  &separator-trailing="\ue0b0"
  &prefix= ""
  &suffix= "\ue0b0 "
]

rprompt-config = [
  &separator-leading="\ue0b2"
  &prefix= "\ue0b2"
  &suffix= ""
]

# Style manipulation

fn get-fg [s]{
    put $s[fg-color]
}

fn set-fg [s fg]{
  if (not (has-prefix $fg "color")) {
    fg="color"$fg
  }
  s[fg-color] = $fg
  put $s
}

fn get-bg [s]{
  put $s[bg-color]
}

fn set-bg [s bg]{
  if (not (has-prefix $bg "color")) {
    bg="color"$bg
  }
  s[bg-color] = $bg
  put $s
}

fn -build-prompt [segments cfg]{
  if (== (count $segments) 0) {
    return
  }
  first = $true
  last-style = $cfg[default-style]

  fn prefix-styled [text style]{
    if (!=s "" $text) {
      put (styled-segment $text &fg-color=(get-bg $style))
    }
  }
  fn suffix-styled [text]{
    if (!=s "" $text) {
      put (styled-segment $text &fg-color=(get-bg $last-style))
    }
  }

  fn separator-trailing-styled [text current-style]{
    if (!=s "" $text) {
      my-style=[&fg-color=(get-bg $last-style) &bg-color=(get-bg $current-style)]
      put (styling:apply-style $text $my-style)
    }
  }

  fn separator-leading-styled [text current-style]{
    if (!=s "" $text) {
      my-style=[&fg-color=(get-bg $current-style) &bg-color=(get-bg $last-style)]
      put (styling:apply-style $text $my-style)
    }
  }

  for seg $segments {
    out = [($seg)]
    if (> (count $out) 0) {
      out=$out[0]
      beginning-style = (styling:extract-style $out[0])
      ending-style =  (styling:extract-style $out[-1])

      if $first {
        put (prefix-styled $cfg[prefix] $beginning-style)
        first = $false
      } else {
        if (has-key $cfg separator-trailing) {
          put (separator-trailing-styled $cfg[separator-trailing]  $beginning-style)
        }
        if (has-key $cfg separator-leading) {
          put (separator-leading-styled $cfg[separator-leading] $beginning-style)
        }
      }

      put (styling:apply-style $cfg[segment-prefix] $beginning-style)
      put $out
      put (styling:apply-style $cfg[segment-suffix] $ending-style)

      last-style = $ending-style
    }
  }

  put (suffix-styled $cfg[suffix])
}

fn -render-prompt [segments @cfgs]{
  merged_cfg = [&]
  for cfg $cfgs {
    for k [(keys $cfg | all)] {
      merged_cfg[$k] = $cfg[$k]
    }
  }

  for s [(-build-prompt $segments $merged_cfg)] {
    put $s
  }
}

# Prompt and rprompt functions (careful, they will be executed concurrently)
fn prompt {
  -render-prompt $prompt-segments  $config $prompt-config
}

fn rprompt {
  -render-prompt $rprompt-segments $config $rprompt-config
}

# Default init, assigning our functions to `edit:prompt` and `edit:rprompt`
fn init {
  edit:prompt = $prompt~
  edit:rprompt = $rprompt~
}
