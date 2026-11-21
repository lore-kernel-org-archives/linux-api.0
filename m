Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795219795;
	b=1fbSNBFf9HKQDr20tOuHFver5tfjSwVBwM+SSOt/Dqd5DZWyErzaJ8uTJAdbKs+T+Yow
	 PkULuypBjrQj5tSyjgMWULBIJsp+7CNq9EAsAtG3cCM7Hfoq/YAujV0HOsOM6V3qx0D71
	 OlQaGA0oOlc00RLcoiJQwX8HA6wQo8CBCLK7NiErUwYPLbas86g0X+RybwS93dcjOqrp5
	 g1Smh1IfhCgscM1D6jHINMbETVVX7Nm7SXoCwiP3VroEFZhroncFahBvK6aM9gAyHd9bi
	 Ohs9ZadeWAPssAnpEMwUqyfTi+rFaQNHMz6e/+97vfxLGiOfVRjs8EhYJiLCukW607w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795219795;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=hUPm8hcXsD5eOEjWcMgviJk+m28ETz0ZEKJMYNL1zxw=;
	b=BSR+cjIvZ8sSDN7heH3B2QiKoi0If5Bjs6XqyWcwrd0vcw84c7MLOypnfvlXVx+EsMnF
	 Z4W83BxA8djl2BgBWGICLqPpIcFHdvo1JeFL91atcXpt2ZZ5epgrQus+II/s48bqvnVAY
	 tNqXxqpt6CP9ato2tHBK5NVa1qWMltsMfkKy3aYH/Tu8z4llWreLbTgNYfbOm3kujNPYU
	 E72WQUowJxKCwxnpOTFDEQSAUnDZQt7vNbecpU8TeOMl0DWL27Q8/qY8mWbMp2eY0OhST
	 9+p1y+z2Ta8BFWN0b1n3N62DvhdQFqPsiyktVjI3t3wXRHBj4VYuGGPqutc7mjUjHWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GZ7QEq8W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id D5C1D60A2618;
	Sat, 21 Nov 2026 00:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GZ7QEq8W
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 20BBB1F000EE;
	Sat, 21 Nov 2026 00:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219795;
	bh=hUPm8hcXsD5eOEjWcMgviJk+m28ETz0ZEKJMYNL1zxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GZ7QEq8W4PyqW/qT6hinM44l4wrZpmfeOC9JOLKK2k6wKiN0e1qfZqkzP0UeGB91T
	 FjWoocLZlUeY8+VY37AuOxfG4t7/QzYtAmFvcXZ6H2I7b1qkFxUq+87V6A1XX3h3KE
	 fMsWln9AAQyWd2q0sZpQ0IsDZDZTyyWktN4kghO43q10fKlnRXGzJomJbPQg1Rbz7G
	 DP9i0NkXw3jSZUIHsTs0dtNfsJoSgiLX4ERp86rnP5yosVsCesjlJEDyNBTK6xG5b5
	 xS+z19fkG0n0gvRxR2mZxvxqNjkdeF6J8JgbmTA4zN5twSFDiWPGatBmO2Yn4ArTzQ
	 tnyqYo9ce+gvg==
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
Subject: [RFC PATCH v5 14/25] rootns: Add ROOTNS_WAIT ioctl
Date: Sat, 21 Nov 2026 02:08:33 +0200
Message-ID: <20261121000844.1863324-15-jarkko@kernel.org>
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
 include/uapi/linux/rootns.h | 26 +++++++++++++++++++++
 kernel/rootns.c             | 46 +++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)

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
index 5d59fc9a591d..cb74ddc8363c 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -117,6 +117,47 @@ static long rootns_get_nsfd(struct rootns *rootns, unsigned long nstype)
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
+	if (!pidns_is_ancestor(rootns->ns->pid_ns_for_children, pid_ns))
+		return -ECHILD;
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
@@ -124,6 +165,8 @@ static long rootns_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	switch (cmd) {
 	case ROOTNS_GET_NSFD:
 		return rootns_get_nsfd(rootns, arg);
+	case ROOTNS_WAIT:
+		return rootns_wait(rootns, (void __user *)arg);
 	default:
 		return -ENOIOCTLCMD;
 	}
@@ -134,6 +177,8 @@ static long rootns_compat_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
 	switch (cmd) {
+	case ROOTNS_WAIT:
+		return rootns_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
 	case ROOTNS_GET_NSFD:
 		return rootns_ioctl(file, cmd, arg);
 	default:
@@ -328,3 +373,4 @@ SYSCALL_DEFINE1(rootns, unsigned int, flags)
 
 	return fd;
 }
+
-- 
2.47.3

