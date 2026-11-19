Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795102601;
	b=Vnf7mx9x1/xvAVznyNUH/zqXpn8Iw1Y4d4sPf4s5a3orlAtGDITAA5/GBSVkRdUetVcz
	 QCiPzSsV70Z82nfpZ07C02Hwnczj/XrLGAtD4k4+ZLw18+c0FvHu4x0SSXsa9iS7S36G0
	 tqiF26SU0ns4LHuIFXpW5I8QsgTIJlkJxOIf4YYOdqoS7kYt9iJmFQb58OAS4g6n/YXq7
	 jmYP6auuYtfdGkW5k5+oTImHrFXT2t6nPGK5nxKiJzO6Ca2nEdbyPTEBOQMPrEUx2hgG1
	 1T4YM5vbvfj7g2KA+cXek5Xlt93JzdKLSp4VquMoQ/y42Z45s/nFgah5UhDCoc4YMDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795102601;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer;
	bh=n6T+d3XbZ/vyxKq+QdSr1l5TGxkqG2vUGIGOh718DmE=;
	b=W6fFqL2fJbkHkefIv7oG3kAsf1y/v3x6Ij3Z2zu/su6/YCwXjA8K5k8sijPAsO3MWJWz
	 VTk5trBNTcOc3AWT0Y7DX/IzEkUZ3t1MFvPFHnyyfJ5QEEJu2nI1JOgVKHLVpkDtzT6GF
	 KuxvSYBJAwD8DLcYBL7jTuQMXDgXdTpqhxXP2Z6bQGdpUoRHEhvUGcVJaTh3ZVXqRGNK3
	 A4knO+Cmu03hX7XInsTg5YZ8BHIJ31jiCObEY2vbwLWSJCicOOhuxouAw21sAAjkUmnmu
	 QshBrn0lTc0MV/FmVdyOyeYurLB4thtKH7d8eQnSCuXZl8+n7O8mO9grJ0dG/oA+f5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=LhO+Zigs;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E96C460A2624;
	Thu, 19 Nov 2026 15:36:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E96C460A2624
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=LhO+Zigs
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4FB301C01;
	Thu, 19 Nov 2026 07:36:36 -0800 (PST)
Received: from e142430.arm.com (e142430.arm.com [10.33.10.110])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 691473F882;
	Thu, 19 Nov 2026 07:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795102599; bh=mym0RrVjwwZMk+oYnEacd+P/Wyr2Y4eGqFNXKPBlsFY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LhO+ZigsSZJbpm0fe8hbq57bofd+YFWeJbxQOOxxJUg+7B3IOUwDLX9D29zhGaaFl
	 bIH9YShyinOuKVA9PrzqFY6dBqCy2ItLNlLNF2ATRj1UmKqr1bcD4QXr9Bvf69JHqy
	 yqNBQIV7Bu1CFJ9tHVoUG8lGhxbcIapasDemgL0U=
From: Ahmed Azeem <ahmed.azeem@arm.com>
Date: Thu, 19 Nov 2026 15:36:04 +0000
Subject: [PATCH RFC 2/4] firmware: arm: Add PFDI misc driver skeleton
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
Message-Id: <20261119-topics-ahmaze01-upstream-pfdi-rfc-v1-2-4772d18b9115@arm.com>
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

Add the initial in-kernel driver for the Arm Platform Fault Detection
Interface (PFDI).

Hook the driver into drivers/firmware, probe the firmware interface via
SMCCC, and create per-CPU misc devices at /dev/cpu/<cpu>/pfdi. Implement
the read-only query operations used to retrieve the firmware version,
test library identifier, test count, and firmware health check support.

Limit this initial change to probe and query functionality to keep the
core driver structure easy to review before introducing stateful
execution and error injection support.

Signed-off-by: Divin Raj <divin.raj@arm.com>
Signed-off-by: Ahmed Azeem <ahmed.azeem@arm.com>
---
 MAINTAINERS                 |   1 +
 drivers/firmware/Kconfig    |  14 ++
 drivers/firmware/Makefile   |   1 +
 drivers/firmware/arm_pfdi.c | 489 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 505 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index de9c296d1de1..41101524f3c8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14017,6 +14017,7 @@ M:	Ahmed Azeem <ahmed.azeem@arm.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	Documentation/ABI/testing/dev-cpu-pfdi
+F:	drivers/firmware/arm_pfdi.c
 F:	include/uapi/linux/pfdi.h
 
 IOMMU SUBSYSTEM
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 43e2e2a64594..f8f40027e70a 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -60,6 +60,20 @@ config ARM_SDEI_NMI
 
 	  If unsure, say N.
 
+config ARM_PFDI
+	tristate "Arm Platform Fault Detection Interface (PFDI)"
+	depends on ARM64 && HAVE_ARM_SMCCC
+	help
+	  Expose the Arm Platform Fault Detection Interface (PFDI)
+	  implemented by platform firmware through per-CPU misc devices.
+
+	  This creates /dev/cpu/<cpu>/pfdi device nodes that allow
+	  privileged userspace to query PFDI test metadata and trigger the
+	  firmware health check.
+
+	  Say M or Y here if your platform firmware implements PFDI and you
+	  need Linux userspace access to it.
+
 config EDD
 	tristate "BIOS Enhanced Disk Drive calls determine boot disk"
 	depends on X86
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 50b338313152..6dd53e2426bd 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -2,6 +2,7 @@
 #
 # Makefile for the linux kernel.
 #
+obj-$(CONFIG_ARM_PFDI)		+= arm_pfdi.o
 obj-$(CONFIG_ARM_SCPI_PROTOCOL)	+= arm_scpi.o
 obj-$(CONFIG_ARM_SDE_INTERFACE)	+= arm_sdei.o
 obj-$(CONFIG_ARM_SDEI_NMI)	+= arm_sdei_nmi.o
diff --git a/drivers/firmware/arm_pfdi.c b/drivers/firmware/arm_pfdi.c
new file mode 100644
index 000000000000..8c6d315b0572
--- /dev/null
+++ b/drivers/firmware/arm_pfdi.c
@@ -0,0 +1,489 @@
+// SPDX-License-Identifier: GPL-2.0-only
+// Copyright (C) 2026 Arm Ltd.
+
+#define pr_fmt(fmt) "arm-pfdi: " fmt
+
+#include <linux/arm-smccc.h>
+#include <linux/completion.h>
+#include <linux/compat.h>
+#include <linux/cpuhotplug.h>
+#include <linux/cpu.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/kthread.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/pfdi.h>
+#include <linux/semaphore.h>
+#include <linux/slab.h>
+#include <linux/smp.h>
+#include <linux/uaccess.h>
+
+struct pfdi_per_cpu_info {
+	/* Ensures a single userspace owner per CPU while the node is open. */
+	struct semaphore open_sem;
+};
+
+struct pfdi_dev_data {
+	unsigned int cpu_id;
+	char name[16];
+	char nodename[24];
+};
+
+struct pfdi_cpu_worker {
+	struct kthread_work work;
+	struct completion done;
+	u32 feature_fid;
+	/* Protects worker lifetime and in-flight work state. */
+	struct mutex worker_lock;
+	struct arm_smccc_res smc_ret;
+	int result;
+};
+
+static const u32 pfdi_supported_fids[] = {
+	PFDI_FN_VERSION,
+	PFDI_FN_FEATURES,
+	PFDI_FN_PE_TEST_ID,
+	PFDI_FN_PE_TEST_PART_COUNT,
+	PFDI_FN_PE_TEST_RUN,
+	PFDI_FN_PE_TEST_RESULT,
+	PFDI_FN_FW_CHECK,
+	PFDI_FN_FORCE_ERROR,
+};
+
+static DEFINE_PER_CPU(struct kthread_worker *, pfdi_worker);
+static DEFINE_PER_CPU(struct miscdevice, pfdi_misc_device);
+static DEFINE_PER_CPU(struct pfdi_dev_data, pfdi_device_data);
+static DEFINE_PER_CPU(struct pfdi_cpu_worker, pfdi_worker_ctx);
+static DEFINE_PER_CPU(struct pfdi_per_cpu_info, pfdi_cpu_info);
+
+static enum cpuhp_state pfdi_cpuhp_state;
+
+static int pfdi_to_linux_errno(int err)
+{
+	switch (err) {
+	case SMCCC_RET_SUCCESS:
+		return 0;
+	case SMCCC_RET_NOT_SUPPORTED:
+		return -EOPNOTSUPP;
+	case PFDI_RET_INVALID_PARAM:
+		return -EINVAL;
+	case PFDI_RET_NOT_RUN:
+	case PFDI_RET_TEST_COUNT_ZERO:
+		return -EAGAIN;
+	case PFDI_RET_ERROR:
+	case PFDI_RET_UNKNOWN:
+		return -EIO;
+	case PFDI_RET_FAULT_FOUND:
+		return -EFAULT;
+	default:
+		return -EINVAL;
+	}
+}
+
+static struct arm_smccc_res pfdi_smc_call(u32 smc_fid, u64 x1, u64 x2, u64 x3,
+					  u64 x4)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_smc(smc_fid, x1, x2, x3, x4, 0, 0, 0, &res);
+	return res;
+}
+
+static int pfdi_smc_feature(u32 smc_fid)
+{
+	return (int)pfdi_smc_call(PFDI_FN_FEATURES, smc_fid, 0, 0, 0).a0;
+}
+
+static int pfdi_validate_cpu_features(void)
+{
+	unsigned int i;
+	int ret;
+	struct arm_smccc_res smc_ret;
+
+	smc_ret = pfdi_smc_call(PFDI_FN_VERSION, 0, 0, 0, 0);
+	if ((int)smc_ret.a0 < SMCCC_RET_SUCCESS)
+		return pfdi_to_linux_errno((int)smc_ret.a0);
+
+	if (PFDI_VERSION_MAJOR(smc_ret.a0) != 1)
+		return -EOPNOTSUPP;
+
+	for (i = 0; i < ARRAY_SIZE(pfdi_supported_fids); i++) {
+		ret = pfdi_smc_feature(pfdi_supported_fids[i]);
+		if (ret < 0)
+			return pfdi_to_linux_errno(ret);
+	}
+
+	return 0;
+}
+
+static int pfdi_thread_worker(unsigned int cpu,
+			      void (*handler)(struct kthread_work *work),
+			      unsigned long timeout)
+{
+	int ret = 0;
+	struct kthread_worker *worker;
+	struct pfdi_cpu_worker *worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
+
+	mutex_lock(&worker_ctx->worker_lock);
+	worker = per_cpu(pfdi_worker, cpu);
+	if (!worker) {
+		mutex_unlock(&worker_ctx->worker_lock);
+		return -ENODEV;
+	}
+
+	reinit_completion(&worker_ctx->done);
+	kthread_init_work(&worker_ctx->work, handler);
+	kthread_queue_work(worker, &worker_ctx->work);
+
+	if (!wait_for_completion_timeout(&worker_ctx->done, timeout)) {
+		ret = -ETIME;
+		kthread_cancel_work_sync(&worker_ctx->work);
+	}
+
+	mutex_unlock(&worker_ctx->worker_lock);
+	return ret;
+}
+
+static void pfdi_pe_get_test_id_fn(struct kthread_work *work)
+{
+	struct pfdi_cpu_worker *worker_ctx;
+
+	worker_ctx = container_of(work, struct pfdi_cpu_worker, work);
+	worker_ctx->smc_ret = pfdi_smc_call(PFDI_FN_PE_TEST_ID, 0, 0, 0, 0);
+	complete(&worker_ctx->done);
+}
+
+static void pfdi_pe_get_version_fn(struct kthread_work *work)
+{
+	struct pfdi_cpu_worker *worker_ctx;
+
+	worker_ctx = container_of(work, struct pfdi_cpu_worker, work);
+	worker_ctx->smc_ret = pfdi_smc_call(PFDI_FN_VERSION, 0, 0, 0, 0);
+	complete(&worker_ctx->done);
+}
+
+static int pfdi_pe_get_version(unsigned int cpu, u32 *version)
+{
+	s64 ret;
+	struct pfdi_cpu_worker *worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
+
+	ret = pfdi_thread_worker(cpu, pfdi_pe_get_version_fn,
+				 MAX_SCHEDULE_TIMEOUT);
+	if (ret)
+		return ret;
+
+	ret = (int)worker_ctx->smc_ret.a0;
+	if (ret >= 0)
+		*version = (u32)ret;
+
+	if (ret >= 0)
+		return 0;
+
+	return pfdi_to_linux_errno((int)ret);
+}
+
+static void pfdi_pe_get_features_fn(struct kthread_work *work)
+{
+	struct pfdi_cpu_worker *worker_ctx;
+
+	worker_ctx = container_of(work, struct pfdi_cpu_worker, work);
+	worker_ctx->result = pfdi_smc_call(PFDI_FN_FEATURES,
+					   worker_ctx->feature_fid,
+					   0, 0, 0).a0;
+	complete(&worker_ctx->done);
+}
+
+static int pfdi_pe_get_features(unsigned int cpu, u32 fid)
+{
+	int ret;
+	struct pfdi_cpu_worker *worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
+
+	worker_ctx->feature_fid = fid;
+	ret = pfdi_thread_worker(cpu, pfdi_pe_get_features_fn,
+				 MAX_SCHEDULE_TIMEOUT);
+	if (ret)
+		return ret;
+
+	return pfdi_to_linux_errno(worker_ctx->result);
+}
+
+static int pfdi_pe_get_test_id(unsigned int cpu, u64 *lib_info)
+{
+	int ret;
+	struct pfdi_cpu_worker *worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
+
+	ret = pfdi_thread_worker(cpu, pfdi_pe_get_test_id_fn,
+				 MAX_SCHEDULE_TIMEOUT);
+	if (ret)
+		return ret;
+
+	ret = (int)worker_ctx->smc_ret.a0;
+	if (!ret)
+		*lib_info = worker_ctx->smc_ret.a1;
+
+	return pfdi_to_linux_errno(ret);
+}
+
+static void pfdi_pe_get_test_count_fn(struct kthread_work *work)
+{
+	struct pfdi_cpu_worker *worker_ctx;
+
+	worker_ctx = container_of(work, struct pfdi_cpu_worker, work);
+	worker_ctx->smc_ret = pfdi_smc_call(PFDI_FN_PE_TEST_PART_COUNT,
+					    0, 0, 0, 0);
+	complete(&worker_ctx->done);
+}
+
+static int pfdi_pe_get_test_count(unsigned int cpu, s64 *count)
+{
+	s64 ret;
+	struct pfdi_cpu_worker *worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
+
+	ret = pfdi_thread_worker(cpu, pfdi_pe_get_test_count_fn,
+				 MAX_SCHEDULE_TIMEOUT);
+	if (ret)
+		return ret;
+
+	ret = (s64)worker_ctx->smc_ret.a0;
+	if (ret >= 0) {
+		*count = ret;
+		return 0;
+	}
+
+	return pfdi_to_linux_errno((int)ret);
+}
+
+static void pfdi_pe_fw_check_fn(struct kthread_work *work)
+{
+	struct pfdi_cpu_worker *worker_ctx;
+
+	worker_ctx = container_of(work, struct pfdi_cpu_worker, work);
+	worker_ctx->result = pfdi_smc_call(PFDI_FN_FW_CHECK,
+					   0, 0, 0, 0).a0;
+	complete(&worker_ctx->done);
+}
+
+static int pfdi_pe_fw_check(unsigned int cpu)
+{
+	int ret;
+
+	ret = pfdi_thread_worker(cpu, pfdi_pe_fw_check_fn, MAX_SCHEDULE_TIMEOUT);
+	if (ret)
+		return ret;
+
+	return pfdi_to_linux_errno(per_cpu(pfdi_worker_ctx, cpu).result);
+}
+
+static int arm_pfdi_open(struct inode *inode, struct file *file)
+{
+	struct miscdevice *misc_dev = file->private_data;
+	struct pfdi_dev_data *data;
+	unsigned int cpu;
+
+	if (!misc_dev || !misc_dev->this_device)
+		return -ENODEV;
+
+	data = dev_get_drvdata(misc_dev->this_device);
+	if (!data)
+		return -ENODEV;
+
+	cpu = get_cpu();
+	if (data->cpu_id != cpu) {
+		put_cpu();
+		return -EPERM;
+	}
+
+	if (down_trylock(&per_cpu(pfdi_cpu_info, cpu).open_sem)) {
+		put_cpu();
+		return -EBUSY;
+	}
+
+	put_cpu();
+	return 0;
+}
+
+static long arm_pfdi_ioctl(struct file *file, unsigned int cmd,
+			   unsigned long arg)
+{
+	int err = 0;
+	u32 feature_fid;
+	u32 version;
+	s64 count;
+	u64 lib_info;
+	struct miscdevice *misc_dev = file->private_data;
+	struct pfdi_dev_data *device_data;
+	unsigned int cpu;
+
+	if (!misc_dev || !misc_dev->this_device)
+		return -ENODEV;
+
+	device_data = dev_get_drvdata(misc_dev->this_device);
+	if (!device_data)
+		return -ENODEV;
+
+	cpu = device_data->cpu_id;
+
+	switch (cmd) {
+	case PFDI_IOCTL_VERSION:
+		err = pfdi_pe_get_version(cpu, &version);
+		if (!err && copy_to_user((void __user *)arg, &version,
+					 sizeof(version)))
+			err = -EFAULT;
+		break;
+	case PFDI_IOCTL_FEATURES:
+		if (copy_from_user(&feature_fid, (void __user *)arg,
+				   sizeof(feature_fid)))
+			return -EFAULT;
+
+		err = pfdi_pe_get_features(cpu, feature_fid);
+		break;
+	case PFDI_IOCTL_PE_TEST_ID:
+		err = pfdi_pe_get_test_id(cpu, &lib_info);
+		if (!err && copy_to_user((void __user *)arg, &lib_info,
+					 sizeof(lib_info)))
+			err = -EFAULT;
+		break;
+	case PFDI_IOCTL_PE_TEST_PART_COUNT:
+		err = pfdi_pe_get_test_count(cpu, &count);
+		if (!err && copy_to_user((void __user *)arg, &count,
+					 sizeof(count)))
+			err = -EFAULT;
+		break;
+	case PFDI_IOCTL_FW_CHECK:
+		err = pfdi_pe_fw_check(cpu);
+		break;
+	default:
+		err = -ENOTTY;
+		break;
+	}
+
+	return err;
+}
+
+static int arm_pfdi_release(struct inode *inode, struct file *file)
+{
+	struct miscdevice *misc_dev = file->private_data;
+	struct pfdi_dev_data *data;
+	unsigned int cpu;
+
+	if (!misc_dev || !misc_dev->this_device)
+		return 0;
+
+	data = dev_get_drvdata(misc_dev->this_device);
+	cpu = data ? data->cpu_id : raw_smp_processor_id();
+	up(&per_cpu(pfdi_cpu_info, cpu).open_sem);
+
+	return 0;
+}
+
+static const struct file_operations arm_pfdi_fops = {
+	.owner		= THIS_MODULE,
+	.open		= arm_pfdi_open,
+	.release	= arm_pfdi_release,
+	.unlocked_ioctl	= arm_pfdi_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= compat_ptr_ioctl,
+#endif
+};
+
+static void arm_pfdi_device_init(struct miscdevice *misc_dev,
+				 struct pfdi_dev_data *dev_data, unsigned int cpu)
+{
+	misc_dev->minor = MISC_DYNAMIC_MINOR;
+	dev_data->cpu_id = cpu;
+	snprintf(dev_data->name, sizeof(dev_data->name), "pfdi%u", cpu);
+	snprintf(dev_data->nodename, sizeof(dev_data->nodename),
+		 "cpu/%u/pfdi", cpu);
+	misc_dev->name = dev_data->name;
+	misc_dev->nodename = dev_data->nodename;
+	misc_dev->mode = 0600;
+	misc_dev->fops = &arm_pfdi_fops;
+}
+
+static int arm_pfdi_device_create(unsigned int cpu)
+{
+	int ret;
+	struct miscdevice *misc_dev = &per_cpu(pfdi_misc_device, cpu);
+	struct pfdi_dev_data *dev_data = &per_cpu(pfdi_device_data, cpu);
+	struct pfdi_cpu_worker *worker_ctx = &per_cpu(pfdi_worker_ctx, cpu);
+
+	memset(misc_dev, 0, sizeof(*misc_dev));
+	arm_pfdi_device_init(misc_dev, dev_data, cpu);
+
+	sema_init(&per_cpu(pfdi_cpu_info, cpu).open_sem, 1);
+	mutex_init(&worker_ctx->worker_lock);
+	init_completion(&worker_ctx->done);
+	per_cpu(pfdi_worker, cpu) =
+		kthread_create_worker_on_cpu(cpu, 0, "pfdi/%u");
+	if (IS_ERR(per_cpu(pfdi_worker, cpu))) {
+		ret = PTR_ERR(per_cpu(pfdi_worker, cpu));
+		per_cpu(pfdi_worker, cpu) = NULL;
+		return ret;
+	}
+
+	ret = misc_register(misc_dev);
+	if (ret)
+		goto destroy_worker;
+
+	if (!misc_dev->this_device) {
+		ret = -ENODEV;
+		goto deregister_misc;
+	}
+
+	dev_set_drvdata(misc_dev->this_device, dev_data);
+
+	return 0;
+
+deregister_misc:
+	misc_deregister(misc_dev);
+destroy_worker:
+	kthread_destroy_worker(per_cpu(pfdi_worker, cpu));
+	per_cpu(pfdi_worker, cpu) = NULL;
+	return ret;
+}
+
+static int arm_pfdi_device_destroy(unsigned int cpu)
+{
+	struct miscdevice *misc_dev = &per_cpu(pfdi_misc_device, cpu);
+
+	if (per_cpu(pfdi_worker, cpu)) {
+		kthread_flush_worker(per_cpu(pfdi_worker, cpu));
+		kthread_destroy_worker(per_cpu(pfdi_worker, cpu));
+		per_cpu(pfdi_worker, cpu) = NULL;
+	}
+
+	dev_set_drvdata(misc_dev->this_device, NULL);
+	misc_deregister(misc_dev);
+	return 0;
+}
+
+static int __init arm_pfdi_init(void)
+{
+	int ret;
+
+	ret = pfdi_validate_cpu_features();
+	if (ret)
+		return ret;
+
+	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "firmware/arm-pfdi:online",
+				arm_pfdi_device_create, arm_pfdi_device_destroy);
+	if (ret < 0)
+		return ret;
+
+	pfdi_cpuhp_state = ret;
+	return 0;
+}
+
+static void __exit arm_pfdi_exit(void)
+{
+	if (pfdi_cpuhp_state)
+		cpuhp_remove_state(pfdi_cpuhp_state);
+}
+
+module_init(arm_pfdi_init);
+module_exit(arm_pfdi_exit);
+
+MODULE_DESCRIPTION("Arm Platform Fault Detection Interface driver");
+MODULE_AUTHOR("Divin Raj <divin.raj@arm.com>");
+MODULE_LICENSE("GPL");

-- 
2.43.0

