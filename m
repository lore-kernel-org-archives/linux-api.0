Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3F52F1FD0;
	Fri, 12 Jun 2026 16:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781281279; cv=none; b=tZQf/O2EsDBu7Lou/FMJSUDYhAqzYqn91G/7EWn2gFSD89kXPYvCs9/hvMZ8EgOoS4s4Xm0Xe6mIakeSRwa0s/KDs4pEhPF/GVLEs9SQL5ku+pJ6ELqxZsQMwGtZj1QiXFPMorOvBvuOiq0ADA2fsUVefww9LMTpH2I3OJrq8uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781281279; c=relaxed/simple;
	bh=DQGECCu54qCFjAJEEwdPLsPC8heYQxz75RhXI6ITvYw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=g8EvyD+b3Eo0REJRNucFkYHmgq7fjjpKxbDKTwl5jVA6Qjr2mE8JKK1puZuOHyW3qto1qYSj6v8ZYju2JvoYNulN/9TxD0venBDhknUNWoS9Q92a0aHppfttxN0qrLfba9UmZ69zkh8WpD2fEJmMPKILgy9EKg0qsKpsH9t6MjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=nxgcXRoK; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="nxgcXRoK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=EOUkvSr2Gn8JmW0nio1LgmkdjEeAiY0SGNTncIeyo40=; b=nxgcXRoKu7qdZklZlsuvOJA97/
	vcAYycAQ9Kv5wgl5ZvuXa5vUEdh1TjK913+ngRL4O5K7pha3ONAivVIksQN96WElQHilWBKq+vCdv
	K3syL2vPfWrnVAd7LQeZiTxo2H1X1W0u0Md6dr8khOuNootnwrf+SlFbjn80mfvqCS5LQTWO00VdS
	TB+KR6pJSa3oM8WjogsUh77JrsbalxJQNAllBAF6/fNGbxEI1JWF1/nF/prqCXcgvspbwhRMXeWcJ
	/R4aIBFNgajVvQVS5aj1omhnClCSfC61i29LyBlEP9EFDn8hZvHEjEgR543H7kM9FtHJrFhSTOHPx
	sPBG5Aqw==;
Received: from [189.78.222.70] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wY4d6-00GgP4-Ow; Fri, 12 Jun 2026 18:21:12 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 12 Jun 2026 13:20:20 -0300
Subject: [PATCH v3 7/7] selftests: prctl: Add test for long thread names
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260612-tonyk-long_name-v3-7-7989b66e8a99@igalia.com>
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

Add tests for the new interface to set and get long thread names. The
kernel should accept the LONG_NAME and returning it accordingly. For the
old PR_GET_NAME interface, the kernel should truncate the name up to 16
chars. /proc/<task>/comm should return the same string ad PR_GET_NAME.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 tools/testing/selftests/prctl/set-process-name.c | 36 ++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/testing/selftests/prctl/set-process-name.c b/tools/testing/selftests/prctl/set-process-name.c
index 3f7b146d36df..0f20f7deac67 100644
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
@@ -25,6 +33,16 @@ int set_name(char *name)
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
+}
+
 int check_is_name_correct(char *check_name)
 {
 	char name[TASK_COMM_LEN];
@@ -38,6 +56,19 @@ int check_is_name_correct(char *check_name)
 	return !strcmp(name, check_name);
 }
 
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
+	return !strcmp(name, check_name);
+}
+
 int check_null_pointer(char *check_name)
 {
 	char *name = NULL;
@@ -82,6 +113,11 @@ TEST(rename_process) {
 	EXPECT_GE(set_name(CHANGE_NAME), 0);
 	EXPECT_TRUE(check_is_name_correct(CHANGE_NAME));
 
+	EXPECT_GE(set_ext_name(LONG_NAME), 0);
+	EXPECT_TRUE(check_is_ext_name_correct(LONG_NAME));
+	EXPECT_TRUE(check_is_name_correct(LONG_NAME_CAP));
+	EXPECT_TRUE(check_name());
+
 	EXPECT_GE(set_name(EMPTY_NAME), 0);
 	EXPECT_TRUE(check_is_name_correct(EMPTY_NAME));
 

-- 
2.54.0

