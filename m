Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D50330E0F2;
	Sat, 12 Sep 2026 01:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789176300; cv=none; b=f1PrBTun2LF3C4x2830QKxsSfsm5cdQVaPWZfyaeL3qnyybG9VREsCAzsjxe4dYr4vjVKTjHEdXXx57KfS94CGfv0B/tZ7mUhsSkUpCtWguIQMi0h3ok87q3LJqV/TZe9IWLifiJUu89mvNAULkNl1M4cNzRB23QFSk457N3rUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789176300; c=relaxed/simple;
	bh=hp8HYQQRfq2HGftAqwjfoKMGgu7IXtoPCxAtpHEnYsA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nJr1FP3+Eai24agxFrS2ywz0oIw9GbHIOp2D2qWNU4cOh6B3OjKteNhQBa+Bp6JJ2QhFQ8uKikdgB4PhNrtB/tOVcOvr62RLqzk3ZVSmlrmPexPZeeAKznYts1M7ipU9g5c8eP8KB/Yt/2M+oT+Dgopaij2qUwKdMup27MZ+V+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=G4PjwZTd; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="G4PjwZTd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=jkk2aKfOtQ1sfSPZp1MlJc6YMLBpwH+7BNfIjU4i5Cc=; b=G4PjwZTdz6s2Wj0Xvl+D4VheFF
	zQiHRINyszkW3OC64vIaXCjQdeFXZEVvtpeHig8Vuyh7Y30Te+pNAr0BsoPMLk3nMVpthMlIXiROU
	K+uFqpIc6jbPP7wTEGUIPsuI83iMrB3oJU6BrQ5fNJFl+1OTspXENlGjPlsrTx/SMVJymYqVuFJJe
	sG/1jiGflCJAOrley8Ih6rtcERIobfEl0uF3ILjRSFSSamujg7Pu2JQFKBao07roSfx1Xo0k7QpTy
	xbVVUpvzJjNUOAbkS7u7rL6yRWYfXkpeq0INz50r2u0TUxdrBliP7l2WElXGpA8MY77nGrBPx7hTs
	VOhuuxxQ==;
Received: from [177.172.123.122] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1x5CU5-000xjI-3T; Sat, 12 Sep 2026 03:24:49 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 11 Sep 2026 22:24:03 -0300
Subject: [PATCH v7 6/6] selftests: prctl: Add test for long thread names
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260911-tonyk-long_name-v7-6-34e1ee1564ae@igalia.com>
References: <20260911-tonyk-long_name-v7-0-34e1ee1564ae@igalia.com>
In-Reply-To: <20260911-tonyk-long_name-v7-0-34e1ee1564ae@igalia.com>
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
2.55.0

