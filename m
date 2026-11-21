Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795219769;
	b=yr87sYZLlYUdIiZbnYyfiwDZAqErs/NrBaPU/3GzlUQ6w76NtTahATQtLLj4nTzR530o
	 eKZFyIqjaZbvY3MlFASZNy6LBMspKhVwhF3t7ne7lU331yEZkuKauJl90P+EAybMLklGp
	 6FVmM3QODWvxWwkT1eQTSl+nkkOr5cTq2ERuAv8xiMYackmlAjrUiy9ggH5zGCCHyE7VK
	 /vXIcd/MktE4Pe1jx/e6wptfpe5JVH4gt8vqjDQAx46+Xydt79yAY1iC9RneJ0/AGRjl1
	 aRORSJg9aSyPiMCQHKpmaCe8pPKpt7iLSqCTGe/htcrQIzUZ8+3bPd5UlGYFxoZwxvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795219769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=QAqFmScxDK96ARrPMkdYt6ltTuR2f/mUkkm/Cf8C8SA=;
	b=cb0NCu0G56hV2sYR/e08hjupzxJccPI0ijmZtbse9sT8fQ6ACgYH5nv9AHV05cqu6RSo
	 zYMCyzOS+yUYAkWzXpLmCtOkZ1saFbGMtsHX0BWh9VEiltH32x2W/HfYXGC7O4ZgFlvw4
	 1tbgy0bLAe4dJUWhjFlr+q1Py68smWEfQsdgBzteYd72zcDbU+E/ZHGR6KjRj3Uuo2bt7
	 mB7rya+zKPCRoS6FIUM/RdNgJ5Ttg94UA55XhoioBOcc7rcwoDF0ZJXPuyFh/NPglxrPJ
	 njURQgBvotQ40okqUb72h8xoDSG1B+FZHZJRfzf5iADzxw74L0DwG+SwgpbsKpa7llA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PjkwYkKd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B55A4606A695;
	Sat, 21 Nov 2026 00:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PjkwYkKd
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 999771F000F0;
	Sat, 21 Nov 2026 00:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219769;
	bh=QAqFmScxDK96ARrPMkdYt6ltTuR2f/mUkkm/Cf8C8SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PjkwYkKdZWa+FpnkuNj9WLihIAT8nxjelhtP8KteYzyEZzcTjBsf2OisnnyMG6tGY
	 QAHoa48bYCuqQz0VDKOTj9nKmMYLKckqWx+bGkMzJy9/CCAehLARI6jDFOS6fkW9va
	 k7PN8OgZ+OrfV9jQovdEyPZbxEZ4+zO/I0/GSVzMnlNssJyniwlZuurB3kjJbDV+tk
	 r40I/gT/wAMqhGqxL4XqL1ay693kqSK++3z4BC4nujf+MC/JFpepQrchSnAHpCWt0a
	 mlyMSXy9N/DKAW5+SGI1/m/LToFbGlsIr6msn1XPYnXuy/NzEEV1++n6OaWkdpoRKC
	 5asuyRqrYhKxQ==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v5 08/25] userns: Factor out install_user_ns_cred()
Date: Sat, 21 Nov 2026 02:08:27 +0200
Message-ID: <20261121000844.1863324-9-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
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
index 91232053775d..3600a903442e 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -184,6 +184,7 @@ static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
 }
 
 extern int create_user_ns(struct cred *new);
+int install_user_ns_cred(struct cred *cred, struct user_namespace *user_ns);
 extern int unshare_userns(unsigned long unshare_flags, struct cred **new_cred);
 extern void __put_user_ns(struct user_namespace *ns);
 
@@ -226,6 +227,12 @@ static inline int create_user_ns(struct cred *new)
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
index d7f2cad388c8..4cf5d802032c 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -1632,6 +1632,13 @@ static void userns_put(struct ns_common *ns)
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
@@ -1657,10 +1664,7 @@ static int userns_install(struct nsset *nsset, struct ns_common *ns)
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

