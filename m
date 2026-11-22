Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795310315;
	b=tYbdMxAN7ien2SZkpSjSWhorIu7XspZy0z5poF5hcLxBep4OGVygScxbJ97LBrvBkO17
	 NUD+0HbDD0Zdjek+GRgJUxKAbL5V2QFB/KrJMK0oINHKODpHCxSP/M0fqqyH9HHQ9fF6W
	 q6DODFbihsFcNNiF/q4HXInWoSQfX7q6XJ3PVJabvOw0QGGXfjeBoRr5a2Wb0atfn5uet
	 l98kWH88PDbyuIA8J4cXZWOZ1+2tMaV2cb4VvWtsReQMLNA5e7F5vw/1pDPM4lvkHJaQb
	 WkryCHjTmd6gRNRYQ5+SebHmycnUI2OEdofNdS/IIll88i1vSg8FDjJFCh+GkytTW6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795310315;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=vM1mKrQLSyzANBNyG1aKfJTP501fkwwz9TXQLi7bGuQ=;
	b=1wGwEnNf6UlLIj3TDuOY5uvnIIJtOyJOSX89KuU9YfhGh/il2nTg2FrJFjcEgj5o2N/b
	 ObDBJNSLM7aa80ZFSerFcZJpTkaDS80wv9AVcFzl8mn2neC/JvnnpBz7TcouWmksrGORI
	 3q+a9/InkYwKJjyTjxxgd8BNHdbYGlAPbJowPpzEUjwox7ZYQL5CBs/C/DzOY9d6iwokP
	 VdQw5Fd/aqXPQTtkSn5RC/jCigZ6gBqQlZO4pArscOks6v05wU43oc9PW5+3vhcDBdkuV
	 CW1MYt9sfUCIiHXgmu5OHmYYSOSozGXZ0TWh9lqOMXl8YiRK+5djjEu8HORX0nXiR+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iVfzBuYl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 6B40D606A32C;
	Sun, 22 Nov 2026 01:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iVfzBuYl
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 537E11F000C0;
	Sun, 22 Nov 2026 01:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310315;
	bh=vM1mKrQLSyzANBNyG1aKfJTP501fkwwz9TXQLi7bGuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iVfzBuYl9D5EBPT4RUFYpdPXpt9xaEmzAk8iNSi3aHEVx0ty4J0tWRQaLEXFojX+t
	 JITv1qQ0mH7a4uMK4X9x3tf7ZAYfr/OcZ8IZJgGYGCeIL8zMeFPqBYvdUbFlOTGs7v
	 IBFX+bLKTFOyKKNRSJpg9qROz3I322jsgCLg1l6aivdJl78o6k17Q+xI9YcBVAsv2W
	 BT/lpVDAofPBfRN973YskRwER2LF2hilLpbaCp/58nYiVsSzE+UorBYbqlJ5ScenuI
	 JVzqiK/VGwCFs3WBI6Nd47ozM9A6ALKSH/3jgsri7hUZljkUdalZ7Va5FpbhKtVJ3c
	 cyqt5wPhz1Qyg==
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
Subject: [RFC PATCH v6 04/26] mount: Add mnt_ns_get_root()
Date: Sun, 22 Nov 2026 03:17:47 +0200
Message-ID: <20261122011809.2667684-5-jarkko@kernel.org>
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

