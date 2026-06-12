Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62AE29D270;
	Fri, 12 Jun 2026 16:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781281272; cv=none; b=qKL1Urxrbz4fmG2gInAOMhQxiHWjiAA7X+j0knszx6vml5MqzKRtFSVvo4b75wfTF2MqlsWRhWjhiEivYWIEpqs07+Nn9hX/dWKOHWZsjUekuEOgZnUDkhx9hVRv7h9Wl6S5/L3gYlxFDEoZf/bLrFmUloudqNSVFWFmQ/auDZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781281272; c=relaxed/simple;
	bh=+v7sbVYDGSUf0BVLWGMMLNg0OmezUrfSrXgMZfVI7nc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qLPsWZZAzOlhDBRxvl0wijJzDSK5QPBTVlp3qOLG560qGmU7A107jglcItp6EKqS7RIs+9INq3ILkRF2IdBcDZ3oX63jBThpTmSvvoBSHUYMbaNWreMsOcBPe9Xkk4U4Ek6heGRQ0I972+/aBy6/mRHuJ65LSAt2fQ0RmFllp9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=lH7OBkoF; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="lH7OBkoF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=RCddDmgd7eKFHxOU+gGkLiMWpKP/CXyHYadGUBnbgDc=; b=lH7OBkoFezBTIbiZ4lBQYtBZZG
	VDG6Vt4vZv0nBOXZHUh9ccIW7afgI/OCu5JfZ04fAx6WmoURNjBzHH2dTqliAp+Z6ndbbSqIVR560
	2oZXxn4j3dQjOBsHryau9UGU9ULniy9GSueDDdLcIvEet1A5urdQame+fE2SGuFGATDU6QLNeo59k
	aV9BvLLrfCFxQSW7z8AJYxO0KLnR+zYUmah5SewUU4DCj+/WEQoFAHIu16hzXH9iJ9DuLS40Y9F6c
	epnyGajFpAQJLU0KR4LZTCd7+1EDOR/sbMtxcPeRPUAMkBq2OW7b/F+fafoK8+4nFMUJjxvFFqSLg
	Y/gWD9Jg==;
Received: from [189.78.222.70] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wY4d1-00GgP4-E2; Fri, 12 Jun 2026 18:21:07 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 12 Jun 2026 13:20:19 -0300
Subject: [PATCH v3 6/7] prctl: Add support for long user thread names
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260612-tonyk-long_name-v3-6-7989b66e8a99@igalia.com>
References: <20260612-tonyk-long_name-v3-0-7989b66e8a99@igalia.com>
In-Reply-To: <20260612-tonyk-long_name-v3-0-7989b66e8a99@igalia.com>
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
 linux-api@vger.kernel.org, 
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
index a5dc0f4e7975..5e167023fb81 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1997,7 +1997,7 @@ extern void kick_process(struct task_struct *tsk);
 
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
index 76d77218ab19..1b70d53da998 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2535,7 +2535,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
 	struct task_struct *me = current;
-	unsigned char comm[TASK_COMM_LEN];
+	unsigned char comm[TASK_COMM_EXT_LEN];
 	long error;
 
 	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
@@ -2613,6 +2613,19 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
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
2.54.0

