Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795219800;
	b=vqxU6Xx0fLHYPcJNbw3Ed78wAmeEovyMjN4JD1PejPGhrlzBduOCQRii24vRTrH2RRz3
	 0EyzxV/fAhMm36gEHpilfPFfpSMTLsQ4VWv3RIZhVGPX9QcRpcsldhsajcQb3w/etXICr
	 XkqH4/Znm6ZSMPgkqFXXG7Dt+7dOQEH9SaeDcWYCw9gXRTCB18ZqLouGC2KDeH248xagB
	 jEatvyqlb5OxpsnqfPn5XHc35Jsr5VBF7JcC+Z1uHCDwxAoqT9HehZigGvf5iOlawzSZL
	 f6J9E4ttb6ByK1TKJZNY2XAKSaJbyPrJVbsqh9QVTKgPydEv++extzvJ9lqWETAzLWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795219800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=SNImKxX2bLw9d/2f70sP1UeR26evmgWSkqbTpNpXbl0=;
	b=uLQsODbdn8MuSOm02XlyyoKlOhZ4XG8khJ3jhFLrDQW5l67rCOkzHhCK5ylTGh7Qi2Q8
	 GO/76ZfwUzgCRKJX2n5g4lrW/jj9buQFmy5YFf42BOOiBH8c1+kyGxI5kaP8i+fQ1qz97
	 v4OhvP2ZBq0t4bO4ehqPAk032+c2fdA+hXoO6AUQDgVXgR1dp+jj+FpZVL2ie4aDnc2zh
	 bnpkinzbEv6daIn9XkzTVS88dQ+5ECrsJtwkRVWGbbNmn9TR7Cc/0SYgW+djgkJLd+/dt
	 Y75W+rjZaTNLMi3p24d5s1y3otzso3ZFn48EuCdcnduELtbV1VmOr1O+PCNE2H/pcRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EVH5lsyK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 8362C606A6BF;
	Sat, 21 Nov 2026 00:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EVH5lsyK
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9EDEB1F000C4;
	Sat, 21 Nov 2026 00:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219800;
	bh=SNImKxX2bLw9d/2f70sP1UeR26evmgWSkqbTpNpXbl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EVH5lsyKLLdg413PMHFk2R7SN0jI2u3gI5FXbU2jXZ8Kk1zm14WIaDl1QeVkhyKVm
	 WxbQUFopy0FWxT4TgoEoRtnlUAX3TLCu+aFi5on9wm1I3Hcx6dGKwz8Qmggyeai9b6
	 L8MLxik4JpuLPdHm+vMUmd9nkDjp0+P4xVgWsbNewpi9xdTH72gjjHDQLFaaqUyxvF
	 mRwtqmnUtXn+HaIbC55u9AgHhjuzcWI1BE2LMwHQkNkoDSjV/EAaDKbn87+SQ794dJ
	 6QpYOKvthuoKdt8nQP9A5DnfXguVCI6mKaHMeRTIsxecXEDH3yc+UiwObPl3tgSwzE
	 QGg53Xuc81eBA==
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
Subject: [RFC PATCH v5 15/25] rootns: Add ROOTNS_KILL ioctl
Date: Sat, 21 Nov 2026 02:08:34 +0200
Message-ID: <20261121000844.1863324-16-jarkko@kernel.org>
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
index cb74ddc8363c..5ae975604571 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -158,6 +158,53 @@ static long rootns_wait(struct rootns *rootns, void __user *uarg)
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
@@ -167,6 +214,10 @@ static long rootns_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
@@ -180,6 +231,7 @@ static long rootns_compat_ioctl(struct file *file, unsigned int cmd,
 	case ROOTNS_WAIT:
 		return rootns_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
 	case ROOTNS_GET_NSFD:
+	case ROOTNS_KILL:
 		return rootns_ioctl(file, cmd, arg);
 	default:
 		return -ENOIOCTLCMD;
-- 
2.47.3

