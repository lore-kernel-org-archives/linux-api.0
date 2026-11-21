Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795219752;
	b=pX19IwqSSnXI8/UImmuZgRP0zp/MJQ9JoA3eMpyl8/+pM7/dbh5sqUz7/MakmtvWqSbg
	 67npcpUytc7+fsLXtERo7PUYaKC3bOBlgrotsraUC5Xva/esvSMd6bCLbJzU7oaZXJZU6
	 +V2tBAvH3/dAaWvSCVrkldfLjgUdFHFJLKQdy3Grc6RIns3lYCgz0hGv/i4P94l/BFt6d
	 1eS5yy1/YB8rjLlAywqoaE1/fCEVYP6zscu1RxMy3LXX8JSIPpVAZvU5MjW7RS05K5Zcy
	 cjh3gpSAMQRgZAdid4Wo6HgHpIpXtADipcf34Rt/yZ9IucZbHBPkO6IBNaMnkmNgr0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795219752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=vM1mKrQLSyzANBNyG1aKfJTP501fkwwz9TXQLi7bGuQ=;
	b=OsTvvCDErDf8oaupHIuqC9EFuKKbMu80buJ354KOrii+SJbjUHnUDzwClG15iCiKQm5B
	 iOY1EsKUEWttCTCppd6Q8GyacLbWvsw9U4MZYVqMNRug7D0eG/2BKLiG34S2214j/7Y0i
	 ynO8+3l7hnmpIZh75fIXK3fRqulK/3ximSMzHAk28tS9PRMr1gG/GRa87aN5AIMdKVgkr
	 6gXt/wwRW5xcq7bLDoYeJg5NskvICObyeqp8DUfdZOi1+tOFXAv/hBUjTMJmu6RHxIy02
	 Y9dG7kI6eb4B8uh0j1/qvTbk/SXiP5YzcllSGxHkgXn4zKY6LSTyNqnIiqM0s2ierLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RA5vIfKQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 60428606A6AD;
	Sat, 21 Nov 2026 00:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RA5vIfKQ
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8C46F1F000E0;
	Sat, 21 Nov 2026 00:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219752;
	bh=vM1mKrQLSyzANBNyG1aKfJTP501fkwwz9TXQLi7bGuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RA5vIfKQzINb0NmwFIcU196DEhLa8CEsZmgc4YEKIRIxvuH8traSIVpbLRoke0UNW
	 tBNIUaVWa2z16E0yzA2TbuKe9Dr99uU2BuJn4+YJeLtNb4ptdsmR8iACUIpzwHGjDw
	 ADc1+fp/GjRTAbjfbbISTHLI5l61tBvyZP8A9kfp5ET4fbDhjzozSllLTyKTx/4/7v
	 4QuxUZb0PVU6bKfBCBVUkxxmtmMFjoXaTWhSCZCcG5U7rMoIIgTx3SKe8ZfZKqD4/p
	 YptaHIjyJBjkxcDxySHp+6pL8eUgvFJlhGP9x2qGBjVazwwRzxsk41CIf4neCjnaIo
	 c1dEweQGzro2w==
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
Subject: [RFC PATCH v5 04/25] mount: Add mnt_ns_get_root()
Date: Sat, 21 Nov 2026 02:08:23 +0200
Message-ID: <20261121000844.1863324-5-jarkko@kernel.org>
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

Empty mount namespaces created with CLONE_EMPTY_MNTNS start with only an
internal nullfs root mount until a real root filesystem is mounted over
it, and external callers have no helper to resolve the live root path of
an unentered mount namespace.

Add mnt_ns_get_root() to look up "/" with LOOKUP_DOWN from the mount
namespace's base root mount and return -ENOENT if no filesystem has been
mounted over the initial nullfs root yet.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/namespace.c                | 16 ++++++++++++++++
 include/linux/mnt_namespace.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index aecd05ac0170..781380945d78 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -6708,6 +6708,22 @@ static void mntns_put(struct ns_common *ns)
 	put_mnt_ns(to_mnt_ns(ns));
 }
 
+int mnt_ns_get_root(struct mnt_namespace *mnt_ns, struct path *root)
+{
+	int err;
+
+	err = vfs_path_lookup(mnt_ns->root->mnt.mnt_root, &mnt_ns->root->mnt,
+			      "/", LOOKUP_DOWN, root);
+	if (err)
+		return err;
+	if (root->mnt == &mnt_ns->root->mnt) {
+		path_put(root);
+		*root = (struct path){};
+		return -ENOENT;
+	}
+	return 0;
+}
+
 static int mntns_install(struct nsset *nsset, struct ns_common *ns)
 {
 	struct nsproxy *nsproxy = nsset->nsproxy;
diff --git a/include/linux/mnt_namespace.h b/include/linux/mnt_namespace.h
index 0acd1089d149..98188d1f7428 100644
--- a/include/linux/mnt_namespace.h
+++ b/include/linux/mnt_namespace.h
@@ -8,6 +8,7 @@
 
 struct mnt_namespace;
 struct fs_struct;
+struct path;
 struct user_namespace;
 struct ns_common;
 
@@ -15,6 +16,7 @@ extern struct mnt_namespace init_mnt_ns;
 
 extern struct mnt_namespace *copy_mnt_ns(u64, struct mnt_namespace *,
 		struct user_namespace *, struct fs_struct *);
+int mnt_ns_get_root(struct mnt_namespace *mnt_ns, struct path *root);
 extern void put_mnt_ns(struct mnt_namespace *ns);
 DEFINE_FREE(put_mnt_ns, struct mnt_namespace *, if (!IS_ERR_OR_NULL(_T)) put_mnt_ns(_T))
 extern struct ns_common *from_mnt_ns(struct mnt_namespace *);
-- 
2.47.3

