Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2800553CA61;
	Thu, 10 Sep 2026 16:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789058996; cv=none; b=gvnTjpN/f1Gkv2xcKGtUchXHgC3ut/omhtGBbhgLktG+Yjw+HQmH6APA/RtMT4KGmPqInTaMliQN0wv7nkHWzMHcQR9gfyYNl0jTm7zQDGpmzAOX59ryui01Tu+Wy2XhG61G12qsBcMqHbBCk3QwWTmdFHz7EBHfnMROikW7ig0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789058996; c=relaxed/simple;
	bh=uho5UQ0Az37K2IRerC1Luwb5Pg6lv4RnKyjZ+YPmkrE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OKlb+WXUnO5oUVlOoVz6ck1wfhDcyvJCTgms87DFGwuXLi9udAc9ZLWYETj+T73GTO2Yz0sx6+WYhsDZ8pPfjxHhYYt9JcecPmgtCyHAe19/kKpI5gWINjtbcguDVbKN7CiembiKFnOQB8rotVlPnoIEjshFEBjUKFopRDS/My4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=a2D6raGc; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="a2D6raGc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=eoYcCAglewCWVwj2AVy806Wq+FVmxIJYd36pevZhoXY=; b=a2D6raGcP0RCTpXl67nSvb7R2V
	WFSa5ujCHs+5dcnspyYfejXwX3G7uZ8rNxsr6Mix0RGlxLGLPAArBNxVk52pKrj7wR0Rlxrr5iYuw
	QNf3W75SxuKSxCHEWANzBEWi9d2vs85lUo2YTf3I57UEIBg+Fd/i/jNxzQT7TqY4AKS58lanYXX8K
	b64TzEvq58AA+nBv+eSDmHUY1uewglcotnI9aZG6z9MqvqGSVoOlVBs/JRO5pIeXnI1otx4xKX88d
	a1egSIaIIiC3736hlO/wHdOX43P6i7MMbnPE6hKQ0R7IC0QrbTdAg5p/5Usi/HgT0Yr1yZjhHmkBj
	FlLdxsmg==;
Received: from [177.172.123.122] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1x4hy7-000GV1-LH; Thu, 10 Sep 2026 18:49:47 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Thu, 10 Sep 2026 13:49:25 -0300
Subject: [PATCH v6 3/6] lib/string_kunit: Add test for copy_task_comm()
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260910-tonyk-long_name-v6-3-d70afbf194c5@igalia.com>
References: <20260910-tonyk-long_name-v6-0-d70afbf194c5@igalia.com>
In-Reply-To: <20260910-tonyk-long_name-v6-0-d70afbf194c5@igalia.com>
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

Add a new test for copy_task_comm(). Check if a copy from a task_struct
works, and special cases when the size of source and destination buffer
mismatches.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 lib/tests/string_kunit.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/lib/tests/string_kunit.c b/lib/tests/string_kunit.c
index 0819ace5b027..66c3398f2317 100644
--- a/lib/tests/string_kunit.c
+++ b/lib/tests/string_kunit.c
@@ -881,6 +881,43 @@ static void string_bench_strrchr(struct kunit *test)
 	STRING_BENCH_BUF(test, buf, len, strrchr, buf, '\0');
 }
 
+#define TASK_NAME "task_name"
+#define TASK_NAME_LEN 9
+#define TASK_MAX_LEN TASK_COMM_LEN
+#define SMALLER_LEN (TASK_NAME_LEN - 3)
+#define BIGGER_LEN (TASK_MAX_LEN + 3)
+
+static void string_copy_task_comm(struct kunit *test)
+{
+	char str[TASK_MAX_LEN] = TASK_NAME, copy[TASK_MAX_LEN],
+	     smaller_buf[SMALLER_LEN], bigger_buf[BIGGER_LEN];
+	static struct task_struct task, *tsk = &task;
+	int len1, len2, i;
+
+	/* set and get task name */
+	strscpy_pad(tsk->comm, str);
+	copy_task_comm(copy, tsk, TASK_COMM_LEN);
+
+	len1 = strlen(str);
+	len2 = strlen(copy);
+
+	KUNIT_ASSERT_EQ(test, len1, len2);
+	KUNIT_ASSERT_EQ(test, len2, TASK_NAME_LEN);
+	KUNIT_ASSERT_EQ(test, copy[len2], '\0');
+	KUNIT_ASSERT_TRUE(test, !strcmp(str, copy));
+
+	/* copy to a smaller dst buffer */
+	copy_task_comm(smaller_buf, tsk, sizeof(smaller_buf));
+	KUNIT_ASSERT_TRUE(test, !strncmp(str, smaller_buf, SMALLER_LEN - 1));
+	KUNIT_ASSERT_EQ(test, smaller_buf[SMALLER_LEN - 1], '\0');
+
+	/* copy to a bigger dst buffer */
+	copy_task_comm(bigger_buf, tsk, sizeof(bigger_buf));
+	KUNIT_ASSERT_TRUE(test, !strncmp(str, bigger_buf, TASK_NAME_LEN));
+	for (i = TASK_NAME_LEN; i < BIGGER_LEN; i++)
+		KUNIT_ASSERT_EQ(test, bigger_buf[i], '\0');
+}
+
 static struct kunit_case string_test_cases[] = {
 	KUNIT_CASE(string_test_memset16),
 	KUNIT_CASE(string_test_memset32),
@@ -910,6 +947,7 @@ static struct kunit_case string_test_cases[] = {
 	KUNIT_CASE(string_bench_strnlen),
 	KUNIT_CASE(string_bench_strchr),
 	KUNIT_CASE(string_bench_strrchr),
+	KUNIT_CASE(string_copy_task_comm),
 	{}
 };
 

-- 
2.55.0

