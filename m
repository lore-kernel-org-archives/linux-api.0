Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A924D5984;
	Fri, 25 Sep 2026 17:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790358850; cv=none; b=RQgW+LoiLJp+dNYEI1Y1iTrza7M8u4+Z33Z2DKLqeVABXDsDRPsrUqIIC15NuLJPw0nQcFipL7OrL07dEGvqKmmR0xKjd/yXlS+iKou/3Ku24OrDyl7a5y5V94ov4iWjKkscpHiuH9p2qfoRwAfjEccM+Bbcu5YbK2PaIodAexg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790358850; c=relaxed/simple;
	bh=8CPee7+js4A9gpSddrWC3+04zZTbAtivEux7hIaNo9U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QmM9LO/tK67OKwq0EDiSbGC97m3HiQQz0dU/w4iPCEZsHA2+VlHHJb3h1cY4KR0QwzjI6Q+pwrjrB3RQFnLPId3LBr3cJW/ftL39m6Ydxoua9ReO472qcvnZy/YDAcJJ8lZmWLs4IY4b/4JpYw+a4DDZYpG+uRoiOCby0sOmwak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=As2B0yph; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="As2B0yph"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=XYaRqAUFgecGuVIxFYX6Q+vzphex45P6Eyx82f1z4XQ=; b=As2B0yphWh8prOwJlX0DsMNWwe
	8tHGe4kj4BonXj24LFDltx6CohQbXvOEXO2NBNesaz7SmRj1b0Y8vWc44Bg1ZqsgK0+Pmon3fduF3
	6ynP0LGmIYtLVIgOXfBmYbXf9VS95VkhnRP8FgoTurDq6E0DS+OrSNHRiBPwnwU5hndy9q8Wk0m3A
	Cw8VMRlG3Zpz0BXyp4avYsXcUSohzHs/CKO+ybgscqjZIgyQ6BZPD+8o/JxthbEOq16xnmGN1Zvqn
	wZprLZoM8mjXQhfZV0uOxHzSbu22l6ERve/Of5tWihn4pqDQmXikM8cEQbfr+X1sHT6TnXQxUsOT3
	7W7rkM5g==;
Received: from [177.172.123.214] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xAA7U-007GQg-R2; Fri, 25 Sep 2026 19:54:00 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 25 Sep 2026 14:53:31 -0300
Subject: [PATCH v7 08/10] selftests/futex: Expand for set_robust_list2()
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260925-tonyk-robust_futex-v7-8-d1095991152c@igalia.com>
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
run the relevant tests for both interfaces. Create new test cases for
checking invalid parameters, the ability to correctly set multiple lists
for the same task, and to use 32-bit lists in a 64-bit task.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 .../selftests/futex/functional/robust_list.c       | 431 +++++++++++++++++++--
 1 file changed, 398 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/futex/functional/robust_list.c b/tools/testing/selftests/futex/functional/robust_list.c
index ddb610149857..f4dd600b3d1f 100644
--- a/tools/testing/selftests/futex/functional/robust_list.c
+++ b/tools/testing/selftests/futex/functional/robust_list.c
@@ -49,6 +49,35 @@
 # define BUILD_64
 #endif
 
+#ifndef SYS_set_robust_list2
+# define SYS_set_robust_list2 473
+
+enum robust_list_cmd {
+	FUTEX_ROBUST_LIST_CMD_CREATE_64,
+	FUTEX_ROBUST_LIST_CMD_CREATE_32,
+	FUTEX_ROBUST_LIST_CMD_MODIFY_64,
+	FUTEX_ROBUST_LIST_CMD_MODIFY_32,
+	FUTEX_ROBUST_LIST_CMD_LIST_LIMIT,
+	FUTEX_ROBUST_LIST_CMD_USER_MAX,
+
+	/*
+	 * Kernel internal, rejected for user space
+	 */
+	FUTEX_ROBUST_LIST_SET_NATIVE = 128,
+	FUTEX_ROBUST_LIST_SET_COMPAT,
+};
+
+struct robust_list32 {
+	uint32_t next;
+};
+
+struct robust_list_head32 {
+	struct robust_list32	list;
+	int32_t			futex_offset;
+	uint32_t		list_op_pending;
+};
+#endif
+
 static pthread_barrier_t barrier, barrier2;
 
 static int set_robust_list(struct robust_list_head *head, size_t len)
@@ -67,6 +96,65 @@ static int sys_futex_robust_unlock(_Atomic(uint32_t) *uaddr, unsigned int op, in
 	return syscall(SYS_futex, uaddr, op, val, NULL, list_op_pending, val3, 0);
 }
 
+static int set_robust_list2(struct robust_list_head *head, enum robust_list_cmd cmd,
+			    unsigned int index, unsigned int flags)
+{
+	return syscall(SYS_set_robust_list2, head, cmd, index, flags, 0, 0);
+}
+
+static bool robust_list2_support(void)
+{
+	int ret = set_robust_list2(NULL, FUTEX_ROBUST_LIST_CMD_LIST_LIMIT, 0, 0);
+
+	if (ret == -1 && errno == ENOSYS)
+		return false;
+
+	return true;
+}
+
+/*
+ * Return the set command according to the app bitness
+ */
+static int get_cmd_create(void)
+{
+	return sizeof(uintptr_t) == 8 ? FUTEX_ROBUST_LIST_CMD_CREATE_64 :
+	       FUTEX_ROBUST_LIST_CMD_CREATE_64;
+}
+
+static int get_cmd_modify(void)
+{
+	return sizeof(uintptr_t) == 8 ? FUTEX_ROBUST_LIST_CMD_MODIFY_64 :
+	       FUTEX_ROBUST_LIST_CMD_MODIFY_64;
+}
+
+FIXTURE(robust_api) {};
+
+FIXTURE_VARIANT(robust_api)
+{
+	bool robust2;
+};
+
+FIXTURE_SETUP(robust_api)
+{
+	if (!variant->robust2)
+		return;
+
+	if (!robust_list2_support())
+		SKIP(return, "robust_list2 not supported");
+}
+
+FIXTURE_TEARDOWN(robust_api) {}
+
+FIXTURE_VARIANT_ADD(robust_api, robust1)
+{
+	.robust2 = false,
+};
+
+FIXTURE_VARIANT_ADD(robust_api, robust2)
+{
+	.robust2 = true,
+};
+
 /*
  * Basic lock struct, contains just the futex word and the robust list element
  * Real implementations have also a *prev to easily walk in the list
@@ -76,6 +164,12 @@ typedef _Atomic(unsigned int) atomic_futex_t;
 struct lock_struct {
 	atomic_futex_t		futex;
 	struct robust_list	list;
+	bool			robust2;
+};
+
+struct lock_struct32 {
+	_Atomic(uint32_t)	futex;
+	struct robust_list32	list;
 };
 
 struct child_args {
@@ -118,20 +212,32 @@ static int create_child(struct __test_metadata *_metadata, int (*fn)(void *arg),
 /*
  * Helper function to prepare and register a robust list
  */
-static int set_list(struct robust_list_head *head)
+static int set_list(struct robust_list_head *head, bool robust2, int *index)
 {
 	int ret;
 
-	ret = set_robust_list(head, sizeof(*head));
-	if (ret)
-		return ret;
-
 	head->futex_offset = (size_t) offsetof(struct lock_struct, futex) -
 			     (size_t) offsetof(struct lock_struct, list);
 	head->list.next = &head->list;
 	head->list_op_pending = NULL;
 
-	return 0;
+	if (!robust2)
+		return set_robust_list(head, sizeof(*head));
+
+	ret = set_robust_list2(head, get_cmd_create(), 0, 0);
+
+	if (ret >= 0 && index)
+		*index = ret;
+
+	return ret;
+}
+
+/*
+ * Change a given list index to a different head
+ */
+static int modify_list(struct robust_list_head *head, int index)
+{
+	return set_robust_list2(head, get_cmd_modify(), index, 0);
 }
 
 /*
@@ -203,12 +309,12 @@ static int child_fn_lock(void *arg)
 	struct __test_metadata *_metadata = cargs->_metadata;
 	struct lock_struct *lock = cargs->arg;
 	struct robust_list_head head;
-	int ret;
+	int ret, index;
 
 	free(cargs);
 
-	ret = set_list(&head);
-	ASSERT_EQ(ret, 0)
+	ret = set_list(&head, lock->robust2, &index);
+	ASSERT_NE(ret, -1)
 		TH_LOG("set_robust_list error");
 
 	ret = mutex_lock(lock, &head, false);
@@ -233,15 +339,17 @@ static int child_fn_lock(void *arg)
  * in the robust list and die. The parent thread will wait on this futex, and
  * should be waken up when the child exits.
  */
-TEST(test_robustness)
+TEST_F(robust_api, test_robustness)
 {
 	struct lock_struct lock = { .futex = 0 };
 	atomic_futex_t *futex = &lock.futex;
 	struct robust_list_head head;
-	int ret, pid, wstatus;
+	int ret, pid, wstatus, index;
 
-	ret = set_list(&head);
-	ASSERT_EQ(ret, 0);
+	lock.robust2 = variant->robust2;
+
+	ret = set_list(&head, lock.robust2, &index);
+	ASSERT_NE(ret, -1);
 
 	/*
 	 * Lets use a barrier to ensure that the child thread takes the lock
@@ -296,6 +404,23 @@ TEST(test_set_robust_list_invalid_size)
 	ASSERT_EQ(errno, EINVAL);
 }
 
+/*
+ * Test invalid parameters
+ */
+TEST(test_set_robust_list2_inval)
+{
+	struct robust_list_head head;
+	int ret;
+
+	if (!robust_list2_support())
+		SKIP(return, "robust_list2 not supported\n");
+
+	/* Bad flag */
+	ret = set_robust_list2(&head, get_cmd_create(), 0, 999);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, EINVAL);
+}
+
 /*
  * Test get_robust_list with pid = 0, getting the list of the running thread
  */
@@ -388,12 +513,12 @@ static int child_fn_lock_with_error(void *arg)
 	struct __test_metadata *_metadata = cargs->_metadata;
 	struct lock_struct *lock = cargs->arg;
 	struct robust_list_head head;
-	int ret;
+	int ret, index;
 
 	free(cargs);
 
-	ret = set_list(&head);
-	ASSERT_EQ(ret, 0)
+	ret = set_list(&head, lock->robust2, &index);
+	ASSERT_NE(ret, -1)
 		TH_LOG("set_robust_list error");
 
 	ret = mutex_lock(lock, &head, true);
@@ -413,15 +538,17 @@ static int child_fn_lock_with_error(void *arg)
  * earlier, just after setting list_op_pending and taking the lock, to test the
  * list_op_pending mechanism
  */
-TEST(test_set_list_op_pending)
+TEST_F(robust_api, test_set_list_op_pending)
 {
 	struct lock_struct lock = { .futex = 0 };
 	atomic_futex_t *futex = &lock.futex;
 	struct robust_list_head head;
-	int ret, wstatus;
+	int ret, wstatus, index;
 
-	ret = set_list(&head);
-	ASSERT_EQ(ret, 0);
+	lock.robust2 = variant->robust2;
+
+	ret = set_list(&head, lock.robust2, &index);
+	ASSERT_NE(ret, -1);
 
 	ret = pthread_barrier_init(&barrier, NULL, 2);
 	ASSERT_EQ(ret, 0);
@@ -450,11 +577,11 @@ static int child_lock_holder(void *arg)
 	struct child_args *cargs = arg;
 	struct lock_struct *locks = cargs->arg;
 	struct robust_list_head head;
-	int i;
+	int i, index;
 
 	free(cargs);
 
-	set_list(&head);
+	set_list(&head, locks[0].robust2, &index);
 
 	for (i = 0; i < CHILD_NR; i++) {
 		locks[i].futex = 0;
@@ -495,17 +622,23 @@ static int child_wait_lock(void *arg)
  * Test a robust list of more than one element. All the waiters should wake when
  * the holder dies
  */
-TEST(test_robust_list_multiple_elements)
+TEST_F(robust_api, test_robust_list_multiple_elements)
 {
 	struct lock_struct locks[CHILD_NR];
 	pid_t pids[CHILD_NR + 1];
 	int i, ret, wstatus;
 
+	if (variant->robust2 && !robust_list2_support())
+		SKIP(return, "robust_list2 not supported\n");
+
+	locks[0].robust2 = variant->robust2;
+
 	ret = pthread_barrier_init(&barrier, NULL, 2);
 	ASSERT_EQ(ret, 0);
 	ret = pthread_barrier_init(&barrier2, NULL, CHILD_NR + 1);
 	ASSERT_EQ(ret, 0);
 
+
 	pids[0] = create_child(_metadata, &child_lock_holder, &locks);
 	ASSERT_NE(pids[0], -1);
 
@@ -532,18 +665,110 @@ TEST(test_robust_list_multiple_elements)
 		TH_LOG("One or more children failed");
 }
 
+static int child_lock_holder_multiple_lists(void *arg)
+{
+	struct child_args *cargs = arg;
+	struct __test_metadata *_metadata = cargs->_metadata;
+	struct lock_struct *locks = cargs->arg;
+	struct robust_list_head *heads;
+	int i, list_limit, index, ret;
+
+	list_limit = set_robust_list2(NULL, FUTEX_ROBUST_LIST_CMD_LIST_LIMIT, 0, 0);
+	ASSERT_GT(list_limit, 1);
+
+	heads = malloc(list_limit * sizeof(*heads));
+	ASSERT_TRUE((uintptr_t) heads);
+
+	/*
+	 * Try to clear any exiting list, ignore errors if they didn't exit
+	 */
+	for (i = 0; i < list_limit; i++)
+		modify_list(NULL, i);
+
+	/*
+	 * Given that this thread has no robust list attached yet, it should
+	 * get as return all available lists in order [0, list_limit)
+	 */
+	for (i = 0; i < list_limit; i++) {
+		ret = set_list(&heads[i], true, &index);
+		ASSERT_EQ(ret, i);
+		locks[i].futex = 0;
+		mutex_lock(&locks[i], &heads[i], false);
+	}
+
+	pthread_barrier_wait(&barrier);
+	pthread_barrier_wait(&barrier2);
+
+	/* See comment at child_fn_lock() */
+	usleep(SLEEP_US * 10);
+
+	return 0;
+}
+
+/*
+ * Similar to test_robust_list_multiple_elements, but instead of one list with
+ * several elements, create several lists with one element.
+ */
+TEST(test_robust_list_multiple_lists)
+{
+	int i, ret, wstatus, list_limit;
+	struct lock_struct *locks;
+	pid_t *pids;
+
+	if (!robust_list2_support())
+		SKIP(return, "robust_list2 not supported\n");
+
+	list_limit = set_robust_list2(NULL, FUTEX_ROBUST_LIST_CMD_LIST_LIMIT, 0, 0);
+	ASSERT_GT(list_limit, 1);
+
+	locks = malloc(list_limit * sizeof(*locks));
+	ASSERT_NE(locks, NULL);
+
+	pids = malloc(list_limit * sizeof(*pids));
+	ASSERT_NE(pids, NULL);
+
+	ret = pthread_barrier_init(&barrier, NULL, 2);
+	ASSERT_EQ(ret, 0);
+	ret = pthread_barrier_init(&barrier2, NULL, list_limit + 1);
+	ASSERT_EQ(ret, 0);
+
+	pids[0] = create_child(_metadata, &child_lock_holder_multiple_lists, locks);
+
+	/* Wait until the locker thread takes the look */
+	pthread_barrier_wait(&barrier);
+
+	for (i = 0; i < list_limit; i++)
+		pids[i+1] = create_child(_metadata, &child_wait_lock, &locks[i]);
+
+	/* Wait for all children to return */
+	ret = 0;
+
+	for (i = 0; i < list_limit; i++) {
+		waitpid(pids[i], &wstatus, 0);
+		if (WEXITSTATUS(wstatus))
+			ret = -1;
+	}
+
+	pthread_barrier_destroy(&barrier);
+	pthread_barrier_destroy(&barrier2);
+
+	free(locks);
+	free(pids);
+}
+
 static int child_circular_list(void *arg)
 {
 	struct child_args *cargs = arg;
+	bool robust2 = cargs->arg;
 	struct __test_metadata *_metadata = cargs->_metadata;
 	static struct lock_struct a, b, c;
 	struct robust_list_head head;
-	int ret;
+	int ret, index;
 
 	free(cargs);
 
-	ret = set_list(&head);
-	ASSERT_EQ(ret, 0)
+	ret = set_list(&head, robust2, &index);
+	ASSERT_NE(ret, -1)
 		TH_LOG("set_list error");
 
 	head.list.next = &a.list;
@@ -563,11 +788,13 @@ static int child_circular_list(void *arg)
  * while processing it so it won't be trapped in an infinite loop while handling
  * a process exit
  */
-TEST(test_circular_list)
+TEST_F(robust_api, test_circular_list)
 {
+	bool robust2 = variant->robust2;
 	int wstatus;
 	pid_t pid;
 
+	create_child(_metadata, child_circular_list, (void *) robust2);
 	pid = create_child(_metadata, child_circular_list, NULL);
 	ASSERT_NE(pid, -1);
 
@@ -660,8 +887,8 @@ TEST_F(vdso_unlock, test_robust_try_unlock_uncontended)
 
 	*futex = tid;
 
-	ret = set_list(&head);
-	if (ret)
+	ret = set_list(&head, false, NULL);
+	if (ret == -1)
 		ksft_test_result_fail("set_robust_list error\n");
 
 	head.list_op_pending = &lock.list;
@@ -700,8 +927,8 @@ TEST_F(vdso_unlock, test_robust_try_unlock_contended)
 
 	*futex = tid | FUTEX_WAITERS;
 
-	ret = set_list(&head);
-	if (ret)
+	ret = set_list(&head, false, NULL);
+	if (ret == -1)
 		ksft_test_result_fail("set_robust_list error\n");
 
 	head.list_op_pending = &lock.list;
@@ -783,8 +1010,8 @@ TEST_F(futex_op, test_futex_robust_unlock)
 
 	*futex = tid | FUTEX_WAITERS;
 
-	ret = set_list(&head);
-	if (ret)
+	ret = set_list(&head, false, 0);
+	if (ret == -1)
 		ksft_test_result_fail("set_robust_list error\n");
 
 	head.list_op_pending = &lock.list;
@@ -806,4 +1033,142 @@ TEST_F(futex_op, test_futex_robust_unlock)
 	ASSERT_EQ((uintptr_t)(unsigned long)head.list_op_pending, exp);
 }
 
+/*
+ * 32-bit version of child_lock_holder.
+ */
+static int child_lock_holder32(void *arg)
+{
+	struct child_args *cargs = arg;
+	struct lock_struct32 *locks = cargs->arg;
+	struct __test_metadata *_metadata = cargs->_metadata;
+	struct robust_list_head32 *head;
+	pid_t tid = gettid();
+	int i, ret;
+
+	head = mmap((void *)0x10000, sizeof(*head), PROT_READ | PROT_WRITE,
+		    MAP_FIXED_NOREPLACE | MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+
+	ASSERT_TRUE((uintptr_t) head);
+	ASSERT_LT(((uint32_t)(uintptr_t) head), 0x7FFFFFFF);
+
+	head->futex_offset = (uint32_t) ((size_t) offsetof(struct lock_struct32, futex) -
+			     (size_t) offsetof(struct lock_struct32, list));
+	head->list.next = (uint32_t)(uintptr_t) &head->list;
+	head->list_op_pending = (uint32_t)(uintptr_t) NULL;
+
+	ret = set_robust_list2((struct robust_list_head *) head,
+			FUTEX_ROBUST_LIST_CMD_CREATE_32, 0, 0);
+	ASSERT_GE(ret, 0);
+
+	/*
+	 * Take all the locks and insert them in the list
+	 */
+	for (i = 0; i < CHILD_NR; i++) {
+		struct robust_list32 *list = &head->list;
+
+		locks[i].futex = tid;
+
+		while (list->next != (uint32_t)(uintptr_t) &head->list)
+			list = (struct robust_list32 *)(uintptr_t) list->next;
+
+		list->next = (uint32_t)(uintptr_t) &locks[i].list;
+		locks[i].list.next = (uint32_t)(uintptr_t) &head->list;
+	}
+
+	pthread_barrier_wait(&barrier);
+	pthread_barrier_wait(&barrier2);
+
+	/* See comment at child_fn_lock() */
+	usleep(SLEEP_US);
+
+	/* Exit holding all the locks */
+	return 0;
+}
+
+static int child_wait_lock32(void *arg)
+{
+	struct child_args *cargs = arg;
+	struct __test_metadata *_metadata = cargs->_metadata;
+	struct lock_struct32 *lock = cargs->arg;
+	atomic_futex_t *futex;
+	struct timespec to;
+	pid_t tid;
+	int ret;
+
+	futex = &lock->futex;
+
+	pthread_barrier_wait(&barrier2);
+
+	to.tv_sec = FUTEX_TIMEOUT;
+	to.tv_nsec = 0;
+
+	tid = atomic_load(futex);
+
+	/* Kernel ignores futexes without the waiters flag */
+	tid |= FUTEX_WAITERS;
+	atomic_store(futex, tid);
+
+	ret = futex_wait((futex_t *) futex, tid, &to, 0);
+
+	ASSERT_EQ(ret, 0);
+	ASSERT_TRUE(lock->futex & FUTEX_OWNER_DIED);
+
+	return 0;
+}
+
+/*
+ * Test to create a 32-bit robust list in a 64-bit kernel. Replicate
+ * test_robust_list_multiple_elements, but it's simplified: don't do all the
+ * mutex lock dance, just insert futexes in the list and check if the kernel
+ * correctly walks the list and wake the threads
+ */
+TEST(test_32bit_lists)
+{
+	struct lock_struct32 *locks;
+	pid_t pids[CHILD_NR + 1];
+	int i, ret, wstatus;
+
+#ifndef BUILD_64
+	SKIP(return, "Test only for 64-bit\n");
+#endif
+
+	if (!robust_list2_support())
+		SKIP(return, "robust_list2 not supported\n");
+
+	locks = mmap((void *)0x20000, sizeof(*locks) * CHILD_NR,
+		     PROT_READ | PROT_WRITE,
+		     MAP_FIXED_NOREPLACE | MAP_PRIVATE | MAP_ANONYMOUS,
+		     -1, 0);
+
+	ASSERT_NE(locks, NULL);
+	ASSERT_LT((uintptr_t) locks, 0x7FFFFFFF);
+
+	ret = pthread_barrier_init(&barrier, NULL, 2);
+	ASSERT_EQ(ret, 0);
+	ret = pthread_barrier_init(&barrier2, NULL, CHILD_NR + 1);
+	ASSERT_EQ(ret, 0);
+
+	pids[0] = create_child(_metadata, &child_lock_holder32, locks);
+
+	/* Wait until the locker thread takes the look */
+	pthread_barrier_wait(&barrier);
+
+	for (i = 0; i < CHILD_NR; i++)
+		pids[i+1] = create_child(_metadata, &child_wait_lock32, &locks[i]);
+
+	/* Wait for all children to return */
+	ret = 0;
+
+	for (i = 0; i < CHILD_NR; i++) {
+		waitpid(pids[i], &wstatus, 0);
+		if (WEXITSTATUS(wstatus))
+			ret = -1;
+	}
+
+	pthread_barrier_destroy(&barrier);
+	pthread_barrier_destroy(&barrier2);
+
+	munmap(locks, sizeof(*locks) * CHILD_NR);
+}
+
 TEST_HARNESS_MAIN

-- 
2.55.0

