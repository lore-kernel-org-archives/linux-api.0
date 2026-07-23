Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81719471D0C;
	Thu, 23 Jul 2026 11:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784806263; cv=none; b=S8oUppYTLjb2UlQafbli5ivJe30WWTkWj33Pk5VbnaBxyUFXMc7xIY0dL+zjBYLPV3MPEWPlVacnKsn/jgd9BnQnDWYnSi4T/StpTAGQgoCNozEEagEEFqxixJ4v1zUxZmPQWC2isbxzf/df4oKLuxuzRCdQZxYiIBGvjxeraww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784806263; c=relaxed/simple;
	bh=C++APXasOEg8g/XQcYBrRPDHVq5h8OHVddjqmZ0vcd8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=b54A3CJye76J52LeAYHMMvkRqHPubw7KbTG8kXvye7LMejsekSqBPgIF+GAoh3TNiXeJS+UebQQZHscvsHsUgASNMOq8mMex5GGRlgr9JmYQKO6Eb8zPlFa3vZvewCOAlz9AldyzuZUiQ0bCCGG5Qut7Ckj6ulc/agIm+ra9TF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EftVfQ47; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EftVfQ47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42081F00A3E;
	Thu, 23 Jul 2026 11:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784806261;
	bh=xARf2O0qu7qCYZPDkTyhea6H3gAN0CxcFQpfXrpAzPY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EftVfQ47BWM2HcE46jmhKFntDoTIzB/h1rEI3b48MkBs8Rqxr84orUugmhpH1sG+O
	 +oXOS+DVsSuAYCJzr0jCVsfUg2l5HqzrR9qryFl5nvJEiUI+O8qrySo7mUNHUqtkQ+
	 AmcPNXhqvG3+icJXR4YCb9f7Kmi4IHuIoy/wyPnx4usLkC4/MV0D0sxZzrIvbXWhnN
	 lzRBeM14zn8YzsZNL3UEmrVSsfF97gZDKbXL5+DjH/BzdKG/5bv4/01NbUlTOyN4ac
	 J8Lfo8fIHK9lFmKVQwnpcHG0lzDu3n03P/Wn34lWIqajX/Cg1xXoQ4X75caz9v6hlr
	 7b+sj91K+gxAg==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 23 Jul 2026 13:30:26 +0200
Subject: [PATCH RFC 7/7] Documentation: add failfs documentation
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-work-failfs-v1-7-3f69b9a9e958@kernel.org>
References: <20260723-work-failfs-v1-0-3f69b9a9e958@kernel.org>
In-Reply-To: <20260723-work-failfs-v1-0-3f69b9a9e958@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3730; i=brauner@kernel.org;
 h=from:subject:message-id; bh=C++APXasOEg8g/XQcYBrRPDHVq5h8OHVddjqmZ0vcd8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQl/g4XSZigIL1NyNJvr9vGC0WqzsceKu0MDztz8cMRI
 9Egq8KyjhIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlIHWb4psib9p+7LV5x3ZbO
 F1ZCnzeJeSyvv/HDJmmhzeVLmU28DP8L2yTeH/haLiSY0lOnsDOyI12O+//WuXzmUbEvwt4s2cA
 CAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Document the failfs semantics, the FD_FAILFS_ROOT sentinel, the
fchroot() entry requirements, and the ways back out.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/filesystems/failfs.rst | 64 ++++++++++++++++++++++++++++++++++++
 Documentation/filesystems/index.rst  |  1 +
 2 files changed, 65 insertions(+)

diff --git a/Documentation/filesystems/failfs.rst b/Documentation/filesystems/failfs.rst
new file mode 100644
index 000000000000..46d91525916b
--- /dev/null
+++ b/Documentation/filesystems/failfs.rst
@@ -0,0 +1,64 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+======
+failfs
+======
+
+failfs is a kernel-internal filesystem that fails every operation
+reaching it with ``EOPNOTSUPP``. It is the counterpart to nullfs. Where
+nullfs is a permanently empty failfs means "nothing is supported here". It
+cannot be mounted from userspace, nothing can be mounted on top of it. It
+cannot be cloned.
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
+The root itself cannot be opened at all not even with ``O_PATH``.
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
+may enter if both of the following hold:
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
+Leaving
+=======
+
+A process that entered failfs counts as chrooted. It cannot create user
+namespaces to regain ``CAP_SYS_CHROOT``, and ``chroot(2)`` or
+``fchroot(2)`` back out require ``CAP_SYS_CHROOT``. The only other exit
+is ``setns(2)`` with a mount namespace file descriptor, which requires
+``CAP_SYS_ADMIN`` over the target mount namespace as well as
+``CAP_SYS_CHROOT`` and ``CAP_SYS_ADMIN`` in the caller's user namespace
+and resets both root and working directory. A process that holds no such
+file descriptor and restricts ``*chdir()``/``*chroot()``/``setns()`` via
+seccomp has thrown away the key.
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

