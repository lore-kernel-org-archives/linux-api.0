Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.97.179.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794763918;
	b=H6MuWb6SQvbKPFxv01eyxgBOJ6G5mkWsR7yaglMXNyTS56VBr6ZPzzKI/vwY0+1VPIN6
	 37ARGqE/MUjTB6ifCXYHSQgZrV6PZqYdk1+xJmRHQTozV/pqyqEoozhoNOADqOM+Ci9ea
	 03G/MW/cEzz/e3jmYtJyIB2YDMWMRuZMBuWskoLmz5fgBZA5LC5rRYJAvgo6lkJXmfa9m
	 WGIQbFnuZXphoxP9c/14CtnifUvaAP9f6QL9MmLuMqN2t7vmiNP3hl3WkKQgOeUvH641l
	 8Ti57Attd3OwKmit7CF9VHdEiH8caVu/VeR4wzgElgVEK3QhSOl5TGMzwqW8nhc5alw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794763918;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=u4RVpOqduk6CllMXzYay6C4L2uuW82fWVX57CQ3awKo=;
	b=nqsNDUI/xZl8H8J0xHpK55VCEAKXZtgwAPDh+rS5cJFNpFntZIMzC+u2EKbshLOL2Scn
	 KP9XlOT5pIUDOdZnR8S0hx03hrbpuq+I+dSsgOFWOpOoZdrnA7fJCcIf3n+Eb6OQpBpOH
	 R4vChxk69Bit0Ch5CsotlMnJban60hT1MOujs1nJRRovEF3kBgALijjFfOwpnlRLTXnXU
	 XhyqcwTyjINgi9NLSErLxVhfu2draMY5pSJdXRM7bf7r4nkdGoy28doxNRvDu2+so+qnz
	 +s2WC7Xkn15NqnmdVs7fKsmQ+HONREn4/zAtIvTM3mSoEUGnk/F5ias/rTf0kyGyRxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=igalia.com;
	spf=pass smtp.mailfrom=igalia.com;
	dkim=pass header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=foASp72R;
	arc=none smtp.remote-ip=213.97.179.56
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1230606A339;
	Sun, 15 Nov 2026 17:31:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1230606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=foASp72R
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=u4RVpOqduk6CllMXzYay6C4L2uuW82fWVX57CQ3awKo=; t=1794763917; x=2110123917; 
	b=foASp72Rce8YvKQdkspGNPcx+zn7z+XABfRA5Pc/zfH+kd4yW8EParOW7B9eUuTlS0S9/8jonNR
	CxuSQU54KQ3iPiF15tkbZv0+nvRrD70XBr0qfjwjmq08ZF8NwQWtnwuGRGV5jgGEY4Xx1g8paWjcF
	pz/A/4INYrFSfPoIFk6Ht7c5LSOH2zHQX3HHa4bPum8G+zULGN8A3qzHkjdqa9gLFslN0Ze3vv23w
	k5EVVeLN2oDfkJy2LNVN/OooqTtuaHvVv4Se3Ufdo5Cbfw4xY3rQtGKUsgwYanaIejNHkHYKFGmzk
	QLQVCVEV4L9NuUIQ2yn9/DCRE5Qp6I71EbCA==;
Received: from [177.172.124.218] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xSe4w-00B0BK-6J; Sun, 15 Nov 2026 18:31:46 +0100
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Sun, 15 Nov 2026 14:31:18 -0300
Subject: [PATCH v8 09/10] selftests/futex: Expand for get_robust_list2()
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
Message-Id: <20261115-tonyk-robust_futex-v8-9-a4fe47333a28@igalia.com>
References: <20261115-tonyk-robust_futex-v8-0-a4fe47333a28@igalia.com>
In-Reply-To: <20261115-tonyk-robust_futex-v8-0-a4fe47333a28@igalia.com>
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
 .../selftests/futex/functional/robust_list.c       | 164 ++++++++++++++++++---
 1 file changed, 143 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/futex/functional/robust_list.c b/tools/testing/selftests/futex/functional/robust_list.c
index 7666b9a64501..3d97b948bc0a 100644
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
@@ -454,40 +478,45 @@ TEST(test_set_robust_list2_inval)
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
-	ASSERT_EQ(ret, 0);
+	ret = set_list(&head, robust2, 0);
+	ASSERT_GE(ret, 0);
 
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
-	ASSERT_EQ(ret, 0)
+	ret = set_list(head, robust2, 0);
+	ASSERT_GE(ret, 0)
 		TH_LOG("set_robust_list error");
 
 	/*
@@ -507,23 +536,26 @@ static int child_list(void *arg)
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
 
@@ -1073,9 +1105,9 @@ static int child_lock_holder32(void *arg)
 	struct child_args *cargs = arg;
 	struct lock_struct32 *locks = cargs->arg;
 	struct __test_metadata *_metadata = cargs->_metadata;
-	struct robust_list_head32 *head;
+	struct robust_list_head32 *head, *head_ptr;
 	pid_t tid = gettid();
-	int i, ret;
+	int i, ret, index;
 
 	head = mmap((void *)0x10000, sizeof(*head), PROT_READ | PROT_WRITE,
 		    MAP_FIXED_NOREPLACE | MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
@@ -1088,9 +1120,20 @@ static int child_lock_holder32(void *arg)
 	head->list.next = (uint32_t)(uintptr_t) &head->list;
 	head->list_op_pending = (uint32_t)(uintptr_t) NULL;
 
-	ret = set_robust_list2((struct robust_list_head *) head,
+	index = set_robust_list2((struct robust_list_head *)head,
 			FUTEX_ROBUST_LIST_CMD_CREATE_32, 0, 0);
+	ASSERT_GE(index, 0);
+
+	/* Test get list */
+	ret = get_robust_list2(0, (struct robust_list_head **)&head_ptr, index, 0);
 	ASSERT_GE(ret, 0);
+	ASSERT_EQ(head, head_ptr);
+
+	/* Test trying to set a 64 bit list in the same index */
+	ret = set_robust_list2((struct robust_list_head *)head,
+			       FUTEX_ROBUST_LIST_CMD_MODIFY_64, 0, 0);
+	ASSERT_EQ(ret, -1);
+	ASSERT_TRUE(errno & (EOPNOTSUPP | EINVAL));
 
 	/*
 	 * Take all the locks and insert them in the list
@@ -1203,4 +1246,83 @@ TEST(test_32bit_lists)
 	munmap(locks, sizeof(*locks) * CHILD_NR);
 }
 
+/*
+ * Test setting and getting mutiple head lists
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
+	/*
+	 * Recreate the list. It should support the same number of elements as
+	 * before, given that we just cleared the list.
+	 */
+	for (i = 0; i < list_limit; i++) {
+		ret = set_list(&heads[i], true, &index[i]);
+		ASSERT_GE(ret, 0);
+		ASSERT_EQ(i, index[i]);
+	}
+
+	free(heads);
+	free(index);
+}
+
 TEST_HARNESS_MAIN

-- 
2.56.1

