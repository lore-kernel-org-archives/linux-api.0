Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795310373;
	b=iNEBRVMZvQk4OEPuHGBu3LvHWOYr4i0H8whdvzUrNYBmICkyfpDG+t+e973eJxeRxQFh
	 TtPiNmktJTEmVeU4y/hrJ6ERqtxGwphC8egZ/cJLpfeI+gwdU/eCiVsZMuKn+wm+pSXwM
	 2MFkejXuELSSupDKCer+bY9vEPbkItN7BFzvjhwcl1UlDsF2H/2cXoOES0tzp1+Bt69yW
	 lMFmcUq2t+p/cenF9i9VakwZmlebeR/w+PT2a2lBoRySoy8Qqab+shDob+yxYcJl/Y+rS
	 +30mg2JB79i1lURdUuiczU3JIP7gMsls1peTcKNKV/hcm7P6QhXitNp1/6ChZjVv+Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795310373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Jfv3MMg/O7UN8A+W1NHYimNXqqAkPIDpKwh6yDT3Yps=;
	b=JkKYYbGpnrZC1TdAmwx7tL2CeSqYeCPxW0rW7hq/AtTbVZD2OHw3CO979tUWIk48l3/h
	 RpNS5oHZF13ACEueP7IdnC/1+r1nA555aQwcCBRqNmVlL6gRNxnN4p3dVeB/sUdnkoadS
	 8PVUss52uk/9NewpzX1o63kzvnbmnhqhDZBIG0peOf1L4205zlwU81Dui63GQ5mWxpYto
	 tdoZBQC3w/dU1itZb9SQw0R+QaNdx6l+HTaKWl0IfN6tHO6GwEvQMuILmsLcrfznyXFUb
	 jiHP+TjzIFeRmg/l8uB05sJyCuV6Keu4aKv/WZKd3GSTPc+/6XlZwSI1DCDs//PUJBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ImYiBKVg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 6B65F606A6A7;
	Sun, 22 Nov 2026 01:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ImYiBKVg
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5D51E1F000D2;
	Sun, 22 Nov 2026 01:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310373;
	bh=Jfv3MMg/O7UN8A+W1NHYimNXqqAkPIDpKwh6yDT3Yps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ImYiBKVgbRfrgL6jWXxTiUQHqd1cEEzMz2iVAaA7uEeHzW4qLJDA3Tl2qGS/3utjZ
	 vH7FISh1UNPnyMNohDOGsom9ecspAClJKjNoOgplVjFIsRGrEtSBmfapZMPNZamQq1
	 stUP1vhyNg00QuEzC+Jcgt2GhFZBIdc80ERycGmeMUXDpAmT50+jxrbLIMCBdrfeT1
	 XI0TeGu0qJq904zZAMgLfpGW7w7+4+QruOgSA3OppYd/eN9giTW4jPDn8h0/uv9QAm
	 QkM/4NCJvGUQ2s+gGjCFYdooaAGbB7nkU9acbTLeYRCVyAXFKHeGUxZZBRobdO4d5l
	 N7vc71l/mwM4w==
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
Subject: [RFC PATCH v6 19/26] proc: Implement ->set_userland() fs_context operation
Date: Sun, 22 Nov 2026 03:18:02 +0200
Message-ID: <20261122011809.2667684-20-jarkko@kernel.org>
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

proc_init_fs_context() binds ctx->pid_ns to task_active_pid_ns(current)
and resets fc->user_ns to ctx->pid_ns->user_ns, overriding the user
namespace delegated by FSCONFIG_SET_USERLAND and leaving the context
attached to the caller's PID namespace.

Wire up proc_set_userland() to verify that the target userland's PID
namespace is a descendant of the caller's active PID namespace and
rebind ctx->pid_ns and fc->user_ns accordingly, and mark proc with
FS_USERLAND_MOUNT.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/proc/root.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/proc/root.c b/fs/proc/root.c
index 7fbbe92bf73a..e61b1a559172 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -15,6 +15,8 @@
 #include <linux/sched/stat.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
+#include <linux/nsproxy.h>
+#include <linux/userland.h>
 #include <linux/user_namespace.h>
 #include <linux/fs_context.h>
 #include <linux/mount.h>
@@ -206,6 +208,10 @@ static int proc_parse_param(struct fs_context *fc, struct fs_parameter *param)
 			errorfc(fc, "cannot reconfigure pidns for existing procfs");
 			return -EBUSY;
 		}
+		if (fc->userland_bound) {
+			errorfc(fc, "cannot override pidns on userland-bound procfs");
+			return -EBUSY;
+		}
 		err = proc_parse_pidns_param(fc, param, &result);
 		if (err)
 			return err;
@@ -323,6 +329,21 @@ static int proc_get_tree(struct fs_context *fc)
 	return get_tree_nodev(fc, proc_fill_super);
 }
 
+static int proc_set_userland(struct fs_context *fc, struct userland *userland)
+{
+	struct proc_fs_context *ctx = fc->fs_private;
+	struct pid_namespace *target = userland->ns->pid_ns_for_children;
+
+	if (!pidns_is_ancestor(target, task_active_pid_ns(current)))
+		return invalfc(fc, "cannot set pidns to non-descendant pidns");
+
+	put_pid_ns(ctx->pid_ns);
+	ctx->pid_ns = get_pid_ns(target);
+	put_user_ns(fc->user_ns);
+	fc->user_ns = get_user_ns(ctx->pid_ns->user_ns);
+	return 0;
+}
+
 static void proc_fs_context_free(struct fs_context *fc)
 {
 	struct proc_fs_context *ctx = fc->fs_private;
@@ -334,6 +355,7 @@ static void proc_fs_context_free(struct fs_context *fc)
 static const struct fs_context_operations proc_fs_context_ops = {
 	.free		= proc_fs_context_free,
 	.parse_param	= proc_parse_param,
+	.set_userland	= proc_set_userland,
 	.get_tree	= proc_get_tree,
 	.reconfigure	= proc_reconfigure,
 };
@@ -371,7 +393,9 @@ static struct file_system_type proc_fs_type = {
 	.init_fs_context	= proc_init_fs_context,
 	.parameters		= proc_fs_parameters,
 	.kill_sb		= proc_kill_sb,
-	.fs_flags		= FS_USERNS_MOUNT | FS_USERNS_MOUNT_RESTRICTED | FS_DISALLOW_NOTIFY_PERM,
+	.fs_flags		= FS_USERNS_MOUNT | FS_USERLAND_MOUNT |
+				  FS_USERNS_MOUNT_RESTRICTED |
+				  FS_DISALLOW_NOTIFY_PERM,
 };
 
 void __init proc_root_init(void)
-- 
2.47.3

