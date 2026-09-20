Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899213F9F2D;
	Sun, 20 Sep 2026 10:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789898880; cv=none; b=pcdb+KyRIRjTxlhzitIWlsgTP2YTxWk6JSKQa1LYN1L2Kx9MzeWjW3WgxphAQygMi+Mda2WhX2DJcCmpPzPp1J79W42CcZRhdkBi3wDW7kIzVSajRtdw/O0awC859coIZaVWgtuBLSzmB+VyPgBHD5eiZYSHqyoIZ9BSZ6Dgu7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789898880; c=relaxed/simple;
	bh=z0c3qyOWJVydlY9zxPEIAyZ/BoTsXZ18/+n7/YXCCRg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FQJAkG1g44ljOoIZZnynBmyaA96nTTq5ROwByFW0YsAZ92GLtk4mTr2UybmbsedwXL3GmnZGluzr6r+G4AZiZbvV/lWvfaJXbp3e7eyqMI0sXeJcO5k3IvEUyOrCKjJXpokPFv1zs+AEAW7epXN+lN6P+FWF7tUnDtJvCnw3nIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=nCK2fWkE; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="nCK2fWkE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version:
	Content-Type; bh=Lz4jFwZI0w5gGsbjB6Aaftvipp9sXD3BQGI63Khravc=;
	b=nCK2fWkEIN53gY5eJojyHr3DFNbFQX7++Nbms6vHVBuS1qwZdZ9fjqt7YYPyE+
	gJ++gpfgYryaSVjxsHvX/Wjg+adNQSG6CimuskgMVRTvobYaK0JenFrOo2Yz1bEK
	6D4N1zn3vihKtAIHDaOpGulRHnBpm3QGvJVr45r5IE6TU=
Received: from LAPTOP-EGO65D59.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wDnrzlVsK9qzshABw--.64142S2;
	Sun, 20 Sep 2026 18:07:21 +0800 (CST)
From: =?UTF-8?q?=E6=9E=97=E6=BF=AC=E5=93=B2?= <m18667909625@163.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org,
	linux-api@vger.kernel.org,
	luto@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	m18667909625@163.com
Subject: [PATCH] kernel: add system_energy_efficiency syscall (nr 337)
Date: Sun, 20 Sep 2026 18:07:13 +0800
Message-ID: <20260920100714.46206-1-m18667909625@163.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnrzlVsK9qzshABw--.64142S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3GryfuFWDAw4Utw45ZF43ZFb_yoW7CFyxpF
	WkGFy5t395AryxXFyxKF1UCFyFgr1DXFy7GrWI9r13A3s8t3sIgw4vga90vryfArW7WFW3
	tFWqqFWqkF4UXa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRE1vsUUUUU=
X-CM-SenderInfo: bpryllixzqmlisv6il2tof0z/xtbC-RnIzmqvsFkvbQAA3M

Add a new syscall that reports GPU presence and system-wide
energy information:

- mode 0: returns the number of display devices found on the PCI bus
- mode 1: returns an energy efficiency metric; prefers the real GPU
  power reported through hwmon, falls back to runtime PM status
  weights, plus the online CPU count
- mode 2: returns the real-time GPU power in milliwatts read from
  the hwmon power1_input channel exposed by GPU drivers
  (amdgpu/nouveau/radeon/nvidia); returns 0 if not reported

Signed-off-by: 林濬哲 <m18667909625@163.com>
Assisted-by: AI coding assistant (disclosed per kernel AI guidelines)
---
 arch/x86/entry/syscalls/syscall_64.tbl |   1 +
 include/linux/syscalls.h               |   2 +
 kernel/sys.c                           | 138 +++++++++++++++++++++++++
 3 files changed, 141 insertions(+)

diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index d5b6045b0090..f99649dfaa38 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -346,6 +346,7 @@
 334	common	rseq			sys_rseq
 335	common	uretprobe		sys_uretprobe
 336	common	uprobe			sys_uprobe
+337	common	system_energy_efficiency	sys_system_energy_efficiency
 # don't use numbers 387 through 423, add new calls after the last
 # 'common' entry
 424	common	pidfd_send_signal	sys_pidfd_send_signal
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 8413b624ad47..dfa9d31c20cd 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1017,6 +1017,8 @@ asmlinkage long sys_uretprobe(void);
 
 asmlinkage long sys_uprobe(void);
 
+asmlinkage long sys_system_energy_efficiency(int __user *mode, int __user *value);
+
 /* pciconfig: alpha, arm, arm64, ia64, sparc */
 asmlinkage long sys_pciconfig_read(unsigned long bus, unsigned long dfn,
 				unsigned long off, unsigned long len,
diff --git a/kernel/sys.c b/kernel/sys.c
index 35b538ba843c..bb1106085d7e 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -22,6 +22,7 @@
 #include <linux/workqueue.h>
 #include <linux/capability.h>
 #include <linux/device.h>
+#include <linux/pci.h>
 #include <linux/key.h>
 #include <linux/times.h>
 #include <linux/posix-timers.h>
@@ -181,6 +182,143 @@ int fs_overflowgid = DEFAULT_FS_OVERFLOWGID;
 EXPORT_SYMBOL(fs_overflowuid);
 EXPORT_SYMBOL(fs_overflowgid);
 
+
+/*
+ * Read the real power consumption reported by GPU drivers via hwmon,
+ * in milliwatts. The hwmon ABI exposes power1_input in microwatts;
+ * amdgpu/nouveau/radeon/nvidia provide this channel on supported
+ * hardware. Returns 0 if no driver reports a power reading.
+ */
+static long gpu_hwmon_power_mw(void)
+{
+	static const char * const gpu_drivers[] = {
+		"amdgpu", "nouveau", "radeon", "nvidia",
+	};
+	char buf[32];
+	char path[64];
+	loff_t pos;
+	long total_uw = 0;
+	long val;
+	int i, j, ret;
+
+	for (i = 0; i < 32; i++) {
+		bool is_gpu = false;
+		struct file *fp;
+
+		snprintf(path, sizeof(path), "/sys/class/hwmon/hwmon%d/name", i);
+		fp = filp_open(path, O_RDONLY, 0);
+		if (IS_ERR(fp))
+			continue;
+
+		pos = 0;
+		ret = kernel_read(fp, buf, sizeof(buf) - 1, &pos);
+		filp_close(fp, NULL);
+		if (ret <= 0)
+			continue;
+		buf[ret] = '\0';
+
+		for (j = 0; j < ARRAY_SIZE(gpu_drivers); j++) {
+			if (!strncmp(buf, gpu_drivers[j], strlen(gpu_drivers[j]))) {
+				is_gpu = true;
+				break;
+			}
+		}
+		if (!is_gpu)
+			continue;
+
+		snprintf(path, sizeof(path), "/sys/class/hwmon/hwmon%d/power1_input", i);
+		fp = filp_open(path, O_RDONLY, 0);
+		if (IS_ERR(fp))
+			continue;
+
+		pos = 0;
+		ret = kernel_read(fp, buf, sizeof(buf) - 1, &pos);
+		filp_close(fp, NULL);
+		if (ret <= 0)
+			continue;
+		buf[ret] = '\0';
+
+		if (kstrtol(buf, 10, &val))
+			continue;
+
+		total_uw += val;
+	}
+
+	return total_uw / 1000;	/* microwatts -> milliwatts */
+}
+
+static int gpu_energy_estimate(int *gpus)
+{
+	static const int class_list[] = {
+		0x030000,	/* VGA compatible controller */
+		0x030200,	/* 3D controller (modern NVIDIA/AMD GPUs) */
+		0x030100,	/* XGA */
+		0x030080,	/* other display controller */
+	};
+	struct pci_dev *pdev;
+	int i, count = 0, energy = 0;
+
+	for (i = 0; i < ARRAY_SIZE(class_list); i++) {
+		pdev = NULL;
+		while ((pdev = pci_get_class(class_list[i], pdev)) != NULL) {
+			count++;
+			if (pdev->dev.power.runtime_status == RPM_ACTIVE)
+				energy += 100;
+			else
+				energy += 5;
+		}
+	}
+
+	if (gpus)
+		*gpus = count;
+
+	return energy;
+}
+
+SYSCALL_DEFINE2(system_energy_efficiency, int __user *, mode, int __user *, value)
+{
+	int mode_v, ret;
+	int gpu_num, gpu_energy;
+	long gpu_power_mw;
+
+	if (get_user(mode_v, mode))
+		return -EFAULT;
+
+	if (mode_v < 0 || mode_v > 2)
+		return -EINVAL;
+
+	gpu_energy = gpu_energy_estimate(&gpu_num);
+	gpu_power_mw = gpu_hwmon_power_mw();
+
+	switch (mode_v) {
+	case 0:
+		/* number of GPUs, 0 if the system has none */
+		ret = gpu_num;
+		break;
+	case 1:
+		/*
+		 * Energy efficiency metric: prefer the real GPU power
+		 * (mW) reported by the driver, fall back to runtime PM
+		 * status weights if no power channel exists, then add
+		 * the CPU part (online CPUs x 10)
+		 */
+		ret = (int)(gpu_power_mw ? gpu_power_mw : gpu_energy) +
+		      num_online_cpus() * 10;
+		break;
+	case 2:
+		/* real-time GPU power in mW, 0 if not reported */
+		ret = (int)gpu_power_mw;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (put_user(ret, value))
+		return -EFAULT;
+
+	return 0;
+}
+
 static const struct ctl_table overflow_sysctl_table[] = {
 	{
 		.procname	= "overflowuid",
-- 
2.54.0.windows.1

