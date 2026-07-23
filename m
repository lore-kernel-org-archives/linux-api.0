Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BAE471CF3;
	Thu, 23 Jul 2026 11:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784806249; cv=none; b=MwfrIDSI1qIFUNQs++k742EDFGpiTWaLLVB86eMHvFU0VwbAdAWAh1jjlvO4QJmNJKC7ih27j+IgwCwEppD6yAhnstJFDOtB9V2uS1/xa1jrrXorC0pQIjbR8srEKLMGtCWkS0IvftIgVQR/Y1kR3Unaxyt4dOzrhOShqC3IIxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784806249; c=relaxed/simple;
	bh=QeyHf0dBOuekHuS6Q6V8exUEh7qyASDiJjuWd8I++yM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=esg5IUnXFQj3MvQfcAY+fthJ7On6k13XtuAQ54Ra1L/Gk8GMi+OSZEl9abpwJsHDe8pxccF5i81C9Wo+PdyC6XUWzK8kaa9TJPcIuy47A2iA+CD812B+8xQ1Tfy66k+4HXFV2aoib4bCuiapdk2Ve+zoZ+1I0JiW8OkAeJHVbFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dXvhydE4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dXvhydE4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0278E1F00A3A;
	Thu, 23 Jul 2026 11:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784806246;
	bh=kL222Q7bZV1iEsYup1nUUuglGOFcK2eaek04QbM40+0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dXvhydE4RCXkBFqhcOoOvoyjbGrViCWMuuM+CfOL6DQ2vDp+KOylOkN7MoT/TNcyU
	 u7glF1Fwe+PcqyTbQSWWDx7ICK1M5n/4a1UsNn8B6Di2FqS7hBJnXOVvghUeTeZK5y
	 AxeQwZ5OQ9ndV8TPzF7oncpfdSMLeIkXgktZpWLj4nyRVDxC9v2o/yO5zE1sXuPjHH
	 Yn2iiUDMpruqXHnRQygiG3le+32DjpDJx/wJu7/tQcXpadCX7QTf+oLI+iROugpNhq
	 6C6NOFYTQI1ab1BBOqquMEq2v9Gly3zWeJRvNNJXvOwqUFLH3hrZ7XAzKgVG/JHFiX
	 5BxSPjNhO0GPw==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 23 Jul 2026 13:30:22 +0200
Subject: [PATCH RFC 3/7] fs: add fchroot()
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-work-failfs-v1-3-3f69b9a9e958@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2585; i=brauner@kernel.org;
 h=from:subject:message-id; bh=QeyHf0dBOuekHuS6Q6V8exUEh7qyASDiJjuWd8I++yM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQl/g5PqWuQ0d+ZpOG8uXtyplb70dLkvMsF112SnijPf
 9n70cqso5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCKf5Rn+l1vNVrnGuKi6qfFo
 xYbSi+8WLFp+gsHh8FGhu16nlpRsDWL4H7xHXt9MuVJox9UXym9yr/rVloV1Wr08La+kyCWg6f2
 ECwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Add a file descriptor based counterpart to chroot(2). This has been
overdue for a long time. It is the natural companion to fchdir() and
avoids re-resolving a path that the caller already holds a file
descriptor to. No TOCTOU between resolving the target and changing the
root. It composes with modern fd-based APIs meaning it works with O_PATH
file descriptors and file descriptors to detached mount trees created
via open_tree(OPEN_TREE_CLONE).

The permission model is identical to chroot(2). Rhe caller must have
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

