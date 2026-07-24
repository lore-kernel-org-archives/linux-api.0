Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64ADE437440;
	Fri, 24 Jul 2026 13:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784900502; cv=none; b=LjhbStZ5QPmHtMEE8i8tEIfzI7uQukPYl1gRsROTfeu77nstPe21C8l6zfbaT76z3cD/tsdH/M+O00FtQ9f/3rkvFsIJ1kt8XILAisVI0XTB1IjHzJ2VZkX5SeDTrVUaD5BoIKG8ew3B8JTfhFROYoldSLLkzJ2/54z9qTdejB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784900502; c=relaxed/simple;
	bh=e/PMUsFjYc4cClYq8CIpXiy0k7R//ssIqvGBQ4FVIrE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Y45EZHkECDsdY2rm/8EOuJMOybKfdnkNhWLzHCQ9SmxlAYeC7sHPUcJd33mbqeXMTlc5cwzhv/VNEbNUjeqW4zVobsJkL96GzNIgbN5/urALV+V1Vs0J++P3fjNJ6lhV+Ttr5ylKvYq/+gs7wykX7l8YH6f0eD6P+Akf1iFC6z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UlxG9tfp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UlxG9tfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C941F000E9;
	Fri, 24 Jul 2026 13:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784900501;
	bh=zKWM0iXJn0uuXn3vmCcASaPMe0mI56Y0cEnjxJgGQ9c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UlxG9tfppoWCzLcD5HBMLjylPUkrgvQ530wvoYnuuQ9vOi2f6MG0eMeSxeaXk8R4Q
	 V7kQfs1IPVwpM1dh8URGsXUKIyQsh+Szvojm4sT4Yh9aU4BgDa6VhybTDK+xV6KJZh
	 xdAvKGYqid2JimFHeJF6RL7jVni1SKUODsGsUTrh3Nc2TrJEFd7VGkKTsq0yRnEcSh
	 YzADucnCz74S+4xzkTMD/Z2gM8V9Txzb5ul/2ryDGCsPCHlY+NM+I9YXAL6S8bbNi/
	 Bx2lyLdYGRwjWstvDqSeOBwttPG8DSY351eb7wpdQEfpHm877gghytylIFja9YP8oA
	 LTxG5hin5LAmw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 24 Jul 2026 15:41:20 +0200
Subject: [PATCH v2 4/7] fs: support FD_FAILFS_ROOT in fchroot()
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260724-work-failfs-v2-4-485dabbae185@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5599; i=brauner@kernel.org;
 h=from:subject:message-id; bh=e/PMUsFjYc4cClYq8CIpXiy0k7R//ssIqvGBQ4FVIrE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQlZzfv2ZL/Y4n5Et4ardPR/iqB9x+u0NgusJ09XDdFv
 f2l42/djlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIk8+MvwP2eWoea/4gczzRJ2
 nV3hv80oJLi50minpBbjJZZrzf3CrIwMDVVGB33kcx51CfIoLH7xePq/z+xmdk25L59cbGBeKHO
 HDQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Allow a process to move its root directory into failfs via
fchroot(FD_FAILFS_ROOT). From that point on every absolute path lookup
and every absolute symlink fails with EOPNOTSUPP. Combined with
fchdir(FD_FAILFS_ROOT) this leaves the process with lookups anchored
at explicit directory file descriptors only. It is the fs_struct
equivalent of RESOLVE_BENEATH. This allows taks to drop their filesystem
state completely.

Callers with CAP_SYS_CHROOT in their user namespace may always do
this, mirroring chroot(2). Unprivileged callers are subject to three
requirements (which may be loosened later):

(1) no_new_privs must be set

    After entering failfs suid binaries on regular mounts remain
    reachable via inherited directory file descriptors or the working
    directory. A setuid program executing with an unusable root
    directory might be tricked by this. I'm not 100% convinced that this
    is needed but it feels more secure initially and it also forces more
    no_new_privs on userspace. So win-win imo.

(2) The caller must not already be chrooted.

    The root directory is what confines .. resolution. The failfs root
    can never be reached by walking up a real mount tree. A task whose
    root is failfs has no .. barrier left below the top of its mount
    tree. A .. walk from any real directory fd it still holds climbs
    to the mount-namespace root. Which is kinda the point if you want to
    do fd-based lookup only. If failfs prevented you from doing that
    then it doesn't make a lot of sense.

    A task that a privileged manager chrooted into a subtree could use
    chroot()ing into failfs as a way to allow for an inherited fd to
    resolve it again.

    So reject already-chrooted callers closing that issue without losing
    anything for the intended self-sandboxing use case.

(3) The caller must not share its fs_struct.

    Requirement (1) is checked on the calling thread, but the root
    lives in the fs_struct which may be shared via CLONE_FS. A sibling
    thread without no_new_privs could then execute a setuid binary with
    the failfs root and defeat (1). setns() to a mount or user namespace
    refuses a shared fs_struct for the same kind of reason, so do the
    same here and require fs->users == 1. no_new_privs is inherited
    across clone() and can never be cleared, so any CLONE_FS child
    created afterwards carries it too and the guarantee holds.

Privileged callers (CAP_SYS_CHROOT) are not subject to these
requirements and may share the fs_struct. They can already chroot and
exec a setuid binary today, so failfs hands them nothing new.

Backing out is currently hard, but that is a property of the current
implementation and not a promise. current_chrooted() treats a failfs
root as chrooted so for now the task cannot create user namespaces to
regain CAP_SYS_CHROOT and chroot()/fchroot() back out require
CAP_SYS_CHROOT. This is not guaranteed though. current_chrooted() may
change, or an unprivileged no_new_privs task could be allowed to chroot
to a real directory, either of which would loosen this. So don't treat
it as a permanent one-way door.

The remaining way out today is setns() to a mount namespace file
descriptor which requires CAP_SYS_ADMIN over the target namespace plus
CAP_SYS_CHROOT and CAP_SYS_ADMIN in the caller's user namespace and
resets both root and working directory. A task that closes or never had
such file descriptors and restricts *chdir()/*chroot()/setns() via
seccomp currently cannot get back out.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/open.c | 47 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index c57f641f2e29..6b1c14e684a9 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -620,31 +620,48 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
 
 SYSCALL_DEFINE2(fchroot, int, fd, unsigned int, flags)
 {
+	struct path path;
 	int error;
 
 	if (flags)
 		return -EINVAL;
 
-	CLASS(fd_raw, f)(fd);
-	if (fd_empty(f))
-		return -EBADF;
+	if (fd == FD_FAILFS_ROOT) {
+		if (!ns_capable(current_user_ns(), CAP_SYS_CHROOT)) {
+			if (!task_no_new_privs(current))
+				return -EPERM;
+			/* A shared fs_struct lets a sibling exec setuid past the check above. */
+			if (current->fs->users != 1)
+				return -EINVAL;
+			/* Moving the root to failfs lifts the old root's ".." barrier. */
+			if (current_chrooted())
+				return -EPERM;
+		}
+		failfs_get_root(&path);
+	} else {
+		CLASS(fd_raw, f)(fd);
+		if (fd_empty(f))
+			return -EBADF;
 
-	if (!d_can_lookup(fd_file(f)->f_path.dentry))
-		return -ENOTDIR;
+		if (!d_can_lookup(fd_file(f)->f_path.dentry))
+			return -ENOTDIR;
 
-	error = file_permission(fd_file(f), MAY_EXEC | MAY_CHDIR);
-	if (error)
-		return error;
+		error = file_permission(fd_file(f), MAY_EXEC | MAY_CHDIR);
+		if (error)
+			return error;
 
-	if (!ns_capable(current_user_ns(), CAP_SYS_CHROOT))
-		return -EPERM;
+		if (!ns_capable(current_user_ns(), CAP_SYS_CHROOT))
+			return -EPERM;
 
-	error = security_path_chroot(&fd_file(f)->f_path);
-	if (error)
-		return error;
+		path = fd_file(f)->f_path;
+		path_get(&path);
+	}
 
-	set_fs_root(current->fs, &fd_file(f)->f_path);
-	return 0;
+	error = security_path_chroot(&path);
+	if (!error)
+		set_fs_root(current->fs, &path);
+	path_put(&path);
+	return error;
 }
 
 int chmod_common(const struct path *path, umode_t mode)

-- 
2.53.0

