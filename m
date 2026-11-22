Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795310334;
	b=g4v+H4/aQKkVQtHMmth/P2EkhdGJy122BXkxyJCorpwMjbU5RUyJNJJs8NiXfY/zEzRu
	 RAG8A9FDDmZul8pDC70FodXQ7pv0/BHfdRzBfkciwfrBBchiF5I1iIYEWuGavVVI+j3En
	 F54eeDTStSgDCnl5L/s5CYVpfx1aYa3mUkXIChilepSeIBNhErviYncNwev2T6uKUnYvJ
	 eOr1wDDEzCMrA0LzknndDHEgG5c+KicyIPYQmV4kOkFFkZaXZZW1/xVDDDuANAAphjE48
	 n/sx7GDs3iwDQkkQXnlWAin2WyuubQlN+ajgWNYhxRde9ROtmpZsBOUH+tQ+7zkA3yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795310334;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ujYt3pxK39YV6xgrJ9ycAzI8XphJxsY1pHf5v0/Q8cY=;
	b=WAwh1tK1TIc/Z5kr590JpcM2K9Wu4msF/QTOaRtWFR94F5YJdaxTl4M/lKoy7steh+tJ
	 QKbKlHeQCTz8MV+32ALoPwzEr1yKz7W+wLMd6dyaI/iph90EfpFzLNRWJfn94wsTco/Dq
	 9Ko63bzGTpThXR53ZPzmjxeBDTL2bDje9ZxgR/wysr0TgrUlw+dPllJt6H11AqgFBUiob
	 SpRCcA0+GGXdK/vuXctkXFW5sVhl7nqOsCx9FfYpMD5pvZJpIMuGG8gHJVz2jnshMGnIN
	 PtulUuTLXg9faHaqjCepr7V4yoflYKZaygXQs3ssQO6N/WQjtbqsYLvK5JDr+5DhnEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CgSTB0r+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id CD696606A337;
	Sun, 22 Nov 2026 01:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CgSTB0r+
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A62951F000C4;
	Sun, 22 Nov 2026 01:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310334;
	bh=ujYt3pxK39YV6xgrJ9ycAzI8XphJxsY1pHf5v0/Q8cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CgSTB0r+qkmpoLhDmBXzXLaFPO6TDxI9hqMTd0QaDETYc5hiIE+oYwIeSHoX1F7C2
	 hd4PtTV9HD0t1euQNFWbrMDTgq3tJFnzNsMmMoSuoKqqkpx7uBZwv3KuTHe0XWlT1+
	 ibaYClAnRYgqz30+oCDgftSDlETTtIjeVlGs4deSajG4UoiIsbes7IlDJCXQCRWcNK
	 +8ry9WPoRCz0m4MKw+ikMxE98B092zAXImn5aAsN1ebTZK54gbFDfVJ7ydT4B2F/ql
	 AwZiXUqVcm46z0BjZkGXB4W5lC+crtcEE4G7ken5udDPyk6vtlnCJ0uS5D984Peiuh
	 v8M/mrv42qB7A==
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
Subject: [RFC PATCH v6 09/26] nsproxy: Expose create_new_namespaces()
Date: Sun, 22 Nov 2026 03:17:52 +0200
Message-ID: <20261122011809.2667684-10-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
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

