Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402AE2F7EE4;
	Thu, 16 Jul 2026 14:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213003; cv=pass; b=ZIc08jA+q9Jax3oGgUIY/zDpxWCLejj4HMvHQf1tuDQhmlXiD0NyDj+dAMqu/Hr4jnNao1ZXx7fqN4bKERfOOxivjnr0CmEcD3BGBtGXa+9D8q1hKVi+ltU8Bs8Y/BDYwDdtFWszCFsax6n17CwzkNWhrjxQNxBUQEp/sG5AhS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213003; c=relaxed/simple;
	bh=xwNO/BHEehgIHosWVtKtYquGuqEzDY4uf+4QkMfgcMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzfJm+dGzQdFtvj1upSp2ASGwHxIAlfxtKP0tnlDS4YVLOUmCxeMFqMnj7A8jj3g1uC8fkco1Y2rgvK+CCyBcUM6GtIUP/Fh34klOyLlQvQrB8BhteZi9xK90skZqrC8IsknHEWXhijdAPi5IvaRIyqpK2seoz8cREfnuX7QyzU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=dQsbi3Vk; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="dQsbi3Vk"
ARC-Seal: i=1; a=rsa-sha256; t=1784212519; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=jivl9Si2tzrgW2TWRxYTEgSGTrd9fIckk2zQgqpkmOpsYSl0qFMW1jESl/jSN8Gdx1yy/zW9ujsPO6U/Z+j84IUWuuTLjcbsJBk1fBLScDoqhYIoEvn7bJ2WYmlkKzsYcSk5e9R2h7sugIZLWas1C99LzPEL8IKBu0iZ1hJda2w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212519; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=l4c5dTszoqEm6NDTThmAIzODAGvFqwPJuKg6pJyF2JU=; 
	b=UlOIo6zIxvMm6ZvPr1oDZyFLQlspxpdfJ7AdvTLjPFYNMOtYMaErrEqov10/42UllktxPz98FNh5x9dcmSTqhxpZk1k+ijvgqLxvmmVWAMZjyjKGV9gJE/C2oEo59KyjOt0GkYBV211oniciVPU4+LdBjTPO0L2roPaZu1z2zcg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212519;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=l4c5dTszoqEm6NDTThmAIzODAGvFqwPJuKg6pJyF2JU=;
	b=dQsbi3VkI6jCoAjM5LNwtScRr+BQ10uZztyd9ethvs6BQ1bO7Va6o8QVjej7FyCr
	K9j/0ErAl5wQJvdioQ2YC2zf7xVwoQ5gxOHkcplaMkzJ9oxTWgAckgKgCJzcUK5Mwv8
	1xlm5c94CTysq10GjBXGRlpwds6xFZxBI5D/tGVg=
Received: by mx.zohomail.com with SMTPS id 1784212516958201.0119212011324;
	Thu, 16 Jul 2026 07:35:16 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Gabriel Krisman Bertazi <krisman@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	audit@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH 19/24] file: expose spawn file-action helpers
Date: Thu, 16 Jul 2026 22:31:45 +0800
Message-ID: <0ef568259d4e7b0ec79e81ee16e0f38bfdab0483.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Process builders need to apply close_range() and fchdir() while
preparing a child. Split the syscall bodies into internal helpers so
callers in fs can reuse existing validation and state updates. Keep the
helpers internal to fs rather than adding new global interfaces.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/file.c     | 11 ++++++++---
 fs/internal.h |  2 ++
 fs/open.c     |  7 ++++++-
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 628ca07dc4b17..4f4cb1d5752c2 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -805,7 +805,7 @@ static inline void __range_close(struct files_struct *files, unsigned int fd,
 }
 
 /**
- * sys_close_range() - Close all file descriptors in a given range.
+ * do_close_range() - Close all file descriptors in a given range.
  *
  * @fd:     starting file descriptor to close
  * @max_fd: last file descriptor to close
@@ -815,8 +815,7 @@ static inline void __range_close(struct files_struct *files, unsigned int fd,
  * from @fd up to and including @max_fd are closed.
  * Currently, errors to close a given file descriptor are ignored.
  */
-SYSCALL_DEFINE3(close_range, unsigned int, fd, unsigned int, max_fd,
-		unsigned int, flags)
+int do_close_range(unsigned int fd, unsigned int max_fd, unsigned int flags)
 {
 	struct task_struct *me = current;
 	struct files_struct *cur_fds = me->files, *fds = NULL;
@@ -867,6 +866,12 @@ SYSCALL_DEFINE3(close_range, unsigned int, fd, unsigned int, max_fd,
 	return 0;
 }
 
+SYSCALL_DEFINE3(close_range, unsigned int, fd, unsigned int, max_fd,
+		unsigned int, flags)
+{
+	return do_close_range(fd, max_fd, flags);
+}
+
 /**
  * file_close_fd - return file associated with fd
  * @fd: file descriptor to retrieve file for
diff --git a/fs/internal.h b/fs/internal.h
index 71cc43e72b33e..25492194e2883 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -198,6 +198,8 @@ extern struct file *do_file_open_root(const struct path *,
 extern struct open_how build_open_how(int flags, umode_t mode);
 extern int build_open_flags(const struct open_how *how, struct open_flags *op);
 struct file *file_close_fd_locked(struct files_struct *files, unsigned fd);
+int do_close_range(unsigned int fd, unsigned int max_fd, unsigned int flags);
+int do_fchdir(unsigned int fd);
 
 int do_ftruncate(struct file *file, loff_t length, unsigned int flags);
 int chmod_common(const struct path *path, umode_t mode);
diff --git a/fs/open.c b/fs/open.c
index 408925d7bd0b7..bf9d7bdcf487c 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -568,7 +568,7 @@ SYSCALL_DEFINE1(chdir, const char __user *, filename)
 	return error;
 }
 
-SYSCALL_DEFINE1(fchdir, unsigned int, fd)
+int do_fchdir(unsigned int fd)
 {
 	CLASS(fd_raw, f)(fd);
 	int error;
@@ -585,6 +585,11 @@ SYSCALL_DEFINE1(fchdir, unsigned int, fd)
 	return error;
 }
 
+SYSCALL_DEFINE1(fchdir, unsigned int, fd)
+{
+	return do_fchdir(fd);
+}
+
 SYSCALL_DEFINE1(chroot, const char __user *, filename)
 {
 	struct path path;
-- 
2.52.0

