Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795102598;
	b=iznRqC3246oZT7jBMePEZfV2chEZgDVDcJjE/2Z0ZcOX0i6FrCqWV7I+OJxQWr2zUPcl
	 fgjyUqH44kNXBTaAq9OpF1OEVOn7+rrildgp8sFoprI52OXCDv7xMDM4w21154SwiBGbo
	 qvjuDnG4B8gVXXy4I6Qsp9HxNnW6fKkuc/kSSfMODTSuS9FvjKPsuTp1/aqn+95qfdNfL
	 2ztnIiwphoPbxbRXi23/PQEFkRVjv7vJcQLQFywLRa5qZLE0mkEAKT2wMAT4fcPWPIl5I
	 g5Ld0/HpKmaZBgdCS+jurXRLcQvKUSR49xgjY5xkNQ6HWfq8NrotMAaiaR8CJwr9dKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795102598;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer;
	bh=d3xYow8ORTqrFcj+TCUVwlzJAP68PZhkX5ooYPd2dsw=;
	b=an6J+6WvjIUcbu1MvxLI+ZMygPxWsaIsObKpLeTd/N569e7f/HR6iSTnu3B9twdI6bm3
	 G9+74YWe2+Dr+W9AYblnIp2TcBOwlcXTL+SK8pqTHHVpwtKecaSKV/nIETxZSUIfONGMt
	 ohH9HXLT8H2cPfFKtQFmdjYpj1CwkrH0ZUDtt1GqmHQ0xvauAHq38x6C5VGEbmRbGn/N2
	 bN9n6vjW9fwMyLp5wqUHyggE5VV5f62SbZDUzoBfguTnV8TEpTGt0ArUHuhmHFcvoF17d
	 hZCZwOraFvOS7TW/ec+C2fmnGGsnEjcxB9Z4KivtKmLOJcj06F/sW8ADE5hbAj5f5SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=GoapcUJi;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA03160A2600;
	Thu, 19 Nov 2026 15:36:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA03160A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=GoapcUJi
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 265C619F0;
	Thu, 19 Nov 2026 07:36:34 -0800 (PST)
Received: from e142430.arm.com (e142430.arm.com [10.33.10.110])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4A49F3F882;
	Thu, 19 Nov 2026 07:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795102597; bh=DQpZ0nokIMPkbzWDv1VnKuDKQss11s/mtOoOxrD723Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=GoapcUJi0pEeZnV4ebNl7TPRMHBPOxytGhq88+ncGTO6vM1Z1oYs1qIWkfTfxwg71
	 vKH5zkh5ee4gAY2sV3k5E+jhinc9tjA6zl6cBs/jwfpkRew5OKQCv+uuTJNn8B+K8E
	 vmghNQuKLsHfYA6LxbJnY1ZWQjQtzk+oSD1in7eA=
From: Ahmed Azeem <ahmed.azeem@arm.com>
Date: Thu, 19 Nov 2026 15:36:03 +0000
Subject: [PATCH RFC 1/4] uapi: firmware: arm: Add PFDI userspace ABI
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
Message-Id: <20261119-topics-ahmaze01-upstream-pfdi-rfc-v1-1-4772d18b9115@arm.com>
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

Define the userspace ABI for the Arm Platform Fault Detection
Interface (PFDI).

Subsequent commits introduce a driver that exposes a per-CPU misc
device. The ioctl definitions, data structures, and return codes
must therefore be shared with userspace. Add these definitions to
a UAPI header and document the ABI for /dev/cpu/<cpu>/pfdi.

Placing the interface under include/uapi ensures availability via
headers_install and clearly identifies it as a userspace contract.

Link: https://developer.arm.com/documentation/110468/1-0alp0

Signed-off-by: Divin Raj <divin.raj@arm.com>
Signed-off-by: Ahmed Azeem <ahmed.azeem@arm.com>
---
 Documentation/ABI/testing/dev-cpu-pfdi             | 103 +++++++++++++++++++++
 Documentation/userspace-api/ioctl/ioctl-number.rst |   1 +
 MAINTAINERS                                        |   7 ++
 include/uapi/linux/pfdi.h                          |  89 ++++++++++++++++++
 4 files changed, 200 insertions(+)

diff --git a/Documentation/ABI/testing/dev-cpu-pfdi b/Documentation/ABI/testing/dev-cpu-pfdi
new file mode 100644
index 000000000000..e07ed6baa7f8
--- /dev/null
+++ b/Documentation/ABI/testing/dev-cpu-pfdi
@@ -0,0 +1,103 @@
+What:		/dev/cpu/<cpu>/pfdi
+Date:		May 2026
+KernelVersion:	6.18
+Contact:	Linux ARM Kernel Mailing list <linux-arm-kernel@lists.infradead.org>
+Reference:	Arm Platform Fault Detection Interface, document 110468,
+		version 1.0 ALP0
+Description:	Per-CPU Arm Platform Fault Detection Interface (PFDI) misc
+		device nodes. Each node targets the CPU encoded in its
+		path and exposes the PFDI service implemented by firmware.
+		PFDI uses the Arm SMCCC SMC64 calling convention and is
+		PE-local. Userspace is therefore expected to bind itself to
+		the target CPU before opening or issuing ioctls on the
+		matching device node. Each node is single-open: only one
+		userspace owner at a time may hold /dev/cpu/<cpu>/pfdi for a
+		given CPU. Additional open attempts fail with -EBUSY while the
+		device is already open.
+
+		The ABI is defined in <linux/pfdi.h>. The following ioctls
+		are supported:
+
+		* PFDI_IOCTL_VERSION
+		  Read the PFDI version for the target CPU. On success the
+		  ioctl returns 0 and copies a 32-bit version value to
+		  userspace with the following layout:
+		  Bits[30:16] PFDI major version
+		  Bits[15:0] PFDI minor version
+
+		* PFDI_IOCTL_FEATURES
+		  Query whether a PFDI function ID is supported on the
+		  target CPU. Userspace passes a 32-bit PFDI function ID.
+		  The ioctl returns 0 when the function is supported,
+		  and -EOPNOTSUPP when it is not supported on the target
+		  CPU, reserved by the specification, or otherwise not
+		  recognized by firmware.
+
+		* PFDI_IOCTL_PE_TEST_ID
+		  Read the test engine identifier for the target CPU.
+		  On success the ioctl returns 0 and copies a 64-bit value to
+		  userspace with the following layout:
+		  Bits[63:32] reserved and zero
+		  Bits[31:24] vendor ID
+		  Bits[23:20] reserved and zero
+		  Bits[19:16] vendor-defined implementation ID
+		  Bits[15:8] major version
+		  Bits[7:0] minor version
+
+		* PFDI_IOCTL_PE_TEST_PART_COUNT
+		  Read the number of available test parts for the target
+		  CPU. On success the ioctl returns 0 and copies a signed
+		  64-bit count to userspace. The smallest schedulable unit is
+		  a test part, and valid test part indices are in the range 0
+		  to count - 1.
+
+		* PFDI_IOCTL_PE_TEST_RUN
+		  Run a requested inclusive test part range on the target
+		  CPU. struct pfdi_test_run.range.start and .end are signed
+		  64-bit values.
+		  Passing start = -1 and end = -1 requests execution of all
+		  available test parts on the target CPU. Any mixed use of
+		  -1, reversed ranges, out-of-range indices, or non-zero
+		  reserved arguments is rejected with -EINVAL, either by the
+		  kernel before the request is issued or by firmware.
+		  If firmware reports PFDI_RET_FAULT_FOUND, the ioctl returns
+		  -EFAULT and copies a signed 64-bit failing test part
+		  identifier to struct pfdi_test_run.ft_id. If the failing
+		  part cannot be identified, ft_id is set to
+		  PFDI_RET_UNKNOWN.
+
+		* PFDI_IOCTL_PE_TEST_RESULT
+		  Fetch the stored out-of-reset test result for the target CPU.
+		  If firmware reports PFDI_RET_FAULT_FOUND, the ioctl returns
+		  -EFAULT and copies a signed 64-bit failing test part
+		  identifier to userspace. If the failing part cannot be
+		  identified, the copied value is PFDI_RET_UNKNOWN. If no
+		  power-on tests were executed on the target CPU, the ioctl
+		  returns -EAGAIN.
+
+		* PFDI_IOCTL_FW_CHECK
+		  Ask firmware to execute platform firmware resident software
+		  integrity checks. The ioctl returns 0 when no fault is
+		  detected. It returns -EFAULT when firmware reports a fault.
+		  Platforms that do not implement firmware integrity checks
+		  still report success.
+
+		* PFDI_IOCTL_FORCE_ERROR
+		  Schedule injection of a specific PFDI return value for the
+		  next invocation of a selected PFDI function on the same
+		  CPU. The requested function ID must be a supported PFDI
+		  function IDs. Only one pending injected error is permitted
+		  per CPU and function, and a new request replaces any older
+		  undelivered request for the same pair. When the injection
+		  is delivered, firmware returns the injected value in x0 and
+		  zeros x1 to x4.
+
+		These device nodes reflect the PFDI 1.0 ALP0 specification.
+		PFDI state is not persistent across reset or firmware update;
+		userspace must rediscover capabilities and any test state
+		after such events.
+
+		These nodes are intended for platform bring-up and validation.
+		Access should therefore be restricted to privileged software.
+
+Users:		Platform validation and manufacturing test tools
diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index dbe462040999..aa5a6cf20d3c 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -170,6 +170,7 @@ Code  Seq#    Include File                                             Comments
 'I'   all    linux/isdn.h                                              conflict!
 'I'   00-0F  drivers/isdn/divert/isdn_divert.h                         conflict!
 'I'   40-4F  linux/mISDNif.h                                           conflict!
+'J'   01-08  linux/pfdi.h                                              Arm Platform Fault Detection Interface
 'K'   all    linux/kd.h
 'L'   00-1F  linux/loop.h                                              conflict!
 'L'   10-1F  drivers/scsi/mpt3sas/mpt3sas_ctl.h                        conflict!
diff --git a/MAINTAINERS b/MAINTAINERS
index d738990161bd..de9c296d1de1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14012,6 +14012,13 @@ F:	drivers/iommu/iova.c
 F:	include/linux/iommu-dma.h
 F:	include/linux/iova.h
 
+Platform Fault Detection Interface - ARM PFDI
+M:	Ahmed Azeem <ahmed.azeem@arm.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
+F:	Documentation/ABI/testing/dev-cpu-pfdi
+F:	include/uapi/linux/pfdi.h
+
 IOMMU SUBSYSTEM
 M:	Joerg Roedel (AMD) <joro@8bytes.org>
 M:	Will Deacon <will@kernel.org>
diff --git a/include/uapi/linux/pfdi.h b/include/uapi/linux/pfdi.h
new file mode 100644
index 000000000000..e3b7fe19daf4
--- /dev/null
+++ b/include/uapi/linux/pfdi.h
@@ -0,0 +1,89 @@
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
+/*
+ * Arm Platform Fault Detection Interface (PFDI) userspace ABI
+ *
+ * Copyright (C) 2026 Arm Ltd.
+ */
+
+#ifndef _UAPI_LINUX_PFDI_H
+#define _UAPI_LINUX_PFDI_H
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+/*
+ * SMC function IDs for PFDI v1.0.
+ * These follow the SMCCC fast-call, 64-bit, Standard Secure Service encoding.
+ */
+#define PFDI_FN_BASE			0xC40002D0U
+#define PFDI_FN(n)			(PFDI_FN_BASE + (n))
+
+#define PFDI_FN_VERSION			PFDI_FN(0x00)
+#define PFDI_FN_FEATURES		PFDI_FN(0x01)
+#define PFDI_FN_PE_TEST_ID		PFDI_FN(0x02)
+#define PFDI_FN_PE_TEST_PART_COUNT	PFDI_FN(0x03)
+#define PFDI_FN_PE_TEST_RUN		PFDI_FN(0x04)
+#define PFDI_FN_PE_TEST_RESULT		PFDI_FN(0x05)
+#define PFDI_FN_FW_CHECK		PFDI_FN(0x06)
+#define PFDI_FN_FORCE_ERROR		PFDI_FN(0x07)
+
+#define PFDI_VERSION_MAJOR_SHIFT	16
+#define PFDI_VERSION_MAJOR_MASK		0x7FFFU
+#define PFDI_VERSION_MINOR_MASK		0xFFFFU
+
+#define PFDI_VERSION_MAJOR(ver) \
+	(((ver) >> PFDI_VERSION_MAJOR_SHIFT) & PFDI_VERSION_MAJOR_MASK)
+#define PFDI_VERSION_MINOR(ver)		((ver) & PFDI_VERSION_MINOR_MASK)
+#define PFDI_VERSION(maj, min) \
+	((((maj) & PFDI_VERSION_MAJOR_MASK) << PFDI_VERSION_MAJOR_SHIFT) | \
+	 ((min) & PFDI_VERSION_MINOR_MASK))
+
+/* PFDI return values */
+#define PFDI_RET_TEST_COUNT_ZERO	(-8)
+#define PFDI_RET_UNKNOWN		(-7)
+#define PFDI_RET_NOT_RUN		(-6)
+#define PFDI_RET_ERROR			(-5)
+#define PFDI_RET_FAULT_FOUND		(-4)
+#define PFDI_RET_INVALID_PARAM		(-3)
+#ifndef SMCCC_RET_NOT_SUPPORTED
+#define SMCCC_RET_NOT_SUPPORTED		(-1)
+#endif
+#ifndef SMCCC_RET_SUCCESS
+#define SMCCC_RET_SUCCESS		0
+#endif
+
+struct pfdi_test_range {
+	__s64 start;
+	__s64 end;
+};
+
+struct pfdi_test_run {
+	struct pfdi_test_range range;
+	__s64 ft_id;
+};
+
+struct pfdi_force_error {
+	__u32 smc_fid;
+	/* Keep the ioctl layout identical for native and compat userspace. */
+	__u32 reserved;
+	__s64 error_id;
+};
+
+#define PFDI_IOCTL_VERSION \
+	_IOR('J', 1, __u32)
+#define PFDI_IOCTL_FEATURES \
+	_IOW('J', 2, __u32)
+#define PFDI_IOCTL_PE_TEST_ID \
+	_IOR('J', 3, __u64)
+#define PFDI_IOCTL_PE_TEST_PART_COUNT \
+	_IOR('J', 4, __s64)
+#define PFDI_IOCTL_PE_TEST_RUN \
+	_IOWR('J', 5, struct pfdi_test_run)
+#define PFDI_IOCTL_PE_TEST_RESULT \
+	_IOR('J', 6, __s64)
+#define PFDI_IOCTL_FW_CHECK \
+	_IO('J', 7)
+#define PFDI_IOCTL_FORCE_ERROR \
+	_IOW('J', 8, struct pfdi_force_error)
+
+#endif /* _UAPI_LINUX_PFDI_H */

-- 
2.43.0

