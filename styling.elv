fn transformer [style]{
  fn apply-fg-color [next]{
    put [s]{ styled-segment ($next $s) &fg-color=$style[fg-color] }
  }
  fn apply-bg-color [next]{
    put [s]{ styled-segment ($next $s) &bg-color=$style[bg-color] }
  }
  fn apply-bold [next]{
    put [s]{ styled-segment ($next $s) &bold=$true }
  }
  fn apply-dim [next]{
    put [s]{ styled-segment ($next $s) &dim=$true }
  }
  fn apply-italic [next]{
    put [s]{ styled-segment ($next $s) &italic=$true }
  }
  fn apply-underlined [next]{
    put [s]{ styled-segment ($next $s) &underlined=$true }
  }
  fn apply-blink [next]{
    put [s]{ styled-segment ($next $s) &blink=$true }
  }
  fn apply-inverse [next]{
    put [s]{ styled-segment ($next $s) &inverse=$true }
  }

  x=[s]{ put $s }
  if (has-key $style fg-color) {
    x=(apply-fg-color $x)
  }
  if (has-key $style bg-color) {
    x=(apply-bg-color $x)
  }
  if (has-key $style bold) {
    x=(apply-bold $x)
  }
  if (has-key $style dim) {
    x=(apply-dim $x)
  }
  if (has-key $style italic) {
    x=(apply-italic $x)
  }
  if (has-key $style underlined) {
    x=(apply-underlined $x)
  }
  if (has-key $style blink) {
    x=(apply-blink $x)
  }
  if (has-key $style inverse) {
    x=(apply-inverse $x)
  }
  put $x
}

fn create-style [fg bg &bold=$false &dim=$false &italic=$false &underlined=$false &blink=$false &inverse=$false]{
  s=[&]
  if (!=s $fg '') {
    s[fg-color]=$fg
  }
  if (!=s $bg '') {
    s[bg-color]=$bg
  }
  if $bold {
    s[bold]=$true
  }
  if $dim {
    s[dim]=$true
  }
  if $italic {
    s[italic]=$true
  }
  if $underlined {
    s[underlined]=$true
  }
  if $blink {
    s[blink]=$true
  }
  if $inverse {
    s[inverse]=$true
  }
  put $s
}

fn apply-style [x style]{
  styled $x (transformer $style)
}

fn extract-style [x &favor-last=$false]{
  if (==s 'map' (kind-of $x)) {
    s=[&]
    if (has-key $x fg-color) {
      s[fg-color] = $x[fg-color]
    }
    if (has-key $x bg-color) {
      s[bg-color] = $x[bg-color]
    }
    if (has-key $x bold) {
      s[bold]=$true
    }
    if (has-key $x dim) {
      s[dim]=$true
    }
    if (has-key $x italic) {
      s[italic]=$true
    }
    if (has-key $x underlined) {
      s[underlined]=$true
    }
    if (has-key $x blink) {
      s[blink]=$true
    }
    if (has-key $x inverse) {
      s[inverse]=$true
    }
    put $s
  } elif (==s 'styled-text' (kind-of $x)) {
    if $favor-last {
      extract-style $x[-1]
    } else {
      extract-style $x[0]
    }
  } elif (==s 'styled-segment' (kind-of $x)) {
    s=[&]
    if (!=s "" $x[fg-color]) {
      s[fg-color] = $x[fg-color]
    }
    if (!=s "" $x[bg-color]) {
      s[bg-color] = $x[bg-color]
    }
    if $x[bold] {
      s[bold]=$true
    }
    if $x[dim] {
      s[dim]=$true
    }
    if $x[italic] {
      s[italic]=$true
    }
    if $x[underlined] {
      s[underlined]=$true
    }
    if $x[blink] {
      s[blink]=$true
    }
    if $x[inverse] {
      s[inverse]=$true
    }
    put $s
  } else {
    put [&]
  }
}