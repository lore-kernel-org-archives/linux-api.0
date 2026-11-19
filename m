Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795128224;
	b=atNIR0l9n+an7JrDlRSAE/d3HsnsfOl48c1CtMj0N4Ck6hv973RXvuxlBnVPqAhLlAAT
	 86kLgYtkJRZh+mRoz5uUl5M2BfRZOwa2g5rsJK8SiCIVdf/3oA8sjvbR6VWEwY5vG6uST
	 jAkap2i+Y5BZaF6a/DFKKeLxbuD5olw9PorSlXSLiCrGJdt9bJMvqWJZs3Wbz/XE2OzaX
	 4D5nm7yOGkYPxxGnrZ19ladgDSJagSy9jZHf7zBRCk/+XZJhaSY3E2pG2kQMrkqeK/dbJ
	 Lw+uJH3iRCyJmtOTdO1dA2OtI3Y+lfibN9Hk/lAKV5u8GpGNHI13l1PbJtAAnpPP7Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795128224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=zRQovrukGv04cJ+t7fEPlO9r8OAb8ireDPkh8aF4iko=;
	b=PvYzvykLOIUO3ht60Kj2puEwId+SbyXhdr78xcTdITVLz2izKrF/7ozAm/SvfU3SYrC+
	 ixQMcrcpFqrgSO0N3hu/bdQHMBhcWHNNm1T5KGb71DwRNth1qd130S2gIPA9KUs9h+Y/Q
	 O6WViVpE4NnM0Dq4/iOpeMmbDP6jb6cUDf3FbP3vmfekam7mWjYRhuf0OuQ82+cO+5vGb
	 R39xImHHz4NxKSIsAdAO44kIDEU8qLaLiYOMq+dQ3Cgc6YKAQJBZH4QW6Wd/GLQju9499
	 9w47pLxARA0mlULY0cls473xrZIPW0uqg7XFJ/ExG9qc8mXzQJ+sMjiOFB7OyvinEDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IqAmwIAD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 380D360A2607;
	Thu, 19 Nov 2026 22:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IqAmwIAD
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1444F1F000C6;
	Thu, 19 Nov 2026 22:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795128223;
	bh=zRQovrukGv04cJ+t7fEPlO9r8OAb8ireDPkh8aF4iko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IqAmwIADSCvztT4Xn5UwJrs8o5NaXnyeHoN0NceR94mxjJtP2Ow8aOP7YOjZyXGfJ
	 OFWly6MoIVQK86qBzpj57ETRgv3ZdXjULpBBNzh0qHnfqfxXRi1yc+R/bwaSsvCBU1
	 LQdrUFTCpcp2YKRXovU5VVGtljsldJ3CvAzCHpxCl4crYnVJEfnajIlZCOkiylRRVj
	 wPJ2wn9THlW/zIXMvk+APK0dUC6DJXDqAjWbbsCKSFDt2KCBLEDk8ybBHu1e9vqMWn
	 n55aNTP5IQtAZ8mO4KyGIeoNVZrfMPWXSFOptCjotNs/q6nL1I0YvGRdkGf+IG2CZN
	 2hG47lWkJCO6A==
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
Subject: [RFC PATCH v4 03/14] rootns: Track init lifecycle via copy_process() and pid_namespace
Date: Fri, 20 Nov 2026 00:43:01 +0200
Message-ID: <20261119224312.1037966-4-jarkko@kernel.org>
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

A root namespace needs to record its init thread group's PID when
bootstrapped and capture its exit status once all processes in the root
namespace have terminated, without serializing normal fork() and exit()
paths inside the container.

Commit the bootstrap child reaper, bind pid_ns->rootns, and wake waiters
in copy_rootns() after attach_pid(PIDTYPE_PID), and invoke exit_rootns()
from zap_pid_ns_processes() after the root namespace's PID namespace has
killed and reaped all member tasks.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/pid_namespace.h |  4 ++++
 include/linux/rootns.h        | 15 ++++++++++++++
 kernel/fork.c                 |  3 +++
 kernel/pid_namespace.c        |  2 ++
 kernel/rootns.c               | 38 +++++++++++++++++++++++++++++++++++
 5 files changed, 62 insertions(+)

diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index b20baaa7e62b..6fd959f4d0d4 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -15,6 +15,7 @@
 #define MAX_PID_NS_LEVEL 32
 
 struct fs_pin;
+struct rootns;
 
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_MEMFD_CREATE)
 /* modes for vm.memfd_noexec sysctl */
@@ -45,6 +46,9 @@ struct pid_namespace {
 	struct user_namespace *user_ns;
 	struct ucounts *ucounts;
 	int reboot;	/* group exit code if this pidns was rebooted */
+#ifdef CONFIG_ROOTNS
+	struct rootns *rootns;
+#endif
 	struct ns_common ns;
 	struct work_struct	work;
 } __randomize_layout;
diff --git a/include/linux/rootns.h b/include/linux/rootns.h
index 3f59415efadb..0557ce75195d 100644
--- a/include/linux/rootns.h
+++ b/include/linux/rootns.h
@@ -13,6 +13,8 @@
 struct file;
 struct nsproxy;
 struct pid;
+struct pid_namespace;
+struct task_struct;
 struct user_namespace;
 
 enum rootns_state {
@@ -41,6 +43,9 @@ struct rootns {
 struct rootns *get_rootns(struct rootns *c);
 void put_rootns(struct rootns *c);
 bool is_rootns_file(struct file *file);
+void copy_rootns(struct task_struct *tsk, struct pid *pid,
+		 struct rootns *rootns);
+void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk);
 #else
 static inline struct rootns *get_rootns(struct rootns *c)
 {
@@ -55,6 +60,16 @@ static inline bool is_rootns_file(struct file *file)
 {
 	return false;
 }
+
+static inline void copy_rootns(struct task_struct *tsk, struct pid *pid,
+			       struct rootns *rootns)
+{
+}
+
+static inline void exit_rootns(struct pid_namespace *pid_ns,
+			       struct task_struct *tsk)
+{
+}
 #endif /* CONFIG_ROOTNS */
 
 #endif /* _LINUX_ROOTNS_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 5efceb8d58a7..08fc28ad1eed 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -83,6 +83,7 @@
 #include <linux/fs_struct.h>
 #include <linux/magic.h>
 #include <linux/perf_event.h>
+#include <linux/rootns.h>
 #include <linux/posix-timers.h>
 #include <linux/user-return-notifier.h>
 #include <linux/oom.h>
@@ -2576,6 +2577,8 @@ __latent_entropy struct task_struct *copy_process(
 					  &p->signal->thread_head);
 		}
 		attach_pid(p, PIDTYPE_PID);
+		if (thread_group_leader(p))
+			copy_rootns(p, pid, NULL);
 		nr_threads++;
 	}
 	total_forks++;
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 127a5fd23e70..081c27aa85bd 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -24,6 +24,7 @@
 #include <linux/sched/signal.h>
 #include <linux/idr.h>
 #include <linux/nstree.h>
+#include <linux/rootns.h>
 #include <uapi/linux/wait.h>
 #include "pid_sysctl.h"
 
@@ -280,6 +281,7 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 		current->signal->group_exit_code = pid_ns->reboot;
 
 	acct_exit_ns(pid_ns);
+	exit_rootns(pid_ns, me);
 	return;
 }
 
diff --git a/kernel/rootns.c b/kernel/rootns.c
index 3bbf7677080e..bde7cf4baebe 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -183,3 +183,41 @@ bool is_rootns_file(struct file *file)
 {
 	return file->f_op == &rootns_fops;
 }
+
+void copy_rootns(struct task_struct *tsk, struct pid *pid, struct rootns *c)
+{
+	if (likely(!c || !is_child_reaper(pid)))
+		return;
+
+	scoped_guard(spinlock, &c->lock) {
+		if (c->state != ROOTNS_FORKING)
+			return;
+		ns_of_pid(pid)->rootns = get_rootns(c);
+		WRITE_ONCE(c->init_pid, get_pid(pid));
+		WRITE_ONCE(c->state, ROOTNS_RUNNING);
+	}
+	wake_up_all(&c->waitq);
+}
+
+void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk)
+{
+	struct rootns *c = pid_ns->rootns;
+	struct task_struct *leader;
+	int status;
+
+	if (!c)
+		return;
+
+	leader = tsk->group_leader;
+	status = (tsk->signal->flags & SIGNAL_GROUP_EXIT) ?
+		 tsk->signal->group_exit_code : leader->exit_code;
+
+	scoped_guard(spinlock, &c->lock) {
+		c->exit_code = status;
+		WRITE_ONCE(c->state, ROOTNS_DEAD);
+	}
+
+	pid_ns->rootns = NULL;
+	wake_up_poll(&c->waitq, EPOLLHUP);
+	put_rootns(c);
+}
-- 
2.47.3

