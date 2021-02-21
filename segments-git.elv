use github.com/sblundy/elvish-chain-theme/styling
use github.com/muesli/elvish-libs/git

# Glyphs to be used in the prompt
glyph = [
	&branch= "⎇"
	&ahead= "⬆"
	&behind= "⬇"
	&staged= "✔"
	&dirty= "✎"
	&untracked= "+"
]

style = [
	&branch=     (styling:create-style   "color0" "color148")
	&ahead=      (styling:create-style  "color15"  "color52")
	&behind=     (styling:create-style  "color15"  "color52")
	&staged=     (styling:create-style  "color15"  "color22")
	&dirty=      (styling:create-style  "color15" "color161")
	&untracked=  (styling:create-style  "color15"  "color52")
]

# cached git status
-last-status = [&]

# Updates the status once, rather than each segment doing so.
fn pseudo-segment-init {
	-last-status = (git:status &counts=$true)
}

fn segment-branch {
	branch = $-last-status[branch-name]
	if (not-eq $branch "") {
		if (eq $branch '(detached)') {
			branch = $-last-status[branch-oid][0:7]
		}
		put (styling:apply-style $glyph[branch]' '$branch $style[branch])
	}
}

fn segment-ahead {
	if (> $-last-status[rev-ahead] 0) {
		put (styling:apply-style $-last-status[rev-ahead]$glyph[ahead] $style[ahead])
	}
}

fn segment-behind {
	if (> $-last-status[rev-behind] 0) {
		put (styling:apply-style $-last-status[rev-behind]$glyph[behind] $style[behind])
	}
}

fn segment-staged {
	total-staged = (+ $-last-status[staged-modified-count] $-last-status[staged-deleted-count] $-last-status[staged-added-count] $-last-status[renamed-count] $-last-status[copied-count])
	if (> $total-staged 0) {
		put (styling:apply-style $total-staged$glyph[staged] $style[staged])
	}
}

fn segment-dirty {
	if (> $-last-status[local-modified-count] 0) {
		put (styling:apply-style $-last-status[local-modified-count]$glyph[dirty] $style[dirty])
	}
}

fn segment-untracked {
	if (> $-last-status[untracked-count] 0) {
		put (styling:apply-style $-last-status[untracked-count]$glyph[untracked] $style[untracked])
	}
}
