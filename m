Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030588;
	b=jHgRXgmUyaACG5MWskV0VKmeqjYWn1xfwQzvw5lSJqEdwxntyIEMw8Y6oa+Vl77zfnLz
	 oh+0BUa3UaJJm2YXnlZj4XyJCriEtLLU9MB6DnT9RuQslxnP3IBccpmhL3dnEeaTV/TGe
	 /x4V6dTcJXI1BeBUy7EQiWxPiR22JHCVlunHSiBSiTDhNNUZOQSXIbZc7rZmc9Jyd1DbY
	 AHy/gaoyVTqy8rK5sK1Vl9bBrbP0OLygQeJnOFHu3bIfUOs7uzCoLKSCxY84xO92F5kK4
	 NGi+28iqYM9XvpIMKGqIsg26PPRG7+4LunRIs6fQeMuKal8/2eKHxpdG6VnwBSd4Kxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=RLySXlw2qkGSikQZcqQu4v/kKS57qhr6tNuPuE+peRQ=;
	b=My1rnNNCrAJJKjK0sTfKj9jxVEpuaSCQCtd+i54acLuxPIdq/CipMp75ANv3LsbueMDt
	 5PDA98MV4QmaBn7WeSUCwMVgg55y3Ipp3cvXVV+2B5z58BcU+REfx49m+AjDwvO08ah6I
	 G7zhQypuscfLSDkXhGUJd8MTVQQxbPgTto32BxuuD9YDIAqDn/0Qso8bg0FFQkuyOJM/g
	 RmCKccGi78gJMN3bjie61DZfWmWvvXOQU3eeG8p5iBySJQpWv7h6roRbCJAfjDfaPkCZN
	 EgqCNJaAgkWkKLzJLYASBvJch29wys+BW4k4m3z9EYg5Z1zXp0edWZ2EcysGQmkFLPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eDLBJCLq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id ADD25606DD23;
	Wed, 18 Nov 2026 19:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eDLBJCLq
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 97DDE1F000CE;
	Wed, 18 Nov 2026 19:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795030588;
	bh=RLySXlw2qkGSikQZcqQu4v/kKS57qhr6tNuPuE+peRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eDLBJCLqJZOJm6cw53EhFns4WkXQwt2jO2vrFHmGVWFB8SHeoqhP9ECawkioY/t43
	 FKoNMLI/B6NBAWq27Ycu6C8uQD3kiiOnDjUxmkSS1GUMVLwwxuhuqhlYOMct7uBjqu
	 J+PiTUrI6SYxSVQm+0g9xFfXZNSnzIaPi4898N8NSO51faXl9cYNpYgTi0NIH/emdp
	 eUJJX5wY7Nn2jqixOtSicGV+7Be+BgNjxsuDoMFGG6genRuaHNr3vgJsIedtMfk/AB
	 XT+9ODK9nizQ7zek5NC/2fVsdcAWB05Igm7aA1iCC46D6v3Bfw8kU5d8/BplUluMYM
	 fnyVoc2NpEeyw==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
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
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v3 10/13] arch: Wire up rootns system calls
Date: Wed, 18 Nov 2026 21:35:36 +0200
Message-ID: <20261118193539.240065-11-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118193539.240065-1-jarkko@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
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
(474), and rootns_kill() (475) across all architecture system call
tables and asm-generic unistd.h.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/alpha/kernel/syscalls/syscall.tbl      |  3 +++
 arch/arm/tools/syscall.tbl                  |  3 +++
 arch/arm64/tools/syscall_32.tbl             |  3 +++
 arch/m68k/kernel/syscalls/syscall.tbl       |  3 +++
 arch/microblaze/kernel/syscalls/syscall.tbl |  3 +++
 arch/mips/kernel/syscalls/syscall_n32.tbl   |  3 +++
 arch/mips/kernel/syscalls/syscall_n64.tbl   |  3 +++
 arch/mips/kernel/syscalls/syscall_o32.tbl   |  3 +++
 arch/parisc/kernel/syscalls/syscall.tbl     |  3 +++
 arch/powerpc/kernel/syscalls/syscall.tbl    |  3 +++
 arch/s390/kernel/syscalls/syscall.tbl       |  3 +++
 arch/sh/kernel/syscalls/syscall.tbl         |  3 +++
 arch/sparc/kernel/syscalls/syscall.tbl      |  3 +++
 arch/x86/entry/syscalls/syscall_32.tbl      |  3 +++
 arch/x86/entry/syscalls/syscall_64.tbl      |  3 +++
 arch/xtensa/kernel/syscalls/syscall.tbl     |  3 +++
 include/uapi/asm-generic/unistd.h           | 10 +++++++++-
 scripts/syscall.tbl                         |  3 +++
 18 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/syscalls/syscall.tbl
index 52e3538cc7df..c7bec286deff 100644
--- a/arch/alpha/kernel/syscalls/syscall.tbl
+++ b/arch/alpha/kernel/syscalls/syscall.tbl
@@ -512,3 +512,6 @@
 580	common	listns				sys_listns
 581	common	rseq_slice_yield		sys_rseq_slice_yield
 582	common	fchroot				sys_fchroot
+583	common	rootns_create			sys_rootns_create
+584	common	rootns_wait			sys_rootns_wait
+585	common	rootns_kill			sys_rootns_kill
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index 55717ed32c27..59f78bf991c9 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -487,3 +487,6 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
diff --git a/arch/arm64/tools/syscall_32.tbl b/arch/arm64/tools/syscall_32.tbl
index df2d1d82fb3c..8ef57696c6a8 100644
--- a/arch/arm64/tools/syscall_32.tbl
+++ b/arch/arm64/tools/syscall_32.tbl
@@ -484,3 +484,6 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait		compat_sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
diff --git a/arch/m68k/kernel/syscalls/syscall.tbl b/arch/m68k/kernel/syscalls/syscall.tbl
index ba7a4d8903d0..36eb16ae659f 100644
--- a/arch/m68k/kernel/syscalls/syscall.tbl
+++ b/arch/m68k/kernel/syscalls/syscall.tbl
@@ -472,3 +472,6 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl b/arch/microblaze/kernel/syscalls/syscall.tbl
index 76d7cbe2a133..54739d61a9ee 100644
--- a/arch/microblaze/kernel/syscalls/syscall.tbl
+++ b/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -478,3 +478,6 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index 9ae88e4eac61..f0a58c6b4516 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -411,3 +411,6 @@
 470	n32	listns				sys_listns
 471	n32	rseq_slice_yield		sys_rseq_slice_yield
 472	n32	fchroot				sys_fchroot
+473	n32	rootns_create			sys_rootns_create
+474	n32	rootns_wait			compat_sys_rootns_wait
+475	n32	rootns_kill			sys_rootns_kill
diff --git a/arch/mips/kernel/syscalls/syscall_n64.tbl b/arch/mips/kernel/syscalls/syscall_n64.tbl
index 83dc93a0712f..c1d2774c6283 100644
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -387,3 +387,6 @@
 470	n64	listns				sys_listns
 471	n64	rseq_slice_yield		sys_rseq_slice_yield
 472	n64	fchroot				sys_fchroot
+473	n64	rootns_create			sys_rootns_create
+474	n64	rootns_wait			sys_rootns_wait
+475	n64	rootns_kill			sys_rootns_kill
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 9c62429c9b7b..99a753234dbf 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -460,3 +460,6 @@
 470	o32	listns				sys_listns
 471	o32	rseq_slice_yield		sys_rseq_slice_yield
 472	o32	fchroot				sys_fchroot
+473	o32	rootns_create			sys_rootns_create
+474	o32	rootns_wait			sys_rootns_wait			compat_sys_rootns_wait
+475	o32	rootns_kill			sys_rootns_kill
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index 88adc4016cce..f3bac8085491 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -471,3 +471,6 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait			compat_sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index cfbb70039ff0..7ab1948f76b7 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -563,3 +563,6 @@
 470	common	listns				sys_listns
 471	nospu	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	nospu	rootns_create			sys_rootns_create
+474	nospu	rootns_wait			sys_rootns_wait			compat_sys_rootns_wait
+475	nospu	rootns_kill			sys_rootns_kill
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index 1b45e68a217b..7f8cd4147860 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -399,3 +399,6 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
diff --git a/arch/sh/kernel/syscalls/syscall.tbl b/arch/sh/kernel/syscalls/syscall.tbl
index ace068dff0de..9bfcb96dcdeb 100644
--- a/arch/sh/kernel/syscalls/syscall.tbl
+++ b/arch/sh/kernel/syscalls/syscall.tbl
@@ -476,3 +476,6 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index 5b9fe0e8140f..a847f4cbea3a 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -518,3 +518,6 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait			compat_sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 2c172ef48dfd..e49c96692038 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -478,3 +478,6 @@
 470	i386	listns			sys_listns
 471	i386	rseq_slice_yield	sys_rseq_slice_yield
 472	i386	fchroot			sys_fchroot
+473	i386	rootns_create		sys_rootns_create
+474	i386	rootns_wait		sys_rootns_wait		compat_sys_rootns_wait
+475	i386	rootns_kill		sys_rootns_kill
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index d5b6045b0090..d6f7fb7be172 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -397,6 +397,9 @@
 470	common	listns			sys_listns
 471	common	rseq_slice_yield	sys_rseq_slice_yield
 472	common	fchroot			sys_fchroot
+473	common	rootns_create		sys_rootns_create
+474	common	rootns_wait		sys_rootns_wait
+475	common	rootns_kill		sys_rootns_kill
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/arch/xtensa/kernel/syscalls/syscall.tbl b/arch/xtensa/kernel/syscalls/syscall.tbl
index d354bb231796..268c0d577788 100644
--- a/arch/xtensa/kernel/syscalls/syscall.tbl
+++ b/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -443,3 +443,6 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 5b7e77a7c736..571db09eb571 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -867,8 +867,16 @@ __SYSCALL(__NR_rseq_slice_yield, sys_rseq_slice_yield)
 #define __NR_fchroot 472
 __SYSCALL(__NR_fchroot, sys_fchroot)
 
+/* kernel/rootns.c */
+#define __NR_rootns_create 473
+__SYSCALL(__NR_rootns_create, sys_rootns_create)
+#define __NR_rootns_wait 474
+__SC_COMP(__NR_rootns_wait, sys_rootns_wait, compat_sys_rootns_wait)
+#define __NR_rootns_kill 475
+__SYSCALL(__NR_rootns_kill, sys_rootns_kill)
+
 #undef __NR_syscalls
-#define __NR_syscalls 473
+#define __NR_syscalls 476
 
 /*
  * 32 bit systems traditionally used different
diff --git a/scripts/syscall.tbl b/scripts/syscall.tbl
index 0ab531605120..e9ff99c03b2b 100644
--- a/scripts/syscall.tbl
+++ b/scripts/syscall.tbl
@@ -413,3 +413,6 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait			compat_sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
-- 
2.47.3

