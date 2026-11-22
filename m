Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795310330;
	b=P45r4ITXfVSfp+AfTkG30N/yxOuTfkFynGyyaXAyHwvJreLHuCFML0ApFzHH1OAxfxYm
	 K3s/xCh/qPZmneKczR6e4DCX4o8LF67fYzEZMW0TDhtgETeY8nOYhjtqBysZ+r+GBmZnV
	 gJqSsMVEKKZYG50G/IZ5zPL6wqyMsi55XPI+ApUhKbQ9Qiy49eBQzx0Ut1QlobmaNd1mT
	 KbqpgdIFHowqxSIZpmLTeFy8T6FWzLm4qFRMGhT1RXBs4plTrRsWmAJ9Bd/TpEJdlm+z/
	 qCIp18wFlZ5nm70+3qy8jeKoyCf4NmpKjbYTYj/O1m/Yn7CAafy3MmCZ+FuROGVh1ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795310330;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=7i1ZKyYWLmxMooUHWzodPLxMUmlmO8vdX8qUIBZhiHg=;
	b=LuuIyE7pByA5gK8x54ou+HG4O8uDSvGaPwPRbH1yGtiB7QQPSfDPExHfwg5W1na9cKg2
	 aPdxCeg+Fzr/EDjEG9aY2D1qWuG7HhEF2oge7DP1xxzA+UVZUXbtQd1ytJNGdYuvrxwBa
	 UKUoQfdZTOWH7qgqo2h0ZC6WrePe4cYTcTJfz5cWWVjjA1CJEpBfWLC8t+8h0y2OvcZAD
	 Jz72jfN4dOqGkCWb8xkkGD9lFeCippueJLdelSNHFkVYweNrWqExj5GQUr9qD+/j8qVtk
	 Qd8l0XG0P8aKFICN5mrYEMWU7Xqcgp3GgxuDWq0yoJQuxDxzYWIi62JlORC/eieUR2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HLKngoZc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B1104606A320;
	Sun, 22 Nov 2026 01:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HLKngoZc
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DE3B91F000D4;
	Sun, 22 Nov 2026 01:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310330;
	bh=7i1ZKyYWLmxMooUHWzodPLxMUmlmO8vdX8qUIBZhiHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HLKngoZcXVDJegov6aUSnuW5rbhlxkfcJOWqXdXeFpgr81zwLzn+RDL6dabXOaOY+
	 4Vl58atGb0z4/aDHm0RJriTd8jDGqSL/XPulb1lFYW535a4R3kNlg5yytA0FNOONfk
	 3ZRis0tF//jE8/AEQGNMiao1qfBvwHiIM8N+hagpBDQr6xdrNsFQV2eF7z43nGwmO2
	 LKza6buMaUQRxhzsdkKVjyKPu5B7gnovypqe3hg1bNykCnsJKYgshHffYlBykB5XDV
	 o/FoxZbNxE27GbjxKULDw18duEr39TWl8nhY1fVwxxFcDcmKruTZyVEqVipJ6ApeCs
	 BcxM2zdM5GvrQ==
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
Subject: [RFC PATCH v6 08/26] userns: Factor out install_user_ns_cred()
Date: Sun, 22 Nov 2026 03:17:51 +0200
Message-ID: <20261122011809.2667684-9-jarkko@kernel.org>
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

userns_install() updates a credential's owning user namespace and
rebinds its ucounts inline, which cannot be reused by fork paths that
switch a newly allocated child credential into a target user namespace.

Factor this logic out into install_user_ns_cred() with a !CONFIG_USER_NS
stub so callers outside kernel/user_namespace.c can install a target
user namespace on a prepared struct cred.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/user_namespace.h |  7 +++++++
 kernel/user_namespace.c        | 12 ++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index b4a50edfe003..ecee91aa2257 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -182,6 +182,7 @@ static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
 }
 
 extern int create_user_ns(struct cred *new);
+int install_user_ns_cred(struct cred *cred, struct user_namespace *user_ns);
 extern int unshare_userns(unsigned long unshare_flags, struct cred **new_cred);
 extern void __put_user_ns(struct user_namespace *ns);
 
@@ -224,6 +225,12 @@ static inline int create_user_ns(struct cred *new)
 	return -EINVAL;
 }
 
+static inline int install_user_ns_cred(struct cred *cred,
+				       struct user_namespace *user_ns)
+{
+	return -EINVAL;
+}
+
 static inline int unshare_userns(unsigned long unshare_flags,
 				 struct cred **new_cred)
 {
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index e151ffc1f708..4a8a2ea67ddb 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -1631,6 +1631,13 @@ static void userns_put(struct ns_common *ns)
 	put_user_ns(to_user_ns(ns));
 }
 
+int install_user_ns_cred(struct cred *cred, struct user_namespace *user_ns)
+{
+	put_user_ns(cred->user_ns);
+	set_cred_user_ns(cred, get_user_ns(user_ns));
+	return set_cred_ucounts(cred);
+}
+
 static int userns_install(struct nsset *nsset, struct ns_common *ns)
 {
 	struct user_namespace *user_ns = to_user_ns(ns);
@@ -1656,10 +1663,7 @@ static int userns_install(struct nsset *nsset, struct ns_common *ns)
 	if (!cred)
 		return -EINVAL;
 
-	put_user_ns(cred->user_ns);
-	set_cred_user_ns(cred, get_user_ns(user_ns));
-
-	if (set_cred_ucounts(cred) < 0)
+	if (install_user_ns_cred(cred, user_ns) < 0)
 		return -EINVAL;
 
 	return 0;
-- 
2.47.3

