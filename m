Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CE442D75D;
	Thu, 16 Jul 2026 14:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213149; cv=pass; b=G6XUWhQTRysC3pB4/mhk5cfqRqV07FPQ8o9VNLvX8IQyX91dBL1Y/KZuIplGmfW/oQUnuAq0GvfNMYVTDkPXNDz/Oi6HMtqu3mJYxdzWIf8EiY6gorYZlmpJ/1FkmCcDCJ/FKaFbHmDlqyHm4Dq3kjo+P3X9pKLt6PteeW3Qirw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213149; c=relaxed/simple;
	bh=Osuwk/F3F1ktFhji/dpepPwgY5gy/hCoBX+aYqvbGIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvyeL1p7S4oSmwOMR4UDe48oIGj1n/lahMoVTmzn8AfY2oofJUfGKbDRod7x7j707xx0WmiTJU2JnyD5gkI3hBHN+v4kVGipYX7Q+SVzCnlAEEmbwQTG/RAiDTl7H7PxXP0VMS8LwvfFvrWjOcpaFB6eUoS96RYqRf3YgQZq/SE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=mACiqZj1; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="mACiqZj1"
ARC-Seal: i=1; a=rsa-sha256; t=1784212550; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=JduyLb3z7uuZZIJZ/tG0Z6jN9XDjUExC/qvVKxwFUtJdijdpmAGGXX2igRxnJRNtp1KiGWvbhfWiSGv8tQhUwPg4qXGgqLV9H1InoXgATIjl/B5ipwYI0t3obyv5YPyrcFPhhOoTpxj2lp2LQEuB0Tri13MWZdF/UWcgoFxaHig=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212550; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=qdqO/dqsF7yjZrH4mg7qpw1lf9OYQ69PUl21BjI0kUE=; 
	b=jcyjrgoqasGbc8y4GB6LkaqE3TWMjVAXvKl2dAy/eF0aoStzCvI1VFkqqZDdCltojGgg3nS0W+jUE2I/ky+w5wqf1ZnymFCgyota9rucOFwReqdn6iOwmqaKb4xdih9zN+SQe7b5cDSb40UcdyS2DYa9TD6UOiKPY27hK8LtuHw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212550;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=qdqO/dqsF7yjZrH4mg7qpw1lf9OYQ69PUl21BjI0kUE=;
	b=mACiqZj1Qjc+gUj8Ys01AfNp6e12wk1ed/pzwjDhkRJERJYp6TCmd38aQFgoTXgt
	kyLlaxBZCMWmXSPX3sLCXpJTjIUAoKqcaX75aVly9Erb10J1FRqk1O9OxLIIf7tDHjE
	TJVjevIqIMB4M+95XXLCggMqNK+q6HWCUq962sFQ=
Received: by mx.zohomail.com with SMTPS id 1784212547429642.3160082187562;
	Thu, 16 Jul 2026 07:35:47 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Gabriel Krisman Bertazi <krisman@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	audit@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH 22/24] pidfd: expose spawn builder system calls
Date: Thu, 16 Jul 2026 22:31:48 +0800
Message-ID: <08700c80bff699de86def3904a5b6e91d09ffe19.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

The preceding commits define the future-pidfd lifetime, configuration, and
run state machine without making them reachable from userspace. Each
preparatory step therefore remains bisectable without exposing a partial
process builder.

Make pidfd_open(0, PIDFD_EMPTY) create a taskless future pidfd and expose
pidfd_config() and pidfd_spawn_run(). Add the syscall declarations and
table entries together so the complete initial interface becomes reachable
at one commit boundary. Synchronize the lagging arm64 AArch32 perf mirror
through the current syscall table while adding the builder entries.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 arch/alpha/kernel/syscalls/syscall.tbl        |  2 ++
 arch/arm/tools/syscall.tbl                    |  2 ++
 arch/arm64/tools/syscall_32.tbl               |  2 ++
 arch/m68k/kernel/syscalls/syscall.tbl         |  2 ++
 arch/microblaze/kernel/syscalls/syscall.tbl   |  2 ++
 arch/mips/kernel/syscalls/syscall_n32.tbl     |  2 ++
 arch/mips/kernel/syscalls/syscall_n64.tbl     |  2 ++
 arch/mips/kernel/syscalls/syscall_o32.tbl     |  2 ++
 arch/parisc/kernel/syscalls/syscall.tbl       |  2 ++
 arch/powerpc/kernel/syscalls/syscall.tbl      |  2 ++
 arch/s390/kernel/syscalls/syscall.tbl         |  2 ++
 arch/sh/kernel/syscalls/syscall.tbl           |  2 ++
 arch/sparc/kernel/syscalls/syscall.tbl        |  2 ++
 arch/x86/entry/syscalls/syscall_32.tbl        |  2 ++
 arch/x86/entry/syscalls/syscall_64.tbl        |  2 ++
 arch/xtensa/kernel/syscalls/syscall.tbl       |  2 ++
 include/linux/syscalls.h                      |  7 +++++++
 include/uapi/asm-generic/unistd.h             |  8 +++++++-
 kernel/pid.c                                  | 19 ++++++++++++++++++-
 scripts/syscall.tbl                           |  2 ++
 tools/include/uapi/asm-generic/unistd.h       |  8 +++++++-
 .../arch/alpha/entry/syscalls/syscall.tbl     |  2 ++
 .../perf/arch/arm/entry/syscalls/syscall.tbl  |  2 ++
 .../arch/arm64/entry/syscalls/syscall_32.tbl  | 11 +++++++++++
 .../arch/mips/entry/syscalls/syscall_n64.tbl  |  2 ++
 .../arch/parisc/entry/syscalls/syscall.tbl    |  2 ++
 .../arch/powerpc/entry/syscalls/syscall.tbl   |  2 ++
 .../perf/arch/s390/entry/syscalls/syscall.tbl |  2 ++
 tools/perf/arch/sh/entry/syscalls/syscall.tbl |  2 ++
 .../arch/sparc/entry/syscalls/syscall.tbl     |  2 ++
 .../arch/x86/entry/syscalls/syscall_32.tbl    |  2 ++
 .../arch/x86/entry/syscalls/syscall_64.tbl    |  2 ++
 .../arch/xtensa/entry/syscalls/syscall.tbl    |  2 ++
 tools/scripts/syscall.tbl                     |  2 ++
 34 files changed, 108 insertions(+), 3 deletions(-)

diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/syscalls/syscall.tbl
index f31b7afffc345..8dd0b22a407c5 100644
--- a/arch/alpha/kernel/syscalls/syscall.tbl
+++ b/arch/alpha/kernel/syscalls/syscall.tbl
@@ -511,3 +511,5 @@
 579	common	file_setattr			sys_file_setattr
 580	common	listns				sys_listns
 581	common	rseq_slice_yield		sys_rseq_slice_yield
+582	common	pidfd_config			sys_pidfd_config
+583	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index 94351e22bfcf7..9830c4600fc78 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -486,3 +486,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/arm64/tools/syscall_32.tbl b/arch/arm64/tools/syscall_32.tbl
index 62d93d88e0fef..9c3281b3612c2 100644
--- a/arch/arm64/tools/syscall_32.tbl
+++ b/arch/arm64/tools/syscall_32.tbl
@@ -483,3 +483,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/m68k/kernel/syscalls/syscall.tbl b/arch/m68k/kernel/syscalls/syscall.tbl
index 2489342571014..2db719475e061 100644
--- a/arch/m68k/kernel/syscalls/syscall.tbl
+++ b/arch/m68k/kernel/syscalls/syscall.tbl
@@ -471,3 +471,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl b/arch/microblaze/kernel/syscalls/syscall.tbl
index 223d263036272..41ead93dba5c4 100644
--- a/arch/microblaze/kernel/syscalls/syscall.tbl
+++ b/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -477,3 +477,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index 7430714e2b8f8..b6bfca9ddedc6 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -410,3 +410,5 @@
 469	n32	file_setattr			sys_file_setattr
 470	n32	listns				sys_listns
 471	n32	rseq_slice_yield		sys_rseq_slice_yield
+472	n32	pidfd_config			sys_pidfd_config
+473	n32	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/mips/kernel/syscalls/syscall_n64.tbl b/arch/mips/kernel/syscalls/syscall_n64.tbl
index 630aab9e54259..229a1a5bff0e9 100644
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -386,3 +386,5 @@
 469	n64	file_setattr			sys_file_setattr
 470	n64	listns				sys_listns
 471	n64	rseq_slice_yield		sys_rseq_slice_yield
+472	n64	pidfd_config			sys_pidfd_config
+473	n64	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 128653112284b..4ee804186e399 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -459,3 +459,5 @@
 469	o32	file_setattr			sys_file_setattr
 470	o32	listns				sys_listns
 471	o32	rseq_slice_yield		sys_rseq_slice_yield
+472	o32	pidfd_config			sys_pidfd_config
+473	o32	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index c6331dad94613..ff6760df2dc51 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -470,3 +470,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index 4fcc7c58a105d..021b334a8e1a0 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -562,3 +562,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	nospu	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index 09a7ef04d9791..eea88f94a7624 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -398,3 +398,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/sh/kernel/syscalls/syscall.tbl b/arch/sh/kernel/syscalls/syscall.tbl
index 70b315cbe710c..37166286c4045 100644
--- a/arch/sh/kernel/syscalls/syscall.tbl
+++ b/arch/sh/kernel/syscalls/syscall.tbl
@@ -475,3 +475,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index 7e71bf7fcd14f..70f2165b9cfb3 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -517,3 +517,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index f832ebd2d79b0..b2eeddbe99be9 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -477,3 +477,5 @@
 469	i386	file_setattr		sys_file_setattr
 470	i386	listns			sys_listns
 471	i386	rseq_slice_yield	sys_rseq_slice_yield
+472	i386	pidfd_config		sys_pidfd_config
+473	i386	pidfd_spawn_run		sys_pidfd_spawn_run
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 524155d655da1..f0952f34c10a5 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -396,6 +396,8 @@
 469	common	file_setattr		sys_file_setattr
 470	common	listns			sys_listns
 471	common	rseq_slice_yield	sys_rseq_slice_yield
+472	common	pidfd_config		sys_pidfd_config
+473	common	pidfd_spawn_run		sys_pidfd_spawn_run
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/arch/xtensa/kernel/syscalls/syscall.tbl b/arch/xtensa/kernel/syscalls/syscall.tbl
index a9bca4e484dec..45dd80ab94cf9 100644
--- a/arch/xtensa/kernel/syscalls/syscall.tbl
+++ b/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -442,3 +442,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 874d9067a43b5..ec90454d01214 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -79,6 +79,7 @@ struct mnt_id_req;
 struct ns_id_req;
 struct xattr_args;
 struct file_attr;
+struct pidfd_spawn_run_args;
 
 #include <linux/types.h>
 #include <linux/aio_abi.h>
@@ -908,6 +909,12 @@ asmlinkage long sys_clock_adjtime32(clockid_t which_clock,
 asmlinkage long sys_syncfs(int fd);
 asmlinkage long sys_setns(int fd, int nstype);
 asmlinkage long sys_pidfd_open(pid_t pid, unsigned int flags);
+asmlinkage long sys_pidfd_config(int fd, unsigned int cmd,
+				 const char __user *key,
+				 const void __user *value, int aux);
+asmlinkage long sys_pidfd_spawn_run(int fd,
+				    const struct pidfd_spawn_run_args __user *uargs,
+				    size_t usize);
 asmlinkage long sys_sendmmsg(int fd, struct mmsghdr __user *msg,
 			     unsigned int vlen, unsigned flags);
 asmlinkage long sys_process_vm_readv(pid_t pid,
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index a627acc8fb5fe..9ab8ae5100ec1 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -863,8 +863,14 @@ __SYSCALL(__NR_listns, sys_listns)
 #define __NR_rseq_slice_yield 471
 __SYSCALL(__NR_rseq_slice_yield, sys_rseq_slice_yield)
 
+#define __NR_pidfd_config 472
+__SYSCALL(__NR_pidfd_config, sys_pidfd_config)
+
+#define __NR_pidfd_spawn_run 473
+__SYSCALL(__NR_pidfd_spawn_run, sys_pidfd_spawn_run)
+
 #undef __NR_syscalls
-#define __NR_syscalls 472
+#define __NR_syscalls 474
 
 /*
  * 32 bit systems traditionally used different
diff --git a/kernel/pid.c b/kernel/pid.c
index 010f80177cac8..a1d05ce10ac25 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -43,6 +43,7 @@
 #include <linux/sched/task.h>
 #include <linux/idr.h>
 #include <linux/pidfs.h>
+#include <linux/pidfd_spawn.h>
 #include <net/sock.h>
 #include <uapi/linux/pidfd.h>
 
@@ -715,10 +716,26 @@ SYSCALL_DEFINE2(pidfd_open, pid_t, pid, unsigned int, flags)
 	int fd;
 	struct pid *p;
 
+	/*
+	 * pidfd_open(0, PIDFD_EMPTY) is the spawn-builder entry point.
+	 * It creates a future pidfd instead of looking up pid 0.
+	 */
+	if (pid == 0) {
+		if (!(flags & PIDFD_EMPTY))
+			return -EINVAL;
+		if (flags & ~(PIDFD_EMPTY | PIDFD_NONBLOCK))
+			return -EINVAL;
+
+		return pidfd_empty_open(flags & PIDFD_NONBLOCK);
+	}
+
+	/* PIDFD_EMPTY is only meaningful for the pid == 0 builder form. */
+	if (flags & PIDFD_EMPTY)
+		return -EINVAL;
 	if (flags & ~(PIDFD_NONBLOCK | PIDFD_THREAD))
 		return -EINVAL;
 
-	if (pid <= 0)
+	if (pid < 0)
 		return -EINVAL;
 
 	p = find_get_pid(pid);
diff --git a/scripts/syscall.tbl b/scripts/syscall.tbl
index 7a42b32b65776..29248f0ac1a07 100644
--- a/scripts/syscall.tbl
+++ b/scripts/syscall.tbl
@@ -412,3 +412,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/tools/include/uapi/asm-generic/unistd.h b/tools/include/uapi/asm-generic/unistd.h
index a627acc8fb5fe..9ab8ae5100ec1 100644
--- a/tools/include/uapi/asm-generic/unistd.h
+++ b/tools/include/uapi/asm-generic/unistd.h
@@ -863,8 +863,14 @@ __SYSCALL(__NR_listns, sys_listns)
 #define __NR_rseq_slice_yield 471
 __SYSCALL(__NR_rseq_slice_yield, sys_rseq_slice_yield)
 
+#define __NR_pidfd_config 472
+__SYSCALL(__NR_pidfd_config, sys_pidfd_config)
+
+#define __NR_pidfd_spawn_run 473
+__SYSCALL(__NR_pidfd_spawn_run, sys_pidfd_spawn_run)
+
 #undef __NR_syscalls
-#define __NR_syscalls 472
+#define __NR_syscalls 474
 
 /*
  * 32 bit systems traditionally used different
diff --git a/tools/perf/arch/alpha/entry/syscalls/syscall.tbl b/tools/perf/arch/alpha/entry/syscalls/syscall.tbl
index 74720667fe091..a20f81b950349 100644
--- a/tools/perf/arch/alpha/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/alpha/entry/syscalls/syscall.tbl
@@ -502,3 +502,5 @@
 570	common	lsm_set_self_attr		sys_lsm_set_self_attr
 571	common	lsm_list_modules		sys_lsm_list_modules
 572	common  mseal				sys_mseal
+582	common	pidfd_config			sys_pidfd_config
+583	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/tools/perf/arch/arm/entry/syscalls/syscall.tbl b/tools/perf/arch/arm/entry/syscalls/syscall.tbl
index 94351e22bfcf7..9830c4600fc78 100644
--- a/tools/perf/arch/arm/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/arm/entry/syscalls/syscall.tbl
@@ -486,3 +486,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/tools/perf/arch/arm64/entry/syscalls/syscall_32.tbl b/tools/perf/arch/arm64/entry/syscalls/syscall_32.tbl
index 9a37930d4e26f..9c3281b3612c2 100644
--- a/tools/perf/arch/arm64/entry/syscalls/syscall_32.tbl
+++ b/tools/perf/arch/arm64/entry/syscalls/syscall_32.tbl
@@ -474,3 +474,14 @@
 460	common	lsm_set_self_attr		sys_lsm_set_self_attr
 461	common	lsm_list_modules		sys_lsm_list_modules
 462	common	mseal				sys_mseal
+463	common	setxattrat			sys_setxattrat
+464	common	getxattrat			sys_getxattrat
+465	common	listxattrat			sys_listxattrat
+466	common	removexattrat			sys_removexattrat
+467	common	open_tree_attr			sys_open_tree_attr
+468	common	file_getattr			sys_file_getattr
+469	common	file_setattr			sys_file_setattr
+470	common	listns				sys_listns
+471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/tools/perf/arch/mips/entry/syscalls/syscall_n64.tbl b/tools/perf/arch/mips/entry/syscalls/syscall_n64.tbl
index 630aab9e54259..229a1a5bff0e9 100644
--- a/tools/perf/arch/mips/entry/syscalls/syscall_n64.tbl
+++ b/tools/perf/arch/mips/entry/syscalls/syscall_n64.tbl
@@ -386,3 +386,5 @@
 469	n64	file_setattr			sys_file_setattr
 470	n64	listns				sys_listns
 471	n64	rseq_slice_yield		sys_rseq_slice_yield
+472	n64	pidfd_config			sys_pidfd_config
+473	n64	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/tools/perf/arch/parisc/entry/syscalls/syscall.tbl b/tools/perf/arch/parisc/entry/syscalls/syscall.tbl
index 66dc406b12e44..88311785913f8 100644
--- a/tools/perf/arch/parisc/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/parisc/entry/syscalls/syscall.tbl
@@ -461,3 +461,5 @@
 460	common	lsm_set_self_attr		sys_lsm_set_self_attr
 461	common	lsm_list_modules		sys_lsm_list_modules
 462	common	mseal				sys_mseal
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl b/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
index 4fcc7c58a105d..021b334a8e1a0 100644
--- a/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
@@ -562,3 +562,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	nospu	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/tools/perf/arch/s390/entry/syscalls/syscall.tbl b/tools/perf/arch/s390/entry/syscalls/syscall.tbl
index 09a7ef04d9791..eea88f94a7624 100644
--- a/tools/perf/arch/s390/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/s390/entry/syscalls/syscall.tbl
@@ -398,3 +398,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/tools/perf/arch/sh/entry/syscalls/syscall.tbl b/tools/perf/arch/sh/entry/syscalls/syscall.tbl
index 70b315cbe710c..37166286c4045 100644
--- a/tools/perf/arch/sh/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/sh/entry/syscalls/syscall.tbl
@@ -475,3 +475,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/tools/perf/arch/sparc/entry/syscalls/syscall.tbl b/tools/perf/arch/sparc/entry/syscalls/syscall.tbl
index 7e71bf7fcd14f..70f2165b9cfb3 100644
--- a/tools/perf/arch/sparc/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/sparc/entry/syscalls/syscall.tbl
@@ -517,3 +517,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/tools/perf/arch/x86/entry/syscalls/syscall_32.tbl b/tools/perf/arch/x86/entry/syscalls/syscall_32.tbl
index f832ebd2d79b0..b2eeddbe99be9 100644
--- a/tools/perf/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/tools/perf/arch/x86/entry/syscalls/syscall_32.tbl
@@ -477,3 +477,5 @@
 469	i386	file_setattr		sys_file_setattr
 470	i386	listns			sys_listns
 471	i386	rseq_slice_yield	sys_rseq_slice_yield
+472	i386	pidfd_config		sys_pidfd_config
+473	i386	pidfd_spawn_run		sys_pidfd_spawn_run
diff --git a/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl b/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
index 524155d655da1..f0952f34c10a5 100644
--- a/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
@@ -396,6 +396,8 @@
 469	common	file_setattr		sys_file_setattr
 470	common	listns			sys_listns
 471	common	rseq_slice_yield	sys_rseq_slice_yield
+472	common	pidfd_config		sys_pidfd_config
+473	common	pidfd_spawn_run		sys_pidfd_spawn_run
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/tools/perf/arch/xtensa/entry/syscalls/syscall.tbl b/tools/perf/arch/xtensa/entry/syscalls/syscall.tbl
index a9bca4e484dec..45dd80ab94cf9 100644
--- a/tools/perf/arch/xtensa/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/xtensa/entry/syscalls/syscall.tbl
@@ -442,3 +442,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
diff --git a/tools/scripts/syscall.tbl b/tools/scripts/syscall.tbl
index 7a42b32b65776..29248f0ac1a07 100644
--- a/tools/scripts/syscall.tbl
+++ b/tools/scripts/syscall.tbl
@@ -412,3 +412,5 @@
 469	common	file_setattr			sys_file_setattr
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
+472	common	pidfd_config			sys_pidfd_config
+473	common	pidfd_spawn_run			sys_pidfd_spawn_run
-- 
2.52.0

