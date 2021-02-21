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

  var x = [s]{ put $s }
  if (has-key $style fg-color) {
    set x = (apply-fg-color $x)
  }
  if (has-key $style bg-color) {
    set x = (apply-bg-color $x)
  }
  if (has-key $style bold) {
    set s = (apply-bold $x)
  }
  if (has-key $style dim) {
    set s = (apply-dim $x)
  }
  if (has-key $style italic) {
    set s = (apply-italic $x)
  }
  if (has-key $style underlined) {
    set s = (apply-underlined $x)
  }
  if (has-key $style blink) {
    set s = (apply-blink $x)
  }
  if (has-key $style inverse) {
    set s = (apply-inverse $x)
  }
  put $x
}

fn create-style [fg bg &bold=$false &dim=$false &italic=$false &underlined=$false &blink=$false &inverse=$false]{
  var s = [&]
  if (!=s $fg '') {
    set s[fg-color] = $fg
  }
  if (!=s $bg '') {
    set s[bg-color] = $bg
  }
  if $bold {
    set s[bold] = $true
  }
  if $dim {
    set s[dim] = $true
  }
  if $italic {
    set s[italic] = $true
  }
  if $underlined {
    set s[underlined] = $true
  }
  if $blink {
    set s[blink] = $true
  }
  if $inverse {
    set s[inverse] = $true
  }
  put $s
}

fn apply-style [x style]{
  styled $x (transformer $style)
}

fn extract-style [x &favor-last=$false]{
  if (==s 'map' (kind-of $x)) {
    var s = [&]
    if (has-key $x fg-color) {
      set s[fg-color] = $x[fg-color]
    }
    if (has-key $x bg-color) {
      set s[bg-color] = $x[bg-color]
    }
    if (has-key $x bold) {
      set s[bold] = $true
    }
    if (has-key $x dim) {
      set s[dim] = $true
    }
    if (has-key $x italic) {
      set s[italic] = $true
    }
    if (has-key $x underlined) {
      set s[underlined] = $true
    }
    if (has-key $x blink) {
      set s[blink] = $true
    }
    if (has-key $x inverse) {
      set s[inverse] = $true
    }
    put $s
  } elif (or (==s 'styled-text' (kind-of $x)) (==s 'ui:text' (kind-of $x))) {
    if $favor-last {
      extract-style $x[-1]
    } else {
      extract-style $x[0]
    }
  } elif (or (==s 'styled-segment' (kind-of $x)) (==s 'ui:text-segment' (kind-of $x))) {
    var s = [&]
    if (!=s "" $x[fg-color]) {
      set s[fg-color] = $x[fg-color]
    }
    if (!=s "" $x[bg-color]) {
      set s[bg-color] = $x[bg-color]
    }
    if $x[bold] {
      set s[bold] = $true
    }
    if $x[dim] {
      set s[dim] = $true
    }
    if $x[italic] {
      set s[italic] = $true
    }
    if $x[underlined] {
      set s[underlined] = $true
    }
    if $x[blink] {
      set s[blink] = $true
    }
    if $x[inverse] {
      set s[inverse] = $true
    }
    put $s
  } else {
    put [&]
  }
}