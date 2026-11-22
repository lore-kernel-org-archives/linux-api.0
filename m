Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795310377;
	b=wRwoi5t1r+yZMU9z/RwumfHfq0s8zqJGYMClEoSYYyQfIYBQSYHCponosZZhs/yXCanz
	 d2/aWra3/P2XlOaNjcsQJnwoAWjibkAa4DCN9v+RilZm1jjINQ06IRMXaS3x2vgr0YnQg
	 BEWS7oYMNkheZ3HfVuEay7JmMPNPuIIWNUe92F1GD58NbmmgYGGULZ7LgF+6Y//6tv77+
	 iLTcZkXevSovoUTai+R6KNwO9ildy/sSNon8aY5n0vEVZYUDV8Yaj0gBGH8eosBCLwckJ
	 8UW00G7GXzibSHKgWX3epjDHNMICrTRNQdMlovDXeDnxmKegH9T9pGCp62hdgBP+TAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795310377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=cgy8beB6sSd/m8AunHL+Exu9SqwXUH4jGUnQFpHNC2g=;
	b=hZeFZ1vtOLwC4xM9XP22slwWGQWfKGNYO4CjzuCJtxKolNxFisT0LPIcFhZnvt8hgX1U
	 aBEtz32iPyrko2gWkwBXPD/0genKf1oEiW/1I7t/G/AVaPDur6Ol2QfsSNZ4YBDRiW/by
	 b0Z65Nr2pcRn4OhZchtBXQFr3kKO8Wmblm4SaPWv8maLrLbUk47Xz015j4JEFKbc8FdF3
	 jUJdHnXmQ1t12lq86zu3UgY5lLw42kCXzG5RemTnuyIoERzkUbZie6EIFutoI12e9uN2l
	 ib4N7ssq8ql3WytzS7jCPpLu7n83kb+HRJsXfcUtmxtYTsZyvzQh0Cv1cZuiPh69yOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GvIMyozx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 4CAEA60A3803;
	Sun, 22 Nov 2026 01:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GvIMyozx
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 391951F000C0;
	Sun, 22 Nov 2026 01:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310376;
	bh=cgy8beB6sSd/m8AunHL+Exu9SqwXUH4jGUnQFpHNC2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GvIMyozxQl2DNpJ+i9/m0l+3o6O48P/fEjSwUWnn82fEfSo57NovKzR3OPVk7A61K
	 XjAJSkujQBHcPPxECwi5KwwTiRDcYlNDu+e1PNBcEBWMtssY6WRX5vBc53NYjAPBEr
	 Tv7asu646lnLsM5ppF4enYZnpOkTBolaRtspxeAAY2+udhoECXMsHuGWYNVgQjAmS1
	 /lOu3eEW0QMsdZpW4L2drbyR2+TIDheT6W6B2Bmd8Hq+T56a0D8kNQVnYjX0Tf8qB/
	 tyBn0oOE47SMzTP0+w8XxAU+oaMGQA7nbju/cU/6dLYbzWWGPsssXYB958t127iwjt
	 0eS6dwhezh+RQ==
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
Subject: [RFC PATCH v6 20/26] ipc/mqueue: Implement ->set_userland() fs_context operation
Date: Sun, 22 Nov 2026 03:18:03 +0200
Message-ID: <20261122011809.2667684-21-jarkko@kernel.org>
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

mqueue_init_fs_context() captures current->nsproxy->ipc_ns and resets
fc->user_ns to ctx->ipc_ns->user_ns, overriding the user namespace
delegated by FSCONFIG_SET_USERLAND and leaving the context bound to the
caller's IPC namespace.

Wire up mqueue_set_userland() to switch ctx->ipc_ns to the target
userland's IPC namespace, update fc->user_ns to match, and mark mqueue
with FS_USERLAND_MOUNT.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 ipc/mqueue.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 322c3dd98c44..f3079f7d888b 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -32,6 +32,7 @@
 #include <linux/mutex.h>
 #include <linux/nsproxy.h>
 #include <linux/pid.h>
+#include <linux/userland.h>
 #include <linux/ipc_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/slab.h>
@@ -400,6 +401,20 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 	return ERR_PTR(ret);
 }
 
+static int mqueue_set_userland(struct fs_context *fc, struct userland *userland)
+{
+	struct mqueue_fs_context *ctx = fc->fs_private;
+	struct ipc_namespace *ipc_ns;
+
+	scoped_guard(spinlock, &userland->lock)
+		ipc_ns = get_ipc_ns(userland->ns->ipc_ns);
+	put_ipc_ns(ctx->ipc_ns);
+	ctx->ipc_ns = ipc_ns;
+	put_user_ns(fc->user_ns);
+	fc->user_ns = get_user_ns(ipc_ns->user_ns);
+	return 0;
+}
+
 static int mqueue_fill_super(struct super_block *sb, struct fs_context *fc)
 {
 	struct inode *inode;
@@ -1613,6 +1628,7 @@ static const struct super_operations mqueue_super_ops = {
 
 static const struct fs_context_operations mqueue_fs_context_ops = {
 	.free		= mqueue_fs_context_free,
+	.set_userland	= mqueue_set_userland,
 	.get_tree	= mqueue_get_tree,
 };
 
@@ -1620,7 +1636,7 @@ static struct file_system_type mqueue_fs_type = {
 	.name			= "mqueue",
 	.init_fs_context	= mqueue_init_fs_context,
 	.kill_sb		= kill_anon_super,
-	.fs_flags		= FS_USERNS_MOUNT,
+	.fs_flags		= FS_USERNS_MOUNT | FS_USERLAND_MOUNT,
 };
 
 int mq_init_ns(struct ipc_namespace *ns)
-- 
2.47.3

