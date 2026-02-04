# frozen_string_literal: true

module CoreutilsWasm
  module Commands
    # All available coreutils commands
    ALL = %w[
      arch base32 base64 baseenc basename cat chcon chgrp chmod chown chroot
      cksum comm cp csplit cut date dd df dircolors dirname du echo env expand
      expr factor false fmt fold groups hashsum head hostid hostname id install
      join kill link ln logname ls mkdir mkfifo mknod mktemp more mv nice nl
      nohup nproc numfmt od paste pathchk pinky pr printenv printf ptx pwd
      readlink realpath relpath rm rmdir runcon seq shred shuf sleep sort split
      stat stdbuf sum sync tac tail tee test timeout touch tr true truncate
      tsort tty uname unexpand uniq unlink uptime users wc who whoami yes
    ].freeze
  end
end
