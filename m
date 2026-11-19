Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795128228;
	b=AopE9VAAE+XOWHkenynzAYfyD7Oc9GRlB7XH5Utl6w1JICt9TqOiMoEd22xXrCtXX49j
	 iDPQD7ammetMPm0jxW9lwK9ZHTqj0IgmN4hvmTVtiZPfwtshBD83cNo44RsqqKDw1JMR0
	 8ZK0HzMN4+YcRfoBAlcM02hF/OxSYNUs5Gq5Ghv9IXIRkjbhafcixsaQYF80puk1Zw4rB
	 Q9XbDFwVtk9QKMz+0+DiWXFssr1HLPfnQRgD+G5PxmnJTzY9yGElS0QwbOZV/elX4d+1b
	 VptChxEfXSirvDCKGqkCbi0gK+jzGZ/MMQ/KlMi1WYNL2794pDgnDXKNfAWIyApRDag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795128228;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=pvt4UdkTTYjUIPq8QfDpabIaPIEN39yMkMxUWezMv3k=;
	b=bgKAY/+YEC7eoZJwYL//LM9Y58wgzBopr18GwOs2sAEs/pI6efkJXXrqsSdRboQvd3rF
	 avWUH17RS1Y9mfYZykZNswrocKL/kklouomquvpK6mzj3qL6HYprJY7jb7M+IhYGKmRmP
	 MKXZZy+n21HUdstyN0r/5bYi9Y/ZUPFtC53AJahjjJ76p3waSmlT5NpKya45Na/rd10Mt
	 ZYXnK6Yox+IBHleTvk48fhkySSs71MGzcv8H/AfKGaLkpHoyBBVMgkcIEQC0SiD+jDrp+
	 X5kZpmGJ3kFhCV5/9bMCS6kJtD399De48980gG9J5IgFyNBWgeS0KNfty+gBu5zznog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eItWyBT5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 32A91606A330;
	Thu, 19 Nov 2026 22:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eItWyBT5
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0CA801F000D0;
	Thu, 19 Nov 2026 22:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795128227;
	bh=pvt4UdkTTYjUIPq8QfDpabIaPIEN39yMkMxUWezMv3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eItWyBT5ZdpDkT/I1avp8bM2iwRFREJ28upAbQocTOq9oR/vvmpxIMP/CGsmOJDvK
	 n4rHqscsmVlhKzVBpxu+kVVMxc+UJAaf8axjlWGkC7fRRVDfDLel7NBaNkWSStnYrO
	 IBAC+KfV61XDnildwpzGxlqH4CCcOqgQcos4kUcwRiG3BAKvQA1X7vDR2BGm1uF8WB
	 YbLDH0avww85AxPKEpjOmOgsfVZgEJ9V4itxc6LGpk+1Jy8h3J9/g1xpb2Ili2AZCK
	 /bhQGlmvclP+uFBYWLr0Q78ijvDQxRBbluKGugPjU+bNsZTZoHzqbwFE11aRGSOSF9
	 W1VgrTW6OY1Fg==
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
Subject: [RFC PATCH v4 04/14] rootns: Add rootns() system call
Date: Fri, 20 Nov 2026 00:43:02 +0200
Message-ID: <20261119224312.1037966-5-jarkko@kernel.org>
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

Setting up an isolated namespace environment from a multithreaded
manager process currently requires helper processes to call unshare()
and pass file descriptors back over sockets.

Add the rootns() system call to allocate a detached rootns instance
owning a fresh user namespace alongside dedicated empty mount
(CLONE_EMPTY_MNTNS), PID, UTS, IPC, network, cgroup, and time
namespaces, and return its control file descriptor. Finalize the nsproxy
time namespace and pin active references for the lifetime of the rootns.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/syscalls.h       |   1 +
 include/linux/time_namespace.h |  13 ++++
 kernel/rootns.c                | 106 +++++++++++++++++++++++++++++++++
 kernel/sys_ni.c                |   3 +
 4 files changed, 123 insertions(+)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 552d9710a0d5..7e630b612ef2 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1006,6 +1006,7 @@ asmlinkage long sys_lsm_get_self_attr(unsigned int attr, struct lsm_ctx __user *
 asmlinkage long sys_lsm_set_self_attr(unsigned int attr, struct lsm_ctx __user *ctx,
 				      u32 size, u32 flags);
 asmlinkage long sys_lsm_list_modules(u64 __user *ids, u32 __user *size, u32 flags);
+asmlinkage long sys_rootns(unsigned int flags);
 
 /*
  * Architecture-specific system calls
diff --git a/include/linux/time_namespace.h b/include/linux/time_namespace.h
index 58bd9728df58..bdc185543893 100644
--- a/include/linux/time_namespace.h
+++ b/include/linux/time_namespace.h
@@ -60,6 +60,15 @@ static inline void put_time_ns(struct time_namespace *ns)
 		free_time_ns(ns);
 }
 
+static inline void timens_activate_nsproxy(struct nsproxy *nsproxy)
+{
+	if (nsproxy->time_ns != nsproxy->time_ns_for_children) {
+		get_time_ns(nsproxy->time_ns_for_children);
+		put_time_ns(nsproxy->time_ns);
+		nsproxy->time_ns = nsproxy->time_ns_for_children;
+	}
+}
+
 void proc_timens_show_offsets(struct task_struct *p, struct seq_file *m);
 
 struct proc_timens_offset {
@@ -125,6 +134,10 @@ static inline void put_time_ns(struct time_namespace *ns)
 {
 }
 
+static inline void timens_activate_nsproxy(struct nsproxy *nsproxy)
+{
+}
+
 static inline
 struct time_namespace *copy_time_ns(u64 flags,
 				    struct user_namespace *user_ns,
diff --git a/kernel/rootns.c b/kernel/rootns.c
index bde7cf4baebe..d9ef68d603a2 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -221,3 +221,109 @@ void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk)
 	wake_up_poll(&c->waitq, EPOLLHUP);
 	put_rootns(c);
 }
+
+static struct user_namespace *create_rootns_user_ns(void)
+{
+	struct user_namespace *user_ns;
+	struct cred *new;
+	int ret;
+
+	new = prepare_creds();
+	if (!new)
+		return ERR_PTR(-ENOMEM);
+
+	ret = create_user_ns(new);
+	if (ret < 0) {
+		abort_creds(new);
+		return ERR_PTR(ret);
+	}
+
+	user_ns = get_user_ns(new->user_ns);
+	abort_creds(new);
+	return user_ns;
+}
+
+/*
+ * Create a new rootns.
+ */
+static struct rootns *create_rootns(unsigned int flags)
+{
+	u64 clone_flags = CLONE_NEWNS | CLONE_EMPTY_MNTNS | CLONE_NEWPID |
+			  CLONE_NEWCGROUP | CLONE_NEWUTS | CLONE_NEWIPC |
+			  CLONE_NEWNET |
+			  (IS_ENABLED(CONFIG_TIME_NS) ? CLONE_NEWTIME : 0);
+	struct user_namespace *user_ns;
+	struct nsproxy *ns;
+	struct rootns *c;
+	int ret;
+
+	c = kzalloc_obj(*c, GFP_KERNEL);
+	if (!c)
+		return ERR_PTR(-ENOMEM);
+
+	init_waitqueue_head(&c->waitq);
+	spin_lock_init(&c->lock);
+	refcount_set(&c->usage, 1);
+	c->flags = flags;
+
+	user_ns = create_rootns_user_ns();
+	if (IS_ERR(user_ns)) {
+		ret = PTR_ERR(user_ns);
+		goto err_put;
+	}
+	c->user_ns = user_ns;
+	ns_ref_active_get(user_ns);
+
+	if (!ns_capable(user_ns, CAP_SYS_ADMIN)) {
+		ret = -EPERM;
+		goto err_put;
+	}
+
+	ns = create_new_namespaces(clone_flags, current->nsproxy, user_ns,
+				   NULL);
+	if (IS_ERR(ns)) {
+		ret = PTR_ERR(ns);
+		goto err_put;
+	}
+
+	timens_activate_nsproxy(ns);
+	c->ns = ns;
+	nsproxy_ns_active_get(ns);
+
+	return c;
+
+err_put:
+	put_rootns(c);
+	return ERR_PTR(ret);
+}
+
+/**
+ * sys_rootns - Create a detached root namespace
+ * @flags: Combination of &enum rootns_flags values
+ *
+ * Allocate a detached root namespace owning a fresh user namespace and
+ * dedicated empty mount, PID, UTS, IPC, network, cgroup, and time namespaces.
+ *
+ * Return: Control file descriptor on success, negative error code on failure.
+ */
+SYSCALL_DEFINE1(rootns, unsigned int, flags)
+{
+	struct rootns *c;
+	int fd;
+
+	if (flags & ~ROOTNS_ALL_FLAGS)
+		return -EINVAL;
+	if (unlikely(!current->nsproxy))
+		return -EOPNOTSUPP;
+
+	c = create_rootns(flags);
+	if (IS_ERR(c))
+		return PTR_ERR(c);
+
+	fd = anon_inode_getfd("rootns", &rootns_fops, c,
+			      O_RDWR | (flags & ROOTNS_CLOSE_ON_EXEC ? O_CLOEXEC : 0));
+	if (fd < 0)
+		put_rootns(c);
+
+	return fd;
+}
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index c8be0abaa407..9fba98f15a20 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -398,3 +398,6 @@ COND_SYSCALL(rseq_slice_yield);
 
 COND_SYSCALL(uretprobe);
 COND_SYSCALL(uprobe);
+
+/* kernel/rootns.c */
+COND_SYSCALL(rootns);
-- 
2.47.3

