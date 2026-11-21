Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795219774;
	b=kBNqSKTZmPB83hwggG2a3ao45I+Ly8oM25NiFhz0RCcOdfzuFuBBryfJlRMOiMGCB5Lf
	 AZTv77eMMnxivz+mYNH8mbjAVysMuYqLr91VlH0266HToe92izQxko/svSiEOexXvfi1X
	 5QZeHj6Swf1egEeI8JHztz/Cq46uOoKhswVWSPdRZQQ9Lo/javSAkdXf/aCeGAHLCUJxB
	 uQpR0a7fwL1TOXtxoVfx2oLO/PeV3J2M+QCjWTJvglp2cCb2MRzZW0VADrlTlb78ZdrG6
	 o6e+cL4OZmlyx2oRlkKoqjxlOqUzbisuv+iSsIvYojDGav+VrBz5b2GfLA0ZTR/AH6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795219774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=HzREVgEBs+NJFPQiDqKMMmGwcM3JLTD/1v4USFGXPBU=;
	b=rnRb8ImLf4+W6oH8MtT+OhNeH9YVq4iL9v2ETQSTUfLLePnX24cUZPK/hnGsjy2BPg2k
	 bi5GfIvjHtDmQ/Jg2oJgSRpOiQGZcl/Gbhhwvt2DwbOGGa36kz4aT5O2rUkk414B3GyRN
	 8ALbnAfiWednZi9XIJKYQQf6D1ZLC5fI4bbZH6yGmmae2cTfFyirrcYZ5wqDJtLWSSTP9
	 EKP7rS3xD5R7y8XWgPKb3dLJ93h+rrGZYRgxdaLlv5H2BlLLngv4zrms2JEwEKt75ymko
	 /Rp+Dm7SFgE0Scihq8oetc/Kgrvph9SquJFzCtEjtHK/BbFoTv9RMqyBY4TUpmEpldg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JCCENwSk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 01A9A60A2607;
	Sat, 21 Nov 2026 00:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JCCENwSk
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9811F1F000D0;
	Sat, 21 Nov 2026 00:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219773;
	bh=HzREVgEBs+NJFPQiDqKMMmGwcM3JLTD/1v4USFGXPBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JCCENwSkL59f6V0Kx69Qk+VVb3g8rAVMeE2yN7DMvOVdI3qNLKt/N3cwzDjoZa85w
	 ZHp2z52rZDTrLMuw9QsGYjukfEsZtx2Cum5KZp+IGmhUnnC1eCz3c41IhX8mLg0qAi
	 qsU9OOWGo3atwfdHG4ZJGae0XxAZpZeK7gVXyvhp9ei5148vQtimv5qMkNPuYiOYpK
	 haZKyouOH3HEeqQ6rvijeje88OML2y+Ft/JYMaNBYQ5KivfkjTimg5JaJsrbYr1EjX
	 J4IEIKPHiyaxvHbkByw8//0hOs7KHgQhdOAZV3/AEmRdpIn1VBJKYt80G61U7W6Bcl
	 bFu0u6P9anbrQ==
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
Subject: [RFC PATCH v5 09/25] nsfs: Add nsproxy_open_namespace()
Date: Sat, 21 Nov 2026 02:08:28 +0200
Message-ID: <20261121000844.1863324-10-jarkko@kernel.org>
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

Opening nsfs file descriptors currently operates on a live task via
procfs or pidfs, preventing callers that own a detached struct nsproxy
and struct user_namespace from opening member namespace file descriptors
directly.

Add nsproxy_open_namespace() to take a passive reference on the
requested namespace type (CLONE_NEWNS, CLONE_NEWCGROUP, CLONE_NEWUTS,
CLONE_NEWIPC, CLONE_NEWUSER, CLONE_NEWPID, CLONE_NEWNET, or
CLONE_NEWTIME) from a supplied nsproxy and user_ns pair and return an
nsfs file descriptor via open_namespace().

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/nsfs.c            | 64 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/nsfs.h |  2 ++
 2 files changed, 66 insertions(+)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 8179d69da038..1de51cd47508 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -711,3 +711,67 @@ void nsproxy_ns_active_put(struct nsproxy *ns)
 	ns_ref_active_put(ns->time_ns);
 	ns_ref_active_put(ns->time_ns_for_children);
 }
+
+int nsproxy_open_namespace(struct nsproxy *nsp, struct user_namespace *user_ns,
+			   unsigned long nstype)
+{
+	struct ns_common *ns = NULL;
+
+	switch (nstype) {
+	case CLONE_NEWNS:
+		if (ns_ref_get(nsp->mnt_ns))
+			ns = to_ns_common(nsp->mnt_ns);
+		break;
+#ifdef CONFIG_CGROUPS
+	case CLONE_NEWCGROUP:
+		if (ns_ref_get(nsp->cgroup_ns))
+			ns = to_ns_common(nsp->cgroup_ns);
+		break;
+#endif
+#ifdef CONFIG_UTS_NS
+	case CLONE_NEWUTS:
+		if (ns_ref_get(nsp->uts_ns))
+			ns = to_ns_common(nsp->uts_ns);
+		break;
+#endif
+#ifdef CONFIG_IPC_NS
+	case CLONE_NEWIPC:
+		if (ns_ref_get(nsp->ipc_ns))
+			ns = to_ns_common(nsp->ipc_ns);
+		break;
+#endif
+#ifdef CONFIG_USER_NS
+	case CLONE_NEWUSER:
+		if (ns_ref_get(user_ns))
+			ns = to_ns_common(user_ns);
+		break;
+#endif
+#ifdef CONFIG_PID_NS
+	case CLONE_NEWPID:
+		if (ns_ref_get(nsp->pid_ns_for_children))
+			ns = to_ns_common(nsp->pid_ns_for_children);
+		break;
+#endif
+#ifdef CONFIG_NET_NS
+	case CLONE_NEWNET:
+		if (ns_ref_get(nsp->net_ns))
+			ns = to_ns_common(nsp->net_ns);
+		break;
+#endif
+	case CLONE_NEWTIME:
+#ifdef CONFIG_TIME_NS
+		if (ns_ref_get(nsp->time_ns))
+			ns = to_ns_common(nsp->time_ns);
+		break;
+#else
+		return -EOPNOTSUPP;
+#endif
+	default:
+		return -EINVAL;
+	}
+
+	if (!ns)
+		return -ESRCH;
+
+	return open_namespace(ns);
+}
diff --git a/include/linux/nsfs.h b/include/linux/nsfs.h
index 731b67fc2fec..bfba790ee1a7 100644
--- a/include/linux/nsfs.h
+++ b/include/linux/nsfs.h
@@ -39,5 +39,7 @@ void nsfs_init(void);
 
 void nsproxy_ns_active_get(struct nsproxy *ns);
 void nsproxy_ns_active_put(struct nsproxy *ns);
+int nsproxy_open_namespace(struct nsproxy *nsp, struct user_namespace *user_ns,
+			   unsigned long nstype);
 
 #endif /* _LINUX_NSFS_H */
-- 
2.47.3

