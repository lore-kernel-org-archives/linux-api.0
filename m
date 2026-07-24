Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFA2253B73;
	Fri, 24 Jul 2026 13:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784900489; cv=none; b=AUpgOh57lhUZiRL1Ip4ogvhfTEnaaITaoF/4Ixfcp52G/7X9GNcfLL5jHsHtcbEsc+Am4SbLNhb8G2I8CjxnrA3sV+QrU3+I7yjSX0WF4y8zdQqLKfvoIzlyPjCyVTeIB7GDb8WM7pgtIqvTwwyNdRrEqlxvsQxIm9Z6iyiVTTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784900489; c=relaxed/simple;
	bh=5kf9ua2YCWWDaYgThU/728pJvNb5qOHFDcOkv3i309A=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=DiG4EOxM22WH0zAZqLbEs97u3SwfTYzSUIrHspnwFZekzSpLx00Um8vO1uv5Y2T1U7Y2kIr+TKQywAN3aqBc5NeyilnhDjB3A4/6/NbvdUT/67e1Wo9hNQDTK08NBIVcUjYRHkxkQmUBdm6AziQD6y6alMZlTOIvkj8eDdeelHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZMAmLpa4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZMAmLpa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394421F000E9;
	Fri, 24 Jul 2026 13:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784900487;
	bh=WS+/fqJsoaqzVBxDQzYjHJOvK1j12E+pEZZnghnlN48=;
	h=From:Subject:Date:To:Cc;
	b=ZMAmLpa4i51UuF9sCNiFBZaF3Aa3LRCt0ofncJvNaRTIurkHpBnKLwgw7VOsOkSqw
	 QhxBpp9nkSdDab03D5cgebI7mpZx1+dRK1v8kvWkrbaMsNtiKnJgw08KiYcxVXEYto
	 YWJ3rOCRFqTCdRlNHHXuQmAG188OHNvNEvJxdbnsksfXSmzx0OX25ekn5ttgbL0Sm2
	 dBBCAfNAWOO6igi3AlwLbH/tVVV6yYNsQGLKTkd54fAtSxjsK9kOzJ8upJ1ogyX+1p
	 M6VUtdMOEq9EhQldqVE34ocg0ob0HZddu9jBniQxirmXbIlwUYYeTe1H3kd8xyEfpm
	 aiag3zdwWaVMQ==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH v2 0/7] fs: add failfs
Date: Fri, 24 Jul 2026 15:41:16 +0200
Message-Id: <20260724-work-failfs-v2-0-485dabbae185@kernel.org>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHxrY2oC/22Oyw6CMBBFf8V0bUkpyMOV/2FY9DGFCrZmilVD+
 Hcpbl2eyZ1z70ICoIVAzoeFIEQbrHcb8OOBqEG4HqjVGxPOeMVqXtCXx5EaYScTqG4qwVSuZdl
 osn08EIx977Zr9+PwlDdQc1KkhBQBqETh1JBOdxFmwCzWGaeoypQYbJg9fvZBMU+m/90xp4wWp
 mplK1poT81lBHQwZR570q3r+gUHJExH2wAAAA==
X-Change-ID: 20260723-work-failfs-d86a0c1db48d
To: linux-fsdevel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, 
 Jann Horn <jannh@google.com>
Cc: John Ericson <mail@johnericson.me>, linux-api@vger.kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <kees@kernel.org>, 
 Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
 linux-doc@vger.kernel.org
X-Mailer: b4 0.16-dev-401aa
X-Developer-Signature: v=1; a=openpgp-sha256; l=5638; i=brauner@kernel.org;
 h=from:subject:message-id; bh=5kf9ua2YCWWDaYgThU/728pJvNb5qOHFDcOkv3i309A=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQlZzevNX8+w5WrJksskyW3ebe81gGewrD+CY4izIXrt
 159V2bUUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMJFOa0aGuT3Zi7jnCYk+mBnl
 lf7ca81zQ4/p6/kC8/csVVTTd1nExMjQt3HDZfnKiTfqxY5/P/1lztKt20TaWk8kXXoadHK+cJ0
 dMwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

nullfs provides a permanently empty and immutable directory. Lookups
fail with ENOENT. The directory can be opened, read, stat, mounted upon.
It behaves like nothing is there.

Add its counterpart failfs where the semantics are not "there is
nothing here" but "nothing is supported here". Every operation that
reaches the filesystem fails with EOPNOTSUPP. Even statfs()/fstatfs()
fail so the filesystem cannot be discovered through an fd to it.

EOPNOTSUPP rather than a permission errno keeps that coherent. There
is no permission model in which anything could ever be allowed and
EACCES or EPERM would merely suggest that different credentials might
succeed while EIO would suggest corruption. It also makes hitting the
failfs boundary mostly quite dinstinguishable. A task anchoring its
lookups at real directory file descriptors may be able to tell a failfs
refusal from an ordinary permission failure. I wouldn't go so far as
guaranteeing that but it should mostly work.

The root cannot be opened at all not even with O_PATH. It is never
reached by a lookup in a parent directory. The only way to a path-walk
terminal at the root is a jump through a /proc/<pid>/{root,cwd} magic
link or by mountpoint traversal. The root also refuses
->d_weak_revalidate() which the VFS calls for jumped terminals. That
closes every remaining way to reference it. An O_PATH
open is refused and name_to_handle_at() cannot encode it into a file
handle, and following a magic link into it fails. A plain readlink() of
such a link still works and shows "failfs:/".

There is a single instance of failfs mounted during early boot via
kern_mount() making it logically distinct from every mount namespace.

Since the mount is a member of no mount namespace mounting onto it
fails. So nothing can ever be mounted on top of it. It cannot be cloned
via OPEN_TREE_CLONE and it does not show up in statmount()/listmount()
or /proc/<pid>/mountinfo. The filesystem is not registered so it is
not visible in /proc/filesystems and cannot be mounted from userspace.

This lets tasks shed their filesystem state completely. A process with
its root directory or working directory in failfs must anchor every path
lookup at an explicit file descriptor or is doomed to fail any lookup.
Absolute paths, absolute symlinks, and AT_FDCWD-relative lookups
simply fail. Followup patches will expose it via a new FD_FAILFS_ROOT
file descriptor sentinel understood by fchdir() and the new fchroot()
system call.

Fun fact, because of how dynamic binary execution work with PT_INTERP
this also currently prevents execution of dynamic binaries because
loaders have absolute paths (see selftests).

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Changes in v2:
- Don't promise guarantees we might not want to give.
- Link to v1: https://patch.msgid.link/20260723-work-failfs-v1-0-3f69b9a9e958@kernel.org

---
Christian Brauner (7):
      fs: add failfs
      fs: support FD_FAILFS_ROOT in fchdir()
      fs: add fchroot()
      fs: support FD_FAILFS_ROOT in fchroot()
      arch: hookup fchroot() system call
      selftests/filesystems: add failfs selftests
      Documentation: add failfs documentation

 Documentation/filesystems/failfs.rst               |  73 +++
 Documentation/filesystems/index.rst                |   1 +
 arch/alpha/kernel/syscalls/syscall.tbl             |   1 +
 arch/arm/tools/syscall.tbl                         |   1 +
 arch/arm64/tools/syscall_32.tbl                    |   1 +
 arch/m68k/kernel/syscalls/syscall.tbl              |   1 +
 arch/microblaze/kernel/syscalls/syscall.tbl        |   1 +
 arch/mips/kernel/syscalls/syscall_n32.tbl          |   1 +
 arch/mips/kernel/syscalls/syscall_n64.tbl          |   1 +
 arch/mips/kernel/syscalls/syscall_o32.tbl          |   1 +
 arch/parisc/kernel/syscalls/syscall.tbl            |   1 +
 arch/powerpc/kernel/syscalls/syscall.tbl           |   1 +
 arch/s390/kernel/syscalls/syscall.tbl              |   1 +
 arch/sh/kernel/syscalls/syscall.tbl                |   1 +
 arch/sparc/kernel/syscalls/syscall.tbl             |   1 +
 arch/x86/entry/syscalls/syscall_32.tbl             |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl             |   1 +
 arch/xtensa/kernel/syscalls/syscall.tbl            |   1 +
 fs/Makefile                                        |   2 +-
 fs/d_path.c                                        |   3 +-
 fs/failfs.c                                        | 166 ++++++
 fs/internal.h                                      |   4 +
 fs/namespace.c                                     |   1 +
 fs/open.c                                          |  51 +-
 include/linux/syscalls.h                           |   1 +
 include/uapi/asm-generic/unistd.h                  |   6 +-
 include/uapi/linux/fcntl.h                         |   1 +
 include/uapi/linux/magic.h                         |   1 +
 scripts/syscall.tbl                                |   1 +
 tools/include/uapi/asm-generic/unistd.h            |   6 +-
 tools/perf/arch/x86/entry/syscalls/syscall_64.tbl  |   1 +
 tools/scripts/syscall.tbl                          |   1 +
 tools/testing/selftests/Makefile                   |   1 +
 .../selftests/filesystems/failfs/.gitignore        |   2 +
 .../testing/selftests/filesystems/failfs/Makefile  |   5 +
 .../selftests/filesystems/failfs/failfs_test.c     | 581 +++++++++++++++++++++
 36 files changed, 919 insertions(+), 5 deletions(-)
---
base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
change-id: 20260723-work-failfs-d86a0c1db48d

