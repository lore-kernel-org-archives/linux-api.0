Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.97.179.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794763908;
	b=XR8OpiE0tIi6PP30ROn/cNYZqDmJvza1JSRwwoLuhWfAIVREUFjr7h/uVFPwSzAY0pC/
	 9SgGDu4XzmfQtQ/kcrwIOp6NZPvSjxC//h0JI6hFLWtqwPH+h0xxTkzsI20J5d2Qv2pYv
	 125UHLe3kTKiawRjKEvhYD3sr7nHPDltLaMwYYtiQ6YoAL/qymgoq1WO2xPKf38fOc09r
	 03CnqRqI9Cy/3PmNgvh466D6ggNDI1BBJQfOMKHZQrRS8OVSJN8Nt7obB51Ggtq7HkIuD
	 ktWhjEjLJsvBK33sgJSIVEUi06SImYwEF9ZgUMDJPlCHc7+8g9719TJJMBmDbxtDAgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794763908;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=HRWYrXzhlwAbtuV2gpwgHXA9J9vxIsN+hfFv8twN1aY=;
	b=r2hTLOw2w+RXpxwoDMMWIWe+W4+sEjxhOyLWc2M+wI1LvxfqQrfepFD3VHVvJDPMwD+p
	 Vw4vMb4mbfAx51zVR9H4VX67OOg2JAOHqMWO4rF6ICNDDteueWitvXSEs2KjbYQMISMcE
	 IbT+nRreOzQaSQ2kWy+b7UEB/yhdOFYpUZjIHe4KQSkk0zwF9lOyFHr49/GooT7voCsP2
	 AX/rfdS/8nnIn4FkxdIDDMnmXG6Gg7BMOkMmnXXbWvz6tu0Q2JShvKgRxuoabjGfSn9MV
	 qaLRqnk5uEBVnlWfx4Wc71TZFehuQiQpBQomcl083isFGc65VCn3hepshLaSuAUG/SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=igalia.com;
	spf=pass smtp.mailfrom=igalia.com;
	dkim=pass header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=WmJseOeV;
	arc=none smtp.remote-ip=213.97.179.56
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2D4606A33F;
	Sun, 15 Nov 2026 17:31:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF2D4606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=WmJseOeV
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=HRWYrXzhlwAbtuV2gpwgHXA9J9vxIsN+hfFv8twN1aY=; t=1794763907; x=2110123907; 
	b=WmJseOeVgWRd04hkkcFYYTOyFi0S/fPYURWWUl/MqD2p5xiFzvkLDFTBqH69N+v7qAqy0Wi3JL7
	dNSFCtR6feFzyH66WaygwP/2WGJNyQFxrssxMhZx8vbFHP3dMRrb9CZDU8tm14FK48BpCiCdB3Dwz
	zNzvmQ/kXJxnYXaAS/9yooehlVU8rAMFZIE0D0OHkAzaafjS7LC/bHiofhKIT0Brpb52ezVo7q1zO
	gY9tZapcqNs0W1mp4w+xdjyL+bbW9lRgj3mhV5jk4XA4UBbk1xykUZ8a1xNV1L5Yee1qvvFAnv2+H
	j2tBCZ6J76tHRaqiUL9fLGxMsXVlUZxuWXEA==;
Received: from [177.172.124.218] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xSe4p-00B0BK-4j; Sun, 15 Nov 2026 18:31:39 +0100
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Sun, 15 Nov 2026 14:31:16 -0300
Subject: [PATCH v8 07/10] futex: Wire up get_robust_list2 syscall
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261115-tonyk-robust_futex-v8-7-a4fe47333a28@igalia.com>
References: <20261115-tonyk-robust_futex-v8-0-a4fe47333a28@igalia.com>
In-Reply-To: <20261115-tonyk-robust_futex-v8-0-a4fe47333a28@igalia.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Darren Hart <dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Waiman Long <longman@redhat.com>, Ryan Houdek <Sonicadvance1@gmail.com>, 
 Thomas Gleixner <tglx@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-api@vger.kernel.org, kernel-dev@igalia.com, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2

Wire up the new get_robust_list2 syscall in all available architectures.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 arch/alpha/kernel/syscalls/syscall.tbl      | 1 +
 arch/arm/tools/syscall.tbl                  | 1 +
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
 include/uapi/asm-generic/unistd.h           | 4 +++-
 scripts/syscall.tbl                         | 1 +
 17 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/syscalls/syscall.tbl
index cdf641845014..e26df2cf9de7 100644
--- a/arch/alpha/kernel/syscalls/syscall.tbl
+++ b/arch/alpha/kernel/syscalls/syscall.tbl
@@ -513,3 +513,4 @@
 581	common	rseq_slice_yield		sys_rseq_slice_yield
 582	common	fchroot				sys_fchroot
 583	common	set_robust_list2		sys_set_robust_list2
+584	common	get_robust_list2		sys_get_robust_list2
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index c287461803ff..0268a887f90d 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -488,3 +488,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	set_robust_list2		sys_set_robust_list2
+474	common	get_robust_list2		sys_get_robust_list2
diff --git a/arch/m68k/kernel/syscalls/syscall.tbl b/arch/m68k/kernel/syscalls/syscall.tbl
index beb0ba7f350c..91cc1ea407ec 100644
--- a/arch/m68k/kernel/syscalls/syscall.tbl
+++ b/arch/m68k/kernel/syscalls/syscall.tbl
@@ -473,3 +473,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common  set_robust_list2		sys_set_robust_list2
+474	common  get_robust_list2		sys_get_robust_list2
diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl b/arch/microblaze/kernel/syscalls/syscall.tbl
index bf04133f7239..18a59b24724c 100644
--- a/arch/microblaze/kernel/syscalls/syscall.tbl
+++ b/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -479,3 +479,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	set_robust_list2		sys_set_robust_list2
+474	common	get_robust_list2		sys_get_robust_list2
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index 5b5b217ee7f3..f498b01178e4 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -412,3 +412,4 @@
 471	n32	rseq_slice_yield		sys_rseq_slice_yield
 472	n32	fchroot				sys_fchroot
 473	n32	set_robust_list2		sys_set_robust_list2
+474	n32	get_robust_list2		sys_get_robust_list2
diff --git a/arch/mips/kernel/syscalls/syscall_n64.tbl b/arch/mips/kernel/syscalls/syscall_n64.tbl
index 6f203cb3a558..b12328d537e3 100644
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -388,3 +388,4 @@
 471	n64	rseq_slice_yield		sys_rseq_slice_yield
 472	n64	fchroot				sys_fchroot
 473	n64	set_robust_list2		sys_set_robust_list2
+474	n64	get_robust_list2		sys_get_robust_list2
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index d170650521a7..3c8e3890644f 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -461,3 +461,4 @@
 471	o32	rseq_slice_yield		sys_rseq_slice_yield
 472	o32	fchroot				sys_fchroot
 473	o32	set_robust_list2		sys_set_robust_list2
+474	o32	get_robust_list2		sys_get_robust_list2
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index f9317ff28e37..f746f152cd51 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -472,3 +472,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	set_robust_list2		sys_set_robust_list2
+474	common	get_robust_list2		sys_get_robust_list2
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index acb9d446d1f6..b785d6861963 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -564,3 +564,4 @@
 471	nospu	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	set_robust_list2		sys_set_robust_list2
+474	common	get_robust_list2		sys_get_robust_list2
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index 987e026ffbcf..eb0c5bf1d71f 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -400,3 +400,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	set_robust_list2		sys_set_robust_list2
+474	common	get_robust_list2		sys_get_robust_list2
diff --git a/arch/sh/kernel/syscalls/syscall.tbl b/arch/sh/kernel/syscalls/syscall.tbl
index c944333c1990..520ec9072ce3 100644
--- a/arch/sh/kernel/syscalls/syscall.tbl
+++ b/arch/sh/kernel/syscalls/syscall.tbl
@@ -477,3 +477,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	set_robust_list2		sys_set_robust_list2
+474	common	get_robust_list2		sys_get_robust_list2
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index 3c01fa1cd885..8d332ffde99f 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -519,3 +519,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	set_robust_list2		sys_set_robust_list2
+474	common	get_robust_list2		sys_get_robust_list2
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 11ebbf074920..be72e54ce2fd 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -479,3 +479,4 @@
 471	i386	rseq_slice_yield	sys_rseq_slice_yield
 472	i386	fchroot			sys_fchroot
 473	i386	set_robust_list2	sys_set_robust_list2
+474	i386	get_robust_list2	sys_get_robust_list2
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 53398e8d4981..d5f91d276e75 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -398,6 +398,7 @@
 471	common	rseq_slice_yield	sys_rseq_slice_yield
 472	common	fchroot			sys_fchroot
 473	common	set_robust_list2	sys_set_robust_list2
+474	common	get_robust_list2	sys_get_robust_list2
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/arch/xtensa/kernel/syscalls/syscall.tbl b/arch/xtensa/kernel/syscalls/syscall.tbl
index 7ba9d6993800..4908baf60363 100644
--- a/arch/xtensa/kernel/syscalls/syscall.tbl
+++ b/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -444,3 +444,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	set_robust_list2		sys_set_robust_list2
+474	common	get_robust_list2		sys_get_robust_list2
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 7525e0add809..3d84f306e677 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -869,9 +869,11 @@ __SYSCALL(__NR_fchroot, sys_fchroot)
 
 #define __NR_set_robust_list2 473
 __SYSCALL(__NR_set_robust_list2, sys_set_robust_list2)
+#define __NR_get_robust_list2 474
+__SYSCALL(__NR_get_robust_list2, sys_get_robust_list2)
 
 #undef __NR_syscalls
-#define __NR_syscalls 474
+#define __NR_syscalls 475
 
 /*
  * 32 bit systems traditionally used different
diff --git a/scripts/syscall.tbl b/scripts/syscall.tbl
index c8d261cb8762..b4fb5e1a2141 100644
--- a/scripts/syscall.tbl
+++ b/scripts/syscall.tbl
@@ -414,3 +414,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	set_robust_list2		sys_set_robust_list2
+474	common	get_robust_list2		sys_get_robust_list2

-- 
2.56.1

