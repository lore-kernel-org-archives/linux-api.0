Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA5644AB6F;
	Thu, 23 Jul 2026 11:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784806236; cv=none; b=UYN+xLG+JVSjuQqrpIh2YJIpnv090J69FkkbRxoyOa+TMGDkUAZeakUpO/9KJ4VaBe0YnQb1VvL+3hoZ6qEyb/RGgvWgB8fNemx+klHzirmiM5L4dJgFsDM58Vm6oHIS2K/D1sdVjBmMGGc0SBWL4o7v/GJUX9X+kTazXQtdtn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784806236; c=relaxed/simple;
	bh=zMJZ+jNZ/LOPV6DRhFOcjlbbfDmY8IPP9Twkpnp/Fyk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=WmVGb4xuyZqxv15MWVAs6jE/olj6lotQ7eY+el2YrDGKlAHgLJ8uJE31w3plvwjiu6Jw0+Fw04A03WYR/wAV6mz7BCzfCbj4g48IHtUexkEEbmqexjNWihiHjH2HtvsKFSX2W8JmcDWqzwe/iyQQyL8j/H3GNLt5u5rrdkCs/E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EOXMQirG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EOXMQirG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F611F000E9;
	Thu, 23 Jul 2026 11:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784806235;
	bh=RxdpYBEDrd7gAzE2H3SAafkhf4yZk16mK+RUP3uXQ9o=;
	h=From:Subject:Date:To:Cc;
	b=EOXMQirGJCAyMAR4TF929llQIIJhY1fKjkMincd577Tu4Vi918htv5BioZpHGr2eh
	 VmDbdOWoys6lqvaVTTX67N2cGgi1p60QBY6RXTl52jg4E1E8nRGCnfP32rAi1fYHmG
	 cvW5bl2RAcks3SQabnawWVHdBVA/sZ7OzWt7UupD8YKMAs5WzZKakFOm6jT7j53IG+
	 LHVQ5X7JqlwIKVCPJ/WIXLLf+CY9nZqWQTIUHCZ0BM2u8Ve01JT2J5vQ4NuAg9HNIj
	 IYrHZM4/fg4bso1vAtLJu8zT7Sh3Iu0PbPavzhMcJdFrGKYDiRm8s3H5NQk4Nv3Gxk
	 LuPpTOkQgcRVw==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH RFC 0/7] fs: add failfs
Date: Thu, 23 Jul 2026 13:30:19 +0200
Message-Id: <20260723-work-failfs-v1-0-3f69b9a9e958@kernel.org>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEv7YWoC/yWMyw6CMBBFf4XM2iGlEiBuTfwAt8ZFH1OpDzAzi
 CaEf7fV5Tm59ywgxJEEdsUCTHOUOA4Jqk0BrjfDhTD6xKCVblSrt/ge+YbBxHsQ9F1jlKu8rTs
 P6fFkCvHzq53geNjD+S/lZa/kptzJM2uE0LIZXJ/Vw8hEXM5tqZFdDev6BQ3HqLaWAAAA
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
X-Mailer: b4 0.16-dev-0e65f
X-Developer-Signature: v=1; a=openpgp-sha256; l=5230; i=brauner@kernel.org;
 h=from:subject:message-id; bh=zMJZ+jNZ/LOPV6DRhFOcjlbbfDmY8IPP9Twkpnp/Fyk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQl/g4vqQ1dHhb8dHGn+svnX+pnlx9KPOayTFOXbX1B+
 t6vCi/XdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkhT0jw/OVKydOlWw5lGCp
 xXdkdg53+cayfbv/frxirXXTPEnhnTvDb1Z+r0WPPbbKLN3K4KHvPjlYJmTmuYVMC52WXzFOc/K
 rZgIA
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
such a link still works and shows "/".

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
Christian Brauner (7):
      fs: add failfs
      fs: add FD_FAILFS_ROOT and support it in fchdir()
      fs: add fchroot()
      fs: support FD_FAILFS_ROOT in fchroot()
      arch: hookup fchroot() system call
      selftests/filesystems: add failfs selftests
      Documentation: add failfs documentation

 Documentation/filesystems/failfs.rst               |  64 +++
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
 fs/failfs.c                                        | 155 +++++++
 fs/internal.h                                      |   3 +
 fs/namespace.c                                     |   1 +
 fs/open.c                                          |  58 ++-
 include/linux/syscalls.h                           |   1 +
 include/uapi/asm-generic/unistd.h                  |   6 +-
 include/uapi/linux/fcntl.h                         |   1 +
 include/uapi/linux/magic.h                         |   1 +
 scripts/syscall.tbl                                |   1 +
 tools/testing/selftests/Makefile                   |   1 +
 .../selftests/filesystems/failfs/.gitignore        |   2 +
 .../testing/selftests/filesystems/failfs/Makefile  |   5 +
 .../selftests/filesystems/failfs/failfs_test.c     | 506 +++++++++++++++++++++
 32 files changed, 821 insertions(+), 3 deletions(-)
---
base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
change-id: 20260723-work-failfs-d86a0c1db48d

