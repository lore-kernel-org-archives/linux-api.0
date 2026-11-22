Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795376251;
	b=1KarJaDuhjPeTn49ZGEKlTwIKjr8XzSCKHh0peoo3NOXaIy3vEwF1rL6LXloYk8v51ZZ
	 RlX1JlZ72qV4Amv0QVI/8XwDrN3sdVxqfkrZR2q9NVfugoZ1iXB555CVrmYfOoNkjodRC
	 o1u0YhUjmp67RmbcdgPwdLWpN904b9N3eC5r0dhDttT/JbF4ZsLH8admpZd9+1YkAxP1S
	 VsHXy12YMqYgaOt2PM802RuGtuVwLNd161z8ciJoaZZzUpuuv8QvxobPJIBBGWAZZGPhb
	 cg8Tas63IPIyedpkGPO6qmuMWmZwCJRlTxoRe/YedPS2AVHD6rOARcm1eKHEoLCwX2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795376251;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=zs4d8Qildq2fNc6PLk+GUR8ZjIlQZmHZPkOwBRx3+1A=;
	b=Pu14LMi6C0MVv0oYIfo4K0I0/bq8AEjm6iw9e2cG7G+3C9SK6JIo9z8L7GaGyYaMVlM7
	 +cWvZfJLrNuvBx2Z3fML1/7ngla2VJU4XMw7s2qZ11m99uW1cvZD3Fu1PWsFtHMrO3A2N
	 wSbW+xfw4DDGtboAiQjHJkw1C3ogSxHQPBHtBcgmgxexA68Sl9VzyqeSG16hcuTrRt8hs
	 GIvTN6/SAMq7RBCvlZ6vSxMsaNPN6MjARkTxmECJkzMkcQ1JdoMmwOeFIZx8sun8Pl9cA
	 thdy7BulebM0baxX9QtSKy5kZr7rxTSXmXf8p5FKVsN9/hG5Ix+ja3V57yiE9sNK9Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W8nWhqyY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 67B84606A6AD;
	Sun, 22 Nov 2026 19:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W8nWhqyY
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 193F91F000C0;
	Sun, 22 Nov 2026 19:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376250;
	bh=zs4d8Qildq2fNc6PLk+GUR8ZjIlQZmHZPkOwBRx3+1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W8nWhqyY1l/5oIhxo9AusbNPDS7pNe2c7jdlfibiK9O4J7YFbmrpPsuK6dub2ROAe
	 rn9773eP+vZgMLsdrGpMNtNwUR97O+i7Ymi7QxvdMtYxyu/B5vZtW0/SSzz9CikZZG
	 zz2so70cW+rNG9k2mcDrKZFtWEFpUpG1MUttpQAI7FZabGlKL8TGb/tF7vF0ZmWO80
	 Hm87LXNBNvD3YulVza7xOlYl39k1q+U50EdgVJtvNyOJtHreMMEnqffEYjwpr841I8
	 Iu4gBtD2Cfw8Lt+5t4n478r/phiivzEwhQSTNlPRapp8t/upmoP72EBoqdD5BcfafY
	 ZTCS4Or2D4EEA==
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
Subject: [RFC PATCH v7 22/26] bpf: Register userland LSM hooks
Date: Sun, 22 Nov 2026 21:35:35 +0200
Message-ID: <20261122193539.3334213-23-jarkko@kernel.org>
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

BPF LSM programs need sleepable and untrusted hook classifications for
the userland LSM hooks in order to attach policies to userland
allocation, namespace sharing, cloning, signaling, and release.

Register bpf_lsm_userland_alloc, bpf_lsm_userland_share,
bpf_lsm_userland_clone, and bpf_lsm_userland_kill in
sleepable_lsm_hooks, and bpf_lsm_userland_alloc and
bpf_lsm_userland_free in untrusted_lsm_hooks under CONFIG_USERLAND.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 kernel/bpf/bpf_lsm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 468e63dbd922..ac8508a6b242 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -16,6 +16,7 @@
 #include <linux/btf_ids.h>
 #include <linux/ima.h>
 #include <linux/bpf-cgroup.h>
+#include <linux/userland.h>
 
 /* For every LSM hook that allows attachment of BPF programs, declare a nop
  * function where a BPF program can be attached. Notably, we qualify each with
@@ -404,6 +405,12 @@ BTF_ID(func, bpf_lsm_task_setscheduler)
 BTF_ID(func, bpf_lsm_userns_create)
 BTF_ID(func, bpf_lsm_bdev_alloc_security)
 BTF_ID(func, bpf_lsm_bdev_setintegrity)
+#ifdef CONFIG_USERLAND
+BTF_ID(func, bpf_lsm_userland_alloc)
+BTF_ID(func, bpf_lsm_userland_share)
+BTF_ID(func, bpf_lsm_userland_clone)
+BTF_ID(func, bpf_lsm_userland_kill)
+#endif /* CONFIG_USERLAND */
 BTF_SET_END(sleepable_lsm_hooks)
 
 BTF_SET_START(untrusted_lsm_hooks)
@@ -420,6 +427,10 @@ BTF_ID(func, bpf_lsm_sk_free_security)
 BTF_ID(func, bpf_lsm_task_free)
 BTF_ID(func, bpf_lsm_bdev_alloc_security)
 BTF_ID(func, bpf_lsm_bdev_free_security)
+#ifdef CONFIG_USERLAND
+BTF_ID(func, bpf_lsm_userland_alloc)
+BTF_ID(func, bpf_lsm_userland_free)
+#endif /* CONFIG_USERLAND */
 BTF_SET_END(untrusted_lsm_hooks)
 
 bool bpf_lsm_is_sleepable_hook(u32 btf_id)
-- 
2.47.3

