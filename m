Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795219818;
	b=0MvDvinrjC2NZogSUCkJoO5q0Kd+siux/q76PQDmQTzt/3U/kSo7fpBy7rnZ6EQH6di9
	 wOZwxrUPupIee3gaNby0qkcuGYVaFyNiPwYUiXuUusW/9LZ8lrOkHBwrK8nMw811Kx96e
	 O6o3vdHOsMQWYQ/9Y6omlHj208ih5AdpBUB7Lk5SS3XcKK6gKqa0MXbpaAb6MOiBjc9KD
	 io2wmJ9NUp06ixsjMqVrglbu3Up53dM3y3H8JQWtedzC68geaHHJCjEmwmWuvijvgJ0B9
	 avtPC2s+uhkBzwFLyeeoKferCExyLegNsNlEDUSORvZ44xGeAa7DpVtQUIVQ/l7RxUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795219818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=keQHOqhbQzKnskPEephNWpQJ2+gEr/C+/pBH6fJD4Uk=;
	b=JzO+VUody/iQ59SQQI7IinKgHfLtfOfsKzagH/zYira1IoyALFgxmZ/dupmf0S25CXNq
	 gfz3QQauRE57+76FH652q25cVIRbyz7ZYtUZPGb9QX61LroVi0Yr3OkDOSibTb85fLDRs
	 OEuKoOkj+AjC0pSyMjLQaRg870xmb9OcD006geiYLmH7SNAIn1J8G8LIWc0MbBtS3EcTd
	 yjcP+KztjreeuToeGCo/OMCCDFNaVaTSWggYt6bCiuATJx6Rct2xDxhRJEOFNGBQOTvCG
	 6sMUM06DlHx0OZv/gT523EE45drdo2qsbflt33Se9qqSOLH6aq03keAz28qy2U2+nkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hCUdNbCW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3602E606BA92;
	Sat, 21 Nov 2026 00:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hCUdNbCW
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EC7FC1F000D2;
	Sat, 21 Nov 2026 00:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219817;
	bh=keQHOqhbQzKnskPEephNWpQJ2+gEr/C+/pBH6fJD4Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hCUdNbCWHBgRryTU5nu551za3xRW0gezc5OnTNZCeYNqM9wRJ/NsAbAG+VMQ80fFc
	 uoQohgRLiSlksCc/Z8OXAbokvEzSj2xFDa8SHwHcHhFa9Mn4xhv1Gww7/2oW4JGL/D
	 I/qlCZrwdXviGnAWdDkBva0/NKmT2NxDqQbqnlGKCmc2i86RdFVhnvMh9gbxbtOdja
	 oyVx0Mgr/BwtKtQ0XfHqiIFV9uqT7kXGDt1GJ6f5Y1qpPeuWjr4cktfc+tNAvXZLSo
	 ArIrP3F4dln8owvw8NahPBsy34x8S7IbeE6gBha8FZ0lmJqFEy+A5PAviI8Yv13P4v
	 viHdX3QpRHJkw==
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
Subject: [RFC PATCH v5 19/25] ipc/mqueue: Implement ->set_rootns() fs_context operation
Date: Sat, 21 Nov 2026 02:08:38 +0200
Message-ID: <20261121000844.1863324-20-jarkko@kernel.org>
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

mqueue_init_fs_context() captures current->nsproxy->ipc_ns and resets
fc->user_ns to ctx->ipc_ns->user_ns, overriding the user namespace
delegated by FSCONFIG_SET_ROOTNS and leaving the context bound to the
caller's IPC namespace.

Wire up mqueue_set_rootns() to switch ctx->ipc_ns to the target root
namespace's IPC namespace and update fc->user_ns to match.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 ipc/mqueue.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 322c3dd98c44..f94e9b566bd0 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -32,6 +32,7 @@
 #include <linux/mutex.h>
 #include <linux/nsproxy.h>
 #include <linux/pid.h>
+#include <linux/rootns.h>
 #include <linux/ipc_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/slab.h>
@@ -400,6 +401,17 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 	return ERR_PTR(ret);
 }
 
+static int mqueue_set_rootns(struct fs_context *fc, struct rootns *rootns)
+{
+	struct mqueue_fs_context *ctx = fc->fs_private;
+
+	put_ipc_ns(ctx->ipc_ns);
+	ctx->ipc_ns = get_ipc_ns(rootns->ns->ipc_ns);
+	put_user_ns(fc->user_ns);
+	fc->user_ns = get_user_ns(ctx->ipc_ns->user_ns);
+	return 0;
+}
+
 static int mqueue_fill_super(struct super_block *sb, struct fs_context *fc)
 {
 	struct inode *inode;
@@ -1613,6 +1625,7 @@ static const struct super_operations mqueue_super_ops = {
 
 static const struct fs_context_operations mqueue_fs_context_ops = {
 	.free		= mqueue_fs_context_free,
+	.set_rootns	= mqueue_set_rootns,
 	.get_tree	= mqueue_get_tree,
 };
 
-- 
2.47.3

