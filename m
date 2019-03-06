From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH RESEND v5 0/5] namei: vfs flags to restrict path resolution
Date: Thu,  7 Mar 2019 06:12:39 +1100
Message-ID: <20190306191244.8691-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Christian Brauner <christian@brauner.io>, David Drysdale <drysdale@google.com>, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Now that the holiday break is over, it's time to re-send this patch
series (with a few additions, due to new information we got from
CVE-2019-5736 -- which this patchset mostly protected against but had
some holes with regards to #!-style scripts).

Patch changelog:
  v5:
    * In response to CVE-2019-5736 (one of the vectors showed that
      open(2)+fexec(3) cannot be used to scope binfmt_script's implicit
      open_exec()), AT_* flags have been re-added and are now piped
      through to binfmt_script (and other binfmt_* that use open_exec)
      but are only supported for execveat(2) for now.
  v4:
    * Remove AT_* flag reservations, as they require more discussion.
    * Switch to path_is_under() over __d_path() for breakout checking.
    * Make O_XDEV no longer block openat("/tmp", "/", O_XDEV) -- dirfd
      is now ignored for absolute paths to match other flags.
    * Improve the dirfd_path_init() refactor and move it to a separate
      commit.
    * Remove reference to Linux-capsicum.
    * Switch "proclink" name to "magic link".
  v3: [resend]
  v2:
    * Made ".." resolution with AT_THIS_ROOT and AT_BENEATH safe(r) with
      some semi-aggressive __d_path checking (see patch 3).
    * Disallowed "proclinks" with AT_THIS_ROOT and AT_BENEATH, in the
      hopes they can be re-enabled once safe.
    * Removed the selftests as they will be reimplemented as xfstests.
    * Removed stat(2) support, since you can already get it through
      O_PATH and fstatat(2).

The need for some sort of control over VFS's path resolution (to avoid
malicious paths resulting in inadvertent breakouts) has been a very
long-standing desire of many userspace applications. This patchset is a
revival of Al Viro's old AT_NO_JUMPS[1,2] patchset (which was a variant
of David Drysdale's O_BENEATH patchset[3] which was a spin-off of the
Capsicum project[4]) with a few additions and changes made based on the
previous discussion within [5] as well as others I felt were useful.

In line with the conclusions of the original discussion of AT_NO_JUMPS,
the flag has been split up into separate flags:

  * O_XDEV blocks all mountpoint crossings (upwards, downwards, or
    through absolute links). Absolute pathnames alone in openat(2) do
    not trigger this.

  * O_NOMAGICLINKS blocks resolution through /proc/$pid/fd-style links.
    This is done by blocking the usage of nd_jump_link() during
    resolution in a filesystem. The term "magic links" is used to match
    with the only reference to these links in Documentation/, but I'm
    happy to change the name.

    It should be noted that this is different to the scope of O_NOFOLLOW
    in that it applies to all path components. However, you can do
    open(O_NOFOLLOW|O_NOMAGICLINKS|O_PATH) on a "magic link" and it will
    *not* fail (assuming that no parent component was a "magic link"),
    and you will have an fd for the "magic link".

  * O_BENEATH disallows escapes to outside the starting dirfd's tree,
    using techniques such as ".." or absolute links. Absolute paths in
    openat(2) are also disallowed. Conceptually this flag is to ensure
    you "stay below" a certain point in the filesystem tree -- but this
    requires some additional to protect against various races that would
    allow escape using ".." (see patch 4 for more detail).

    Currently O_BENEATH implies O_NOMAGICLINKS, because it can trivially
    beam you around the filesystem (breaking the protection). In future,
    there might be similar safety checks as in patch 4, but that
    requires more discussion.

In addition, two new flags were added that expand on the above ideas:

  * O_NOSYMLINKS does what it says on the tin. No symlink resolution is
    allowed at all, including "magic links". Just as with O_NOMAGICLINKS
    this can still be used with (O_PATH|O_NOFOLLOW) to open an fd for
    the symlink as long as no parent path had a symlink component.

  * O_THISROOT is an extension of O_BENEATH that, rather than blocking
    attempts to move past the root, forces all such movements to be
    scoped to the starting point. This provides chroot(2)-like
    protection but without the cost of a chroot(2) for each filesystem
    operation, as well as being safe against race attacks that chroot(2)
    is not.

    If a race is detected (as with O_BENEATH) then an error is
    generated, and similar to O_BENEATH it is not permitted to cross
    "magic links" with O_THISROOT.

    The primary need for this is from container runtimes, which
    currently need to do symlink scoping in userspace[6] when opening
    paths in a potentially malicious container. There is a long list of
    CVEs that could have bene mitigated by having O_THISROOT (such as
    CVE-2017-1002101, CVE-2017-1002102, CVE-2018-15664, and
    CVE-2019-5736, just to name a few).

In addition, a mirror set of AT_* flags have been added (though
currently these are only supported for execveat(2) -- and not for any
other syscall). The need for these is explained in the final patch in
the series (it's motivated by CVE-2019-5736).

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: David Drysdale <drysdale@google.com>
Cc: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>
Cc: <containers@lists.linux-foundation.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: <linux-api@vger.kernel.org>

[1]: https://lwn.net/Articles/721443/
[2]: https://lore.kernel.org/patchwork/patch/784221/
[3]: https://lwn.net/Articles/619151/
[4]: https://lwn.net/Articles/603929/
[5]: https://lwn.net/Articles/723057/
[6]: https://github.com/cyphar/filepath-securejoin

Aleksa Sarai (5):
  namei: split out nd->dfd handling to dirfd_path_init
  namei: O_BENEATH-style path resolution flags
  namei: O_THISROOT: chroot-like path resolution
  namei: aggressively check for nd->root escape on ".." resolution
  binfmt_*: scope path resolution of interpreters

 fs/binfmt_elf.c                  |   2 +-
 fs/binfmt_elf_fdpic.c            |   2 +-
 fs/binfmt_em86.c                 |   4 +-
 fs/binfmt_misc.c                 |   2 +-
 fs/binfmt_script.c               |   2 +-
 fs/exec.c                        |  26 +++-
 fs/fcntl.c                       |   2 +-
 fs/namei.c                       | 205 ++++++++++++++++++++++---------
 fs/open.c                        |  13 +-
 include/linux/binfmts.h          |   1 +
 include/linux/fcntl.h            |   3 +-
 include/linux/fs.h               |   9 +-
 include/linux/namei.h            |   8 ++
 include/uapi/asm-generic/fcntl.h |  17 +++
 include/uapi/linux/fcntl.h       |   6 +
 15 files changed, 228 insertions(+), 74 deletions(-)

-- 
2.21.0
