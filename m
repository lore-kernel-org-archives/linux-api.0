Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795128236;
	b=FAj9GBV/zIaw3blejQQOMbBWm/qFX1p7OfaG9W9e8A1Zb0Ry5j58edylf4OSinObrAO1
	 YifS344TCy4511QTVHVmHaSMsUqaWJSeR2eAsiKwOjeK2FKXZh5w7jhnHEF4KpeTlVJWz
	 JJdlR1YSBdHSBW3dNoMuogqNFhcYzG32lsLDld+CRaeVs8+eCjh4nLCFn5C3Rjz5Ery7x
	 Qx0q/GsMeoqz8VlplEFMmcd6wW202nOrAeDVF2lhihalRU9mgS/FuJbiOBUS21f8TQve8
	 ybIsgALaRmWBTEF9kfsULuY6eLEVHJguzqc5UpqKz202fFunAcaY6g7kIp0KBprVJrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795128236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=VgOViuFvQ1WLBdTgeo0xBwSjxxf619C+mTR7GkYLz0I=;
	b=iGAbKP5LVKixMtRwBp9QS/tDMq8fjJPLWXDY+RoqSQZAXK8IyLxyKiKNap2tanHo7c1s
	 fiieoF9iNSJxtOS4flgaIwr7qPCMjCSjcmuklFikKkOTIqeF71S5bFAKEOv+OLxstWGsW
	 m6bGzLvbaA8cOKxS7jkFG3uiW4KUzCudGmxhwT1oGoQxsXE09kLNgrXyYRSNwHBbm9t1j
	 WIIDA/aLlcJY/GfQ3w6lkAmThJFPtxGIr9j2MdPl/iIsqNwKHj1v0eNwvJKw1o2GFjV82
	 6g+SVmS60HqZ8EOJHCGEb4SlkpkQKG6yfF/vU4fScgkmvJoOW05uk8nXDkU+nlN9PkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HC8W9Wjx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 2387460A2616;
	Thu, 19 Nov 2026 22:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HC8W9Wjx
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0F42C1F000EF;
	Thu, 19 Nov 2026 22:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795128235;
	bh=VgOViuFvQ1WLBdTgeo0xBwSjxxf619C+mTR7GkYLz0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HC8W9WjxhO4iHCFx5ER3+ZmW2t7L+2P4zUurqe98F/Lvvhw8xIi1zCmlHrOVbm/81
	 kQQauMVeRfBsEspfcxnerySlinGDiwTyxXGoXNt4eTwin6LReM70QBdaeB0k31MTQS
	 wghGogcrqFKCmL7Q+6qsLbjGoYeZeMgB36JY1UkqUAup23NwLQWNvUI74t++Np2flf
	 /NSSESeDRIzNzPSLfh3bZwiG+xilQwJz8T9qfYEJZGRml/MvWnKCqWrxYkYCpwCTkH
	 Sy33ZPrHxWaECiltE4d3JNTsN9FL2SpMblL/W84E9WqTX0lmWT6hCeOpPqstxJz3HH
	 IsmM7K7tfV3zA==
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
Subject: [RFC PATCH v4 06/14] rootns: Add ROOTNS_KILL ioctl
Date: Fri, 20 Nov 2026 00:43:04 +0200
Message-ID: <20261119224312.1037966-7-jarkko@kernel.org>
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

Signaling every process inside a container from userspace via /proc is
racy against concurrent fork() calls.

Add the ROOTNS_KILL ioctl to require an ancestor active PID namespace,
walk the root namespace's PID namespace IDR under tasklist_lock, and
deliver a validated signal once to each thread group including in-flight
forks, aggregating per-process delivery results.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/uapi/linux/rootns.h | 13 ++++++++++
 kernel/rootns.c             | 52 +++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/include/uapi/linux/rootns.h b/include/uapi/linux/rootns.h
index 3fd215185398..acd91d895c63 100644
--- a/include/uapi/linux/rootns.h
+++ b/include/uapi/linux/rootns.h
@@ -67,4 +67,17 @@ struct rootns_wait_args {
  */
 #define ROOTNS_WAIT		_IOWR(ROOTNS_IOCTL_MAGIC, 0x02, struct rootns_wait_args)
 
+/**
+ * DOC: ROOTNS_KILL
+ *
+ * ``ioctl(rootnsfd, ROOTNS_KILL, sig)`` walks the target root namespace's PID
+ * namespace IDR under ``tasklist_lock`` and delivers ``sig`` (or ``0`` for a
+ * permission check) once to each member thread group.
+ *
+ * Returns ``0`` if at least one thread group was signaled, or ``-1`` with
+ * ``errno`` set to ``EXDEV`` if the caller's active PID namespace is not an
+ * ancestor or ``ESRCH`` if the ``rootns`` is not running or has no members.
+ */
+#define ROOTNS_KILL		_IO(ROOTNS_IOCTL_MAGIC, 0x03)
+
 #endif /* _UAPI_LINUX_ROOTNS_H */
diff --git a/kernel/rootns.c b/kernel/rootns.c
index 5f03b6ba4a54..ce012a07e982 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -154,6 +154,53 @@ static long rootns_wait(struct rootns *rootns, void __user *uarg)
 	return ret;
 }
 
+static int rootns_kill_members(struct rootns *rootns, int sig)
+{
+	struct pid_namespace *pid_ns = rootns->ns->pid_ns_for_children;
+	bool any_success = false;
+	bool any_other = false;
+	bool any_perm = false;
+	int other_err = 0;
+	struct pid *pid;
+	int nr;
+
+	if (!pidns_is_ancestor(pid_ns, task_active_pid_ns(current)))
+		return -EXDEV;
+	if (READ_ONCE(rootns->state) != ROOTNS_RUNNING)
+		return -ESRCH;
+
+	scoped_guard(rcu) {
+		read_lock(&tasklist_lock);
+		idr_for_each_entry(&pid_ns->idr, pid, nr) {
+			struct task_struct *task = pid_task(pid, PIDTYPE_TGID);
+			int err;
+
+			if (!task)
+				continue;
+
+			err = group_send_sig_info(sig, SEND_SIG_NOINFO, task,
+						  PIDTYPE_MAX);
+			if (!err) {
+				any_success = true;
+			} else if (err == -EPERM) {
+				any_perm = true;
+			} else if (err != -ESRCH && !any_other) {
+				any_other = true;
+				other_err = err;
+			}
+		}
+		read_unlock(&tasklist_lock);
+	}
+
+	if (any_success)
+		return 0;
+	if (any_other)
+		return other_err;
+	if (any_perm)
+		return -EPERM;
+	return -ESRCH;
+}
+
 static long rootns_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct rootns *rootns = file->private_data;
@@ -163,6 +210,10 @@ static long rootns_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return rootns_get_nsfd(rootns, arg);
 	case ROOTNS_WAIT:
 		return rootns_wait(rootns, (void __user *)arg);
+	case ROOTNS_KILL:
+		if (arg > INT_MAX || !valid_signal(arg))
+			return -EINVAL;
+		return rootns_kill_members(rootns, arg);
 	default:
 		return -ENOIOCTLCMD;
 	}
@@ -176,6 +227,7 @@ static long rootns_compat_ioctl(struct file *file, unsigned int cmd,
 	case ROOTNS_WAIT:
 		return rootns_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
 	case ROOTNS_GET_NSFD:
+	case ROOTNS_KILL:
 		return rootns_ioctl(file, cmd, arg);
 	default:
 		return -ENOIOCTLCMD;
-- 
2.47.3

