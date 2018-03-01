From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v2 0/3] arm64: Fix invalid si_codes for fault signals
Date: Thu,  1 Mar 2018 17:44:05 +0000
Message-ID: <1519926248-12591-1-git-send-email-Dave.Martin@arm.com>
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
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

Changes since v1:

 * Fixed failing BUILD_BUG_ON() sanity check on NSIGFPE done by x86.
   (Thanks to James Morse for spotting.)

   The addition of FPE_FLTUNK is harmless to x86, since only arm64
   uses this code right now.

Changes since RFC v2:

 * Fold in reverts of the relevant parts of Eric's *_FIXME changes,
   since this series removes all cases of those dummy si_code values
   from arm64.

 * Propagated the new signal/si_code assignments for synchronous
   external aborts correctly to signals thrown from do_sea().

Original blurb:

As reported by Eric Biederman, [1], [2], [3] etc., several architectures
are inappropriately setting si_code to 0 when signaling faults to
userspace, which will interpret this value as SI_USER leading to garbage
being read out of siginfo fields that the kernel doesn't initialise.

This seems not to be a huge problem in practice, since many affected
faults should only happen if the kernel or hardware is buggy or broken.
However, there are some cases that don't fall under this.

This RFC series proposes fixes to eliminate these si_code == 0 cases
from arm64.  Some of the changes may be controversial.

There are two main headlines here, which may be applicable to other
architectures:

 * addition of a new code FPE_UNKNOWN for undiagnosable floating-point
   exception traps;

 * delivering SIGKILL instead of SIGSEGV/BUS/TRAP etc. for "impossible"
   exceptions that are not feasible to recover from and likely indicate
   a kernel or system bug or failure.

In particular there is likely to be a fair amount of overlap between arm
and arm64 here, but due to the longer history and evolution of the arm
tree and 32-bit architecture I'm less confident in making correct
judgements for that case.  This series doesn't touch arm, for now.

Boot-tested on Arm Juno r0.
Floating-point exception traps tested on the Arm Fast Model.

[1] [PATCH 00/11] siginfo fixes/cleanups esp SI_USER
https://marc.info/?l=linux-kernel&m=151571871109016&w=2

[2] [PATCH 08/11] signal/arm: Document conflicts with SI_USER and SIGFPE
http://lists.infradead.org/pipermail/linux-arm-kernel/2018-January/553574.html

[3] [PATCH 07/11] signal/arm64: Document conflicts with SI_USER and SIGFPE, SIGTRAP, SIGBUS
lists.infradead.org/pipermail/linux-arm-kernel/2018-January/553573.html

Dave Martin (3):
  signal: Add FPE_FLTUNK si_code for undiagnosable fp exceptions
  arm64: fpsimd: Fix bad si_code for undiagnosed SIGFPE
  arm64: signal: Ensure si_code is valid for all fault signals

 arch/arm64/include/asm/esr.h          |   9 +++
 arch/arm64/include/uapi/asm/siginfo.h |  21 ------
 arch/arm64/kernel/fpsimd.c            |  31 +++++----
 arch/arm64/mm/fault.c                 | 116 +++++++++++++++++-----------------
 arch/x86/kernel/signal_compat.c       |   2 +-
 include/uapi/asm-generic/siginfo.h    |   3 +-
 kernel/signal.c                       |   4 --
 7 files changed, 87 insertions(+), 99 deletions(-)

-- 
2.1.4
