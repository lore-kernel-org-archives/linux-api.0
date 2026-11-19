Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795102613;
	b=MAgqEj+pr4KHeRcQGxxq75vlZ/4JhoByWhNVYQ5tu0JaJx8bY5XIvxKyokzDPRwDhHgC
	 bN/hVtAXPvCSnxasf7KkO5sciK2o2OYZGTB1MIwavCyb39IU7otkLyhNNP0LTS0VxYZVN
	 L5R20OGUc4kPbnd5pZE6gG4WjZK6tSOFekMjntKOWr8M5xEFs8xpgJVQ69xg1Gy2pULjC
	 mQuENphpHkSdOeDrKVRa83U1JxEmXfcVrXaZcf9aVW1GspRPmG5t6oJZUwDBJ28DqUtaQ
	 MNPfxOuajNuYVECi6MYDhhxgkVBhcq0S5WeZvpgcrRDQzmPHH+IcEBWBSLfoZZLaWag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795102613;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer;
	bh=CYTdg/ZbWYFGIrC86gz99BU0CGcr9ksMpr62NJg3iH8=;
	b=dNq621YUlobVBsyxMyI9DUazM4OOrw8poHqG2ZIdmleOtE8ftE4G/B1nlRAp0DKnLFyv
	 NbrP3ItSfgUk246tdOA+BS3os06dGOJXRW1qu8P0x0EzS3/q+v+MEQ+LiCDjNMj3VvWM1
	 fo3Ib1VHBhYYnOvujM0YmUR3t+5sveK8lQGWzA0Bw9TBi8n0V8IA+UiJsPx3FgNcXIE5r
	 mz9jWJS1wp/VUdLrRI3uHCLH80/APrBpl/HBB4ZCrFaVlW8DwQKubMYvCXrcGnUar8TSl
	 ML1wkYfk031XM/490Xz0tiFc1qQbAq1nkN2+kk+1+hrMi9gGyMm7cNqHlOvwqIOQUqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=daCgpKin;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC54B60A2635;
	Thu, 19 Nov 2026 15:36:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC54B60A2635
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=daCgpKin
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6F4F11C00;
	Thu, 19 Nov 2026 07:36:38 -0800 (PST)
Received: from e142430.arm.com (e142430.arm.com [10.33.10.110])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 914713F882;
	Thu, 19 Nov 2026 07:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795102601; bh=ibynNGRiusd6ZgkuSuWkJ+rzZqrUZwhkZUAn9KEZDKc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=daCgpKinQtU2ezBSqGagx3sjYxrrHHV0pqROpBagBe1GP7ENzKjypG+DIFYumtxbJ
	 uO0ZaRu2cekIvBa2KeAhYC3zC3Lv5U9J1jGmLisVRcGx1f8L3AudaAxRBeWH/0FEvR
	 ZH3YF39yJGn8WISAY/T5MwJ9K3FIMabrmCebqzsc=
From: Ahmed Azeem <ahmed.azeem@arm.com>
Date: Thu, 19 Nov 2026 15:36:05 +0000
Subject: [PATCH RFC 3/4] firmware: arm: Add PFDI run, result, and error
 injection support
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
Message-Id: <20261119-topics-ahmaze01-upstream-pfdi-rfc-v1-3-4772d18b9115@arm.com>
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

Extend the PFDI driver with ioctls to execute tests and manage results.

Add support for PFDI_IOCTL_PE_TEST_RUN, PFDI_IOCTL_PE_TEST_RESULT, and
PFDI_IOCTL_FORCE_ERROR, along with per-CPU state to serialize test
execution. When firmware reports PFDI_RET_FAULT_FOUND, return the
failing test identifier to userspace.

Signed-off-by: Divin Raj <divin.raj@arm.com>
Signed-off-by: Ahmed Azeem <ahmed.azeem@arm.com>
---
 drivers/firmware/arm_pfdi.c | 225 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 225 insertions(+)

diff --git a/drivers/firmware/arm_pfdi.c b/drivers/firmware/arm_pfdi.c
index 8c6d315b0572..22a69b12dbc8 100644
--- a/drivers/firmware/arm_pfdi.c
+++ b/drivers/firmware/arm_pfdi.c
@@ -18,10 +18,16 @@
 #include <linux/slab.h>
 #include <linux/smp.h>
 #include <linux/uaccess.h>
+#include <linux/wait.h>
 
 struct pfdi_per_cpu_info {
+	atomic_t run_inprogress;
 	/* Ensures a single userspace owner per CPU while the node is open. */
 	struct semaphore open_sem;
+	/* Serializes per-CPU run state and device availability. */
+	struct mutex state_lock;
+	struct pfdi_test_range ongoing_run_range;
+	wait_queue_head_t run_wait;
 };
 
 struct pfdi_dev_data {
@@ -36,6 +42,8 @@ struct pfdi_cpu_worker {
 	u32 feature_fid;
 	/* Protects worker lifetime and in-flight work state. */
 	struct mutex worker_lock;
+	struct pfdi_force_error error_info;
+	struct pfdi_test_run test_run;
 	struct arm_smccc_res smc_ret;
 	int result;
 };
@@ -59,6 +67,10 @@ static DEFINE_PER_CPU(struct pfdi_per_cpu_info, pfdi_cpu_info);
 
 static enum cpuhp_state pfdi_cpuhp_state;
 
+static unsigned int pfdi_wait_timeout_ms = 60;
+module_param_named(wait_timeout_ms, pfdi_wait_timeout_ms, uint, 0444);
+MODULE_PARM_DESC(wait_timeout_ms,
+		 "Maximum time in ms to wait for an in-progress PFDI run");
 static int pfdi_to_linux_errno(int err)
 {
 	switch (err) {
@@ -95,6 +107,18 @@ static int pfdi_smc_feature(u32 smc_fid)
 	return (int)pfdi_smc_call(PFDI_FN_FEATURES, smc_fid, 0, 0, 0).a0;
 }
 
+static bool pfdi_fid_supported(u32 smc_fid)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(pfdi_supported_fids); i++) {
+		if (pfdi_supported_fids[i] == smc_fid)
+			return true;
+	}
+
+	return false;
+}
+
 static int pfdi_validate_cpu_features(void)
 {
 	unsigned int i;
@@ -275,6 +299,172 @@ static int pfdi_pe_fw_check(unsigned int cpu)
 	return pfdi_to_linux_errno(per_cpu(pfdi_worker_ctx, cpu).result);
 }
 
+static void pfdi_pe_get_result_fn(struct kthread_work *work)
+{
+	struct pfdi_cpu_worker *worker_ctx;
+
+	worker_ctx = container_of(work, struct pfdi_cpu_worker, work);
+	worker_ctx->smc_ret = pfdi_smc_call(PFDI_FN_PE_TEST_RESULT,
+					    0, 0, 0, 0);
+	complete(&worker_ctx->done);
+}
+
+static int pfdi_pe_get_result(unsigned int cpu, s64 *ft_id)
+{
+	int ret;
+	struct pfdi_cpu_worker *worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
+
+	ret = pfdi_thread_worker(cpu, pfdi_pe_get_result_fn,
+				 MAX_SCHEDULE_TIMEOUT);
+	if (ret)
+		return ret;
+
+	ret = (int)worker_ctx->smc_ret.a0;
+	if (ret == PFDI_RET_FAULT_FOUND)
+		*ft_id = worker_ctx->smc_ret.a1;
+
+	return pfdi_to_linux_errno(ret);
+}
+
+static void pfdi_pe_force_error_fn(struct kthread_work *work)
+{
+	struct pfdi_cpu_worker *worker_ctx;
+
+	worker_ctx = container_of(work, struct pfdi_cpu_worker, work);
+	worker_ctx->result = pfdi_smc_call(PFDI_FN_FORCE_ERROR,
+					   worker_ctx->error_info.smc_fid,
+					   worker_ctx->error_info.error_id,
+					   0, 0).a0;
+	complete(&worker_ctx->done);
+}
+
+static int pfdi_pe_force_error(unsigned int cpu,
+			       const struct pfdi_force_error *error_info)
+{
+	int ret;
+	struct pfdi_cpu_worker *worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
+
+	if (!pfdi_fid_supported(error_info->smc_fid))
+		return -EINVAL;
+
+	if (error_info->error_id < PFDI_RET_TEST_COUNT_ZERO ||
+	    error_info->error_id > SMCCC_RET_SUCCESS)
+		return -EINVAL;
+
+	worker_ctx->error_info = *error_info;
+
+	ret = pfdi_thread_worker(cpu, pfdi_pe_force_error_fn,
+				 MAX_SCHEDULE_TIMEOUT);
+	if (ret)
+		return ret;
+
+	return pfdi_to_linux_errno(worker_ctx->result);
+}
+
+static bool pfdi_ranges_equal(const struct pfdi_test_range *lhs,
+			      const struct pfdi_test_range *rhs)
+{
+	return lhs->start == rhs->start && lhs->end == rhs->end;
+}
+
+static bool pfdi_run_available(const struct pfdi_per_cpu_info *cpu_info)
+{
+	return !atomic_read(&cpu_info->run_inprogress);
+}
+
+static int pfdi_validate_test_range(unsigned int cpu,
+				    const struct pfdi_test_range *range)
+{
+	s64 count;
+	int ret;
+
+	if (range->start == -1 || range->end == -1)
+		return pfdi_ranges_equal(range,
+					 &(struct pfdi_test_range){ .start = -1,
+								    .end = -1 }) ?
+		       0 : -EINVAL;
+
+	if (range->start < 0 || range->end < 0 || range->start > range->end)
+		return -EINVAL;
+
+	ret = pfdi_pe_get_test_count(cpu, &count);
+	if (ret)
+		return ret;
+
+	if (range->start >= count || range->end >= count)
+		return -EINVAL;
+
+	return 0;
+}
+
+static void pfdi_pe_run_fn(struct kthread_work *work)
+{
+	struct arm_smccc_res smc_ret;
+	struct pfdi_cpu_worker *worker_ctx;
+
+	worker_ctx = container_of(work, struct pfdi_cpu_worker, work);
+	smc_ret = pfdi_smc_call(PFDI_FN_PE_TEST_RUN,
+				worker_ctx->test_run.range.start,
+				worker_ctx->test_run.range.end, 0, 0);
+
+	if ((int)smc_ret.a0 == PFDI_RET_FAULT_FOUND)
+		worker_ctx->test_run.ft_id = smc_ret.a1;
+
+	worker_ctx->result = (int)smc_ret.a0;
+	complete(&worker_ctx->done);
+}
+
+static int pfdi_pe_run_tests(unsigned int cpu, struct pfdi_test_run *test_run)
+{
+	int ret;
+	unsigned long wait_timeout;
+	struct pfdi_cpu_worker *worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
+	struct pfdi_per_cpu_info *cpu_info = &per_cpu(pfdi_cpu_info, cpu);
+
+	ret = pfdi_validate_test_range(cpu, &test_run->range);
+	if (ret)
+		return ret;
+
+	wait_timeout = msecs_to_jiffies(pfdi_wait_timeout_ms);
+
+	mutex_lock(&cpu_info->state_lock);
+	while (atomic_read(&cpu_info->run_inprogress)) {
+		if (pfdi_ranges_equal(&test_run->range,
+				      &cpu_info->ongoing_run_range)) {
+			mutex_unlock(&cpu_info->state_lock);
+			return -EBUSY;
+		}
+
+		mutex_unlock(&cpu_info->state_lock);
+			ret = wait_event_interruptible_timeout(cpu_info->run_wait,
+							       pfdi_run_available(cpu_info),
+							       wait_timeout);
+		if (ret <= 0)
+			return ret ? ret : -ETIME;
+
+		mutex_lock(&cpu_info->state_lock);
+	}
+
+	atomic_set(&cpu_info->run_inprogress, 1);
+	cpu_info->ongoing_run_range = test_run->range;
+	worker_ctx->test_run = *test_run;
+	mutex_unlock(&cpu_info->state_lock);
+
+	ret = pfdi_thread_worker(cpu, pfdi_pe_run_fn, wait_timeout);
+
+	mutex_lock(&cpu_info->state_lock);
+	if (worker_ctx->result == PFDI_RET_FAULT_FOUND)
+		test_run->ft_id = worker_ctx->test_run.ft_id;
+	atomic_set(&cpu_info->run_inprogress, 0);
+	wake_up_all(&cpu_info->run_wait);
+	mutex_unlock(&cpu_info->state_lock);
+
+	if (ret)
+		return ret;
+
+	return pfdi_to_linux_errno(worker_ctx->result);
+}
+
 static int arm_pfdi_open(struct inode *inode, struct file *file)
 {
 	struct miscdevice *misc_dev = file->private_data;
@@ -310,9 +500,12 @@ static long arm_pfdi_ioctl(struct file *file, unsigned int cmd,
 	u32 feature_fid;
 	u32 version;
 	s64 count;
+	s64 ft_id;
 	u64 lib_info;
 	struct miscdevice *misc_dev = file->private_data;
 	struct pfdi_dev_data *device_data;
+	struct pfdi_test_run test_run;
+	struct pfdi_force_error error_info;
 	unsigned int cpu;
 
 	if (!misc_dev || !misc_dev->this_device)
@@ -350,9 +543,35 @@ static long arm_pfdi_ioctl(struct file *file, unsigned int cmd,
 					 sizeof(count)))
 			err = -EFAULT;
 		break;
+	case PFDI_IOCTL_PE_TEST_RUN:
+		if (copy_from_user(&test_run, (void __user *)arg,
+				   sizeof(test_run)))
+			return -EFAULT;
+
+		err = pfdi_pe_run_tests(cpu, &test_run);
+		if (err == -EFAULT &&
+		    copy_to_user((void __user *)arg, &test_run,
+				 sizeof(test_run)))
+			err = -EFAULT;
+		break;
+	case PFDI_IOCTL_PE_TEST_RESULT:
+		err = pfdi_pe_get_result(cpu, &ft_id);
+		if (err == -EFAULT && copy_to_user((void __user *)arg, &ft_id,
+						   sizeof(ft_id)))
+			err = -EFAULT;
+		break;
 	case PFDI_IOCTL_FW_CHECK:
 		err = pfdi_pe_fw_check(cpu);
 		break;
+	case PFDI_IOCTL_FORCE_ERROR:
+		if (copy_from_user(&error_info, (void __user *)arg,
+				   sizeof(error_info)))
+			return -EFAULT;
+		if (error_info.reserved)
+			return -EINVAL;
+
+		err = pfdi_pe_force_error(cpu, &error_info);
+		break;
 	default:
 		err = -ENOTTY;
 		break;
@@ -413,6 +632,9 @@ static int arm_pfdi_device_create(unsigned int cpu)
 
 	sema_init(&per_cpu(pfdi_cpu_info, cpu).open_sem, 1);
 	mutex_init(&worker_ctx->worker_lock);
+	atomic_set(&per_cpu(pfdi_cpu_info, cpu).run_inprogress, 0);
+	mutex_init(&per_cpu(pfdi_cpu_info, cpu).state_lock);
+	init_waitqueue_head(&per_cpu(pfdi_cpu_info, cpu).run_wait);
 	init_completion(&worker_ctx->done);
 	per_cpu(pfdi_worker, cpu) =
 		kthread_create_worker_on_cpu(cpu, 0, "pfdi/%u");
@@ -447,6 +669,9 @@ static int arm_pfdi_device_destroy(unsigned int cpu)
 {
 	struct miscdevice *misc_dev = &per_cpu(pfdi_misc_device, cpu);
 
+	if (atomic_read(&per_cpu(pfdi_cpu_info, cpu).run_inprogress) > 0)
+		return -EBUSY;
+
 	if (per_cpu(pfdi_worker, cpu)) {
 		kthread_flush_worker(per_cpu(pfdi_worker, cpu));
 		kthread_destroy_worker(per_cpu(pfdi_worker, cpu));

-- 
2.43.0

