Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795219748;
	b=oke9z6kMc4PKzOfk0CTc9TBP52hWf+RbuZrgn6ul6GF9nfey/D8dPIy8ygoHmDNVFi+2
	 rb4t7sctm4xSE7RRVEGwxmLpQdFDP0kjaHvtceSbvAHdJodrsAxlbYFHYoG3enKPxAWsT
	 EphvGG0zD7pxI7ZOmiL58MHYUcBKM/1nbDMa743liqotYT4LzZxT54bWNJbd+t4PvFcHD
	 3I5m+AP7loIi+XB47oOmWSrIJIvxt7E14+X/RA2s622WG7Zdn6FbKIiPFbHYzQUR8gfUh
	 QX+gj3WwaQjxslH7zY5r2HlsL2I1R+P3OOLL/hOzw/8lOzxXtDPxTcOX4vw4CfxZJHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795219748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=xdMFQd5iWnE0etuNgaG+P1V3IRtO+2edlHDd0w1oiXI=;
	b=IwGhSNlRv5tYu5V7Vv13UwOqgB+22ajjFe0noKrN+DFmVB55gssUBLc6dJG5qZZXxeMJ
	 awjZrV3BoNknvRv7nsn2P4eu9MBsL2/l/Vmdq3T4fGnl13hKK81hS+SWv5f0SsTmveRfY
	 EmVX9i2BwZFTdm/IOZJMb1ME1RGCGuOILCjyixhlvGTf3VbtUzNrxisNs/57h3V0dpP+A
	 G+xn0V7vstbNhTZl/Y9UOGKkun7cETc5Hq0yptmf7idsmDgevC4KNdKfwrPCVk55fVEPt
	 EnZRmDFvDn6V9G29n1EBRNIxKiBTnStwY8z9VRIRQv+uskfy87v4ZF9fH1avAdIfOZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OIx38B1u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 0B04A606A6A6;
	Sat, 21 Nov 2026 00:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OIx38B1u
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 35F191F000C6;
	Sat, 21 Nov 2026 00:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219747;
	bh=xdMFQd5iWnE0etuNgaG+P1V3IRtO+2edlHDd0w1oiXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OIx38B1u3nJnanXh/hKXPskEKfSxQGZ8uO6Ie5n7ZxFtDVKyfnWoZ2ygDZt0krBMn
	 Eb6WU2mgP3mRzYddEvT/UfzihFtsZQDmPQZM20BNgroAvtd5M8uhQZawsiACv24KkD
	 m/T7osBk+AjPsA3WKfhe2eW82P7pqjW9AIXjhU4Q8vrhXLr53dri75w9xjL783IGV5
	 ptVzBO48eq+CcnchCH82rcsmNSeVP5q4CSSrG2HEPzRzWVBRYTMFbdt3cK5QMlHV2K
	 RgVdRbWc6+ARVMok7ImDzyr4yYRczYlNWV3Z8WmtjZTfnmYmR/tzBrAJqzN6U7dCkx
	 5O/btILf6z72g==
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
Subject: [RFC PATCH v5 03/25] arch: Wire up userns_set_idmap() system call
Date: Sat, 21 Nov 2026 02:08:22 +0200
Message-ID: <20261121000844.1863324-4-jarkko@kernel.org>
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

Expose userns_set_idmap() (473, 583 on Alpha) across all architecture
system call tables and asm-generic unistd.h.

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
index 52e3538cc7df..9384d59a44dc 100644
--- a/arch/alpha/kernel/syscalls/syscall.tbl
+++ b/arch/alpha/kernel/syscalls/syscall.tbl
@@ -512,3 +512,4 @@
 580	common	listns				sys_listns
 581	common	rseq_slice_yield		sys_rseq_slice_yield
 582	common	fchroot				sys_fchroot
+583	common	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index 55717ed32c27..6130366b7681 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -487,3 +487,4 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/arm64/tools/syscall_32.tbl b/arch/arm64/tools/syscall_32.tbl
index df2d1d82fb3c..3fcc7899fd08 100644
--- a/arch/arm64/tools/syscall_32.tbl
+++ b/arch/arm64/tools/syscall_32.tbl
@@ -484,3 +484,4 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/m68k/kernel/syscalls/syscall.tbl b/arch/m68k/kernel/syscalls/syscall.tbl
index ba7a4d8903d0..5607635bd4bd 100644
--- a/arch/m68k/kernel/syscalls/syscall.tbl
+++ b/arch/m68k/kernel/syscalls/syscall.tbl
@@ -472,3 +472,4 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl b/arch/microblaze/kernel/syscalls/syscall.tbl
index 76d7cbe2a133..97ee93f42fac 100644
--- a/arch/microblaze/kernel/syscalls/syscall.tbl
+++ b/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -478,3 +478,4 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index 9ae88e4eac61..da4ed57a91d3 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -411,3 +411,4 @@
 470	n32	listns				sys_listns
 471	n32	rseq_slice_yield		sys_rseq_slice_yield
 472	n32	fchroot				sys_fchroot
+473	n32	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/mips/kernel/syscalls/syscall_n64.tbl b/arch/mips/kernel/syscalls/syscall_n64.tbl
index 83dc93a0712f..5e9839b6b389 100644
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -387,3 +387,4 @@
 470	n64	listns				sys_listns
 471	n64	rseq_slice_yield		sys_rseq_slice_yield
 472	n64	fchroot				sys_fchroot
+473	n64	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 9c62429c9b7b..290c1b61be47 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -460,3 +460,4 @@
 470	o32	listns				sys_listns
 471	o32	rseq_slice_yield		sys_rseq_slice_yield
 472	o32	fchroot				sys_fchroot
+473	o32	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index 88adc4016cce..fc0fa917eb92 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -471,3 +471,4 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index cfbb70039ff0..d12e49022b23 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -563,3 +563,4 @@
 470	common	listns				sys_listns
 471	nospu	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index 1b45e68a217b..dc427811d30d 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -399,3 +399,4 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/sh/kernel/syscalls/syscall.tbl b/arch/sh/kernel/syscalls/syscall.tbl
index ace068dff0de..e62ac9acc7ad 100644
--- a/arch/sh/kernel/syscalls/syscall.tbl
+++ b/arch/sh/kernel/syscalls/syscall.tbl
@@ -476,3 +476,4 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index 5b9fe0e8140f..df074bf322c4 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -518,3 +518,4 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 2c172ef48dfd..243a3f55834d 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -478,3 +478,4 @@
 470	i386	listns			sys_listns
 471	i386	rseq_slice_yield	sys_rseq_slice_yield
 472	i386	fchroot			sys_fchroot
+473	i386	userns_set_idmap	sys_sys_userns_set_idmap
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index d5b6045b0090..f11700e3af65 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -397,6 +397,7 @@
 470	common	listns			sys_listns
 471	common	rseq_slice_yield	sys_rseq_slice_yield
 472	common	fchroot			sys_fchroot
+473	common	userns_set_idmap	sys_sys_userns_set_idmap
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/arch/xtensa/kernel/syscalls/syscall.tbl b/arch/xtensa/kernel/syscalls/syscall.tbl
index d354bb231796..1d28de95915f 100644
--- a/arch/xtensa/kernel/syscalls/syscall.tbl
+++ b/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -443,3 +443,4 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 5b7e77a7c736..695eac2d356b 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -867,8 +867,12 @@ __SYSCALL(__NR_rseq_slice_yield, sys_rseq_slice_yield)
 #define __NR_fchroot 472
 __SYSCALL(__NR_fchroot, sys_fchroot)
 
+/* kernel/user_namespace.c */
+#define __NR_userns_set_idmap 473
+__SYSCALL(__NR_userns_set_idmap, sys_userns_set_idmap)
+
 #undef __NR_syscalls
-#define __NR_syscalls 473
+#define __NR_syscalls 474
 
 /*
  * 32 bit systems traditionally used different
diff --git a/scripts/syscall.tbl b/scripts/syscall.tbl
index 0ab531605120..0dddd465d1c5 100644
--- a/scripts/syscall.tbl
+++ b/scripts/syscall.tbl
@@ -413,3 +413,4 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	userns_set_idmap		sys_sys_userns_set_idmap
-- 
2.47.3

