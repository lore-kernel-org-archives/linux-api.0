Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795376173;
	b=uBOddxOuhj8vMUDTmGV0ZDiPfIoRM04Uz7CZOmCkfTXXncH3jZMHx7lmwQhdZ0Az2Suf
	 xWvxI7Alt6iQLeDr0ZfxdAb6rdsWmUddbWNxWtvbGJSdtw4jkI/NncMDApx5bqtyBWhBk
	 XcZI8rBcHeixVBsUWd9uKuiq3Y+hCI3TErjSOQMbWQuFZgEibrGI3P61ja68Ogq4pj1WN
	 esMcoCUMes6zA9mMe34kmoA4UOxVx5RkpYX3sCVwwh2zzVnMeGb5/uukmCEc20PCwbN0n
	 BQBFykZWm+OpID9rHhIRIRTIohsAqGf0Z7+FDnkkl8n7nyHQ94vZdHnTOck8Ekpe6zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795376173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=vM1mKrQLSyzANBNyG1aKfJTP501fkwwz9TXQLi7bGuQ=;
	b=s0H3D5pU8VAOPt5p+syq3G1EZIdKU6N/y4Xzbab9FM6qGnrV5sYgsiNx6RU4krsJJ/NB
	 Aa1f3SGdZ5C/QGUHOt58M7ohuYVDrtqCXG1IPTrYHOJYwaw4RRu4lTxdJ3glmu5VPACWS
	 fZPuzQ0ORo877BbiPtQcmqK8c8daK5DFXRk+V4nTc47YOnVE9eubKT5QOz5f1Rc+WhLgj
	 /LuunyAnNfw3PWI3arJMCgvJb3HlGHDNDiYRVkr7TGhUQsxbwqeD6Ql/6278bu0RT9jyR
	 2k1l18KBIGeEKwMgHJP3t9RtT9FpLX5icI8oPszAud5/YM6SjxObsDHzKVX0TnifFUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ML3xN9f1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 9C669606A32D;
	Sun, 22 Nov 2026 19:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ML3xN9f1
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AD8231F0093E;
	Sun, 22 Nov 2026 19:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376173;
	bh=vM1mKrQLSyzANBNyG1aKfJTP501fkwwz9TXQLi7bGuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ML3xN9f1NmOT9C4XtO9B3G/pEraSCkk+fGaUGxmfXkMSy6TKIXwr5mJ/3Vb0BQdJx
	 bc4Zgm5HzTPW7ytnpBWX+mvGnJJToKTeHouV6VOQ4K0ixbrEDJTitMQrGpBFHfl/YQ
	 Uupc2uCAxIGiBsYzn50mAhzkLjT7HECBIIA83ovrkQSr1W0+ZEjB4dtS+3WxjZm+DD
	 WUEB8tzZ2u5Ytdu9lYsERqyGEtHbrar1iun2ztFzU6sHSkfUhgdjFFouEhwNv/3QaK
	 mjpaCN5iKa1Kot+n2y5Rwu+az720n6eoCHJuGinUAhRjNbLRwVb6KGTnrvVjvRx6Kj
	 1lk1dgq8Y6CjA==
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
Subject: [RFC PATCH v7 04/26] mount: Add mnt_ns_get_root()
Date: Sun, 22 Nov 2026 21:35:17 +0200
Message-ID: <20261122193539.3334213-5-jarkko@kernel.org>
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

