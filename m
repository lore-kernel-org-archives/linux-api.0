Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.97.179.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793396353;
	b=vCCXvSxnfEJmTx1qdIfkkf2DWGWNXKIpTqDpFODoIchJ7hZf1rOC5Z8BfrRmHo+rsmWQ
	 st5tIk3MOknh7W8mR2OZPoH1Srza1Qi2k9AoALtU7toxVI+ujyK4qK0mLpa+vueqFymEm
	 tKID3HjmQDFYvZQtPYGhKCjVcGx/5AOUaAThuEUvoE9OREDMb5xGSenwNP6yPOX8I0/Uj
	 N7gMHBKQhJx8ju/Z6No0jLQ+eFXXi76Y/IRuD8joLrTx3jIwDKxaOl6k52Ihu2/LcRqej
	 s+cKBIL96Rry9iOsWiYrNSCsph3IwCzOBE5kP9Cng5bxhNufH75vcnu1shj5jOvx3fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793396353;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=M/YaOoZYDy/D7DrvfmZL+IRrQH3JuFSO6JeoJL7dP+U=;
	b=gRoO9lns3CMMooLiTSnIL1xMWZclNU3FEleHANOCp3VLIt/fj/UWtsRuDchYSCXPTAji
	 ploIf7oT4eiqd8t5NWXbxKq5Jt3/jx6YummgStEyFAY/2xR53bDJ4VCYNj0Ijrxv1LtJ5
	 kIaL0MlIsBWbS1YwUI1UbIQSYJHzEErNpLBRVq+OWLrC+IuB8kT/oy7/Tjot86GW+i/Si
	 eaxcpUS0BXlnYlZwalXCWrHTWpYoxuulCKXQbpPwAudGTbBQgdiQ1YgPXiTnR8jM8KJon
	 jzfhkQtGZlDOT8wi11NjUwX+MpvStHvx+y+hVYCqDO8+cH+KWo7mSYeinB5aD/SB55Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=igalia.com;
	spf=pass smtp.mailfrom=igalia.com;
	dkim=pass header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=XElzl0Gp;
	arc=none smtp.remote-ip=213.97.179.56
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D317606A31A;
	Fri, 30 Oct 2026 21:39:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D317606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=XElzl0Gp
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=M/YaOoZYDy/D7DrvfmZL+IRrQH3JuFSO6JeoJL7dP+U=; b=XElzl0Gp4duscp1RUvZlqVcSjF
	Nw3D/akHRi/B6HFUyZjNiRwc4szLtE7YSE//AMF7Wc37xZspBiUSwtEY4nJwLsYnpRBroseu1LRXi
	gEDRnqRk16CA3Q06TV0OR9XjDlUDXKM8JB3XBCWq8brIj2Ih0YNSkF5fVvz2uDeDyPQ2DBKO4rSy0
	WYo9fL2rkNOC80tasEMBKgp3H2lTExT8CrGLySMOnI3aqcl4oAajPDEYROlybtpIOChKvHCKPKJfi
	HOYGrMYjBQ7AX8fsG1YJLciMRl9tmoqEKehwAv6JnR65r+mPD/Ets2oa+L5YvxOuLTfNluj3QQx8d
	6YHjgyFg==;
Received: from [177.172.124.63] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xMuJZ-00FNmU-OU; Fri, 30 Oct 2026 22:39:09 +0100
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 30 Oct 2026 18:38:36 -0300
Subject: [PATCH v8 5/6] prctl: Add support for long user thread names
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261030-tonyk-long_name-v8-5-c9b030332254@igalia.com>
References: <20261030-tonyk-long_name-v8-0-c9b030332254@igalia.com>
In-Reply-To: <20261030-tonyk-long_name-v8-0-c9b030332254@igalia.com>
To: Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, 
 Shuah Khan <shuah@kernel.org>, willy@infradead.org, 
 mathieu.desnoyers@efficios.com, David Laight <david.laight.linux@gmail.com>, 
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org, 
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, 
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>
Cc: linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org, 
 linux-api@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2

Add support for getting and setting long user thread names with
PR_{SET,GET}_EXT_NAME.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 include/linux/sched.h      |  2 +-
 include/uapi/linux/prctl.h |  3 +++
 kernel/sys.c               | 15 ++++++++++++++-
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5e02bce749b8..c9477ba674f1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2039,7 +2039,7 @@ extern void kick_process(struct task_struct *tsk);
 
 extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec);
 #define set_task_comm(tsk, from) ({			\
-	BUILD_BUG_ON(sizeof(from) != TASK_COMM_LEN);	\
+	BUILD_BUG_ON(sizeof(from) < TASK_COMM_LEN);	\
 	__set_task_comm(tsk, from, false);		\
 })
 
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index b6ec6f693719..a07f8edadd65 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -56,6 +56,9 @@
 #define PR_SET_NAME    15		/* Set process name */
 #define PR_GET_NAME    16		/* Get process name */
 
+#define PR_SET_EXT_NAME    17		/* Set extended process name */
+#define PR_GET_EXT_NAME    18		/* Get extended process name */
+
 /* Get/set process endian */
 #define PR_GET_ENDIAN	19
 #define PR_SET_ENDIAN	20
diff --git a/kernel/sys.c b/kernel/sys.c
index 6a72c7e644e7..fc9e3c5a9135 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2538,7 +2538,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
 	struct task_struct *me = current;
-	unsigned char comm[TASK_COMM_LEN];
+	unsigned char comm[TASK_COMM_EXT_LEN];
 	long error;
 
 	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
@@ -2616,6 +2616,19 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		if (copy_to_user((char __user *)arg2, comm, TASK_COMM_LEN))
 			return -EFAULT;
 		break;
+	case PR_SET_EXT_NAME:
+		comm[TASK_COMM_EXT_LEN - 1] = 0;
+		if (strncpy_from_user(comm, (char __user *)arg2,
+				      TASK_COMM_EXT_LEN - 1) < 0)
+			return -EFAULT;
+		set_task_comm(me, comm);
+		proc_comm_connector(me);
+		break;
+	case PR_GET_EXT_NAME:
+		strscpy_pad(comm, me->comm, TASK_COMM_EXT_LEN);
+		if (copy_to_user((char __user *)arg2, comm, TASK_COMM_EXT_LEN))
+			return -EFAULT;
+		break;
 	case PR_GET_ENDIAN:
 		error = GET_ENDIAN(me, arg2);
 		break;

-- 
2.56.0

