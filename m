Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00760470430;
	Thu, 23 Jul 2026 11:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784806254; cv=none; b=NWJIldrqcm4oJbwHogk3m4hgrFmm9ZbikRSdGQknXpcP7FuEBt4iZoFINSkbCeerHiYf/CeDqF9/31sJsStms0GYkkyJ6vI/sZ2LMbpFsWunjYdgCvEBevZh57+T5RNJIw0TkCdsEGRdQVvrzUxheh/40sU9InVplRD9PPmmWYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784806254; c=relaxed/simple;
	bh=yqO6vurUVKadnYgpnL4LMFtHuyT4slGfIqlnKKYdgCY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eLWV6mxpyeAAeMiQfBEdS8N3Bwdd89YF8EFmbifW+JFeiiVvZI70Cs+Q2Wk0OLc6Mu0CA6UCseJXR0ZJbWpNyPeVa0Gf7/TMVnZCHHuylPhYvGW2uFrZjFr1szuNf1mKBPtByhxmSZ57BZYYWc7E93RYVD1la+ZyqCdnELxZcRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PX+UDEc9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PX+UDEc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0F81F000E9;
	Thu, 23 Jul 2026 11:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784806249;
	bh=FwpYn/7CVQ0Kudm+A/0Wp/DqAAY0gvJL5RppLdjSL8Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PX+UDEc9N4UI4hSIG7wzkVlj3XC18kCFee5bSjxnyjKokFRhKcRhoN2wLWJbPNkhW
	 ObYo9p/lDmp6GNK7llNrVVlQ7ysztJht5Ll3QB2KihJdvFuFFXR5hmQnJjjG89Kl92
	 8ClwOta63fGbiiuOchOaKIVC8Xqgo+7lQPrageQ9041dMvNXQjozK89YAjHILOhb1a
	 SeWrpqau3JzMS2Xuw637ZQj5vaHDb1GOjMRQdLqAo8JlsgMhIYP3PNVZTHcODoyalB
	 938cZ26q+HGaNBHvzQgcz2HMLigfFEbT3oMs5tTbPS7oICK9rAfH66JmKHZX4wHjey
	 N7ITFibQJR0Sg==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 23 Jul 2026 13:30:23 +0200
Subject: [PATCH RFC 4/7] fs: support FD_FAILFS_ROOT in fchroot()
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-work-failfs-v1-4-3f69b9a9e958@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3927; i=brauner@kernel.org;
 h=from:subject:message-id; bh=yqO6vurUVKadnYgpnL4LMFtHuyT4slGfIqlnKKYdgCY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQl/g53vvF46aXr1v/LP+l+yd+8nE3f8LTQjhvXEmf/0
 Ayt+eiwsqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiNv0M/51PfUt+tv/nUq1J
 64Nrc37cjTZmLz9nYNB99Irlk6prSzYxMpxeza2fUBsZdPTNwnXmazI9p7t90Otc0nOj8eoToYB
 vy7kA
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
this, mirroring chroot(2). Unprivileged callers are subject to two
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

There's also some thought needed around shared fs_struct state. It's
obviously possible to chroot into failfs with a shared fs_struct if the
caller has CAP_SYS_CHROOT and shares the fs_struct or if the caller is
no_new_privs and shares the fs_struct. The non-chrooted-currently
requirement still applies.

Once entered, failfs is a throw-away-the-key moment. The task is
considered chrooted so it cannot create user namespaces to regain
CAP_SYS_CHROOT. chroot()/fchroot() back out require CAP_SYS_CHROOT.

The only other exit is setns() to a mount namespace file descriptor
which requires CAP_SYS_ADMIN over the target namespace plus
CAP_SYS_CHROOT and CAP_SYS_ADMIN in the caller's user namespace and
resets both root and working directory. A process that closes or never
had such file descriptors and restricts *chdir()/*chroot()/setns() via
seccomp has thrown away the key.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/open.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/open.c b/fs/open.c
index c57f641f2e29..8adc9f00889a 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -618,6 +618,27 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
 	return error;
 }
 
+static int fchroot_failfs(void)
+{
+	struct path path;
+	int error;
+
+	if (!ns_capable(current_user_ns(), CAP_SYS_CHROOT)) {
+		if (!task_no_new_privs(current))
+			return -EPERM;
+		/* Moving the root to failfs lifts the old root's ".." barrier. */
+		if (current_chrooted())
+			return -EPERM;
+	}
+
+	failfs_get_root(&path);
+	error = security_path_chroot(&path);
+	if (!error)
+		set_fs_root(current->fs, &path);
+	path_put(&path);
+	return error;
+}
+
 SYSCALL_DEFINE2(fchroot, int, fd, unsigned int, flags)
 {
 	int error;
@@ -625,6 +646,9 @@ SYSCALL_DEFINE2(fchroot, int, fd, unsigned int, flags)
 	if (flags)
 		return -EINVAL;
 
+	if (fd == FD_FAILFS_ROOT)
+		return fchroot_failfs();
+
 	CLASS(fd_raw, f)(fd);
 	if (fd_empty(f))
 		return -EBADF;

-- 
2.53.0

