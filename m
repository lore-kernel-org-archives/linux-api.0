Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794892168;
	b=CGGh1YslSU9mn9HFteu3QeN6lgVMQT64D2uBXMg/VVJSpHdXbrPFfwqvQ0aQzVPZSvXg
	 xCKDCN8ZfuOKEwGIcgqo4WYcpeQgDbOLpKJQ5oGM7K5Xa+OM+lZeMkjtJT7LTGNGIQw71
	 WXCPkFtepm40r90E6kUiUTsX710YbCoJ3/nitmFPhEblqtEfenBnPnWw/33/C+w0Cxoah
	 weDzw/N8qS7SV7jyvT/AganLcC+vxW92Sk79ubVzksNuy+Ift4cGsMgB4CG6/sEDpBL1h
	 cnkLUswTr3TfacJ+8dYOMK9m56Bl0V3HlGEZugDcLtdeoU2tWhrk0i0oB7RtoGtWtTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794892168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=qr4JFwG53XzED0ptwDX6mwXcUzulpjNzvDhvu01tYrY=;
	b=IcMokff2cNxVzyQs0I4DxxfCWRQO/ETNMWFzxb+Gx0W6hPqpucnIXpJNmw2AXMoQspkn
	 q6JI2k9HQjlRVPupMMoBf8RPQaFERPIOCHw7fduFBW//Wt6crUJtgafE3uLPGbqHOAbBn
	 hlpcr+8/WzD/KsTYzYtSLZfPYGMMI9D5nUPUZZc88Clax2c73aDFY4UsZfgR1nikUuUie
	 tpo0sJ1nSpxrlFAnh8Z4scQdsEN9H0WBmUFeA8B2Un+GReKTObjuqm74+WC1/DO14kJAx
	 VDrOdCJFjT3OMA1nIQbr7b0ONP+lPoDt94JDgtAD4DxQDde7V7LYtp5Z2Ly9uAWLidg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l4oeNBzI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C530F606A888;
	Tue, 17 Nov 2026 05:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l4oeNBzI
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 984D41F000D4;
	Tue, 17 Nov 2026 05:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794892168;
	bh=qr4JFwG53XzED0ptwDX6mwXcUzulpjNzvDhvu01tYrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l4oeNBzIZg/k0UEU2KET3uU2dgLdruZ9mzXzNOwTRTObem2IzGwdTzjfU0X6MN6uh
	 iU9vg0QxAeQUMfd/QbLcSE0pW7c9Y+1bvZ6Lcno0cthoWTW5Uvo0RqyNn8xQ0ItcMn
	 zZjeEN8hnhoFt0dsMlADj8u9XklzHyftVa+QGUfa3dtZhb1DeRCKPt6by+iMcqV6MB
	 IsaWRA38E6fC1vIik/lvrMQVqqij/LqVqS+XN5eZi7jAvXTioL4o6bpJkWOeMUvBeG
	 Ggu+6r8u+Y2v6GI4iLi+qF1aBWgL23g1Y/8bpEpDCh+yE6OWIwBxFdh6u0E+P56BSj
	 kwS3ODJ1hFuyQ==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [RFC PATCH 10/13] arch: Wire up rootns system calls
Date: Tue, 17 Nov 2026 07:08:38 +0200
Message-ID: <20261117050841.3289652-11-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117050841.3289652-1-jarkko@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
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
installation are in place, expose rootns_create() (473), rootns_wait()
(474), rootns_kill() (475), and rootns_enter() (476) across all
architecture system call tables and asm-generic unistd.h.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/alpha/kernel/syscalls/syscall.tbl      |  4 ++++
 arch/arm/tools/syscall.tbl                  |  4 ++++
 arch/arm64/tools/syscall_32.tbl             |  4 ++++
 arch/m68k/kernel/syscalls/syscall.tbl       |  4 ++++
 arch/microblaze/kernel/syscalls/syscall.tbl |  4 ++++
 arch/mips/kernel/syscalls/syscall_n32.tbl   |  4 ++++
 arch/mips/kernel/syscalls/syscall_n64.tbl   |  4 ++++
 arch/mips/kernel/syscalls/syscall_o32.tbl   |  4 ++++
 arch/parisc/kernel/syscalls/syscall.tbl     |  4 ++++
 arch/powerpc/kernel/syscalls/syscall.tbl    |  4 ++++
 arch/s390/kernel/syscalls/syscall.tbl       |  4 ++++
 arch/sh/kernel/syscalls/syscall.tbl         |  4 ++++
 arch/sparc/kernel/syscalls/syscall.tbl      |  4 ++++
 arch/x86/entry/syscalls/syscall_32.tbl      |  4 ++++
 arch/x86/entry/syscalls/syscall_64.tbl      |  4 ++++
 arch/xtensa/kernel/syscalls/syscall.tbl     |  4 ++++
 include/uapi/asm-generic/unistd.h           | 12 +++++++++++-
 scripts/syscall.tbl                         |  4 ++++
 18 files changed, 79 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/syscalls/syscall.tbl
index 52e3538cc7df..a945b15abe6d 100644
--- a/arch/alpha/kernel/syscalls/syscall.tbl
+++ b/arch/alpha/kernel/syscalls/syscall.tbl
@@ -512,3 +512,7 @@
 580	common	listns				sys_listns
 581	common	rseq_slice_yield		sys_rseq_slice_yield
 582	common	fchroot				sys_fchroot
+583	common	rootns_create			sys_rootns_create
+584	common	rootns_wait			sys_rootns_wait
+585	common	rootns_kill			sys_rootns_kill
+586	common	rootns_enter			sys_rootns_enter
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index 55717ed32c27..a6df8f688a03 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -487,3 +487,7 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
+476	common	rootns_enter			sys_rootns_enter
diff --git a/arch/arm64/tools/syscall_32.tbl b/arch/arm64/tools/syscall_32.tbl
index df2d1d82fb3c..0fee3f3a6f18 100644
--- a/arch/arm64/tools/syscall_32.tbl
+++ b/arch/arm64/tools/syscall_32.tbl
@@ -484,3 +484,7 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait		compat_sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
+476	common	rootns_enter			sys_rootns_enter
diff --git a/arch/m68k/kernel/syscalls/syscall.tbl b/arch/m68k/kernel/syscalls/syscall.tbl
index ba7a4d8903d0..db99316451d5 100644
--- a/arch/m68k/kernel/syscalls/syscall.tbl
+++ b/arch/m68k/kernel/syscalls/syscall.tbl
@@ -472,3 +472,7 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
+476	common	rootns_enter			sys_rootns_enter
diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl b/arch/microblaze/kernel/syscalls/syscall.tbl
index 76d7cbe2a133..fdd26eb61173 100644
--- a/arch/microblaze/kernel/syscalls/syscall.tbl
+++ b/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -478,3 +478,7 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
+476	common	rootns_enter			sys_rootns_enter
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index 9ae88e4eac61..3a81da7abd44 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -411,3 +411,7 @@
 470	n32	listns				sys_listns
 471	n32	rseq_slice_yield		sys_rseq_slice_yield
 472	n32	fchroot				sys_fchroot
+473	n32	rootns_create			sys_rootns_create
+474	n32	rootns_wait			compat_sys_rootns_wait
+475	n32	rootns_kill			sys_rootns_kill
+476	n32	rootns_enter			sys_rootns_enter
diff --git a/arch/mips/kernel/syscalls/syscall_n64.tbl b/arch/mips/kernel/syscalls/syscall_n64.tbl
index 83dc93a0712f..2c38f050d14e 100644
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -387,3 +387,7 @@
 470	n64	listns				sys_listns
 471	n64	rseq_slice_yield		sys_rseq_slice_yield
 472	n64	fchroot				sys_fchroot
+473	n64	rootns_create			sys_rootns_create
+474	n64	rootns_wait			sys_rootns_wait
+475	n64	rootns_kill			sys_rootns_kill
+476	n64	rootns_enter			sys_rootns_enter
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 9c62429c9b7b..3f0344992c20 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -460,3 +460,7 @@
 470	o32	listns				sys_listns
 471	o32	rseq_slice_yield		sys_rseq_slice_yield
 472	o32	fchroot				sys_fchroot
+473	o32	rootns_create			sys_rootns_create
+474	o32	rootns_wait			sys_rootns_wait			compat_sys_rootns_wait
+475	o32	rootns_kill			sys_rootns_kill
+476	o32	rootns_enter			sys_rootns_enter
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index 88adc4016cce..1f3d051a9c56 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -471,3 +471,7 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait			compat_sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
+476	common	rootns_enter			sys_rootns_enter
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index cfbb70039ff0..610ceedd1a14 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -563,3 +563,7 @@
 470	common	listns				sys_listns
 471	nospu	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait			compat_sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
+476	common	rootns_enter			sys_rootns_enter
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index 1b45e68a217b..e9c7021a07e1 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -399,3 +399,7 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
+476	common	rootns_enter			sys_rootns_enter
diff --git a/arch/sh/kernel/syscalls/syscall.tbl b/arch/sh/kernel/syscalls/syscall.tbl
index ace068dff0de..c122ee2d7cd2 100644
--- a/arch/sh/kernel/syscalls/syscall.tbl
+++ b/arch/sh/kernel/syscalls/syscall.tbl
@@ -476,3 +476,7 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
+476	common	rootns_enter			sys_rootns_enter
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index 5b9fe0e8140f..e7cfd43d616a 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -518,3 +518,7 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait			compat_sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
+476	common	rootns_enter			sys_rootns_enter
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 2c172ef48dfd..c444d59d0267 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -478,3 +478,7 @@
 470	i386	listns			sys_listns
 471	i386	rseq_slice_yield	sys_rseq_slice_yield
 472	i386	fchroot			sys_fchroot
+473	i386	rootns_create		sys_rootns_create
+474	i386	rootns_wait		sys_rootns_wait		compat_sys_rootns_wait
+475	i386	rootns_kill		sys_rootns_kill
+476	i386	rootns_enter		sys_rootns_enter
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index d5b6045b0090..f331f1ddc330 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -397,6 +397,10 @@
 470	common	listns			sys_listns
 471	common	rseq_slice_yield	sys_rseq_slice_yield
 472	common	fchroot			sys_fchroot
+473	common	rootns_create		sys_rootns_create
+474	common	rootns_wait		sys_rootns_wait
+475	common	rootns_kill		sys_rootns_kill
+476	common	rootns_enter		sys_rootns_enter
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/arch/xtensa/kernel/syscalls/syscall.tbl b/arch/xtensa/kernel/syscalls/syscall.tbl
index d354bb231796..7482743ea9b4 100644
--- a/arch/xtensa/kernel/syscalls/syscall.tbl
+++ b/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -443,3 +443,7 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
+476	common	rootns_enter			sys_rootns_enter
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 5b7e77a7c736..2595346d3aac 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -867,8 +867,18 @@ __SYSCALL(__NR_rseq_slice_yield, sys_rseq_slice_yield)
 #define __NR_fchroot 472
 __SYSCALL(__NR_fchroot, sys_fchroot)
 
+/* kernel/rootns.c */
+#define __NR_rootns_create 473
+__SYSCALL(__NR_rootns_create, sys_rootns_create)
+#define __NR_rootns_wait 474
+__SC_COMP(__NR_rootns_wait, sys_rootns_wait, compat_sys_rootns_wait)
+#define __NR_rootns_kill 475
+__SYSCALL(__NR_rootns_kill, sys_rootns_kill)
+#define __NR_rootns_enter 476
+__SYSCALL(__NR_rootns_enter, sys_rootns_enter)
+
 #undef __NR_syscalls
-#define __NR_syscalls 473
+#define __NR_syscalls 477
 
 /*
  * 32 bit systems traditionally used different
diff --git a/scripts/syscall.tbl b/scripts/syscall.tbl
index 0ab531605120..f0e6d70b5260 100644
--- a/scripts/syscall.tbl
+++ b/scripts/syscall.tbl
@@ -413,3 +413,7 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait			compat_sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
+476	common	rootns_enter			sys_rootns_enter
-- 
2.47.3

