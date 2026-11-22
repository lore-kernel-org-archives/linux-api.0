Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795376195;
	b=EwPUx7GJayRNT1uUI2+/Ofvg4o+ubykL9fXewcITgNNoKxN5rNbXBUESm31eHFmg1cLg
	 nFGYMh2xYG/NGOh8ZKzskxPSjYgo+KpyJVK2XTsm9yE7Y0u83RX8jGv+OwiLMmIqmFS9q
	 ViZkjE55GHNBzBjGiVYzebKdP4rgpT/3lbnoV3f0+8WUH3sNuYtnbTA/GkjLJ8spCJoDB
	 DerNaDX2xIEhSo8nEyC8I36Tx5xYaEpYxP6EFTBJS2UHs9djsL9G0iMKrTMJTc82uygPO
	 9Fq//4zvAgctEPmn9B/NpdkDJK/o9DwvxEoGDjje5vivcVagr/sAlvA4XLrfbReD6AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795376195;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ujYt3pxK39YV6xgrJ9ycAzI8XphJxsY1pHf5v0/Q8cY=;
	b=nZNyeNrA8oBoKz1d0iHxBLn+muH/LbgxiZe25vyyVbd7V+91wW8Mtw7GO6RliZyb5OEl
	 Ej2lxkc2KYlAhGqXjuVZbh+rVWzJA07P9ElBOUTdzrXRbACabEHIYnCi2X1n6u5LarW3p
	 6uCKX3T5JlUTBGDkyOwtvv2xXyQDAugBuQ1Q79LME/2uPfAtzzxGzKJqdjlVXS91ZrTgS
	 7PDPQ4aNwRKkVSb9bE73O8iMsHRj8UOX4DDy7NdxGcDTTMkwbZjMOsEOB8j9rV3KbhT5/
	 DZJRmWvjxy0tSKDR8EXWtTrV2d6QL4vA4nWQGtt+WyDZwRV+mSm5E2M3eFqSH3e9bGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OoGSfxYg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3D54A606A32D;
	Sun, 22 Nov 2026 19:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OoGSfxYg
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 275C91F000E1;
	Sun, 22 Nov 2026 19:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376194;
	bh=ujYt3pxK39YV6xgrJ9ycAzI8XphJxsY1pHf5v0/Q8cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OoGSfxYgsZcZJElXw84v9gsSeSMwok9hzGq6rqX9ynWRDXqq3zx71CzuuYvvw2g/R
	 1UpEgjqxgsRgThvgJblfJjMiuNX4mqqhqHoyFnm0J7hEkd5/8FlUQcVS3mkMU4mMYX
	 iF91SZzxOwMNMH2crVXxL7rch4XakMfXwpVbdpSN68at4yxvJhdrFGtdqimiqw52tC
	 d1j+4sNCZtrz2PP53RcNgvvbAnU4dUe5TRSV/ZC+XXhMOQA24qIq01hpvWa3QXVrBH
	 aYxsxae0fedmvv9+V6SNnLaGfcB9iN+D8NEneNdjl2luzlR75sAG8Cl8K/pyTCNbLe
	 u82rSzLk5TrlQ==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	bpf@vger.kernel.org,
	containers@lists.linux.dev,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>,
	Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v7 09/26] nsproxy: Expose create_new_namespaces()
Date: Sun, 22 Nov 2026 21:35:22 +0200
Message-ID: <20261122193539.3334213-10-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

create_new_namespaces() is currently static to kernel/nsproxy.c,
preventing callers outside kernel/nsproxy.c from constructing a child
nsproxy without mutating a task.

Expose create_new_namespaces() in <linux/nsproxy.h> so userland_open()
can allocate a detached namespace set from current.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/nsproxy.h | 4 ++++
 kernel/nsproxy.c        | 6 +++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index dc2447f5f092..d611c40cb4ce 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -12,6 +12,7 @@ struct ipc_namespace;
 struct pid_namespace;
 struct cgroup_namespace;
 struct fs_struct;
+struct user_namespace;
 
 /*
  * A structure to contain pointers to all per-process
@@ -92,6 +93,9 @@ static inline struct cred *nsset_cred(struct nsset *set)
  *
  */
 
+struct nsproxy *create_new_namespaces(u64 flags, struct task_struct *tsk,
+				      struct user_namespace *user_ns,
+				      struct fs_struct *new_fs);
 int copy_namespaces(u64 flags, struct task_struct *tsk);
 void switch_cred_namespaces(const struct cred *old, const struct cred *new);
 void exit_nsproxy_namespaces(struct task_struct *tsk);
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 2dcf105e8ee2..3c4161515c3c 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -85,9 +85,9 @@ void deactivate_nsproxy(struct nsproxy *ns)
  * Return the newly created nsproxy.  Do not attach this to the task,
  * leave it to the caller to do proper locking and attach it to task.
  */
-static struct nsproxy *create_new_namespaces(u64 flags,
-	struct task_struct *tsk, struct user_namespace *user_ns,
-	struct fs_struct *new_fs)
+struct nsproxy *create_new_namespaces(u64 flags, struct task_struct *tsk,
+				      struct user_namespace *user_ns,
+				      struct fs_struct *new_fs)
 {
 	struct nsproxy *new_nsp;
 	int err;
-- 
2.47.3

