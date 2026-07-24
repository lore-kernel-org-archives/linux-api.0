Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5C2439F83;
	Fri, 24 Jul 2026 13:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784900513; cv=none; b=luDkun2Ls94jF/qtvqtqh5GNlYOyDcU7b1ZUTMBiSUtGoRwcuJf67vZy0AtCcc2RVvceLtrcx17anB1oQy86dccdN0bLJXWGyh9HMaIEbgqAtwJw42RjSxx8axDKw3rbJ4lhCDbzAedUwb1wIWQ2E6my0NiKy01z6puzsC+J4vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784900513; c=relaxed/simple;
	bh=LUhZ/dE9W3vccxYhfKIt3x4xBo6p31C7wEWZCYOVwgw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mHCJ1+Uur+xWxC8aVAHMAcIBm6xz6nkY5rzPVE3FmwAUcFHAUu6/gsXfnBBVOPhZuCQLSczeSXaOG+3CMECNk24mHT154KDqXP3SYwXqRIbY6/WQ9TkOJQfKU560kSsA0Ot0T0y6rKNWN6r2rqXL1Lv85ELdGeyXr9tEn9XNCqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WLwPIYBP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WLwPIYBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CAED1F000E9;
	Fri, 24 Jul 2026 13:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784900512;
	bh=UmJ1QzgBu1BNHHfA25a21HVe5z922jx4PkAOoCMcaSI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WLwPIYBPTlH4lfJZVCZ0CEJJAUM6OD+pgVtnBZYIx28BJXS/4tGPvBRlHeTT5VzYu
	 Ah1EkyGtvpJ0z4WrP5+m6kEE2qVk6h5+QJ2vkVuDT6LUvKA9Hl1HKro7NTIBS2mIm+
	 6cmRtJlRDIlOPVgq1f7zifeINuzB9wYiZ0cccVgoqkQ3mskJ6kpCnxpvNaVfJH4Chs
	 LC7S2k4IgwXM6vVTixBvLByiRvpWaxqIU4UPbA9l42u6JeCdq/DC4G+Zp9mSZYsaxW
	 0zybJHroUgpGjrrCy7XU6/JWA1XyllMvOCbNm5Fp94dQsAaJh0n5+UkZIk1Td8ztG2
	 gC8R1ch/UT68g==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 24 Jul 2026 15:41:23 +0200
Subject: [PATCH v2 7/7] Documentation: add failfs documentation
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260724-work-failfs-v2-7-485dabbae185@kernel.org>
References: <20260724-work-failfs-v2-0-485dabbae185@kernel.org>
In-Reply-To: <20260724-work-failfs-v2-0-485dabbae185@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4280; i=brauner@kernel.org;
 h=from:subject:message-id; bh=LUhZ/dE9W3vccxYhfKIt3x4xBo6p31C7wEWZCYOVwgw=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGpja4Oiy5JAPMpHxKtL3iFsApHcrwMGRZo2wRPc9LVUR87vI
 Ih1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmpja4MACgkQkcYbwGV43KJw2wD/R3KW
 hVbFAlmdhvJL6vysO2aHnn/7h20Uqs+LP8Q6wHcBALgFcsfDCle89jTLMjA0ECwsCFHpDxXI2VO
 DTUNV214A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Document the failfs semantics, the FD_FAILFS_ROOT sentinel, the
fchroot() entry requirements, and the ways back out.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/filesystems/failfs.rst | 73 ++++++++++++++++++++++++++++++++++++
 Documentation/filesystems/index.rst  |  1 +
 2 files changed, 74 insertions(+)

diff --git a/Documentation/filesystems/failfs.rst b/Documentation/filesystems/failfs.rst
new file mode 100644
index 000000000000..21ff2db7941d
--- /dev/null
+++ b/Documentation/filesystems/failfs.rst
@@ -0,0 +1,73 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+======
+failfs
+======
+
+failfs is a kernel-internal filesystem that fails every operation
+reaching it with ``EOPNOTSUPP``. It is the counterpart to nullfs. Where
+nullfs is permanently empty, failfs means "nothing is supported here".
+It cannot be mounted from userspace, nothing can be mounted on top of
+it. It cannot be cloned.
+
+The only way into it is the ``FD_FAILFS_ROOT`` file descriptor sentinel which
+is understood by ``fchdir(2)`` and ``fchroot(2)``.
+
+Semantics
+=========
+
+Every path walk of a component through failfs fails with
+``EOPNOTSUPP`` before that component is parsed, including ``.``.
+
+No path lookup can open the root, not even with ``O_PATH``.
+
+A process with its working directory in failfs fails every
+``AT_FDCWD``-relative lookup. As with any working directory that is
+unreachable from the process root, the ``getcwd(2)`` system call returns
+a path prefixed with ``(unreachable)``.
+
+A process with its root directory in failfs fails every absolute path
+lookup including absolute symlinks and the interpreter of dynamically
+linked binaries. In other words, this fails exec.
+
+Lookups anchored at explicit directory file descriptors keep working. It
+is the ``fs_struct`` equivalent of ``RESOLVE_BENEATH``. The process must
+anchor every lookup at a file descriptor it explicitly holds.
+
+Entering
+========
+
+``fchroot(FD_FAILFS_ROOT, 0)`` requires ``CAP_SYS_CHROOT`` in the
+caller's user namespace, mirroring ``chroot(2)``. Unprivileged callers
+may enter if all of the following hold:
+
+* ``no_new_privs`` is set: setuid binaries on regular mounts remain
+  reachable via inherited directory file descriptors and executing them
+  with an unusable root directory is the classic confused deputy.
+
+* The caller is not already chrooted: the root directory is what
+  confines ``..`` resolution and the failfs root can never be reached by
+  walking up a real mount tree, so moving the root of a chrooted task to
+  failfs would allow it to escape its chroot via ``openat(fd, "..")``.
+
+* The caller does not share its ``fs_struct``: ``no_new_privs`` is
+  checked on the calling thread, but the root lives in the ``fs_struct``.
+  A ``CLONE_FS`` sibling without ``no_new_privs`` could otherwise execute
+  a setuid binary with the failfs root, so entry requires ``fs->users ==
+  1``, the same restriction ``setns(2)`` applies for the mount and user
+  namespaces.
+
+Leaving
+=======
+
+Backing out is currently hard, but this is a property of the current
+implementation, not a guaranteed interface, and may be loosened later.
+For now a process that entered failfs counts as chrooted, so it cannot
+create user namespaces to regain ``CAP_SYS_CHROOT``, and ``chroot(2)``
+or ``fchroot(2)`` back out require ``CAP_SYS_CHROOT``. The remaining way
+out today is ``setns(2)`` with a mount namespace file descriptor, which
+requires ``CAP_SYS_ADMIN`` over the target mount namespace as well as
+``CAP_SYS_CHROOT`` and ``CAP_SYS_ADMIN`` in the caller's user namespace
+and resets both root and working directory. A process that holds no such
+file descriptor and restricts ``*chdir()``/``*chroot()``/``setns()`` via
+seccomp cannot currently get back out.
diff --git a/Documentation/filesystems/index.rst b/Documentation/filesystems/index.rst
index 1f71cf159547..734a45e51667 100644
--- a/Documentation/filesystems/index.rst
+++ b/Documentation/filesystems/index.rst
@@ -91,6 +91,7 @@ Documentation for filesystem implementations.
    ext3
    ext4/index
    f2fs
+   failfs
    gfs2/index
    hfs
    hfsplus

-- 
2.53.0

