use re
use str
use github.com/sblundy/elvish-chain-theme/styling

# Glyphs to be used in the prompt
glyph = [
	&arrow= ""
	&arrow-su= "⚡"
	&dirchain= "\ue0b1"
]

style = [
	&arrow=          (styling:create-style   "color0"  "color15")
	&arrow-su=       (styling:create-style  "color15" "color161")
	&dir=            (styling:create-style  "color15"  "color31")
	&host=           (styling:create-style "color254" "color166")
	&timestamp=      (styling:create-style "color250" "color238")
]

# To how many letters to abbreviate directories in the path - 0 to show in full
prompt-pwd-dir-length = 3

# Format to use for the 'timestamp' segment, in strftime(3) format
timestamp-format = "%H:%M:%S"

# User ID that will trigger the "su" segment. Defaults to root.
root-id = 0

# Return the current directory, shortened according to `$prompt-pwd-dir-length`
fn prompt-pwd {
	dir = (tilde-abbr $pwd)
	if (> $prompt-pwd-dir-length 0) {
		dir = (re:replace '(\.?[^/]{'$prompt-pwd-dir-length'})[^/]*/' '$1/' $dir)
	}
	str:split / $dir | joins ' '$glyph[dirchain]' '
}

fn init-segment-arrow {
  bg = (+ (% $pid 216) 16)
  fg = "255"
  if (>= (% (- $bg 16) 36) 18) {
    fg = "232"
  }

  style[arrow] = (styling:create-style 'color'$fg 'color'(to-string $bg))
}

fn segment-arrow {
	uid = (id -u)
	if (eq $uid $root-id) {
		put (styling:apply-style $glyph[arrow-su] $style[arrow-su])
	} elif (!=s "" $glyph[arrow]) {
		put (styled $glyph[arrow] (all $style[arrow]))
		put (styling:apply-style $glyph[arrow] $style[arrow])
	}
}

fn segment-timestamp {
	put (styling:apply-style (date +$timestamp-format) $style[timestamp])
}

fn segment-dir {
  put (styling:apply-style (prompt-pwd) $style[dir])
}

init-segment-arrow
