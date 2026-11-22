Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795376191;
	b=F+DuJWRAMpFfSHbXJS+YprQCxkVaekpjaO0NB5EOIfzrOrH14DYuY0Wfur3x+y2fY2uw
	 aE/qQRFK86mDEpm+r4ILY6uafJf6qZuf3OY8IHlzdUJqMEBhzwYNkoRkT3frjToqp7Ter
	 wDflqDQ0hVzCEBmFKOQAVIHBv1odHm4EhEBy52qOBBenFLC6f0uE9R8fUezmr7jdRyIx9
	 G5/8kQ5v8eXbqg/u0XvZbKzfv82DXaclBohKqqgZJy75g++EjfpUJuHZ5WTZopHHB8C1X
	 igMEn1Se2Phh2Mk3NkRlXZsX+daEDGh64IPGDtcHfm+U/pWqBh4q7WgVaxGYyfK/Prw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795376191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=43MsiEFgIrWkQNcNF+GYEjx93qeN3UcnPDjH27vMBMY=;
	b=NjgPFAuP7VX9v/ecV2jOcO6voJMyU921r26ucFJNu+mIo3pZIN8kIhuMfnLGaPqTwE84
	 RkF9Nuk1FwYmer+1dITbirD7DquoKAjqY4s10em8GrUyxQcQvWViZDmfKS0JRbGoe0Xcu
	 1Az4bPwg+RGPBR5v2ZPCQ2VIEzsy42SwTJ7IWduePirdp0GNunmWPUQJ9LGHIKcM7mYI7
	 UbcMBsyddPJvOh0QlBha0/Q12hBQg+8AnJ6k/fr4cmjIoZjxBt7rkDR32DSlZlD5dwFKP
	 PvtABPomWvreciMV3jISxF00iry6ucnH22TmbAq5tohuM3wE2a+k/k3shc63GkQCW2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jx9MYo4v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 383A9606A338;
	Sun, 22 Nov 2026 19:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jx9MYo4v
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1E7691F000D4;
	Sun, 22 Nov 2026 19:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376190;
	bh=43MsiEFgIrWkQNcNF+GYEjx93qeN3UcnPDjH27vMBMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jx9MYo4v5dG6TuiLqqMpwfnCLNp1dU3fsjM0rs7NeUiQpqvCbQkc6zfNZfQn1ceCg
	 dkL6lAYTT/XApYv1EnrG/3bDLes3Ar8rT3NVk6CyizxCjxJOWQr/BQgKMnE4DozfXc
	 6MaZrPMCQKrw6XbZAf3J55qgj9MKKx8nvfOUvGoHcJ7/8yOdGVy1JssCARbZmF8vek
	 6kxEG95kGAihkM4HDqZ8n1mTcg/lmo4gtW2J8GayVKr+sLDzrsuUuDCALp/vF2d+2v
	 BPUR0GZ3wJ2zZz8SvSCUOuV/4ea/j5aB9DkmJvEGCqfWbjjKoyCZJsHY54JfZejPWu
	 dmVhu9cXx73XQ==
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
Subject: [RFC PATCH v7 08/26] userns: Factor out install_user_ns_cred()
Date: Sun, 22 Nov 2026 21:35:21 +0200
Message-ID: <20261122193539.3334213-9-jarkko@kernel.org>
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
index 61dcf2fab6f0..218ea4e73006 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -1613,6 +1613,13 @@ static void userns_put(struct ns_common *ns)
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
@@ -1638,10 +1645,7 @@ static int userns_install(struct nsset *nsset, struct ns_common *ns)
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

