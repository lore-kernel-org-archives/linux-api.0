From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v3 0/7] arm64: Initial support for CVADP
Date: Mon,  1 Apr 2019 11:45:08 +0100
Message-ID: <20190401104515.39775-1-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, libc-alpha@sourceware.org, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, linux-api@vger.kernel.org, Phil Blundell <pb@pbcl.net>, dave.martin@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

ARMv8.5 introduces a DC CVADP instruction which cleans the data cache to
the point of deep persistence. This series makes the instruction
available to userspace and advertises the presence of this CPU feature.

At present when CONFIG_ARM64_PMEM is enabled and the CVAP feature is
present (ARMv8.2) the CVAP instruction is used (from memcpy_flushcache
and arch_wb_cache_pmem). No changes have been made to use CVADP in
these functions or similar.

As we have moved beyond 32 capabilities we now begin using AT_HWCAP2
for userspace.

Tested as follows:

$ dmesg | grep "Deep"
[    0.166496] CPU features: detected: Data cache clean to Point of Deep Persistence

$ LD_SHOW_AUXV=1 sleep 2>&1 | grep AT_HWCAP
AT_HWCAP:        ef91ff87
AT_HWCAP2:       0x1

Changes since v2:

 - Rebased onto v5.1-rc2

 - Renamed cpu_{have,set}_feature_name to cpu_{have,set}_named_feature

 - Add additional comments and update kernel Documentation

Changes since v1:

 - Rebased onto v5.0-rc7

 - Introduced cpu_{have,set}_feature_name to eliminate use of
   KERNEL_HWCAP prefix

 - Hard coded MAX_CPU_FEATURES and added a WARN_ON

 - Minor comment and tab/spacing changes

 - Use elf_hwcap for all 64 caps in the kernel instead of
   a new elf_hwcap2


Andrew Murray (7):
  arm64: Handle trapped DC CVADP
  arm64: HWCAP: add support for AT_HWCAP2
  arm64: HWCAP: encapsulate elf_hwcap
  arm64: Expose DC CVADP to userspace
  arm64: add CVADP support to the cache maintenance helper
  arm64: Advertise ARM64_HAS_DCPODP cpu feature
  arm64: docs: document AT_HWCAP2 and unused AT_HWCAP bits

 Documentation/arm64/elf_hwcaps.txt       |  18 +++-
 arch/arm64/crypto/aes-ce-ccm-glue.c      |   2 +-
 arch/arm64/crypto/aes-neonbs-glue.c      |   2 +-
 arch/arm64/crypto/chacha-neon-glue.c     |   2 +-
 arch/arm64/crypto/crct10dif-ce-glue.c    |   4 +-
 arch/arm64/crypto/ghash-ce-glue.c        |   8 +-
 arch/arm64/crypto/nhpoly1305-neon-glue.c |   2 +-
 arch/arm64/crypto/sha256-glue.c          |   4 +-
 arch/arm64/include/asm/assembler.h       |   4 +
 arch/arm64/include/asm/cpucaps.h         |   3 +-
 arch/arm64/include/asm/cpufeature.h      |  21 ++---
 arch/arm64/include/asm/esr.h             |   3 +-
 arch/arm64/include/asm/hwcap.h           |  50 ++++++++++-
 arch/arm64/include/uapi/asm/hwcap.h      |   7 +-
 arch/arm64/kernel/cpufeature.c           | 108 +++++++++++++++--------
 arch/arm64/kernel/cpuinfo.c              |   3 +-
 arch/arm64/kernel/fpsimd.c               |   4 +-
 arch/arm64/kernel/traps.c                |   3 +
 drivers/clocksource/arm_arch_timer.c     |   8 ++
 19 files changed, 185 insertions(+), 71 deletions(-)

-- 
2.21.0
