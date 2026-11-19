Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795102597;
	b=q0NX0u7yjb5Ndj+rw+gb7qG5vqKGKvozioaEBchr4IEWJxWEaBiQ2Az5zcEYnOmtEfxc
	 +5vbJXB5e+qT8i+uvJqkiil3AiBUrAkAMr7atzmmAtHlnEtQoZD5ZeW+iH5Wp/3gFHyXT
	 ET+idJypQzgGPo/LUE+tBk7vmQfsMqC9H8GMwxEDA1ZPt3DCWFKKYATiahuB7sI+Mt/ju
	 AgPIWQwFIAnxWi9clYGOVBpuqvFxemBfNnnchqHu1RwxHL2rcRNT+E/rBWh+1Vck9poUz
	 TVouelW7OES1+Jk4N6PfFW5Y/s/6lWFdEXRczSQme55ydXiY+vM9aaqhVIwxp7t5DmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795102597;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:Subject:Date:
	 Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-B4-Tracking:To:Cc:X-Mailer;
	bh=H4yit5SDhOFjRfJFYgJaFUlDDWjSPvM5/XqvlQS4pFA=;
	b=Na4Mcin5L7y2o//AtshEmAcUTmqIo+hAULrBRr82ahmOBS/r3Snxe7dLUGaFSZUZgutK
	 jh+xsm812V+ttJA4nBFGeJdcazLJjKNUJMdnN2h7iJvGYEFZZXdmqH8BS1RGG4n60/wwq
	 5SIQn6rZC6o5f5slsSjeklpp/HzeJBjfq7QroLlOUVCa4b2xzDwOLFzZHuL4u8X3REzJo
	 WGhPNpj49COa1/eeqzymIJKnN7OC4yRvingiV/HhFS4Mb93lGOSXxk1XkqbpsW2GjsNzf
	 puJwwFEENcTHE/g2itHbZrdt/fU1IE+pk2sXHj8Hcks1ZUML5H3QKBTG6wDdHF0N2Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=AvPv5gbz;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7CF860A2602;
	Thu, 19 Nov 2026 15:36:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7CF860A2602
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=AvPv5gbz
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F5D01575;
	Thu, 19 Nov 2026 07:36:32 -0800 (PST)
Received: from e142430.arm.com (e142430.arm.com [10.33.10.110])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2594E3F882;
	Thu, 19 Nov 2026 07:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795102595; bh=F/IW7r05sEPQU7RmKMophY+HTf4SbgNHPg1LXJ+0/7s=;
	h=From:Subject:Date:To:Cc:From;
	b=AvPv5gbzj+pDeoOd2ToVmOfNzetkdOnqKDeIvzzbJSjqfvJawl8Dx7dXaOjNNm80U
	 gGYWYr/ixLyk8l6+AI6HXgPWdB4uPfhX2PSPT27QXE66hTOaLjPxcRVq9uqzQHuXhl
	 /T+RfZqr6whanh7HSkRCi/2iE6bSoRRDpzZiB6DA=
From: Ahmed Azeem <ahmed.azeem@arm.com>
Subject: [PATCH RFC 0/4] firmware: arm: Add Platform Fault Detection
 Interface support
Date: Thu, 19 Nov 2026 15:36:02 +0000
Message-Id: <20261119-topics-ahmaze01-upstream-pfdi-rfc-v1-0-4772d18b9115@arm.com>
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
X-B4-Tracking: v=1; b=H4sIAGIX/2oC/x2NQQ6CQAwAv0J6tgmLQMSrCQ/wajyUpbg9LGxaN
 EbC3109zhxmNjBWYYNzsYHyS0yWOYM7FOADzQ9GGTNDVVatc67DdUniDSlE+nDp8JlsVaaIaRo
 FdfLYHGt/arp6rNoWcicpT/L+P25w7S9wz3IgYxyUZh9++Ui2ssK+fwEWYBH9kQAAAA==
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

Hi all,

This series proposes an arm64 driver for the Arm Platform Fault
Detection
Interface (PFDI), providing a common Linux interface for privileged
userspace to discover and invoke firmware diagnostics.

We are posting this series as an RFC to seek community feedback on both
the proposed Linux interface and the underlying firmware specification
before the specification is finalized. This series and its validation
use
the PFDI 1.0 ALP0 specification [1]. The current public revision is PFDI
1.0 BET0 [2]. Feedback on the software integration will help identify
any
changes needed to align an upstream implementation with the evolving
specification.

PFDI defines firmware calls for discovering a PE's test engine and test
parts, executing online tests, retrieving out-of-reset test results,
checking
firmware integrity, and injecting responses to validate error handling
[1].
Trusted Firmware-A documents an implementation of these services [3].

A practical use case is a safety-critical or high-availability platform
that uses manufacturer-provided software tests in firmware to detect
faults at boot and during operation. These tests can complement hardware
error-detection mechanisms by targeting failure modes that those
mechanisms do not cover. Firmware performs the boot-time tests, Linux
software can retrieve their results and request online tests at
intervals
chosen by the platform's diagnostic application. The diagnostic coverage
depends on the tests implemented by the platform.

The Linux use case is a privileged diagnostic application that needs to
discover the tests available on a CPU, run a selected range, and
retrieve
the outcome, including a failing test identifier where firmware provides
one. A common driver and documented userspace ABI would allow that
application to use the same interface across platforms implementing
PFDI,
while keeping the test implementation in platform firmware.

Kernel mediation is needed to issue the SMC calls and coordinate them
with
CPU placement and lifetime. PFDI operations are PE-local [1], so
executing
a request on the intended CPU is part of the interface's correctness.
The proposed driver uses a worker bound to each target CPU and exposes
/dev/cpu/<cpu>/pfdi. Requests and results are carried through typed
ioctls;
device nodes default to mode 0600, and each CPU device permits one open
owner at a time.

The driver leaves the choice of test ranges, execution frequency, and
response to a reported fault to userspace. It adds no periodic test loop
or automatic recovery policy. The intended upstream benefit is a shared
firmware access mechanism that platform diagnostic tools can build on,
without embedding their deployment-specific policy in the kernel.

The four patches provide:

1. A UAPI header, ioctl allocation, ABI documentation, and MAINTAINERS
   entry.
2. The firmware driver, per-CPU devices, and query operations.
3. Test execution, out-of-reset result retrieval, and error injection.
4. Worker serialization and CPU hotplug lifetime handling.

Error injection is included to exercise the software path that consumes
PFDI responses. The proposed ABI also returns the firmware's 64-bit
failing
test identifier for test execution and out-of-reset result queries.

Arm's public reference software documentation describes firmware, Linux
driver, and userspace components for a PFDI stack [4]. Its default
reference
test backend is a placeholder, so this provides integration context
rather
than evidence of hardware diagnostic coverage.

Validation of this revision:

Runtime validation was performed on Arm Zena CSS using its reference
PFDI
firmware and userspace stack, exercising service startup, per-core
diagnostic execution, out-of-reset result queries, CLI operations,
monitoring, and forced-error handling. As the default reference firmware
test backend is an integration placeholder rather than a production test
library, this validates the end-to-end userspace, Linux, SMC, and
firmware
paths rather than hardware diagnostic coverage.

I would appreciate feedback on the specification's suitability for Linux
integration, the proposed per-CPU ioctl ABI, the worker and hotplug
model,
and whether this belongs under drivers/firmware. In particular, is this
the right scope for a common PFDI interface, and should error injection
be exposed separately from normal diagnostic operations?

[1] Arm Platform Fault Detection Interface Specification, document
110468,
    version 1.0 ALP0:
    https://documentation-service.arm.com/static/68593b17961937560be90fbe

[2] Arm Platform Fault Detection Interface Specification, document
110468,
    version 1.0 BET0:
    https://support.arm.com/documentation/110468/1-0bet0/?lang=en

[3] Trusted Firmware-A PFDI implementation documentation:
    https://tf-a.docs.trustedfirmware.org/en/latest/components/pfdi.html

[4] Arm Zena CSS PFDI design documentation:
    https://arm-zena-css.docs.arm.com/en/latest/design/platform_fault_detection_interface.html

To: linux-arm-kernel@lists.infradead.org
To: Sudeep Holla <sudeep.holla@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: linux-api@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Divin Raj <divin.raj@arm.com>
Cc: Bertrand Marquis <Bertrand.Marquis@arm.com>

Signed-off-by: Ahmed Azeem <ahmed.azeem@arm.com>
---
Divin Raj (4):
      uapi: firmware: arm: Add PFDI userspace ABI
      firmware: arm: Add PFDI misc driver skeleton
      firmware: arm: Add PFDI run, result, and error injection support
      firmware: arm: Harden PFDI worker and hotplug handling

 Documentation/ABI/testing/dev-cpu-pfdi             | 103 +++
 Documentation/userspace-api/ioctl/ioctl-number.rst |   1 +
 MAINTAINERS                                        |   8 +
 drivers/firmware/Kconfig                           |  14 +
 drivers/firmware/Makefile                          |   1 +
 drivers/firmware/arm_pfdi.c                        | 948 +++++++++++++++++++++
 include/uapi/linux/pfdi.h                          |  89 ++
 7 files changed, 1164 insertions(+)
---
base-commit: 20eef29b7c8465ac98d7dd6d6f2ac07a8d8056ca
change-id: 20261119-topics-ahmaze01-upstream-pfdi-rfc-534c8594d266

Best regards,
-- 
Ahmed Azeem <ahmed.azeem@arm.com>

