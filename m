From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 0/3] namei: implement various scoping AT_* flags
Date: Tue, 2 Oct 2018 06:14:46 +1000 (AEST)
Message-ID: <alpine.LRH.2.21.1810020610290.14406@namei.org>
References: <20180929103453.12025-1-cyphar@cyphar.com> <39d64180-73d5-6f27-e455-956143a5b5d3@digikod.net> <CAG48ez1CUHTKrpbwJxXkYoUKm5eYV15LuRRO+dXveo=MQvjJkA@mail.gmail.com> <0ca12a6e-a86b-5d50-40b9-e76c1a4bc6a0@digikod.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="1665246916-1069902232-1538424886=:14406"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0ca12a6e-a86b-5d50-40b9-e76c1a4bc6a0@digikod.net>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Jann Horn <jannh@google.com>, cyphar@cyphar.com, jlayton@kernel.org, Bruce Fields <bfields@fieldses.org>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, shuah@kernel.org, David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>, christian@brauner.io, "Eric W. Biederman" <ebiederm@xmission.com>, Tycho Andersen <tycho@tycho.ws>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, linux-kselftest@vger.kernel.org, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-security-module <linux-security-module@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-1069902232-1538424886=:14406
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 1 Oct 2018, Mickaël Salaün wrote:

> Another way to apply a security policy could be to tied it to a file
> descriptor, similarly to Capsicum, which could enable to create
> programmable (real) capabilities. This way, it would be possible to
> "wrap" a file descriptor with a Landlock program and use it with
> FD-based syscalls or pass it to other processes. This would not require
> changes to the FS subsystem, but only the Landlock LSM code. This isn't
> done yet but I plan to add this new way to restrict operations on file
> descriptors.

Very interesting!

This could possibly be an LSM which stacks/integrates with other LSMs to 
enforce MAC of object capabilities.



> 
> Anyway, for the use case you mentioned, the AT_BENEATH flag(s) should be
> simple to use and enough for now. We must be careful of the hardcoded
> policy though.
> 
> 
> > 
> >> On 9/29/18 12:34, Aleksa Sarai wrote:
> >>> The need for some sort of control over VFS's path resolution (to avoid
> >>> malicious paths resulting in inadvertent breakouts) has been a very
> >>> long-standing desire of many userspace applications. This patchset is a
> >>> revival of Al Viro's old AT_NO_JUMPS[1] patchset with a few additions.
> >>>
> >>> The most obvious change is that AT_NO_JUMPS has been split as dicussed
> >>> in the original thread, along with a further split of AT_NO_PROCLINKS
> >>> which means that each individual property of AT_NO_JUMPS is now a
> >>> separate flag:
> >>>
> >>>   * Path-based escapes from the starting-point using "/" or ".." are
> >>>     blocked by AT_BENEATH.
> >>>   * Mountpoint crossings are blocked by AT_XDEV.
> >>>   * /proc/$pid/fd/$fd resolution is blocked by AT_NO_PROCLINKS (more
> >>>       correctly it actually blocks any user of nd_jump_link() because it
> >>>       allows out-of-VFS path resolution manipulation).
> >>>
> >>> AT_NO_JUMPS is now effectively (AT_BENEATH|AT_XDEV|AT_NO_PROCLINKS). At
> >>> Linus' suggestion in the original thread, I've also implemented
> >>> AT_NO_SYMLINKS which just denies _all_ symlink resolution (including
> >>> "proclink" resolution).
> >>>
> >>> An additional improvement was made to AT_XDEV. The original AT_NO_JUMPS
> >>> path didn't consider "/tmp/.." as a mountpoint crossing -- this patch
> >>> blocks this as well (feel free to ask me to remove it if you feel this
> >>> is not sane).
> >>>
> >>> Currently I've only enabled these for openat(2) and the stat(2) family.
> >>> I would hope we could enable it for basically every *at(2) syscall --
> >>> but many of them appear to not have a @flags argument and thus we'll
> >>> need to add several new syscalls to do this. I'm more than happy to send
> >>> those patches, but I'd prefer to know that this preliminary work is
> >>> acceptable before doing a bunch of copy-paste to add new sets of *at(2)
> >>> syscalls.
> >>>
> >>> One additional feature I've implemented is AT_THIS_ROOT (I imagine this
> >>> is probably going to be more contentious than the refresh of
> >>> AT_NO_JUMPS, so I've included it in a separate patch). The patch itself
> >>> describes my reasoning, but the shortened version of the premise is that
> >>> continer runtimes need to have a way to resolve paths within a
> >>> potentially malicious rootfs. Container runtimes currently do this in
> >>> userspace[2] which has implicit race conditions that are not resolvable
> >>> in userspace (or use fork+exec+chroot and SCM_RIGHTS passing which is
> >>> inefficient). AT_THIS_ROOT allows for per-call chroot-like semantics for
> >>> path resolution, which would be invaluable for us -- and the
> >>> implementation is basically identical to AT_BENEATH (except that we
> >>> don't return errors when someone actually hits the root).
> >>>
> >>> I've added some selftests for this, but it's not clear to me whether
> >>> they should live here or in xfstests (as far as I can tell there are no
> >>> other VFS tests in selftests, while there are some tests that look like
> >>> generic VFS tests in xfstests). If you'd prefer them to be included in
> >>> xfstests, let me know.
> >>>
> >>> [1]: https://lore.kernel.org/patchwork/patch/784221/
> >>> [2]: https://github.com/cyphar/filepath-securejoin
> >>>
> >>> Aleksa Sarai (3):
> >>>   namei: implement O_BENEATH-style AT_* flags
> >>>   namei: implement AT_THIS_ROOT chroot-like path resolution
> >>>   selftests: vfs: add AT_* path resolution tests
> >>>
> >>>  fs/fcntl.c                                    |   2 +-
> >>>  fs/namei.c                                    | 158 ++++++++++++------
> >>>  fs/open.c                                     |  10 ++
> >>>  fs/stat.c                                     |  15 +-
> >>>  include/linux/fcntl.h                         |   3 +-
> >>>  include/linux/namei.h                         |   8 +
> >>>  include/uapi/asm-generic/fcntl.h              |  20 +++
> >>>  include/uapi/linux/fcntl.h                    |  10 ++
> >>>  tools/testing/selftests/Makefile              |   1 +
> >>>  tools/testing/selftests/vfs/.gitignore        |   1 +
> >>>  tools/testing/selftests/vfs/Makefile          |  13 ++
> >>>  tools/testing/selftests/vfs/at_flags.h        |  40 +++++
> >>>  tools/testing/selftests/vfs/common.sh         |  37 ++++
> >>>  .../selftests/vfs/tests/0001_at_beneath.sh    |  72 ++++++++
> >>>  .../selftests/vfs/tests/0002_at_xdev.sh       |  54 ++++++
> >>>  .../vfs/tests/0003_at_no_proclinks.sh         |  50 ++++++
> >>>  .../vfs/tests/0004_at_no_symlinks.sh          |  49 ++++++
> >>>  .../selftests/vfs/tests/0005_at_this_root.sh  |  66 ++++++++
> >>>  tools/testing/selftests/vfs/vfs_helper.c      | 154 +++++++++++++++++
> >>>  19 files changed, 707 insertions(+), 56 deletions(-)
> >>>  create mode 100644 tools/testing/selftests/vfs/.gitignore
> >>>  create mode 100644 tools/testing/selftests/vfs/Makefile
> >>>  create mode 100644 tools/testing/selftests/vfs/at_flags.h
> >>>  create mode 100644 tools/testing/selftests/vfs/common.sh
> >>>  create mode 100755 tools/testing/selftests/vfs/tests/0001_at_beneath.sh
> >>>  create mode 100755 tools/testing/selftests/vfs/tests/0002_at_xdev.sh
> >>>  create mode 100755 tools/testing/selftests/vfs/tests/0003_at_no_proclinks.sh
> >>>  create mode 100755 tools/testing/selftests/vfs/tests/0004_at_no_symlinks.sh
> >>>  create mode 100755 tools/testing/selftests/vfs/tests/0005_at_this_root.sh
> >>>  create mode 100644 tools/testing/selftests/vfs/vfs_helper.c
> >>>
> >>
> > 
> > 
> 
> 

-- 
James Morris
<jmorris@namei.org>

--1665246916-1069902232-1538424886=:14406--
