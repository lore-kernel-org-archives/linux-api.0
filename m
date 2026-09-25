Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9DE471CE4;
	Fri, 25 Sep 2026 17:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790358857; cv=none; b=ukezOmobxbRZVYn4Y/vNvhQB/O1qgD3KoABBbR2dk3B/bqvsv1rzFB0+UwR/WQnXjZ883XI/5thDZvpeOL2QHcnlY7e40MxQiuPbnF46YGoF+/hU28GKq2kUiXk3iZqPQI6thmjMuTU4VKC9+42k4nOepa1lYZ5E7/Th8I11fy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790358857; c=relaxed/simple;
	bh=K2lr70sYs/npcnS7pGdafbEQhcHnsABW3HDSNOQCRTc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UH8E+6finH5n+toY9/291mdcSP42fcWsXySaj2Q1qlyiFv9wpblE/FVNJ/Fos8a6mgn0du+tFacU8SS8qTNriE18JWElO3YrlB7x0fvoLddCUpDqghfjsmsCAiaYCOqOdFDNCQJcguoqu+9/Bw2da/wsY1d7MG028V0FRP48UxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=AtuGXUvD; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="AtuGXUvD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=O5Xrl3iWAvFr3TEsG/18XhDEllbT6d/xPRLLsP8onIM=; b=AtuGXUvDIqLyzG+V0Avp1HXl7t
	XTAsm1H46iRKEqiglJ47S28t01BI7+YKQwW2XrwW1D4bLvAVFn+wFFLOwrNohuorL2kP7yX+Vn5ko
	c7B0tACBM990YwEC0tLg/ZMVg61Son5Wg+b0XfsYvFzTXh5BZSaLL6nahoZpJhxXcTmzfez6L77aG
	IpbG4/RgkY/15TD6qd5x5vW3xyZzMJ6/8lEBRjvfAbWY1CeNb1v7GbZGnpfW0JUSOSVXD8XUBybGw
	IFCr3OvqmjJmu3XfG40AJaAzQ0QhN8qqQNXiBUlF5bez8I39+9ANoTbuSzk3T2pzjbojH4I/sS687
	bR1kdHxA==;
Received: from [177.172.123.214] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xAA7Y-007GQg-6U; Fri, 25 Sep 2026 19:54:04 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 25 Sep 2026 14:53:32 -0300
Subject: [PATCH v7 09/10] selftests/futex: Expand for get_robust_list2()
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260925-tonyk-robust_futex-v7-9-d1095991152c@igalia.com>
References: <20260925-tonyk-robust_futex-v7-0-d1095991152c@igalia.com>
In-Reply-To: <20260925-tonyk-robust_futex-v7-0-d1095991152c@igalia.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Darren Hart <dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Waiman Long <longman@redhat.com>, Ryan Houdek <Sonicadvance1@gmail.com>, 
 Thomas Gleixner <tglx@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-api@vger.kernel.org, kernel-dev@igalia.com, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2

Reuse the same selftest for the original set_robust_list() syscall for
the new set_robust_list2() syscall. Use kselftest variants feature to
run the relevant tests for both interfaces. Create a new test case to
get different lists from the same task.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 .../selftests/futex/functional/robust_list.c       | 133 ++++++++++++++++++---
 1 file changed, 117 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/futex/functional/robust_list.c b/tools/testing/selftests/futex/functional/robust_list.c
index f4dd600b3d1f..587fb529d6ca 100644
--- a/tools/testing/selftests/futex/functional/robust_list.c
+++ b/tools/testing/selftests/futex/functional/robust_list.c
@@ -51,6 +51,7 @@
 
 #ifndef SYS_set_robust_list2
 # define SYS_set_robust_list2 473
+# define SYS_get_robust_list2 474
 
 enum robust_list_cmd {
 	FUTEX_ROBUST_LIST_CMD_CREATE_64,
@@ -102,6 +103,12 @@ static int set_robust_list2(struct robust_list_head *head, enum robust_list_cmd
 	return syscall(SYS_set_robust_list2, head, cmd, index, flags, 0, 0);
 }
 
+static int get_robust_list2(int pid, struct robust_list_head **head,
+			    unsigned int index, unsigned int flags)
+{
+	return syscall(SYS_get_robust_list2, pid, head, index, flags);
+}
+
 static bool robust_list2_support(void)
 {
 	int ret = set_robust_list2(NULL, FUTEX_ROBUST_LIST_CMD_LIST_LIMIT, 0, 0);
@@ -240,6 +247,23 @@ static int modify_list(struct robust_list_head *head, int index)
 	return set_robust_list2(head, get_cmd_modify(), index, 0);
 }
 
+static int get_list(pid_t pid, struct robust_list_head **head, bool robust2, int index)
+{
+	int ret;
+
+	if (!robust2) {
+		size_t len_ptr;
+
+		ret = get_robust_list(pid, head, &len_ptr);
+		if (sizeof(**head) != len_ptr)
+			return -EINVAL;
+
+		return ret;
+	}
+
+	return get_robust_list2(pid, head, index, 0);
+}
+
 /*
  * A basic (and incomplete) mutex lock function with robustness
  */
@@ -424,39 +448,44 @@ TEST(test_set_robust_list2_inval)
 /*
  * Test get_robust_list with pid = 0, getting the list of the running thread
  */
-TEST(test_get_robust_list_self)
+TEST_F(robust_api, test_get_robust_list_self)
 {
 	struct robust_list_head head, head2, *get_head;
-	size_t head_size = sizeof(head), len_ptr;
-	int ret;
+	bool robust2 = variant->robust2;
+	int ret, index = 0;
 
-	ret = set_robust_list(&head, head_size);
+	ret = set_list(&head, robust2, 0);
 	ASSERT_EQ(ret, 0);
 
-	ret = get_robust_list(0, &get_head, &len_ptr);
+	ret = get_list(0, &get_head, robust2, 0);
 	ASSERT_EQ(ret, 0);
 	ASSERT_EQ(get_head, &head);
-	ASSERT_EQ(head_size, len_ptr);
 
-	ret = set_robust_list(&head2, head_size);
-	ASSERT_EQ(ret, 0);
+	ret = set_list(&head2, robust2, &index);
+	ASSERT_GE(ret, 0);
 
-	ret = get_robust_list(0, &get_head, &len_ptr);
+	ret = get_list(0, &get_head, robust2, index);
 	ASSERT_EQ(ret, 0);
 	ASSERT_EQ(get_head, &head2);
-	ASSERT_EQ(head_size, len_ptr);
 }
 
+struct child_arg_struct {
+	struct robust_list_head *head;
+	bool robust2;
+};
+
 static int child_list(void *arg)
 {
 	struct child_args *cargs = arg;
 	struct __test_metadata *_metadata = cargs->_metadata;
-	struct robust_list_head *head = cargs->arg;
+	struct child_arg_struct *child_arg = (struct child_arg_struct *) cargs->arg;
+	struct robust_list_head *head = child_arg->head;
+	bool robust2 = child_arg->robust2;
 	int ret;
 
 	free(cargs);
 
-	ret = set_robust_list(head, sizeof(*head));
+	ret = set_list(head, robust2, 0);
 	ASSERT_EQ(ret, 0)
 		TH_LOG("set_robust_list error");
 
@@ -477,23 +506,26 @@ static int child_list(void *arg)
  * parent
  *   2) the child thread still alive when we try to get the list from it
  */
-TEST(test_get_robust_list_child)
+TEST_F(robust_api, test_get_robust_list_child)
 {
 	struct robust_list_head head, *get_head;
+	bool robust2 = variant->robust2;
+	struct child_arg_struct child =
+		{.robust2 = robust2, .head = &head};
 	int ret, wstatus;
-	size_t len_ptr;
 	pid_t tid;
 
+
 	ret = pthread_barrier_init(&barrier, NULL, 2);
 	ret = pthread_barrier_init(&barrier2, NULL, 2);
 	ASSERT_EQ(ret, 0);
 
-	tid = create_child(_metadata, &child_list, &head);
+	tid = create_child(_metadata, &child_list, &child);
 	ASSERT_NE(tid, -1);
 
 	pthread_barrier_wait(&barrier);
 
-	ret = get_robust_list(tid, &get_head, &len_ptr);
+	ret = get_list(tid, &get_head, robust2, 0);
 	ASSERT_EQ(ret, 0);
 	ASSERT_EQ(&head, get_head);
 
@@ -1171,4 +1203,73 @@ TEST(test_32bit_lists)
 	munmap(locks, sizeof(*locks) * CHILD_NR);
 }
 
+/*
+ * Test setting and getting mutiples head lists
+ */
+TEST(set_and_get_robust2)
+{
+	struct robust_list_head *head = NULL, *heads;
+	int list_limit, ret, *index, i, j;
+
+	if (!robust_list2_support()) {
+		SKIP(return, "robust_list2 not supported\n");
+		return;
+	}
+
+	list_limit = set_robust_list2(NULL, FUTEX_ROBUST_LIST_CMD_LIST_LIMIT, 0, 0);
+	ASSERT_GT(list_limit, 1);
+
+	heads = malloc(list_limit * sizeof(*heads));
+	ASSERT_NE(heads, NULL);
+
+	index = malloc(list_limit * sizeof(*index));
+	ASSERT_NE(index, NULL);
+
+	/*
+	 * Insert various elements into the lists
+	 */
+	for (i = 0; i < list_limit; i++) {
+		ret = set_list(&heads[i], true, &index[i]);
+		ASSERT_GE(ret, 0);
+		ASSERT_EQ(i, index[i]);
+	}
+
+	for (i = 0; i < list_limit; i++) {
+		ret = get_list(0, &head, true, index[i]);
+		ASSERT_EQ(ret, 0);
+		ASSERT_EQ(head, &heads[i]);
+	}
+
+	/*
+	 * Modify the list, adding the elements in the other ordering
+	 */
+	for (i = 0, j = list_limit; i < list_limit; i++, j--) {
+		ret = modify_list(&heads[j], index[i]);
+		ASSERT_GE(ret, 0);
+	}
+
+	for (i = 0, j = list_limit; i < list_limit; i++, j--) {
+		ret = get_list(0, &head, true, index[i]);
+		ASSERT_EQ(ret, 0);
+		ASSERT_EQ(head, &heads[j]);
+	}
+
+	/*
+	 * Delete all elements
+	 */
+	for (i = 0; i < list_limit; i++) {
+		ret = modify_list(NULL, index[i]);
+		ASSERT_EQ(ret, 0);
+	}
+
+	for (i = 0; i < list_limit; i++) {
+		ret = get_list(0, &head, true, index[i]);
+		ASSERT_EQ(ret, 0);
+		ASSERT_EQ(head, NULL);
+	}
+
+	free(heads);
+	free(index);
+}
+
 TEST_HARNESS_MAIN

-- 
2.55.0

