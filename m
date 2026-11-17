Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794929023;
	b=CNCbBj1tkmMbGqwu+KX3OECmfodGexYY9gLv4hT3qcjP7C6u6g6AIOp2RhOfKXr0SCBg
	 oMxQukWO8U+FBqn3RVQREfVi5G/8fMuRniZOv4qviwIZK3QrMG9KaNab4+JAq8AEBiRpK
	 7AwzP5oHoUmbQH9bp6LZKSV0uhL3rgxZyNKw4xOh/51ZjgvCw6PSQeRwHI9RRFOq3iE8e
	 RPUYNY7at8swdEzLBOcZpd7lgxo4vyQTYNzOkmCphSlCE3cubczo42mO/rFHZMOK0SXFB
	 2pXdQ+RkIzxAHC5xVgxrU5vEnxtUO4osUqtnKnMY9KktFSNINxz/tVnalgPqTKIEFiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794929023;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Ofm5M00KSieqbiSYXgLgnUfya5lLhDxnmUYEkWnouA8=;
	b=HwnXL1ljqDnbvlwZNFunb/bScYDa+EoL/MvA2UzjhlKZNUJd48Nm/UU083DJ10BZnz3b
	 OonqhuaMjHA/KWteOr85l7LLdltRrbYMmRHy3xJ7rZZcnzHUpsZR+dBLM3QJqrGHFU1Sz
	 +g6j7z8840F52+ZPlkciAu5PyNner6hj4NmsbQdizhhP0y6kSGOG6RRrKBosqQh0xpqRS
	 Q3ZS/MFnEPE10nYb/YH6j1E6kr6F4JVXhQ9JQXUPN9qAEKFl8WV91t7G9evvOCk5LUmxC
	 jjiQKEom8hOzyaQuZGW8O6k5RHY/qxKV1M9kqplcQDOFDzKuHSdFnTlqv3juK9HYiuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XV3bc96W;
	arc=none smtp.remote-ip=209.85.214.178
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B4F606A31C
	for <linux-api@vger.kernel.org>; Tue, 17 Nov 2026 15:23:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55B4F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XV3bc96W
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2e9ae47b00cso2582915ad.3
        for <linux-api@vger.kernel.org>; Tue, 17 Nov 2026 07:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794929023; x=1795533823; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ofm5M00KSieqbiSYXgLgnUfya5lLhDxnmUYEkWnouA8=;
        b=XV3bc96Wca2hr4zPcYBq+6ILfG4SItRkT9ixosvgf8aLWT7sp4FRkWmuU5PygrAEGV
         Qcf0/PL4h/BapNu+C0n2NNeojaM6oeFadF7xNy303yiNtETTiWoLLuFlgELIniFSgdJK
         EmeUAMDRzabdoJbDza9DfpcqRaaTxdt5ftTzc0SQ471H38RStbjozBTtkuV5VXuVuj1L
         sUSku5rS+DdSqCPy4nwYQ5bciIETSOsxlJpzlZb9oqVjx0YFvgtFvlcUutP+2imTHHi5
         02aa1GWK+DapP4yFjaDL4i19YYOeDix1ZfFMG/aU2qsCLPxsvPLFIEjI6NTDcPXlw4FO
         +wow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794929023; x=1795533823;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ofm5M00KSieqbiSYXgLgnUfya5lLhDxnmUYEkWnouA8=;
        b=ogXViwnJmCy+2OoR1ynx+KvrpSBiJVHg9qHRQPMbH5G4w97cOv/Lw9uND6o8ICHDF1
         wXEaWhOmZylXh+3snkmhuBFpXOpLFZgLKX96dUgDZjoilRhsjBZDdDvw4UZk7DbQHhxC
         Fpooh20NDXB69HSH6+em7zfgsAAZ8X5bWSolQhygT2jmjr9XoAg+N9i513XAkCm5dp6q
         kCojpU8qoZBrdxatKybImTQH3P/HUCDH6mNzmUDqzVxxwd8z0SkWFHDVrq4XxWOHwq8p
         1pxewSKdI2jHtw34NIhVxIb0QKTj3zejObLPj2CPFIi8eBIxNqDQrtHAIaUeVILXGIsX
         4/Og==
X-Forwarded-Encrypted: i=1; AL+hErEtWurNW+S8bINUQguklg5nEk/vbegLnGCBZjY8bxOEpoTjsoVEEkPqvwIckpBwFhXcTyvTAiOxsVs=@vger.kernel.org
X-Gm-Message-State: APuU4Z+QQ8twyDBsKzDjFnSA5LMpHsRAf0yGHCkPHhnTpg6dR/yprlJh
	bBQ9APCA6r+RyLsVqL7BnXIL1v/EgUDIo7m076PHid/xKQ5xfGHzpzOd
X-Gm-Gg: AZFdTZf/bXrVtmkLwYYpLbr8O6N5mrqElLL3Pw3RTmAdpuAGe9upVBwvAK/uk5w3ooz
	pJux2HiFYPsKjpG1r6l4ytKv9+XngkTBz7Byhoa7Xu9+6J3XHdqpMYqgr9qaqiU5z75SpbyL38T
	i1h//JapwXVAvbBfWZLwU3LKs7xzY0jOZi7YzqiXFJQSgWYAltiCGlok5Oieqjf0zo96ys8CVU9
	ht3YKiEfOpyO0rgF8zdpd4LRl73ZatI0ldDOIzpGvIT6GchXn9H9HMel4pO4gYK1knEtZTLGhqK
	e5knu22x4ib2vY8EOXS2GhzKQVXLR+LptAb7eyLta8aDvf1mkTk0aGjtpI2mWprbYhB2S8R5c6o
	bR28xZGaz6vV6pHwLBMh+ByOz6R6tvYSFqa2G+AYEFsMI1Al3D353HBKcvG8SWqo9sS5VpKmIsY
	ItJqGcryQ1hGMy831fj/HpXYySlF/mOUFDWz2t8gNKGBmKy+N43TZbxu2R2yXmVz2urhRM59076
	2cF93cyKbslrYAdV6PmVM0q1tWfEQBmK5xMIz3kbVFZiMjf0cjf+pL7r2d3XBuKLEjCefbXIQ5h
	wdkRILr0oO4ize4o7r2UMazvvW12wX82mluqJr/n95R3HRfoL85XHNxLwejg4/32gkB8VPjQoXm
	IZz4=
X-Received: by 2002:a17:902:e852:b0:2ed:29a5:782d with SMTP id d9443c01a7336-2ee0dd0f21amr218160435ad.2.1794929022438;
        Tue, 17 Nov 2026 07:23:42 -0800 (PST)
Received: from DESKTOP-CJ1L666.localdomain ([211.198.99.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2efd7a11da1sm17810695ad.16.2026.11.17.07.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 07:23:42 -0800 (PST)
From: Jiwoo Kim <arpe1618@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Sargun Dhillon <sargun@sargun.me>,
	Arnd Bergmann <arnd@arndb.de>,
	Jann Horn <jannh@google.com>,
	Chen Linxuan <me@black-desk.cn>,
	linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] pidfd: restrict pidfd_getfd() to the caller's pid namespace
Date: Wed, 18 Nov 2026 00:23:32 +0900
Message-ID: <20261117152332.1221-1-arpe1618@gmail.com>
X-Mailer: git-send-email 2.43.0
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

pidfds can cross pid namespace boundaries: a task can obtain one for a
process outside of its own pid namespace hierarchy through SO_PASSPIDFD
or SO_PEERPIDFD, via SCM_RIGHTS, or through file descriptor
inheritance.

Commit ee8323fdc827 ("pidfd: restrict task access ioctls to the caller's
pid namespace") made the pidfs namespace ioctls fail with -EREMOTE
unless the target is visible in the caller's active pid namespace, as
PIDFD_GET_INFO already does, following the rule that operations which
grant access to additional resources of the target require this [1].

pidfd_getfd() grants access to the target's open files, but it only
performs the ptrace access check, which does not take the pid namespace
relationship between the caller and the target into account. With the
caller in a child pid namespace and in the same user namespace as the
target, PIDFD_GET_INFO and PIDFD_GET_UTS_NAMESPACE fail with -EREMOTE
for such a pidfd, while pidfd_getfd() on the same pidfd returns a
duplicate of the target's file descriptor.

Apply the same rule to pidfd_getfd() and fail with -EREMOTE unless the
target is visible in the caller's active pid namespace. Callers in
ancestor pid namespaces are unaffected.

This was found with an AI coding assistant, which also drafted this
patch and its changelog. The problem was reproduced in a QEMU guest,
and the fix was tested there.

Link: https://lore.kernel.org/all/20260925-gewischt-auftrag-tierzucht-c153cb3f9f74@brauner/ [1]
Fixes: 8649c322f75c ("pid: Implement pidfd_getfd syscall")
Cc: stable@vger.kernel.org
Signed-off-by: Jiwoo Kim <arpe1618@gmail.com>
---
-EREMOTE is a new error for pidfd_getfd(). The check is done before the
task lookup, so, as with PIDFD_GET_INFO, a reaped target outside of the
caller's pid namespace hierarchy gives -EREMOTE rather than -ESRCH, and
the check comes before the ptrace access check.

setns() also accepts such pidfds without this check, but it requires
CAP_SYS_ADMIN over the namespaces being joined, so it is left alone
here.

A reproducer is available on request.

 kernel/pid.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index adf721606768..4f9a29eb29de 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -893,6 +893,13 @@ static int pidfd_getfd(struct pid *pid, int fd)
 	struct file *file;
 	int ret;
 
+	/*
+	 * Require the target to be visible in the caller's pid namespace,
+	 * like the pidfs ioctls that grant access to its resources.
+	 */
+	if (!pid_vnr(pid))
+		return -EREMOTE;
+
 	task = get_pid_task(pid, PIDTYPE_PID);
 	if (!task)
 		return -ESRCH;
@@ -917,9 +924,10 @@ static int pidfd_getfd(struct pid *pid, int fd)
  *
  * This syscall gets a copy of a file descriptor from another process
  * based on the pidfd, and file descriptor number. It requires that
- * the calling process has the ability to ptrace the process represented
- * by the pidfd. The process which is having its file descriptor copied
- * is otherwise unaffected.
+ * the process represented by the pidfd is visible in the caller's pid
+ * namespace and that the calling process has the ability to ptrace it.
+ * The process which is having its file descriptor copied is otherwise
+ * unaffected.
  *
  * Return: On success, a cloexec file descriptor is returned.
  *         On error, a negative errno number will be returned.

base-commit: 44cc27050381e92de64cc3d7836376eda4d92a5f
-- 
2.43.0

