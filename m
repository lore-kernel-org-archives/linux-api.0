Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795219831;
	b=djaVjRP4jIVW5ZwIfyagH9N+IQnVHS1+5D2ACE9MNkKHy2Bf4Q28i+olEeYpxfny/Vlm
	 IhKgj021X0Vp6gS5Vd0DgPYyGz9UkeCG1tMxybL6BuCKs7R/s1Z2zrobKLuVMQAx8JEMp
	 XssEWGvIfjHZlhEQQgi7lE7KYdewD8uHKvroRjwExOpHCjqicPKkwcUEkIM93S2dAOfBA
	 Dl26BtknrzQlaq3zyA3qyLYirXkVhqyxE7v8XiVQO96Q5cWFPVl4L+er43MQ1W6xmeEpX
	 vvEcYaPp6Q4lfX92u+UJZocNi/vXOL50UvKLaaqVKxk+F1LVZgoGbnnXWlbDVQ3v0zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795219831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=DViBjoiBEhcc+z9MHNo95Ypd4vzkhr9Bvmzcv5Vx5kY=;
	b=GKMZmY3qLTC59F9NnfvdFtCmTPXGkvMf0HdO+C7pdZFN2WtofBEgdRCMmRBTFwauNZBl
	 EmfByEYC7HGew93+LdEIgy4GgSuOtO/v37bStaBIojWBVsUoJB1y6uaCZbQlUx02nRk8f
	 aUZEwAwj/QOvl6U5ZvWuyLBd0M7flophz6ltzo/RwJUiAIyzXZzBArwRsUSyYM55AqyuY
	 uyGHeywMLwFnfh80qD6ANydLDvrJxMH/RIOLZwC+LiuL9hpuOl2446ITH+gar23yucecR
	 oKYKMXaaO8VJ/IE+jFPfkMLEnVcONuDdXvX5rwpGnj5ws5/sXjz+JZnwTL7NL94whjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i+I9pF8i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 524AE60A380F;
	Sat, 21 Nov 2026 00:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i+I9pF8i
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D6D951F000C6;
	Sat, 21 Nov 2026 00:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219830;
	bh=DViBjoiBEhcc+z9MHNo95Ypd4vzkhr9Bvmzcv5Vx5kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i+I9pF8iXrTPLs7k7ojdz5xu+dk20AiZRB8zoRBdoJ1yck6+V4I9E4b1PZ5ZBNnhX
	 L3E3/eeOdilGdp6GFOTjsf1yymL44lHrzwJtHr0MT7QhjF6KgTpALHOTCFWLgR2ykj
	 utCL3x/GTFcnoOG8VByiGYYqw47HOZX3J5m3bPDtqPqwz1kA7eGZfSi3kgRd/scazS
	 9Ob4Y4vwzlYcrXXjgr4rXeuKVlL1hIw/3aiOMjEAGIakje6pkuABEci6260dQICe7d
	 zgnYbYzuNz6cXwmsb2t46gJZ4f0RnZlPXSTy1pMiWgGN6IqYpqB74+MsFHmhweqnDA
	 6E/5tjUSbz8Gg==
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
Subject: [RFC PATCH v5 22/25] arch: Wire up rootns() system call
Date: Sat, 21 Nov 2026 02:08:41 +0200
Message-ID: <20261121000844.1863324-23-jarkko@kernel.org>
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

Now that the core root namespace lifecycle and VFS mount-tree
installation are in place, expose rootns() (474, 584 on Alpha) across
all architecture system call tables and asm-generic unistd.h.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/alpha/kernel/syscalls/syscall.tbl      | 1 +
 arch/arm/tools/syscall.tbl                  | 1 +
 arch/arm64/tools/syscall_32.tbl             | 1 +
 arch/m68k/kernel/syscalls/syscall.tbl       | 1 +
 arch/microblaze/kernel/syscalls/syscall.tbl | 1 +
 arch/mips/kernel/syscalls/syscall_n32.tbl   | 1 +
 arch/mips/kernel/syscalls/syscall_n64.tbl   | 1 +
 arch/mips/kernel/syscalls/syscall_o32.tbl   | 1 +
 arch/parisc/kernel/syscalls/syscall.tbl     | 1 +
 arch/powerpc/kernel/syscalls/syscall.tbl    | 1 +
 arch/s390/kernel/syscalls/syscall.tbl       | 1 +
 arch/sh/kernel/syscalls/syscall.tbl         | 1 +
 arch/sparc/kernel/syscalls/syscall.tbl      | 1 +
 arch/x86/entry/syscalls/syscall_32.tbl      | 1 +
 arch/x86/entry/syscalls/syscall_64.tbl      | 1 +
 arch/xtensa/kernel/syscalls/syscall.tbl     | 1 +
 include/uapi/asm-generic/unistd.h           | 6 +++++-
 scripts/syscall.tbl                         | 1 +
 18 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/syscalls/syscall.tbl
index 9384d59a44dc..2087b83d6d2c 100644
--- a/arch/alpha/kernel/syscalls/syscall.tbl
+++ b/arch/alpha/kernel/syscalls/syscall.tbl
@@ -513,3 +513,4 @@
 581	common	rseq_slice_yield		sys_rseq_slice_yield
 582	common	fchroot				sys_fchroot
 583	common	userns_set_idmap		sys_sys_userns_set_idmap
+584	common	rootns				sys_sys_rootns
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index 6130366b7681..93e609de0bad 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -488,3 +488,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_sys_userns_set_idmap
+474	common	rootns				sys_sys_rootns
diff --git a/arch/arm64/tools/syscall_32.tbl b/arch/arm64/tools/syscall_32.tbl
index 3fcc7899fd08..5dd5172b5118 100644
--- a/arch/arm64/tools/syscall_32.tbl
+++ b/arch/arm64/tools/syscall_32.tbl
@@ -485,3 +485,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_sys_userns_set_idmap
+474	common	rootns				sys_sys_rootns
diff --git a/arch/m68k/kernel/syscalls/syscall.tbl b/arch/m68k/kernel/syscalls/syscall.tbl
index 5607635bd4bd..4fa5db7d1e62 100644
--- a/arch/m68k/kernel/syscalls/syscall.tbl
+++ b/arch/m68k/kernel/syscalls/syscall.tbl
@@ -473,3 +473,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_sys_userns_set_idmap
+474	common	rootns				sys_sys_rootns
diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl b/arch/microblaze/kernel/syscalls/syscall.tbl
index 97ee93f42fac..5bfe96f7ec5c 100644
--- a/arch/microblaze/kernel/syscalls/syscall.tbl
+++ b/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -479,3 +479,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_sys_userns_set_idmap
+474	common	rootns				sys_sys_rootns
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index da4ed57a91d3..e664ef0d1e56 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -412,3 +412,4 @@
 471	n32	rseq_slice_yield		sys_rseq_slice_yield
 472	n32	fchroot				sys_fchroot
 473	n32	userns_set_idmap		sys_sys_userns_set_idmap
+474	n32	rootns				sys_sys_rootns
diff --git a/arch/mips/kernel/syscalls/syscall_n64.tbl b/arch/mips/kernel/syscalls/syscall_n64.tbl
index 5e9839b6b389..725c0e5a5ab8 100644
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -388,3 +388,4 @@
 471	n64	rseq_slice_yield		sys_rseq_slice_yield
 472	n64	fchroot				sys_fchroot
 473	n64	userns_set_idmap		sys_sys_userns_set_idmap
+474	n64	rootns				sys_sys_rootns
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 290c1b61be47..2c8472b83d23 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -461,3 +461,4 @@
 471	o32	rseq_slice_yield		sys_rseq_slice_yield
 472	o32	fchroot				sys_fchroot
 473	o32	userns_set_idmap		sys_sys_userns_set_idmap
+474	o32	rootns				sys_sys_rootns
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index fc0fa917eb92..0a32c40cfcbe 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -472,3 +472,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_sys_userns_set_idmap
+474	common	rootns				sys_sys_rootns
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index d12e49022b23..d2fd229b8da8 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -564,3 +564,4 @@
 471	nospu	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_sys_userns_set_idmap
+474	nospu	rootns				sys_sys_rootns
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index dc427811d30d..8251cad9530d 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -400,3 +400,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_sys_userns_set_idmap
+474	common	rootns				sys_sys_rootns
diff --git a/arch/sh/kernel/syscalls/syscall.tbl b/arch/sh/kernel/syscalls/syscall.tbl
index e62ac9acc7ad..13105c503bf6 100644
--- a/arch/sh/kernel/syscalls/syscall.tbl
+++ b/arch/sh/kernel/syscalls/syscall.tbl
@@ -477,3 +477,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_sys_userns_set_idmap
+474	common	rootns				sys_sys_rootns
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index df074bf322c4..7542448ab4eb 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -519,3 +519,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_sys_userns_set_idmap
+474	common	rootns				sys_sys_rootns
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 243a3f55834d..35cb517befbf 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -479,3 +479,4 @@
 471	i386	rseq_slice_yield	sys_rseq_slice_yield
 472	i386	fchroot			sys_fchroot
 473	i386	userns_set_idmap	sys_sys_userns_set_idmap
+474	i386	rootns			sys_sys_rootns
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index f11700e3af65..387ca7628bae 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -398,6 +398,7 @@
 471	common	rseq_slice_yield	sys_rseq_slice_yield
 472	common	fchroot			sys_fchroot
 473	common	userns_set_idmap	sys_sys_userns_set_idmap
+474	common	rootns			sys_sys_rootns
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/arch/xtensa/kernel/syscalls/syscall.tbl b/arch/xtensa/kernel/syscalls/syscall.tbl
index 1d28de95915f..f9869ffeeed1 100644
--- a/arch/xtensa/kernel/syscalls/syscall.tbl
+++ b/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -444,3 +444,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_sys_userns_set_idmap
+474	common	rootns				sys_sys_rootns
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 695eac2d356b..726b39b6b47c 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -871,8 +871,12 @@ __SYSCALL(__NR_fchroot, sys_fchroot)
 #define __NR_userns_set_idmap 473
 __SYSCALL(__NR_userns_set_idmap, sys_userns_set_idmap)
 
+/* kernel/rootns.c */
+#define __NR_rootns 474
+__SYSCALL(__NR_rootns, sys_rootns)
+
 #undef __NR_syscalls
-#define __NR_syscalls 474
+#define __NR_syscalls 475
 
 /*
  * 32 bit systems traditionally used different
diff --git a/scripts/syscall.tbl b/scripts/syscall.tbl
index 0dddd465d1c5..1670f575d3e4 100644
--- a/scripts/syscall.tbl
+++ b/scripts/syscall.tbl
@@ -414,3 +414,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_sys_userns_set_idmap
+474	common	rootns				sys_sys_rootns
-- 
2.47.3

