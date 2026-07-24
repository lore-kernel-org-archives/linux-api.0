Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0ABA43800A;
	Fri, 24 Jul 2026 13:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784900506; cv=none; b=M4EmbosBy64u/M1hmX6YrrirNW+UkxPALOrleK4sjUu0Ljpc/R/GC5TI4GP/N72vcqY3a60R/IfAIyU0PaDn8rjYCqymEx9PfIO++VIazWDogIlJK+7116ttc9bbw1yKJwvyzLcX8xKu53mzGDsOBkKHuHYK99zxwUNspWvkOGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784900506; c=relaxed/simple;
	bh=3HhnMCJBP4HichaGSP3Y+IbCkr0bwbfl6OQb94jw9Fs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=n1So1unuipT4aiksROfa+z2KfsFJdzA3/n5I7rl9fIuUoBE3ZuZq3Yy/KtCh4Iz3xY5k1V2d1IAMyb27d4d+ztORepNi6JDqpq3gpz8PMPDvXzY9PvO2aMl0hZwEKulNII/Z+egZ6bLjBH6l4NnsBoZcBthYOSW9nS9I3PmZnGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KEyYrWQo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KEyYrWQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCC01F00A3A;
	Fri, 24 Jul 2026 13:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784900504;
	bh=SFBKRAEnjn1ImS4A8J3VZkmnYpUAgHBRGYI2/Z6qcV4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KEyYrWQoXcadjq1Y2vgeweFtEAqJsOFFwIVtgSDlkRK1SyIQerKg564f6MpCLjFq+
	 L/kb4AHtxP5VBArltjURm6oq+gAtDdFftJC7Uf7SkysIdFmQuaZikzVwsS673pagxY
	 BNDKvwrtrlv3A3o2iNfh9sN43LRc30CVx020Np9W2k4iXYdG/ci3ifpVNaUfqQEzwq
	 fMuEIaKd8ubMqTAkd0qOkDuYX2W1Lt9WxgT6bTRR/Z8KNOF2yrpLIgH2x79rBbvf2C
	 jbuix/zJQ/tUZeeTbJRNS4ubjBeQrFGaJE+VrzAj4WH1wsc4VASE0LMuRyjd9DSf6l
	 XJ/i/OVDZ63wA==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 24 Jul 2026 15:41:21 +0200
Subject: [PATCH v2 5/7] arch: hookup fchroot() system call
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260724-work-failfs-v2-5-485dabbae185@kernel.org>
References: <20260724-work-failfs-v2-0-485dabbae185@kernel.org>
In-Reply-To: <20260724-work-failfs-v2-0-485dabbae185@kernel.org>
To: linux-fsdevel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, 
 Jann Horn <jannh@google.com>
Cc: John Ericson <mail@johnericson.me>, linux-api@vger.kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <kees@kernel.org>, 
 Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
 linux-doc@vger.kernel.org
X-Mailer: b4 0.16-dev-401aa
X-Developer-Signature: v=1; a=openpgp-sha256; l=10630; i=brauner@kernel.org;
 h=from:subject:message-id; bh=3HhnMCJBP4HichaGSP3Y+IbCkr0bwbfl6OQb94jw9Fs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQlZzc/3Hlu+YxNy4S41rQfeM1/JdTb9ZXZ8Tie4uw5r
 beNjQ71dZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzE/zfDH76MwG9Ryau3ON3N
 4f97cM/yOKHNsZNSY6TyP1zs0DzqvpThr3TMS9dYXtuDU3azmZubGOS2iKqc3Sqr/a3JwfyBSuR
 fHgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Wire up the fchroot() system call as number 472 on (nearly) all
architectures and sync the mirrored copies of the syscall tables and
the asm-generic unistd.h under tools/.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/alpha/kernel/syscalls/syscall.tbl            | 1 +
 arch/arm/tools/syscall.tbl                        | 1 +
 arch/arm64/tools/syscall_32.tbl                   | 1 +
 arch/m68k/kernel/syscalls/syscall.tbl             | 1 +
 arch/microblaze/kernel/syscalls/syscall.tbl       | 1 +
 arch/mips/kernel/syscalls/syscall_n32.tbl         | 1 +
 arch/mips/kernel/syscalls/syscall_n64.tbl         | 1 +
 arch/mips/kernel/syscalls/syscall_o32.tbl         | 1 +
 arch/parisc/kernel/syscalls/syscall.tbl           | 1 +
 arch/powerpc/kernel/syscalls/syscall.tbl          | 1 +
 arch/s390/kernel/syscalls/syscall.tbl             | 1 +
 arch/sh/kernel/syscalls/syscall.tbl               | 1 +
 arch/sparc/kernel/syscalls/syscall.tbl            | 1 +
 arch/x86/entry/syscalls/syscall_32.tbl            | 1 +
 arch/x86/entry/syscalls/syscall_64.tbl            | 1 +
 arch/xtensa/kernel/syscalls/syscall.tbl           | 1 +
 include/uapi/asm-generic/unistd.h                 | 6 +++++-
 scripts/syscall.tbl                               | 1 +
 tools/include/uapi/asm-generic/unistd.h           | 6 +++++-
 tools/perf/arch/x86/entry/syscalls/syscall_64.tbl | 1 +
 tools/scripts/syscall.tbl                         | 1 +
 21 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/syscalls/syscall.tbl
index f31b7afffc34..52e3538cc7df 100644
--- a/arch/alpha/kernel/syscalls/syscall.tbl
+++ b/arch/alpha/kernel/syscalls/syscall.tbl
@@ -511,3 +511,4 @@
 579	common	file_setattr			sys_file_setattr
 580	common	listns				sys_listns
 581	common	rseq_slice_yield		sys_rseq_slice_yield
+582	common	fchroot				sys_fchroot
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index 94351e22bfcf..55717ed32c27 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -486,3 +486,4 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	fchroot				sys_fchroot
diff --git a/arch/arm64/tools/syscall_32.tbl b/arch/arm64/tools/syscall_32.tbl
index 62d93d88e0fe..df2d1d82fb3c 100644
--- a/arch/arm64/tools/syscall_32.tbl
+++ b/arch/arm64/tools/syscall_32.tbl
@@ -483,3 +483,4 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	fchroot				sys_fchroot
diff --git a/arch/m68k/kernel/syscalls/syscall.tbl b/arch/m68k/kernel/syscalls/syscall.tbl
index 248934257101..ba7a4d8903d0 100644
--- a/arch/m68k/kernel/syscalls/syscall.tbl
+++ b/arch/m68k/kernel/syscalls/syscall.tbl
@@ -471,3 +471,4 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	fchroot				sys_fchroot
diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl b/arch/microblaze/kernel/syscalls/syscall.tbl
index 223d26303627..c55a5c96f49b 100644
--- a/arch/microblaze/kernel/syscalls/syscall.tbl
+++ b/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -477,3 +477,4 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	fchroot				sys_fchroot
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index 7430714e2b8f..9ae88e4eac61 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -410,3 +410,4 @@
 469	n32	file_setattr			sys_file_setattr
 470	n32	listns				sys_listns
 471	n32	rseq_slice_yield		sys_rseq_slice_yield
+472	n32	fchroot				sys_fchroot
diff --git a/arch/mips/kernel/syscalls/syscall_n64.tbl b/arch/mips/kernel/syscalls/syscall_n64.tbl
index 630aab9e5425..83dc93a0712f 100644
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -386,3 +386,4 @@
 469	n64	file_setattr			sys_file_setattr
 470	n64	listns				sys_listns
 471	n64	rseq_slice_yield		sys_rseq_slice_yield
+472	n64	fchroot				sys_fchroot
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 128653112284..9c62429c9b7b 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -459,3 +459,4 @@
 469	o32	file_setattr			sys_file_setattr
 470	o32	listns				sys_listns
 471	o32	rseq_slice_yield		sys_rseq_slice_yield
+472	o32	fchroot				sys_fchroot
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index c6331dad9461..88adc4016cce 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -470,3 +470,4 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	fchroot				sys_fchroot
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index 4fcc7c58a105..cfbb70039ff0 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -562,3 +562,4 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	nospu	rseq_slice_yield		sys_rseq_slice_yield
+472	common	fchroot				sys_fchroot
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index 09a7ef04d979..1b45e68a217b 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -398,3 +398,4 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	fchroot				sys_fchroot
diff --git a/arch/sh/kernel/syscalls/syscall.tbl b/arch/sh/kernel/syscalls/syscall.tbl
index 70b315cbe710..ace068dff0de 100644
--- a/arch/sh/kernel/syscalls/syscall.tbl
+++ b/arch/sh/kernel/syscalls/syscall.tbl
@@ -475,3 +475,4 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	fchroot				sys_fchroot
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index 7e71bf7fcd14..5b9fe0e8140f 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -517,3 +517,4 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	fchroot				sys_fchroot
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index f832ebd2d79b..2c172ef48dfd 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -477,3 +477,4 @@
 469	i386	file_setattr		sys_file_setattr
 470	i386	listns			sys_listns
 471	i386	rseq_slice_yield	sys_rseq_slice_yield
+472	i386	fchroot			sys_fchroot
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 524155d655da..d5b6045b0090 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -396,6 +396,7 @@
 469	common	file_setattr		sys_file_setattr
 470	common	listns			sys_listns
 471	common	rseq_slice_yield	sys_rseq_slice_yield
+472	common	fchroot			sys_fchroot
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/arch/xtensa/kernel/syscalls/syscall.tbl b/arch/xtensa/kernel/syscalls/syscall.tbl
index a9bca4e484de..d354bb231796 100644
--- a/arch/xtensa/kernel/syscalls/syscall.tbl
+++ b/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -442,3 +442,4 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	fchroot				sys_fchroot
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index a627acc8fb5f..5b7e77a7c736 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -863,8 +863,12 @@ __SYSCALL(__NR_listns, sys_listns)
 #define __NR_rseq_slice_yield 471
 __SYSCALL(__NR_rseq_slice_yield, sys_rseq_slice_yield)
 
+/* fs/open.c */
+#define __NR_fchroot 472
+__SYSCALL(__NR_fchroot, sys_fchroot)
+
 #undef __NR_syscalls
-#define __NR_syscalls 472
+#define __NR_syscalls 473
 
 /*
  * 32 bit systems traditionally used different
diff --git a/scripts/syscall.tbl b/scripts/syscall.tbl
index 7a42b32b6577..0ab531605120 100644
--- a/scripts/syscall.tbl
+++ b/scripts/syscall.tbl
@@ -412,3 +412,4 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	fchroot				sys_fchroot
diff --git a/tools/include/uapi/asm-generic/unistd.h b/tools/include/uapi/asm-generic/unistd.h
index a627acc8fb5f..5b7e77a7c736 100644
--- a/tools/include/uapi/asm-generic/unistd.h
+++ b/tools/include/uapi/asm-generic/unistd.h
@@ -863,8 +863,12 @@ __SYSCALL(__NR_listns, sys_listns)
 #define __NR_rseq_slice_yield 471
 __SYSCALL(__NR_rseq_slice_yield, sys_rseq_slice_yield)
 
+/* fs/open.c */
+#define __NR_fchroot 472
+__SYSCALL(__NR_fchroot, sys_fchroot)
+
 #undef __NR_syscalls
-#define __NR_syscalls 472
+#define __NR_syscalls 473
 
 /*
  * 32 bit systems traditionally used different
diff --git a/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl b/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
index 524155d655da..d5b6045b0090 100644
--- a/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
@@ -396,6 +396,7 @@
 469	common	file_setattr		sys_file_setattr
 470	common	listns			sys_listns
 471	common	rseq_slice_yield	sys_rseq_slice_yield
+472	common	fchroot			sys_fchroot
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/tools/scripts/syscall.tbl b/tools/scripts/syscall.tbl
index 7a42b32b6577..0ab531605120 100644
--- a/tools/scripts/syscall.tbl
+++ b/tools/scripts/syscall.tbl
@@ -412,3 +412,4 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	fchroot				sys_fchroot

-- 
2.53.0

