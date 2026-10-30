Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.97.179.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793396359;
	b=sV0EDSxxTnd3u4YfSjia0madXt5cClBI3tj2bRrSkF0YXYNFZFeqgdMxhnUsjPg9baFP
	 JuiqyMcVuqaPpPjohOBH6XqhWacgXipr46RljEo14UOIDwQfO/jQxqPdSScsmh9L4MI2m
	 AHc8WEfieJxIbPqJcyAqL1SHQk27ZYuDF0rIHvTCLoH/k9ZpZApcpv3wmv6LZ1OU+9VTd
	 LM3m3GaLuFrilA/lDjBVtHQL7cgJE0tXGmZgme/Z7RW1Wgt4pTdeurtlvNkFnF+j5ooxa
	 8ow3xJB+PwfIZmuFhiOoqx8nL5iQQQjZXuKc9KaFjHDczpQ24ijzVdVMhWSXE2yPlog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793396359;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=PjseVdMtk+B6zIYS1/KaMNbcsZ1JXjao9cOufgyE16k=;
	b=QLUdWJKQybq1JYhLrluTWl7ur2IuEZKIvAvl0PFERHTdXOO2srmRX5JI0gBXw/Yh+oHe
	 nT1dna/pQgYErY73lqHKw/ZtxeZjXrjDRZ1OLH/K3jz5Gt/oQrqadJbnvsolL2JxoPJ/g
	 sA38IMd5iLc/IRpumuvMEzUjZUE9okhzKbJ5PjDuN3zZ7AvX7Mhub1WYiM/2C/wbIfzDi
	 /Z9LYCxFdN/D8NDCxerW5Azg9qkL0XhaGlX6amf31jvJ8c1caIzdk+mT7peSmCuB0ik4C
	 5LfMUkeeE6E9YSe4erS+wS+cj61+hfEx4W6aSiqjgxPUg8Ejgj8t4DxHFFCI7SCJNXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=igalia.com;
	spf=pass smtp.mailfrom=igalia.com;
	dkim=pass header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=Qi3NBuWX;
	arc=none smtp.remote-ip=213.97.179.56
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDA2606A31E;
	Fri, 30 Oct 2026 21:39:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1EDA2606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=Qi3NBuWX
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=PjseVdMtk+B6zIYS1/KaMNbcsZ1JXjao9cOufgyE16k=; b=Qi3NBuWXzihQxtfrBDxtn/7hA6
	TuR2NO8xApdjO/9KXFbZMzfynJ4C3uFKBaEjT7YQwpWQ4DoJadSomUg+4u23eH0pdmPgyhElABozd
	scNPpuEdTwAIRHYeiHPmDDiwx05EVIzBNSD4Lxqe+aY7aLLom0o+fFA6aW0tYgVzHJ6MgUx+IaO2F
	OD0V435PAsZJkGZysN95NHllhisZEyFbfi8uZgZG8OQV5ArN7hUxlfL/JPTKUKdP9tC4O9D2jj5pb
	OZ4vlWi1FDnOO4sBcNpzi7qctnaLPr89jAY6u9Yfv61joZvdLzyr7GtJkmg8W5QIE9fZ7e/9L2bnX
	lFVIEGcw==;
Received: from [177.172.124.63] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xMuJf-00FNmU-2c; Fri, 30 Oct 2026 22:39:15 +0100
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 30 Oct 2026 18:38:37 -0300
Subject: [PATCH v8 6/6] selftests: prctl: Add test for long thread names
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
Message-Id: <20261030-tonyk-long_name-v8-6-c9b030332254@igalia.com>
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

Add tests for the new interface to set and get long thread names. The
kernel should accept the LONG_NAME and returning it accordingly. For the
old PR_GET_NAME interface, the kernel should truncate the name up to 16
chars. /proc/<task>/comm should return the same string ad PR_GET_NAME.

While here, fix the check_is_name_correct() logic. It currently returns 1
for success, or a negative number for error. EXPECT_TRUE() evaluates any
non-zero value as true, so the error will be evaluated as a success. Make
the logic more robust and straightforward by returning the results of
strcmp() and expecting zero as success.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
Changes in v5:
 - fix check_is_name_correct() return logic
---
 tools/testing/selftests/prctl/set-process-name.c | 57 +++++++++++++++++++++---
 1 file changed, 50 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/prctl/set-process-name.c b/tools/testing/selftests/prctl/set-process-name.c
index 3f7b146d36df..f05053aaba85 100644
--- a/tools/testing/selftests/prctl/set-process-name.c
+++ b/tools/testing/selftests/prctl/set-process-name.c
@@ -9,9 +9,17 @@
 
 #include "kselftest_harness.h"
 
+#ifndef PR_SET_EXT_NAME
+# define PR_SET_EXT_NAME 17
+# define PR_GET_EXT_NAME 18
+#endif
+
 #define CHANGE_NAME "changename"
+#define LONG_NAME	"change_to_very_long_extended_name"
+#define LONG_NAME_CAP	"change_to_very_"
 #define EMPTY_NAME ""
 #define TASK_COMM_LEN 16
+#define TASK_COMM_EXT_LEN 64
 #define MAX_PATH_LEN 50
 
 int set_name(char *name)
@@ -25,6 +33,20 @@ int set_name(char *name)
 	return res;
 }
 
+int set_ext_name(char *name)
+{
+	int res;
+
+	res = prctl(PR_SET_EXT_NAME, name, NULL, NULL, NULL);
+
+	if (res < 0)
+		return -errno;
+	return res;
+}
+
+/*
+ * Return 0 if strings match
+ */
 int check_is_name_correct(char *check_name)
 {
 	char name[TASK_COMM_LEN];
@@ -35,7 +57,23 @@ int check_is_name_correct(char *check_name)
 	if (res < 0)
 		return -errno;
 
-	return !strcmp(name, check_name);
+	return strcmp(name, check_name);
+}
+
+/*
+ * Return 0 if strings match
+ */
+int check_is_ext_name_correct(char *check_name)
+{
+	char name[TASK_COMM_EXT_LEN];
+	int res;
+
+	res = prctl(PR_GET_EXT_NAME, name, NULL, NULL, NULL);
+
+	if (res < 0)
+		return -errno;
+
+	return strcmp(name, check_name);
 }
 
 int check_null_pointer(char *check_name)
@@ -56,8 +94,8 @@ int check_name(void)
 	pid = getpid();
 	FILE *fptr = NULL;
 	char path[MAX_PATH_LEN] = {};
-	char name[TASK_COMM_LEN] = {};
-	char output[TASK_COMM_LEN] = {};
+	char name[TASK_COMM_EXT_LEN] = {};
+	char output[TASK_COMM_EXT_LEN] = {};
 	int j;
 
 	j = snprintf(path, MAX_PATH_LEN, "/proc/self/task/%d/comm", pid);
@@ -74,21 +112,26 @@ int check_name(void)
 	if (res < 0)
 		return -errno;
 
-	return !strcmp(output, name);
+	return strcmp(output, name);
 }
 
 TEST(rename_process) {
 
 	EXPECT_GE(set_name(CHANGE_NAME), 0);
-	EXPECT_TRUE(check_is_name_correct(CHANGE_NAME));
+	EXPECT_FALSE(check_is_name_correct(CHANGE_NAME));
+
+	EXPECT_GE(set_ext_name(LONG_NAME), 0);
+	EXPECT_FALSE(check_is_ext_name_correct(LONG_NAME));
+	EXPECT_FALSE(check_is_name_correct(LONG_NAME_CAP));
+	EXPECT_FALSE(check_name());
 
 	EXPECT_GE(set_name(EMPTY_NAME), 0);
-	EXPECT_TRUE(check_is_name_correct(EMPTY_NAME));
+	EXPECT_FALSE(check_is_name_correct(EMPTY_NAME));
 
 	EXPECT_GE(set_name(CHANGE_NAME), 0);
 	EXPECT_LT(check_null_pointer(CHANGE_NAME), 0);
 
-	EXPECT_TRUE(check_name());
+	EXPECT_FALSE(check_name());
 }
 
 TEST_HARNESS_MAIN

-- 
2.56.0

