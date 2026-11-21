Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795219813;
	b=al/OdLc3HFJUn2Yy33XyLh9FX5s2bXvKzGrF7zScBgwr37oNmRHXG1pAv4xiNqrwpP9H
	 CLjj7cU8a1S/qiMIUeffzhOrsic3qi0/ftWXKpfcAsM21hO0IF/fcZQcz35T8eRS5w/zo
	 +9odD5Erw/REafkd00jYFzaMhYSlf3wmm9lCwkQ9BEB4a1YEwOYl2k8J9GStr5tRNommx
	 gZOFLzx4fRGZ+M8dmk3sbboVQSFaVhmpj0k7QMoSpU9aVCsj4bc23tleQnHcNBnBd1j8l
	 QrIQZx1WAo2s12it1J4oa9LY6buC0qa65N2dAEKnzbwD5VZNKpZkwUjt9I4LGh4t2hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795219813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=yqfEnWFETbmbQSAYIEm1u3Lu6ctO7/ZcmaZ3U4EI6KI=;
	b=YlSeAtOPI8yq3VJkbNLHHrQbjZg3d+hIBE1xd3Ptf8kOfGwqZ0Usj7KqTjLWoQt5OO/y
	 owmbZzM/qihIXhLTizVmGgvnXI0ylv1xEWxbWFKr94AXjFmzut/Q001VZxbfoZySdh0C6
	 zOaVJ/mzCP8c1N2ixp4vZSjc2kYwqHYGxNWSeHsItPGqXpYlPuPTOznJij9uJKB3jGR1Z
	 hEPq+HuZgS7wD/WZVlQqe6eNEyzsy479HKIreWaFlbimPu2tlD33KX1LKbzBUZVR3gEI1
	 p3bzd5hetTF3d8B9+RZJHg0CzPjiGzQ7zTOUURlpOAvsxTfDLUv4TCgl4NgC6LaBF4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PfLEaZMk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 7576F60A3835;
	Sat, 21 Nov 2026 00:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PfLEaZMk
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9E8971F000CA;
	Sat, 21 Nov 2026 00:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219813;
	bh=yqfEnWFETbmbQSAYIEm1u3Lu6ctO7/ZcmaZ3U4EI6KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PfLEaZMk2QFj36evDxl3k1fnD+CD+VA6Vsnq2kjvgAfxg06Pb861t+pQVRmkQVDYO
	 1sdYvwiIUk+goQzVebUrpINkVMoGEAUMXDrt29X8HwKyc+1oiBAYwrGSkNAr++i8pe
	 8RZVkAJSI46+nj0Q1+ZnlWauiSZsXeQRem+HKa3HxR0jpUhiUOsUJbgcB6/ZZrFDI8
	 77qSlfwFBb5Vvt9v70DMzx6Z/v1p8BW0ko2egGIOaVZYXlnGGdVHse9LwsE84FlPZZ
	 uv2TEt4sDBgrv2CY0MVZcu2kgnVWdam6Abt57m99cHBej9vMpuSTe5EnOEwDAUJOfi
	 AmrxY/sUZEy2A==
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
Subject: [RFC PATCH v5 18/25] proc: Implement ->set_rootns() fs_context operation
Date: Sat, 21 Nov 2026 02:08:37 +0200
Message-ID: <20261121000844.1863324-19-jarkko@kernel.org>
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

proc_init_fs_context() binds ctx->pid_ns to task_active_pid_ns(current)
and resets fc->user_ns to ctx->pid_ns->user_ns, overriding the user
namespace delegated by FSCONFIG_SET_ROOTNS and leaving the context
attached to the caller's PID namespace.

Wire up proc_set_rootns() to verify that the target root namespace's PID
namespace is a descendant of the caller's active PID namespace and
rebind ctx->pid_ns and fc->user_ns accordingly.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/proc/root.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/proc/root.c b/fs/proc/root.c
index 7fbbe92bf73a..8d2b9bbfa1c1 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -15,6 +15,8 @@
 #include <linux/sched/stat.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
+#include <linux/nsproxy.h>
+#include <linux/rootns.h>
 #include <linux/user_namespace.h>
 #include <linux/fs_context.h>
 #include <linux/mount.h>
@@ -206,6 +208,10 @@ static int proc_parse_param(struct fs_context *fc, struct fs_parameter *param)
 			errorfc(fc, "cannot reconfigure pidns for existing procfs");
 			return -EBUSY;
 		}
+		if (fc->rootns_bound) {
+			errorfc(fc, "cannot override pidns on rootns-bound procfs");
+			return -EBUSY;
+		}
 		err = proc_parse_pidns_param(fc, param, &result);
 		if (err)
 			return err;
@@ -323,6 +329,21 @@ static int proc_get_tree(struct fs_context *fc)
 	return get_tree_nodev(fc, proc_fill_super);
 }
 
+static int proc_set_rootns(struct fs_context *fc, struct rootns *rootns)
+{
+	struct proc_fs_context *ctx = fc->fs_private;
+	struct pid_namespace *target = rootns->ns->pid_ns_for_children;
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
+	.set_rootns	= proc_set_rootns,
 	.get_tree	= proc_get_tree,
 	.reconfigure	= proc_reconfigure,
 };
-- 
2.47.3

