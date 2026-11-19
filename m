Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795102606;
	b=B5Wmti+F5NUjPPgQLA70DH130PIjOWjHTy0ER00vd8RROZf+C0Uq1rC1C82tkZuYygdQ
	 JAX+HS+31dP2pRmDsS9srA4Ea7bu6Tpk1hPN1cEROVT5S5bXOfeKtV5+0sehr3mge7ZLR
	 raU4cs0JI/3bS44pGcppnXoicOxb0SH5matAaZTn2ehDHLHg4AxRGSurfh750tBn58ZJk
	 zg3l3fthtwQrM3p+fx4p+aXltIaU/sQ7+0Sb6iWz0UPIZzArP7MFp+CvI3EETByiXAIZr
	 OOzHoSfv4SY7uKIk7IfZvU7ENTSooMRFZAQhHl98RXTKf5x9WaIbjJY5OQhfX2RHRrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795102606;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer;
	bh=/nVmRQY/vXeDckaLsEBZ3X40t7zF05PmudVPaoNdkas=;
	b=xVduWIpEi360Psn67S8Za8a7ehJEjIxMbO7DMd9Ghi/JqlY8G2/Dpn9sOH85a2Hq039d
	 mfSoeODSVRORS1v3jfIQd8NlIFUBsgZzdxwayYzTIegGXxlHrO2sTOe+YN3T74256qqjV
	 me3w8M3BJ94nT3878M70c1Lpia9ZM9MLEdrJt/L60Bte1AT7sZLXPJ7j6ViPw/zfm/Sdl
	 BZB07Wc4heHI1TeP39uXyt/aHAmJTJPdST9KLqco0hQnVF1wt2SCiQOJRU1c4GHQZp3qV
	 qY9ofw0NiUE+yjMyLgk6XB/NkomWSdGBGpdGqkL7npiEnx7HdB9xQrMvE7fcfIgiGhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=GbqnWalR;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F1FD60A260E;
	Thu, 19 Nov 2026 15:36:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F1FD60A260E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=GbqnWalR
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8D9CE1575;
	Thu, 19 Nov 2026 07:36:40 -0800 (PST)
Received: from e142430.arm.com (e142430.arm.com [10.33.10.110])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AFFD53F882;
	Thu, 19 Nov 2026 07:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795102603; bh=bWqbG7nMrp9zDdEPwBDWvJaqjRCBwTLQZuz2dcCDj7g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=GbqnWalRko6o6LlFKSeLPQt2U5JRc08zNPvyUKSxlWmf1B+mTdIwfCcwpZDzC696Q
	 GrZcMqyv/t7MPVrnoLU11MsiReZpE77BvnFeYe2BkTad3rjRf8IHDxHatCDR512l+o
	 irPsse3jX3kbFLSfzkqtFsczI1DuUuEsBU6od9PM=
From: Ahmed Azeem <ahmed.azeem@arm.com>
Date: Thu, 19 Nov 2026 15:36:06 +0000
Subject: [PATCH RFC 4/4] firmware: arm: Harden PFDI worker and hotplug
 handling
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
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-topics-ahmaze01-upstream-pfdi-rfc-v1-4-4772d18b9115@arm.com>
References: <20261119-topics-ahmaze01-upstream-pfdi-rfc-v1-0-4772d18b9115@arm.com>
In-Reply-To: <20261119-topics-ahmaze01-upstream-pfdi-rfc-v1-0-4772d18b9115@arm.com>
To: linux-arm-kernel@lists.infradead.org, 
 Sudeep Holla <sudeep.holla@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
 Lorenzo Pieralisi <lpieralisi@kernel.org>, linux-api@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Divin Raj <divin.raj@arm.com>, Bertrand Marquis <Bertrand.Marquis@arm.com>, 
 Ahmed Azeem <ahmed.azeem@arm.com>
X-Mailer: b4 0.13.0

From: Divin Raj <divin.raj@arm.com>

Tighten lifetime rules for the per-CPU worker and misc devices.

Do not reuse worker state after a timeout, as the SMC may still be
executing in firmware after wait_for_completion_timeout() expires.
Track in-flight work explicitly, prevent reuse until completion, and
reject teardown while work is active.

Gate open() against CPU teardown, preserve the full 64-bit failing test
identifier returned by firmware, and ensure device removal does not race
with open file descriptors or in-progress requests.

Signed-off-by: Divin Raj <divin.raj@arm.com>
Signed-off-by: Ahmed Azeem <ahmed.azeem@arm.com>
---
 drivers/firmware/arm_pfdi.c | 406 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 320 insertions(+), 86 deletions(-)

diff --git a/drivers/firmware/arm_pfdi.c b/drivers/firmware/arm_pfdi.c
index 22a69b12dbc8..34ccbb7724e6 100644
--- a/drivers/firmware/arm_pfdi.c
+++ b/drivers/firmware/arm_pfdi.c
@@ -24,10 +24,13 @@ struct pfdi_per_cpu_info {
 	atomic_t run_inprogress;
 	/* Ensures a single userspace owner per CPU while the node is open. */
 	struct semaphore open_sem;
+	/* Bumped on each device recreation so stale file contexts can be rejected. */
+	unsigned int generation;
 	/* Serializes per-CPU run state and device availability. */
 	struct mutex state_lock;
 	struct pfdi_test_range ongoing_run_range;
 	wait_queue_head_t run_wait;
+	bool online;
 };
 
 struct pfdi_dev_data {
@@ -36,9 +39,17 @@ struct pfdi_dev_data {
 	char nodename[24];
 };
 
+struct pfdi_file_ctx {
+	unsigned int cpu;
+	/* Snapshot of cpu_info->generation taken when the file was opened. */
+	unsigned int generation;
+};
+
 struct pfdi_cpu_worker {
 	struct kthread_work work;
 	struct completion done;
+	/* Serializes request staging and result extraction around the worker. */
+	struct mutex op_lock;
 	u32 feature_fid;
 	/* Protects worker lifetime and in-flight work state. */
 	struct mutex worker_lock;
@@ -46,6 +57,9 @@ struct pfdi_cpu_worker {
 	struct pfdi_test_run test_run;
 	struct arm_smccc_res smc_ret;
 	int result;
+	bool work_inflight;
+	bool shutting_down;
+	wait_queue_head_t worker_wait;
 };
 
 static const u32 pfdi_supported_fids[] = {
@@ -141,32 +155,80 @@ static int pfdi_validate_cpu_features(void)
 	return 0;
 }
 
-static int pfdi_thread_worker(unsigned int cpu,
-			      void (*handler)(struct kthread_work *work),
-			      unsigned long timeout)
+static int pfdi_reserve_worker(unsigned int cpu, unsigned long timeout)
 {
 	int ret = 0;
 	struct kthread_worker *worker;
 	struct pfdi_cpu_worker *worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
 
+retry:
 	mutex_lock(&worker_ctx->worker_lock);
-	worker = per_cpu(pfdi_worker, cpu);
-	if (!worker) {
+	worker = READ_ONCE(per_cpu(pfdi_worker, cpu));
+	if (!worker || worker_ctx->shutting_down) {
 		mutex_unlock(&worker_ctx->worker_lock);
 		return -ENODEV;
 	}
 
+	if (worker_ctx->work_inflight) {
+		mutex_unlock(&worker_ctx->worker_lock);
+		ret =
+			wait_event_interruptible_timeout(worker_ctx->worker_wait,
+							 !READ_ONCE(worker_ctx->work_inflight) ||
+							 READ_ONCE(worker_ctx->shutting_down),
+							 timeout);
+		if (ret < 0)
+			return ret;
+		if (!ret)
+			return -ETIME;
+		goto retry;
+	}
+
 	reinit_completion(&worker_ctx->done);
+	WRITE_ONCE(worker_ctx->work_inflight, true);
+	mutex_unlock(&worker_ctx->worker_lock);
+
+	return 0;
+}
+
+static int pfdi_queue_worker(unsigned int cpu,
+			     void (*handler)(struct kthread_work *work),
+			     unsigned long timeout)
+{
+	struct kthread_worker *worker;
+	struct pfdi_cpu_worker *worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
+
+	mutex_lock(&worker_ctx->worker_lock);
+	worker = READ_ONCE(per_cpu(pfdi_worker, cpu));
+	if (!worker || worker_ctx->shutting_down || !worker_ctx->work_inflight) {
+		mutex_unlock(&worker_ctx->worker_lock);
+		return -ENODEV;
+	}
+
 	kthread_init_work(&worker_ctx->work, handler);
 	kthread_queue_work(worker, &worker_ctx->work);
+	mutex_unlock(&worker_ctx->worker_lock);
 
-	if (!wait_for_completion_timeout(&worker_ctx->done, timeout)) {
-		ret = -ETIME;
-		kthread_cancel_work_sync(&worker_ctx->work);
-	}
+	if (!wait_for_completion_timeout(&worker_ctx->done, timeout))
+		return -ETIME;
+
+	return 0;
+}
 
+static void pfdi_complete_worker(struct pfdi_cpu_worker *worker_ctx)
+{
+	/*
+	 * Signal the current request before making the worker available again.
+	 * Otherwise a timed-out caller can release op_lock, a new caller can
+	 * reuse the shared completion, and this completion can satisfy the new
+	 * request before its work has run.
+	 */
+	complete(&worker_ctx->done);
+
+	mutex_lock(&worker_ctx->worker_lock);
+	WRITE_ONCE(worker_ctx->work_inflight, false);
 	mutex_unlock(&worker_ctx->worker_lock);
-	return ret;
+
+	wake_up(&worker_ctx->worker_wait);
 }
 
 static void pfdi_pe_get_test_id_fn(struct kthread_work *work)
@@ -175,7 +237,7 @@ static void pfdi_pe_get_test_id_fn(struct kthread_work *work)
 
 	worker_ctx = container_of(work, struct pfdi_cpu_worker, work);
 	worker_ctx->smc_ret = pfdi_smc_call(PFDI_FN_PE_TEST_ID, 0, 0, 0, 0);
-	complete(&worker_ctx->done);
+	pfdi_complete_worker(worker_ctx);
 }
 
 static void pfdi_pe_get_version_fn(struct kthread_work *work)
@@ -184,7 +246,7 @@ static void pfdi_pe_get_version_fn(struct kthread_work *work)
 
 	worker_ctx = container_of(work, struct pfdi_cpu_worker, work);
 	worker_ctx->smc_ret = pfdi_smc_call(PFDI_FN_VERSION, 0, 0, 0, 0);
-	complete(&worker_ctx->done);
+	pfdi_complete_worker(worker_ctx);
 }
 
 static int pfdi_pe_get_version(unsigned int cpu, u32 *version)
@@ -192,14 +254,24 @@ static int pfdi_pe_get_version(unsigned int cpu, u32 *version)
 	s64 ret;
 	struct pfdi_cpu_worker *worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
 
-	ret = pfdi_thread_worker(cpu, pfdi_pe_get_version_fn,
-				 MAX_SCHEDULE_TIMEOUT);
-	if (ret)
+	mutex_lock(&worker_ctx->op_lock);
+	ret = pfdi_reserve_worker(cpu, MAX_SCHEDULE_TIMEOUT);
+	if (ret) {
+		mutex_unlock(&worker_ctx->op_lock);
 		return ret;
+	}
 
-	ret = (int)worker_ctx->smc_ret.a0;
+	ret = pfdi_queue_worker(cpu, pfdi_pe_get_version_fn,
+				MAX_SCHEDULE_TIMEOUT);
+	if (ret) {
+		mutex_unlock(&worker_ctx->op_lock);
+		return ret;
+	}
+
+	ret = (s64)worker_ctx->smc_ret.a0;
 	if (ret >= 0)
 		*version = (u32)ret;
+	mutex_unlock(&worker_ctx->op_lock);
 
 	if (ret >= 0)
 		return 0;
@@ -215,7 +287,7 @@ static void pfdi_pe_get_features_fn(struct kthread_work *work)
 	worker_ctx->result = pfdi_smc_call(PFDI_FN_FEATURES,
 					   worker_ctx->feature_fid,
 					   0, 0, 0).a0;
-	complete(&worker_ctx->done);
+	pfdi_complete_worker(worker_ctx);
 }
 
 static int pfdi_pe_get_features(unsigned int cpu, u32 fid)
@@ -223,13 +295,25 @@ static int pfdi_pe_get_features(unsigned int cpu, u32 fid)
 	int ret;
 	struct pfdi_cpu_worker *worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
 
+	mutex_lock(&worker_ctx->op_lock);
+	ret = pfdi_reserve_worker(cpu, MAX_SCHEDULE_TIMEOUT);
+	if (ret) {
+		mutex_unlock(&worker_ctx->op_lock);
+		return ret;
+	}
+
 	worker_ctx->feature_fid = fid;
-	ret = pfdi_thread_worker(cpu, pfdi_pe_get_features_fn,
-				 MAX_SCHEDULE_TIMEOUT);
-	if (ret)
+	ret = pfdi_queue_worker(cpu, pfdi_pe_get_features_fn,
+				MAX_SCHEDULE_TIMEOUT);
+	if (ret) {
+		mutex_unlock(&worker_ctx->op_lock);
 		return ret;
+	}
 
-	return pfdi_to_linux_errno(worker_ctx->result);
+	ret = worker_ctx->result;
+	mutex_unlock(&worker_ctx->op_lock);
+
+	return pfdi_to_linux_errno(ret);
 }
 
 static int pfdi_pe_get_test_id(unsigned int cpu, u64 *lib_info)
@@ -237,14 +321,24 @@ static int pfdi_pe_get_test_id(unsigned int cpu, u64 *lib_info)
 	int ret;
 	struct pfdi_cpu_worker *worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
 
-	ret = pfdi_thread_worker(cpu, pfdi_pe_get_test_id_fn,
-				 MAX_SCHEDULE_TIMEOUT);
-	if (ret)
+	mutex_lock(&worker_ctx->op_lock);
+	ret = pfdi_reserve_worker(cpu, MAX_SCHEDULE_TIMEOUT);
+	if (ret) {
+		mutex_unlock(&worker_ctx->op_lock);
 		return ret;
+	}
+
+	ret = pfdi_queue_worker(cpu, pfdi_pe_get_test_id_fn,
+				MAX_SCHEDULE_TIMEOUT);
+	if (ret) {
+		mutex_unlock(&worker_ctx->op_lock);
+		return ret;
+	}
 
 	ret = (int)worker_ctx->smc_ret.a0;
 	if (!ret)
 		*lib_info = worker_ctx->smc_ret.a1;
+	mutex_unlock(&worker_ctx->op_lock);
 
 	return pfdi_to_linux_errno(ret);
 }
@@ -256,7 +350,7 @@ static void pfdi_pe_get_test_count_fn(struct kthread_work *work)
 	worker_ctx = container_of(work, struct pfdi_cpu_worker, work);
 	worker_ctx->smc_ret = pfdi_smc_call(PFDI_FN_PE_TEST_PART_COUNT,
 					    0, 0, 0, 0);
-	complete(&worker_ctx->done);
+	pfdi_complete_worker(worker_ctx);
 }
 
 static int pfdi_pe_get_test_count(unsigned int cpu, s64 *count)
@@ -264,12 +358,22 @@ static int pfdi_pe_get_test_count(unsigned int cpu, s64 *count)
 	s64 ret;
 	struct pfdi_cpu_worker *worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
 
-	ret = pfdi_thread_worker(cpu, pfdi_pe_get_test_count_fn,
-				 MAX_SCHEDULE_TIMEOUT);
-	if (ret)
+	mutex_lock(&worker_ctx->op_lock);
+	ret = pfdi_reserve_worker(cpu, MAX_SCHEDULE_TIMEOUT);
+	if (ret) {
+		mutex_unlock(&worker_ctx->op_lock);
 		return ret;
+	}
+
+	ret = pfdi_queue_worker(cpu, pfdi_pe_get_test_count_fn,
+				MAX_SCHEDULE_TIMEOUT);
+	if (ret) {
+		mutex_unlock(&worker_ctx->op_lock);
+		return ret;
+	}
 
 	ret = (s64)worker_ctx->smc_ret.a0;
+	mutex_unlock(&worker_ctx->op_lock);
 	if (ret >= 0) {
 		*count = ret;
 		return 0;
@@ -285,18 +389,32 @@ static void pfdi_pe_fw_check_fn(struct kthread_work *work)
 	worker_ctx = container_of(work, struct pfdi_cpu_worker, work);
 	worker_ctx->result = pfdi_smc_call(PFDI_FN_FW_CHECK,
 					   0, 0, 0, 0).a0;
-	complete(&worker_ctx->done);
+	pfdi_complete_worker(worker_ctx);
 }
 
 static int pfdi_pe_fw_check(unsigned int cpu)
 {
 	int ret;
+	struct pfdi_cpu_worker *worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
 
-	ret = pfdi_thread_worker(cpu, pfdi_pe_fw_check_fn, MAX_SCHEDULE_TIMEOUT);
-	if (ret)
+	mutex_lock(&worker_ctx->op_lock);
+	ret = pfdi_reserve_worker(cpu, MAX_SCHEDULE_TIMEOUT);
+	if (ret) {
+		mutex_unlock(&worker_ctx->op_lock);
+		return ret;
+	}
+
+	ret = pfdi_queue_worker(cpu, pfdi_pe_fw_check_fn,
+				MAX_SCHEDULE_TIMEOUT);
+	if (ret) {
+		mutex_unlock(&worker_ctx->op_lock);
 		return ret;
+	}
 
-	return pfdi_to_linux_errno(per_cpu(pfdi_worker_ctx, cpu).result);
+	ret = worker_ctx->result;
+	mutex_unlock(&worker_ctx->op_lock);
+
+	return pfdi_to_linux_errno(ret);
 }
 
 static void pfdi_pe_get_result_fn(struct kthread_work *work)
@@ -306,7 +424,7 @@ static void pfdi_pe_get_result_fn(struct kthread_work *work)
 	worker_ctx = container_of(work, struct pfdi_cpu_worker, work);
 	worker_ctx->smc_ret = pfdi_smc_call(PFDI_FN_PE_TEST_RESULT,
 					    0, 0, 0, 0);
-	complete(&worker_ctx->done);
+	pfdi_complete_worker(worker_ctx);
 }
 
 static int pfdi_pe_get_result(unsigned int cpu, s64 *ft_id)
@@ -314,14 +432,24 @@ static int pfdi_pe_get_result(unsigned int cpu, s64 *ft_id)
 	int ret;
 	struct pfdi_cpu_worker *worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
 
-	ret = pfdi_thread_worker(cpu, pfdi_pe_get_result_fn,
-				 MAX_SCHEDULE_TIMEOUT);
-	if (ret)
+	mutex_lock(&worker_ctx->op_lock);
+	ret = pfdi_reserve_worker(cpu, MAX_SCHEDULE_TIMEOUT);
+	if (ret) {
+		mutex_unlock(&worker_ctx->op_lock);
 		return ret;
+	}
+
+	ret = pfdi_queue_worker(cpu, pfdi_pe_get_result_fn,
+				MAX_SCHEDULE_TIMEOUT);
+	if (ret) {
+		mutex_unlock(&worker_ctx->op_lock);
+		return ret;
+	}
 
 	ret = (int)worker_ctx->smc_ret.a0;
 	if (ret == PFDI_RET_FAULT_FOUND)
 		*ft_id = worker_ctx->smc_ret.a1;
+	mutex_unlock(&worker_ctx->op_lock);
 
 	return pfdi_to_linux_errno(ret);
 }
@@ -335,7 +463,7 @@ static void pfdi_pe_force_error_fn(struct kthread_work *work)
 					   worker_ctx->error_info.smc_fid,
 					   worker_ctx->error_info.error_id,
 					   0, 0).a0;
-	complete(&worker_ctx->done);
+	pfdi_complete_worker(worker_ctx);
 }
 
 static int pfdi_pe_force_error(unsigned int cpu,
@@ -351,14 +479,26 @@ static int pfdi_pe_force_error(unsigned int cpu,
 	    error_info->error_id > SMCCC_RET_SUCCESS)
 		return -EINVAL;
 
+	mutex_lock(&worker_ctx->op_lock);
+	ret = pfdi_reserve_worker(cpu, MAX_SCHEDULE_TIMEOUT);
+	if (ret) {
+		mutex_unlock(&worker_ctx->op_lock);
+		return ret;
+	}
+
 	worker_ctx->error_info = *error_info;
 
-	ret = pfdi_thread_worker(cpu, pfdi_pe_force_error_fn,
-				 MAX_SCHEDULE_TIMEOUT);
-	if (ret)
+	ret = pfdi_queue_worker(cpu, pfdi_pe_force_error_fn,
+				MAX_SCHEDULE_TIMEOUT);
+	if (ret) {
+		mutex_unlock(&worker_ctx->op_lock);
 		return ret;
+	}
 
-	return pfdi_to_linux_errno(worker_ctx->result);
+	ret = worker_ctx->result;
+	mutex_unlock(&worker_ctx->op_lock);
+
+	return pfdi_to_linux_errno(ret);
 }
 
 static bool pfdi_ranges_equal(const struct pfdi_test_range *lhs,
@@ -397,6 +537,18 @@ static int pfdi_validate_test_range(unsigned int cpu,
 	return 0;
 }
 
+static bool pfdi_file_ctx_valid(const struct pfdi_file_ctx *ctx)
+{
+	bool valid;
+	struct pfdi_per_cpu_info *cpu_info = &per_cpu(pfdi_cpu_info, ctx->cpu);
+
+	mutex_lock(&cpu_info->state_lock);
+	valid = cpu_info->online && ctx->generation == cpu_info->generation;
+	mutex_unlock(&cpu_info->state_lock);
+
+	return valid;
+}
+
 static void pfdi_pe_run_fn(struct kthread_work *work)
 {
 	struct arm_smccc_res smc_ret;
@@ -411,12 +563,12 @@ static void pfdi_pe_run_fn(struct kthread_work *work)
 		worker_ctx->test_run.ft_id = smc_ret.a1;
 
 	worker_ctx->result = (int)smc_ret.a0;
-	complete(&worker_ctx->done);
+	pfdi_complete_worker(worker_ctx);
 }
 
 static int pfdi_pe_run_tests(unsigned int cpu, struct pfdi_test_run *test_run)
 {
-	int ret;
+	int ret, result;
 	unsigned long wait_timeout;
 	struct pfdi_cpu_worker *worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
 	struct pfdi_per_cpu_info *cpu_info = &per_cpu(pfdi_cpu_info, cpu);
@@ -447,14 +599,26 @@ static int pfdi_pe_run_tests(unsigned int cpu, struct pfdi_test_run *test_run)
 
 	atomic_set(&cpu_info->run_inprogress, 1);
 	cpu_info->ongoing_run_range = test_run->range;
-	worker_ctx->test_run = *test_run;
+	mutex_lock(&worker_ctx->op_lock);
 	mutex_unlock(&cpu_info->state_lock);
 
-	ret = pfdi_thread_worker(cpu, pfdi_pe_run_fn, wait_timeout);
+	/*
+	 * wait_timeout_ms limits how long a caller waits behind another run.
+	 * Once this run is selected to execute, wait for the worker to really
+	 * become available and for the firmware operation to complete.
+	 */
+	ret = pfdi_reserve_worker(cpu, MAX_SCHEDULE_TIMEOUT);
+	if (!ret) {
+		worker_ctx->test_run = *test_run;
+		ret = pfdi_queue_worker(cpu, pfdi_pe_run_fn, MAX_SCHEDULE_TIMEOUT);
+	}
 
 	mutex_lock(&cpu_info->state_lock);
-	if (worker_ctx->result == PFDI_RET_FAULT_FOUND)
+	if (!ret && worker_ctx->result == PFDI_RET_FAULT_FOUND)
 		test_run->ft_id = worker_ctx->test_run.ft_id;
+	if (!ret)
+		result = worker_ctx->result;
+	mutex_unlock(&worker_ctx->op_lock);
 	atomic_set(&cpu_info->run_inprogress, 0);
 	wake_up_all(&cpu_info->run_wait);
 	mutex_unlock(&cpu_info->state_lock);
@@ -462,14 +626,16 @@ static int pfdi_pe_run_tests(unsigned int cpu, struct pfdi_test_run *test_run)
 	if (ret)
 		return ret;
 
-	return pfdi_to_linux_errno(worker_ctx->result);
+	return pfdi_to_linux_errno(result);
 }
 
 static int arm_pfdi_open(struct inode *inode, struct file *file)
 {
 	struct miscdevice *misc_dev = file->private_data;
 	struct pfdi_dev_data *data;
-	unsigned int cpu;
+	struct pfdi_per_cpu_info *cpu_info;
+	struct pfdi_file_ctx *ctx;
+	unsigned int cpu, generation;
 
 	if (!misc_dev || !misc_dev->this_device)
 		return -ENODEV;
@@ -478,18 +644,38 @@ static int arm_pfdi_open(struct inode *inode, struct file *file)
 	if (!data)
 		return -ENODEV;
 
+	ctx = kzalloc_obj(*ctx, GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
 	cpu = get_cpu();
 	if (data->cpu_id != cpu) {
 		put_cpu();
+		kfree(ctx);
 		return -EPERM;
 	}
+	cpu_info = &per_cpu(pfdi_cpu_info, cpu);
+	put_cpu();
 
-	if (down_trylock(&per_cpu(pfdi_cpu_info, cpu).open_sem)) {
-		put_cpu();
+	mutex_lock(&cpu_info->state_lock);
+	if (!cpu_info->online) {
+		mutex_unlock(&cpu_info->state_lock);
+		kfree(ctx);
+		return -ENODEV;
+	}
+
+	if (down_trylock(&cpu_info->open_sem)) {
+		mutex_unlock(&cpu_info->state_lock);
+		kfree(ctx);
 		return -EBUSY;
 	}
+	generation = cpu_info->generation;
 
-	put_cpu();
+	mutex_unlock(&cpu_info->state_lock);
+
+	ctx->cpu = cpu;
+	ctx->generation = generation;
+	file->private_data = ctx;
 	return 0;
 }
 
@@ -502,21 +688,18 @@ static long arm_pfdi_ioctl(struct file *file, unsigned int cmd,
 	s64 count;
 	s64 ft_id;
 	u64 lib_info;
-	struct miscdevice *misc_dev = file->private_data;
-	struct pfdi_dev_data *device_data;
 	struct pfdi_test_run test_run;
+	struct pfdi_file_ctx *ctx = file->private_data;
 	struct pfdi_force_error error_info;
 	unsigned int cpu;
 
-	if (!misc_dev || !misc_dev->this_device)
+	if (!ctx)
 		return -ENODEV;
 
-	device_data = dev_get_drvdata(misc_dev->this_device);
-	if (!device_data)
+	cpu = ctx->cpu;
+	if (!pfdi_file_ctx_valid(ctx))
 		return -ENODEV;
 
-	cpu = device_data->cpu_id;
-
 	switch (cmd) {
 	case PFDI_IOCTL_VERSION:
 		err = pfdi_pe_get_version(cpu, &version);
@@ -582,16 +765,18 @@ static long arm_pfdi_ioctl(struct file *file, unsigned int cmd,
 
 static int arm_pfdi_release(struct inode *inode, struct file *file)
 {
-	struct miscdevice *misc_dev = file->private_data;
-	struct pfdi_dev_data *data;
-	unsigned int cpu;
+	struct pfdi_file_ctx *ctx = file->private_data;
+	struct pfdi_per_cpu_info *cpu_info;
 
-	if (!misc_dev || !misc_dev->this_device)
+	if (!ctx)
 		return 0;
 
-	data = dev_get_drvdata(misc_dev->this_device);
-	cpu = data ? data->cpu_id : raw_smp_processor_id();
-	up(&per_cpu(pfdi_cpu_info, cpu).open_sem);
+	cpu_info = &per_cpu(pfdi_cpu_info, ctx->cpu);
+	mutex_lock(&cpu_info->state_lock);
+	if (cpu_info->online && ctx->generation == cpu_info->generation)
+		up(&cpu_info->open_sem);
+	mutex_unlock(&cpu_info->state_lock);
+	kfree(ctx);
 
 	return 0;
 }
@@ -625,22 +810,31 @@ static int arm_pfdi_device_create(unsigned int cpu)
 	int ret;
 	struct miscdevice *misc_dev = &per_cpu(pfdi_misc_device, cpu);
 	struct pfdi_dev_data *dev_data = &per_cpu(pfdi_device_data, cpu);
+	struct pfdi_per_cpu_info *cpu_info = &per_cpu(pfdi_cpu_info, cpu);
 	struct pfdi_cpu_worker *worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
 
 	memset(misc_dev, 0, sizeof(*misc_dev));
 	arm_pfdi_device_init(misc_dev, dev_data, cpu);
 
-	sema_init(&per_cpu(pfdi_cpu_info, cpu).open_sem, 1);
-	mutex_init(&worker_ctx->worker_lock);
-	atomic_set(&per_cpu(pfdi_cpu_info, cpu).run_inprogress, 0);
-	mutex_init(&per_cpu(pfdi_cpu_info, cpu).state_lock);
-	init_waitqueue_head(&per_cpu(pfdi_cpu_info, cpu).run_wait);
-	init_completion(&worker_ctx->done);
-	per_cpu(pfdi_worker, cpu) =
-		kthread_create_worker_on_cpu(cpu, 0, "pfdi/%u");
-	if (IS_ERR(per_cpu(pfdi_worker, cpu))) {
-		ret = PTR_ERR(per_cpu(pfdi_worker, cpu));
-		per_cpu(pfdi_worker, cpu) = NULL;
+	ret = pfdi_validate_cpu_features();
+	if (ret)
+		return ret;
+
+	mutex_lock(&cpu_info->state_lock);
+	atomic_set(&cpu_info->run_inprogress, 0);
+	cpu_info->online = false;
+	cpu_info->generation++;
+	mutex_unlock(&cpu_info->state_lock);
+
+	mutex_lock(&worker_ctx->worker_lock);
+	WRITE_ONCE(worker_ctx->work_inflight, false);
+	WRITE_ONCE(worker_ctx->shutting_down, false);
+	mutex_unlock(&worker_ctx->worker_lock);
+	WRITE_ONCE(per_cpu(pfdi_worker, cpu),
+		   kthread_create_worker_on_cpu(cpu, 0, "pfdi/%u"));
+	if (IS_ERR(READ_ONCE(per_cpu(pfdi_worker, cpu)))) {
+		ret = PTR_ERR(READ_ONCE(per_cpu(pfdi_worker, cpu)));
+		WRITE_ONCE(per_cpu(pfdi_worker, cpu), NULL);
 		return ret;
 	}
 
@@ -654,6 +848,9 @@ static int arm_pfdi_device_create(unsigned int cpu)
 	}
 
 	dev_set_drvdata(misc_dev->this_device, dev_data);
+	mutex_lock(&cpu_info->state_lock);
+	cpu_info->online = true;
+	mutex_unlock(&cpu_info->state_lock);
 
 	return 0;
 
@@ -668,28 +865,65 @@ static int arm_pfdi_device_create(unsigned int cpu)
 static int arm_pfdi_device_destroy(unsigned int cpu)
 {
 	struct miscdevice *misc_dev = &per_cpu(pfdi_misc_device, cpu);
+	struct kthread_worker *worker;
+	struct pfdi_cpu_worker *worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
+	struct pfdi_per_cpu_info *cpu_info = &per_cpu(pfdi_cpu_info, cpu);
+
+	mutex_lock(&cpu_info->state_lock);
+	if (atomic_read(&cpu_info->run_inprogress) > 0) {
+		mutex_unlock(&cpu_info->state_lock);
+		return -EBUSY;
+	}
+	if (down_trylock(&cpu_info->open_sem)) {
+		mutex_unlock(&cpu_info->state_lock);
+		return -EBUSY;
+	}
+	cpu_info->online = false;
+	mutex_unlock(&cpu_info->state_lock);
 
-	if (atomic_read(&per_cpu(pfdi_cpu_info, cpu).run_inprogress) > 0)
+	mutex_lock(&worker_ctx->worker_lock);
+	if (worker_ctx->work_inflight) {
+		mutex_unlock(&worker_ctx->worker_lock);
+		mutex_lock(&cpu_info->state_lock);
+		cpu_info->online = true;
+		mutex_unlock(&cpu_info->state_lock);
+		up(&cpu_info->open_sem);
 		return -EBUSY;
+	}
+	WRITE_ONCE(worker_ctx->shutting_down, true);
+	mutex_unlock(&worker_ctx->worker_lock);
 
-	if (per_cpu(pfdi_worker, cpu)) {
-		kthread_flush_worker(per_cpu(pfdi_worker, cpu));
-		kthread_destroy_worker(per_cpu(pfdi_worker, cpu));
-		per_cpu(pfdi_worker, cpu) = NULL;
+	worker = READ_ONCE(per_cpu(pfdi_worker, cpu));
+	if (worker) {
+		kthread_flush_worker(worker);
+		kthread_destroy_worker(worker);
+		WRITE_ONCE(per_cpu(pfdi_worker, cpu), NULL);
 	}
 
-	dev_set_drvdata(misc_dev->this_device, NULL);
 	misc_deregister(misc_dev);
+	up(&cpu_info->open_sem);
 	return 0;
 }
 
 static int __init arm_pfdi_init(void)
 {
+	unsigned int cpu;
 	int ret;
-
-	ret = pfdi_validate_cpu_features();
-	if (ret)
-		return ret;
+	struct pfdi_cpu_worker *worker_ctx;
+	struct pfdi_per_cpu_info *cpu_info;
+
+	for_each_possible_cpu(cpu) {
+		cpu_info = &per_cpu(pfdi_cpu_info, cpu);
+		worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
+
+		mutex_init(&cpu_info->state_lock);
+		sema_init(&cpu_info->open_sem, 1);
+		init_waitqueue_head(&cpu_info->run_wait);
+		mutex_init(&worker_ctx->op_lock);
+		mutex_init(&worker_ctx->worker_lock);
+		init_completion(&worker_ctx->done);
+		init_waitqueue_head(&worker_ctx->worker_wait);
+	}
 
 	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "firmware/arm-pfdi:online",
 				arm_pfdi_device_create, arm_pfdi_device_destroy);

-- 
2.43.0

