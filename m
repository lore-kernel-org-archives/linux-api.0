Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794281809;
	b=jIA8oQtLHyGsfi12n79MHb74Ij5LGnD6Zx24zneGdRgj72D9cuvKXMk0jz++CHVqZBWc
	 IYtdASPXkkPhaFhahwUpjo/fpyJVwmffDRksKVz1TVrDQiunXXO4QIxtpvWAHB1Vf586b
	 MQWUmFL7H/Q465UfdfrJ1kAExxOAvngsGqOOONxdjHp/fqu/eCQJcq+IRZPHsWk+E1u0x
	 fpJtV3FVtxxAn5tmdASchjJNuAE4QaNCW/LSTXakTjfxCEPbEnX6nj7MUMO1V36r79xca
	 J9dlI0RlLghdPrFQ5FHwbspRn0hWEwdV1zIkTpaGRf1A17h7doJqpASTCsIMphadpIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794281809;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Subject:Date:
	 Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=Gqq2aUjbgUdyU4pEuz0EN5i1JADS+AhZCyuttI7Lpnc=;
	b=Ml+ZVja+Srzp7Bb7u5jFufexhfprcnRe5HemKD2uvTRPWBwu6rYBvxbGI5IkNp8Xi0uO
	 b/trqTPlZNzmb/g3SxvCH4xRBZxoxEnyHfCuaPz9o91/osdYGdvhwpP1AaEOE7jqeZrwB
	 dKOkc5QZ4LvoqbeQDVAsYhu9Hk74t2eHuTxTBUCaFgdk1NzhXikimapj0RPIUPn7xHOwB
	 wOaa4pBZxLQBH4NyDgcqe8L9ayBxGW7diIcrBZczefw5DyeoXcGuNPUe/Jh79DCET3WvH
	 F/qWJnLYi/9I0bE59dPsU8cW2FoN3J2IOR5TRvrm49pxAtOzE+gNXOzgUdnVKvkTihA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="eNU0d8/F";
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E442606A321;
	Tue, 10 Nov 2026 03:36:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E442606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=eNU0d8/F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794281809; x=1825817809;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=ZcMRT1Odg7mJsXpOHhvyGS0FDoKbOOK959OFO8wB1sM=;
  b=eNU0d8/FNq4Tt2tvFpCP4aVoxdyA7X6rjahYm9B/m90ngC6nma2f7wxX
   GXBjYzmTOTAKuSkpliobAOXQr0BdSON1PPjFFR5SLB6W5stJjisn53Nj/
   sTSzX+EL5B2i5c080yqr8lxDz3HR8xm9RjmkhnhbYaf95ymOxlo1m21JP
   1rySASNi68RooE7cq6wUaqCJ9LoYMMoojfNidaLp+1cw2Osjcw4CXVsab
   nlszoRB2Fh8HoIaXwZOAgJw2Tmx3urFOXNEJfTUl6zW7nYdHs/KDkP5wL
   NkexRiroaxIqyWlcSfmUXY4x1zAU/8G2MCbMl8wIh+WijHskm1kkHiG/m
   w==;
X-CSE-ConnectionGUID: jLMxaQEuSLib7eWtVCle7w==
X-CSE-MsgGUID: JTGrWWGpTR2MNmcQ+cPJHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="3010631"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="3010631"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
X-CSE-ConnectionGUID: JxaPr5wLTGKqOvF7u2l8Bw==
X-CSE-MsgGUID: iea3teVpRbK5EKhxQXKWfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="8370783"
Received: from unknown (HELO [172.25.112.21]) ([172.25.112.21])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Subject: [PATCH 00/13] thermal: intel: dpti: Direct the package thermal
 interrupt to a chosen CPU
Date: Mon, 09 Nov 2026 19:36:27 -0800
Message-Id: <20261109-dpti-custom-cpu-v1-0-ead8e2d2067e@linux.intel.com>
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
X-B4-Tracking: v=1; b=H4sIADuR8moC/x3MQQ5AMBBA0avIrE1SU1VxFbGQdjALNC0iEXfXW
 L7F/w8kjsIJuuKByJck2beMqizALeM2M4rPBlLUKEsKfTgE3ZmOfUUXTjS1brVlTWQN5CpEnuT
 +j/3wvh+QeCAlYQAAAA==
To: "Rafael J. Wysocki" <rafael@kernel.org>, 
 Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>, 
 Lukasz Luba <lukasz.luba@arm.com>, 
 Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: linux-pm@vger.kernel.org, linux-api@vger.kernel.org, 
 linux-kernel@vger.kernel.org, ricardo.neri@intel.com, 
 Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794281807; l=8557;
 i=ricardo.neri-calderon@linux.intel.com; s=20250602;
 h=from:subject:message-id; bh=ZcMRT1Odg7mJsXpOHhvyGS0FDoKbOOK959OFO8wB1sM=;
 b=0QoSgEySCBudYcqsYlUYNN5QeV1c0s0rSq4F0VD5f2LPpivG3QRAVQzoBU5qqyv6ecA5QY/ni
 mJXojtlUmN0BkM9Ltl4VSSBBNX35k1AwlKBAjzEyDuRhtKZ4KsIhcem
X-Developer-Key: i=ricardo.neri-calderon@linux.intel.com; a=ed25519;
 pk=NfZw5SyQ2lxVfmNMaMR6KUj3+0OhcwDPyRzFDH9gY2w=

The directed package-level thermal interrupt (DPTI) lets a single CPU per
package receive the package thermal interrupt instead of broadcasting it to
every CPU in the package. Today that CPU is chosen with no regard for the
user's intent: the first CPU of a package to come online claims the
interrupt, and on offline it is redirected to another CPU of the package.
As a result, the interrupt can land on a CPU the user would rather keep
undisturbed, such as a nohz_full CPU, whose tickless isolation it breaks.

This series gives the user explicit control over the interrupt owner
through sysfs. It also updates automatic selection of the owner CPU to
avoid CPUs isolated at boot through the nohz_full and isolcpus=nohz
command-line options.

CPUs isolated through isolcpus=domain or a cpuset isolated partition are
left for a follow-up series, if there is interest.

The sysfs interface
-------------------

On a system with DPTI, every online CPU gets a boolean attribute in its
existing thermal_throttle group:

  /sys/devices/system/cpu/cpuX/thermal_throttle/package_interrupt_owner

Reading it answers a question about cpuX alone: 1 if cpuX is the CPU
currently programmed to receive its package's thermal interrupt, 0
otherwise. The owner is a per-package property, so at most one CPU of a
package reads 1, and all of them read 0 while the interrupt is not directed
to any CPU.

Writing 1 migrates the interrupt to cpuX and pins it there, overriding
automatic selection. The request is honored even if cpuX is
nohz_full-isolated, in which case a warning is logged. The write fails if
the hardware does not acknowledge the new owner.

Writing 0 releases a pin on cpuX and returns the package to automatic
selection. If cpuX is nohz_full-isolated, the interrupt moves to a CPU of
the package that is not, when one is online. Otherwise it stays on cpuX.
Writing 0 to a CPU that is not pinned has no effect.

  # Direct this package's thermal interrupt to CPU 3 and keep it there
  echo 1 > \
      /sys/devices/system/cpu/cpu3/thermal_throttle/package_interrupt_owner

  # Let automatic selection govern that package again
  echo 0 > \
      /sys/devices/system/cpu/cpu3/thermal_throttle/package_interrupt_owner

  # List the CPUs that own their package's interrupt
  grep -l '^1$' \
      /sys/devices/system/cpu/cpu*/thermal_throttle/package_interrupt_owner

Known limitations
-----------------

To keep the interface and the implementation simple, the interface accepts
these limitations:

 - The file reports owner state, not pin state. Writing 0 to a CPU that is
   not isolated unpins without migrating: cpuX keeps the interrupt and
   keeps reading 1 until the placement changes, for example when cpuX goes
   offline.

 - There is no request to move the interrupt away from cpuX. Pin another
   CPU of the package instead.

 - A write to one CPU changes what another CPU's file reads: pinning cpuY
   makes the previous owner, cpuX, read 0 without cpuX's file being
   written.

 - Finding which CPU owns a given package's interrupt takes one read per
   CPU of the package instead of a single read.

 - The pinned preference is not observable. While a pinned CPU is offline,
   the remaining CPUs of the package report the automatically chosen
   fallback. The pin is silently restored when the pinned CPU comes back
   online.

 - The same file appears under every CPU of a package, because per-package
   state is exposed through the per-CPU device. This reuses the existing
   per-CPU device infrastructure and mirrors package_throttle_count, which
   is also per-package state shown per-CPU.

Organization
------------

The series is organized as follows:

 * Fix (patch 1): an existing race between kernel_kexec() and CPU hotplug
   can program a new owner after the syscore shutdown has cleared the DPTI
   in all packages and leave it enabled in the next kernel. Independent of
   the rest of the series.

 * Preparation (patches 2-4): prefix the log messages of therm_throt.c
   with pr_fmt(), move the sysfs device helpers next to their callers, and
   give the DPTI code a consistent dpti_ naming scheme.

 * Groundwork (patches 5-9): owner changes become more likely once the
   selection and sysfs patches land. Limit the full teardown to boot, so
   that a later failure affects only its package; group per-package state
   in struct dpti_pkg; and factor the programming sequence into helpers
   that run it on the target CPU, from any CPU and entry point.

 * Rank-based owner selection (patch 10): instead of special-casing pinned
   and isolated CPUs, rank every CPU and move the interrupt only on a
   strict rank improvement.

 * Serialization (patch 11): introduce dpti_mutex ahead of the sysfs
   writer, which runs concurrently with the CPU hotplug callbacks.

 * Avoid nohz_full-isolated CPUs (patch 12): rank housekeeping CPUs above
   isolated ones, and migrate as soon as a housekeeping CPU comes online.

 * The sysfs interface (patch 13): let the user pin the owner.

Summary of testing
------------------

Tested on a 1-socket system with DPTI and on a 2-socket system without it,
where test-only patches emulate DPTI.

- CPU hotplug:
  - Sweeps that offline and then online each CPU in turn, checking the
    owner in MSR_IA32_THERM_INTERRUPT (and in sysfs from patch 13) after
    every step: about 750 transitions across the kernels of every patch on
    the 1-socket system, and about 950 on the 2-socket system, where
    package owners go offline and the interrupt migrates.
  - lockdep stress runs of up to 10,000 offline/online cycles against
    sysfs writes, with no deadlocks.
  - Injected handover failures always ended with either the old owner
    kept or the package broadcasting.
- Isolation (nohz_full):
  - The owner stayed on housekeeping CPUs and fell back to an isolated CPU,
    with a warning, only when it had to. Ownership migrated back to a
    housekeeping CPU as soon as one came online.
  - 0 of 36 package interrupts reached an isolated CPU with DPTI, against
    26 of 26 without it.
- Hibernation (S4):
  - One cycle on every patch kernel, with the owner restored each time,
    and a pin restored where one was set.
  - All four combinations of image and boot kernel, with and without DPTI,
    left no stale state.
- kexec:
  - The sysfs race went from 22 of 22 failing to 20 of 20 clean with the
    fix in patches 1 and 11. The CPU hotplug race went from 4 of 4 failing
    to 0 of 5 with patch 1.
  - A kexec into a kernel without DPTI always found the hardware clean.
- Configurations:
  - Every patch builds cleanly in an x86_64_defconfig-based configuration,
    with each of NO_HZ_FULL, SYSFS, SMP, CPU_ISOLATION, PM_SLEEP, lockdep
    and X86_THERMAL_VECTOR turned off one at a time, and in a 32-bit
    build. On hardware, I ran the test systems' distribution configuration
    with debug options, plus three variants: NO_HZ_FULL=n, KASAN with
    kmemleak, and a no-debug performance build.

Thanks and BR,
Ricardo

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
---
Ricardo Neri (13):
      thermal: intel: Keep directed package interrupts off after syscore shutdown
      thermal: intel: Prefix log messages via pr_fmt()
      thermal: intel: Move the sysfs device helpers next to their callers
      thermal: intel: dpti: Adopt the dpti_ prefix and the owner terminology
      thermal: intel: dpti: Tear down DPTI only during boot
      thermal: intel: dpti: Introduce struct dpti_pkg for per-package state
      thermal: intel: dpti: Configure the local CPU by value
      thermal: intel: dpti: Factor the programming sequence out into a helper
      thermal: intel: dpti: Program the directed interrupt on the target CPU
      thermal: intel: dpti: Add rank-based owner selection
      thermal: intel: dpti: Serialize updates to the directed interrupt state
      thermal: intel: dpti: Avoid nohz_full CPUs when possible
      thermal: intel: dpti: Add sysfs control of interrupt owner

 Documentation/ABI/testing/sysfs-devices-system-cpu |  40 ++
 drivers/thermal/intel/therm_throt.c                | 739 ++++++++++++++++-----
 2 files changed, 606 insertions(+), 173 deletions(-)
---
base-commit: b76a128501206bf16467a918f09b9f07ec239429
change-id: 20260720-dpti-custom-cpu-543837e32275

Best regards,
-- 
Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

