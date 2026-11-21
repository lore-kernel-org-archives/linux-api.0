Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795219826;
	b=kRIbDvZUCAnGk+5I7jLsOsk0YVAncZzTVhflxqI0vu0Ke+H1Gem0YuZ8Wvsx5rYXzRoM
	 ++OvluU+D1M1HXIOcvjOB2EYDVqiVYUUIlP3fTT/QrGcmOEnnyXr7Ugj5so44Huj+C/im
	 l3eqCh4qAMCbxZbqoVnJY8OTlEmiaRya2ek8+XcUW7jc+INyo63q+/UK6ZqBoj224ZHl/
	 bzcuhS2cJtVzZsanC2yWqz2SW3KRRy7KFIU8txw5Dd1yeIks/C9td4WFx0m0yX6TMNupB
	 23WMEAU9PcBzIaoN+5Vk3UMoB/WupHOLbxQTqUbz+AEQaJKAvSIvILBjssy5wywGW2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795219826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=+Eyq4GxevLOo6CnxBFmFSQzUssMKFYdLLMcgPqVG7IE=;
	b=hOPwLJRlITAdvV5+2M4dgQ1Cf7NR681UzTXanDPpyw+qUebvM1tegPefBn1EvCWXGDzy
	 L/8uYInxAzHNVanjM7sELxWLLXFBZbsB38tyfy3Q8VhK53eDq2yGsNBUTlhgfULOfLMXF
	 AgaxIUNvMXrA3Z1DpfPPhjGiicwVKomUKdr5pTt0vQvF6N6cLnrF/akB98g6H5PzA6sG8
	 X7yWSnaLTijtWJVeDB4QX1xK4HPk1L5I8ZSFnQUP+1F36g7VUpsH//HryinHnREwaLqkI
	 wJGWqkQbckHZDYeIM8BWO/EhH+T1VVsngycB8Kdp7byy5z6ldfISbECnQxAoRDYpWfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j4k3SiVx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id BAAB460A5BC0;
	Sat, 21 Nov 2026 00:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j4k3SiVx
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7A89B1F000C0;
	Sat, 21 Nov 2026 00:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219826;
	bh=+Eyq4GxevLOo6CnxBFmFSQzUssMKFYdLLMcgPqVG7IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4k3SiVxDcE9xNRlED7134kIVV0tuttt6dCAjAJdcuJdDLCLNbA9NMivdrmSGkgMr
	 OyNYJAI4aS5nK5BjnSJmKNea24ET+/1PJcRvhRqVRku61xK52x95rnz1mf14yb5Cq3
	 wzasJkApfZpgAp4UJQVf+77zavqRmbkwXW68Cta8+wbDYMnflh84pGO1NF3AhW3KJ5
	 bkWL4ZK6uXwvzo38zYKicjnk74z6NK/tPzG/PYLm+025Jhr6sftady81fOpPFq+7OL
	 9CVbjQr8GKAmoKnxNWjVKohFbByvxeQb52RjUYIixDe3jeMOt2VRMI+DTnvns4+r/E
	 77iaHcj4oHZ+w==
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
Subject: [RFC PATCH v5 21/25] bpf: Register rootns LSM hooks
Date: Sat, 21 Nov 2026 02:08:40 +0200
Message-ID: <20261121000844.1863324-22-jarkko@kernel.org>
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

BPF LSM programs need sleepable and untrusted hook classifications for
the new root namespace LSM hooks in order to attach policies to root
namespace allocation, cloning, signaling, and release.

Register bpf_lsm_rootns_alloc, bpf_lsm_rootns_clone, and
bpf_lsm_rootns_kill in sleepable_lsm_hooks, and bpf_lsm_rootns_alloc
and bpf_lsm_rootns_free in untrusted_lsm_hooks under CONFIG_ROOTNS.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 kernel/bpf/bpf_lsm.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 468e63dbd922..bbcf1433fdc2 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -16,6 +16,7 @@
 #include <linux/btf_ids.h>
 #include <linux/ima.h>
 #include <linux/bpf-cgroup.h>
+#include <linux/rootns.h>
 
 /* For every LSM hook that allows attachment of BPF programs, declare a nop
  * function where a BPF program can be attached. Notably, we qualify each with
@@ -404,6 +405,11 @@ BTF_ID(func, bpf_lsm_task_setscheduler)
 BTF_ID(func, bpf_lsm_userns_create)
 BTF_ID(func, bpf_lsm_bdev_alloc_security)
 BTF_ID(func, bpf_lsm_bdev_setintegrity)
+#ifdef CONFIG_ROOTNS
+BTF_ID(func, bpf_lsm_rootns_alloc)
+BTF_ID(func, bpf_lsm_rootns_clone)
+BTF_ID(func, bpf_lsm_rootns_kill)
+#endif /* CONFIG_ROOTNS */
 BTF_SET_END(sleepable_lsm_hooks)
 
 BTF_SET_START(untrusted_lsm_hooks)
@@ -420,6 +426,10 @@ BTF_ID(func, bpf_lsm_sk_free_security)
 BTF_ID(func, bpf_lsm_task_free)
 BTF_ID(func, bpf_lsm_bdev_alloc_security)
 BTF_ID(func, bpf_lsm_bdev_free_security)
+#ifdef CONFIG_ROOTNS
+BTF_ID(func, bpf_lsm_rootns_alloc)
+BTF_ID(func, bpf_lsm_rootns_free)
+#endif /* CONFIG_ROOTNS */
 BTF_SET_END(untrusted_lsm_hooks)
 
 bool bpf_lsm_is_sleepable_hook(u32 btf_id)
-- 
2.47.3

