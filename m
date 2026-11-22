Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795310385;
	b=v42/SNGiUi4UHpsCwlg078yr+Nf/9/1mMfR3FLa9vOYvCNL41lfObxwZXwgZ73q+s81A
	 Hfd7KgOU+oTjHEvlAFfb0dIK3wWFGRIdRsATDD47dPH6wMeVzklzouLBGnjDecqPgKEXu
	 klRUnVAGdshCfP9ew0zE29DB9i7TN9ItFy7fJAFtQ7zbcNwpcvslJ4/Un+SVFU9TkfJe+
	 7DHtRfEoWk5aVvYndmPagwvXVfBm/VTQcGmSK2lHY+NUANi6/YDFesLtM3TZzEbFbWQ5Z
	 e24R8ear5I1967wzsIoTg/v9zU/gLJH2mE6Vf/r5AOXOol6MK2LDcQRnDmL7+UsWmMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795310385;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=zs4d8Qildq2fNc6PLk+GUR8ZjIlQZmHZPkOwBRx3+1A=;
	b=XhVilpqSEXH9YPyoPPxj5IcNV1tieSTzVo98exETcUtPXa42PAtbA09KFILekHQcf0Kz
	 yO9qvHgk9Usv7DFCzdTDY9TToanftXKCAkAIBY9ZdugJb6IZOoF+sJo6HwLYgMmKk8msT
	 TMykrOEEvLtMOIcsCDkVGCe13b1pVi0DqANB2p6N/QiXv05aijcej3KyQu1uHKrxI1o3B
	 Dvm1I4Uto3b1vo4dlCfuOcQWUCBTRLy6fRiDig/syFMgh2E/VE3Onb7H+3xV5KBbH1fxL
	 dpxFOLMJQMkZ2T0Cz33ST/0ZWRwtDwHwAkJTWJ90dTW/Rr0Mlarl1mhUwXtHkhxLd4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BSEjz7QP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3AB88606A6AC;
	Sun, 22 Nov 2026 01:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BSEjz7QP
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 104E71F0093E;
	Sun, 22 Nov 2026 01:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310384;
	bh=zs4d8Qildq2fNc6PLk+GUR8ZjIlQZmHZPkOwBRx3+1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSEjz7QPSFK13UkmPy+FDG1IIq4sF2YeDULrI4kWHtnu0cHVT8BQsyOnCBS1DxbiB
	 T3m9yH7tXkc/Nz3d02zn9FIeiXJOJ0xTdAOD7Z+OK2mcBaQL6VFOEJv6BSXb80J/2s
	 b23k7X0WN4XDBkpAty5H7RkbU5MnMRD5OE7s79xxr9CSR6uLtAqw+0qK3MvnCqboTT
	 Q0pGxvMJ/3KG0PEtlSQ5U2tz/A04upM3hqmPJb2DcHybDQm/K/cvNyAVZ/+5D8BZUH
	 wNUeAorZRDwveWkL8uc1RycN+j4q0tKfqTzt7naCD4eykPD1J5itOD5vYaHKabLL3U
	 we3gzfASKSNtA==
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
Subject: [RFC PATCH v6 22/26] bpf: Register userland LSM hooks
Date: Sun, 22 Nov 2026 03:18:05 +0200
Message-ID: <20261122011809.2667684-23-jarkko@kernel.org>
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

