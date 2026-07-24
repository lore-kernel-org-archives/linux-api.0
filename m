Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC1E43304B;
	Fri, 24 Jul 2026 13:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784900498; cv=none; b=oizQvk/Y0rqQl4yGk3WVoNN/hfzNqiVNSp29V0DeJSnXuXZDREPlYHEJMC7pjNvNeSIavyKYnd639jLJW7FvUY3Ng7s+ELyZt1/9PHTSAjcJ0rjII9c+ZuhqJZoDwQuNrsFSOn52vpS4YzJROqWl0tejpgMLkPog+3Un68mZXS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784900498; c=relaxed/simple;
	bh=3kJEjg5rDhovEDPR6daxJNj3kC7dNNM37mvNMr4zgTk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=H6dx7tLtpwDeH5jQqtqeMd7RICgv9AOu9gzvuIyVgunr+3kefXKtw0QfgMC9o56zDL8hhNBAVsUuI1ZwnBXwShP7D4+NtsoHyCUw8pnHbz5jKB+Dv0qQqe8OjokcDoNrfhUMspSYNDkDDpFJgzFXT4OH0ZfhKSNU5YI/+wBTn18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KNlPmki9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KNlPmki9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D561F00A3A;
	Fri, 24 Jul 2026 13:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784900497;
	bh=kF5z1zzpmDYjTEkMEPvP/xmtcH6zrKIbvcfMKStmosg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KNlPmki9BEgWPihJFqBMHxUaH6eBjJCL++woV1WhqhvwzVcWUsgJUdRLn+2PhRI1/
	 Z2qbw5703RjfPmJqTtf44L0HxSunRgDrfMC0JrQnN0nC4nNgG3LavDY2nEXWyidIqA
	 8cMGMcfjaG6fce8DkbstGeh8APW1Qj2SPyoMwNSd7W3ENzdGahNMfL0XP2PQMNBBAl
	 DY5/qhZe2hziaUY2TNyxn1C1qhB6iYj8h1BP2Yrdi4CiU3SGl5TKuAZLATUhusOqt3
	 /DEfXJHoYUY4zjmscOMqD0p3S/G+4k2uVdsZge4CZwnVca55zCzPdJK2wxb4gK0Wvn
	 TYVJ82/223PVA==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 24 Jul 2026 15:41:19 +0200
Subject: [PATCH v2 3/7] fs: add fchroot()
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260724-work-failfs-v2-3-485dabbae185@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2585; i=brauner@kernel.org;
 h=from:subject:message-id; bh=3kJEjg5rDhovEDPR6daxJNj3kC7dNNM37mvNMr4zgTk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQlZzeLxzGfa2Sc7XZmo8NuZ59fBoI/JtWuZek2d9Lxj
 NMRz33QUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMBFeHoY/vM8T9FRyqzKtt9Vr
 Xv9kNEVa30iqwStYw0t3WbeM4p0tDP8D97BPNhPYeO67bEL1DddNlk/tdNPXrWZ/LXttk07yqQA
 mAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Add a file descriptor based counterpart to chroot(2). This has been
overdue for a long time. It is the natural companion to fchdir() and
avoids re-resolving a path that the caller already holds a file
descriptor to. No TOCTOU between resolving the target and changing the
root. It composes with modern fd-based APIs meaning it works with O_PATH
file descriptors and file descriptors to detached mount trees created
via open_tree(OPEN_TREE_CLONE).

The permission model is identical to chroot(2). The caller must have
CAP_SYS_CHROOT in its user namespace, must pass MAY_EXEC | MAY_CHDIR
permission checks on the target directory, and LSMs are consulted via
the same security_path_chroot() hook.

The system call takes a flags argument for future extensibility which
must currently be zero.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/open.c                | 29 +++++++++++++++++++++++++++++
 include/linux/syscalls.h |  1 +
 2 files changed, 30 insertions(+)

diff --git a/fs/open.c b/fs/open.c
index 56b6032d4d81..c57f641f2e29 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -618,6 +618,35 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
 	return error;
 }
 
+SYSCALL_DEFINE2(fchroot, int, fd, unsigned int, flags)
+{
+	int error;
+
+	if (flags)
+		return -EINVAL;
+
+	CLASS(fd_raw, f)(fd);
+	if (fd_empty(f))
+		return -EBADF;
+
+	if (!d_can_lookup(fd_file(f)->f_path.dentry))
+		return -ENOTDIR;
+
+	error = file_permission(fd_file(f), MAY_EXEC | MAY_CHDIR);
+	if (error)
+		return error;
+
+	if (!ns_capable(current_user_ns(), CAP_SYS_CHROOT))
+		return -EPERM;
+
+	error = security_path_chroot(&fd_file(f)->f_path);
+	if (error)
+		return error;
+
+	set_fs_root(current->fs, &fd_file(f)->f_path);
+	return 0;
+}
+
 int chmod_common(const struct path *path, umode_t mode)
 {
 	struct inode *inode = path->dentry->d_inode;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 874d9067a43b..8413b624ad47 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -457,6 +457,7 @@ asmlinkage long sys_faccessat2(int dfd, const char __user *filename, int mode,
 asmlinkage long sys_chdir(const char __user *filename);
 asmlinkage long sys_fchdir(unsigned int fd);
 asmlinkage long sys_chroot(const char __user *filename);
+asmlinkage long sys_fchroot(int fd, unsigned int flags);
 asmlinkage long sys_fchmod(unsigned int fd, umode_t mode);
 asmlinkage long sys_fchmodat(int dfd, const char __user *filename,
 			     umode_t mode);

-- 
2.53.0

