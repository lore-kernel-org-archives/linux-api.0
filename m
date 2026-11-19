Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795128232;
	b=CTPN9L0bs2GCwMl2RZcvVhk0ciNhd5VMrA2TTGJIBUoQE3cgxoTWOhg+F97IYmeCpu+Y
	 SXdKfYgarZ41P0E9DM8fkxUSBltKfJ9GdW9KzVQIA3/SODjBmtt+Ld6miujCgPCkzsHEo
	 /JSv+mf7phPwG3PtAqUg68QYbEbCI726xwKAs35lx0uwyctiTxQ4t9yOW22fwfq0bDeGx
	 3o3ViqHkeTDrZT+J6h/8azV5QJFzNKedYO61nMknhoqy7eHBePgNxzuBNbC9z1uQEG2T1
	 0SObBpLfIzFEZlGAOjzDS1nNXvH8sFj+QWhF7qMzyA4zsuCB78a9heqaJXJxwxQrqjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795128232;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=PPc6X12QD2WGk+0rx20RHiBwFPirneFugf7ZxndZfj4=;
	b=lPf7zqE1Ig/eyqnsRaWhDG/KbP5zBsiOFEcVw/f05Jl/DVGj6i2/kqAJd1OrVYsbme7G
	 JFKqg/SqUO4fBrW9X5fTrAm33X2thq5usJKV9nyEBmK0LvbFe/9k14oC08LM4hRKA7Uon
	 FsvJ2yPhQgyaGEawuSlJtdLM8CRuar8/Ow2tmwE4jhCeyZugP4OX+Cr4NitwvnA2NdPBs
	 ZiAB8TVaq+8Di2+Gn15CbLXdhcHRIOPkE52MsoHDDxxWdOJfqw1y0UnlNuBPC2HqFMQUK
	 YvVBUZyZTr8NbdWbl+UcR0rqR+5WExYKq4F0qhsB7Dut2CydmCIuHF522eDyr7eLcwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nls9+NC+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 210D0606A325;
	Thu, 19 Nov 2026 22:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nls9+NC+
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E9D5D1F000C6;
	Thu, 19 Nov 2026 22:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795128231;
	bh=PPc6X12QD2WGk+0rx20RHiBwFPirneFugf7ZxndZfj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nls9+NC+jPxJH+ylhTtYG2RiRETSIYO+HjpUXY9ef4CcJxkDE4CkPLHxHdDUW2Tmj
	 752KbGp0rM99OWj5cyTa3wSxeelbeRoB78h0qW1yErVRDU1I1+Ud43kPcUQiDijFMH
	 HCiZeURym1/VTQJ3Ewob1zRPOMUIiakm1SipjrDUzO0Z6sfGqzXa30wu5zkrnX7dsp
	 it4NxW5Z+GetL0aBY8tAas+aPg46L7FMI/M3eUGUkgDDF3eZ5E+Tq1VuUe2fYurSMP
	 OZIkNr0BU1GNEJfvJlyVXrAe4LEUj4rnODSc1MejhGXa9CQFYAwM1VRp9wwp8nsVbB
	 UM2WYYdP8rTAw==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Andy Lutomirski <luto@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Ben Segall <bsegall@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Chris Zankel <chris@zankel.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	"Hallgrimur H. Gunnarsson" <halg@google.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Matt Turner <mattst88@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Mel Gorman <mgorman@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Moore <paul@paul-moore.com>,
	Paul Walmsley <pjw@kernel.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Rich Felker <dalias@libc.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Serge Hallyn <sergeh@kernel.org>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v4 05/14] rootns: Add ROOTNS_WAIT ioctl
Date: Fri, 20 Nov 2026 00:43:03 +0200
Message-ID: <20261119224312.1037966-6-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261119224312.1037966-1-jarkko@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
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

wait4() and waitid() only allow a parent or subreaper to collect exit
status, so an external manager holding a rootns file descriptor cannot
wait on a rootns init process forked by another process or observe exit
status multiple times across observers.

Add the ROOTNS_WAIT ioctl and struct rootns_wait_args to wait freezably
and interruptibly on a rootns file descriptor until its init thread group
exits and report the recorded wait status. Return the init TGID
translated into the caller's active PID namespace, 0 for WNOHANG while
running, or -ECHILD if init was never started or is not visible to the
caller.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/uapi/linux/rootns.h | 26 ++++++++++++++++++++++
 kernel/rootns.c             | 44 +++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/include/uapi/linux/rootns.h b/include/uapi/linux/rootns.h
index bd643bdfb43c..3fd215185398 100644
--- a/include/uapi/linux/rootns.h
+++ b/include/uapi/linux/rootns.h
@@ -8,6 +8,7 @@
 #define _UAPI_LINUX_ROOTNS_H
 
 #include <linux/ioctl.h>
+#include <linux/types.h>
 
 /**
  * enum rootns_flags - Flags for rootns()
@@ -24,6 +25,16 @@ enum rootns_flags {
 	ROOTNS_ALL_FLAGS	= 0x00000003,
 };
 
+/**
+ * struct rootns_wait_args - Arguments for %ROOTNS_WAIT
+ * @flags: Wait options (0 or %WNOHANG).
+ * @status: Output wait status of rootns init in waitpid(2) format.
+ */
+struct rootns_wait_args {
+	__u32 flags;
+	__s32 status;
+};
+
 #define ROOTNS_IOCTL_MAGIC	0xB9
 
 /**
@@ -41,4 +52,19 @@ enum rootns_flags {
  */
 #define ROOTNS_GET_NSFD		_IO(ROOTNS_IOCTL_MAGIC, 0x01)
 
+/**
+ * DOC: ROOTNS_WAIT
+ *
+ * ``ioctl(rootnsfd, ROOTNS_WAIT, &args)`` waits interruptibly (unless
+ * ``WNOHANG`` is set in ``args.flags``) until ``rootnsfd`` reaches
+ * ``ROOTNS_DEAD``, then writes the recorded exit status of ``rootns`` init
+ * into ``args.status``.
+ *
+ * Returns the caller-visible TGID of ``rootns`` init on success, ``0`` if
+ * ``WNOHANG`` is set and the ``rootns`` has not terminated, or ``-1`` with
+ * ``errno`` set to ``ECHILD`` if init was never started or is not visible in
+ * the caller's active PID namespace.
+ */
+#define ROOTNS_WAIT		_IOWR(ROOTNS_IOCTL_MAGIC, 0x02, struct rootns_wait_args)
+
 #endif /* _UAPI_LINUX_ROOTNS_H */
diff --git a/kernel/rootns.c b/kernel/rootns.c
index d9ef68d603a2..5f03b6ba4a54 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -115,6 +115,45 @@ static long rootns_get_nsfd(struct rootns *rootns, unsigned long nstype)
 	return nsproxy_open_namespace(rootns->ns, rootns->user_ns, nstype);
 }
 
+static long rootns_wait(struct rootns *rootns, void __user *uarg)
+{
+	struct pid_namespace *pid_ns = task_active_pid_ns(current);
+	struct rootns_wait_args args;
+	long ret;
+
+	if (!uarg)
+		return -EINVAL;
+	if (copy_from_user(&args, uarg, sizeof(args)))
+		return -EFAULT;
+	if (args.flags & ~WNOHANG)
+		return -EINVAL;
+	if (READ_ONCE(rootns->state) == ROOTNS_INIT)
+		return -ECHILD;
+
+	if (!(args.flags & WNOHANG)) {
+		ret = wait_event_freezable(rootns->waitq,
+					   READ_ONCE(rootns->state) == ROOTNS_DEAD ||
+					   READ_ONCE(rootns->state) == ROOTNS_INIT);
+		if (ret)
+			return ret;
+	}
+
+	scoped_guard(spinlock, &rootns->lock) {
+		if (rootns->state == ROOTNS_INIT)
+			return -ECHILD;
+		if (rootns->state != ROOTNS_DEAD)
+			return 0;
+		ret = pid_nr_ns(rootns->init_pid, pid_ns);
+		if (ret <= 0)
+			return -ECHILD;
+		args.status = rootns->exit_code;
+	}
+
+	if (copy_to_user(uarg, &args, sizeof(args)))
+		return -EFAULT;
+	return ret;
+}
+
 static long rootns_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct rootns *rootns = file->private_data;
@@ -122,6 +161,8 @@ static long rootns_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	switch (cmd) {
 	case ROOTNS_GET_NSFD:
 		return rootns_get_nsfd(rootns, arg);
+	case ROOTNS_WAIT:
+		return rootns_wait(rootns, (void __user *)arg);
 	default:
 		return -ENOIOCTLCMD;
 	}
@@ -132,6 +173,8 @@ static long rootns_compat_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
 	switch (cmd) {
+	case ROOTNS_WAIT:
+		return rootns_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
 	case ROOTNS_GET_NSFD:
 		return rootns_ioctl(file, cmd, arg);
 	default:
@@ -327,3 +370,4 @@ SYSCALL_DEFINE1(rootns, unsigned int, flags)
 
 	return fd;
 }
+
-- 
2.47.3

