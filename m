From: ebiederm@xmission.com (Eric W. Biederman)
Subject: [GIT PULL] sysctl: Remove the sysctl system call
Date: Wed, 27 Nov 2019 10:55:52 -0600
Message-ID: <87r21tuulj.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


Linus,

Please pull the for-linus branch from the git tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-linus

   HEAD: 61a47c1ad3a4dc6882f01ebdc88138ac62d0df03 sysctl: Remove the sysctl system call

As far as I can tell we have reached the point where no one enables the
sysctl system call anymore.  It still is enabled in a few defconfigs
but they are mostly the rarely used one and in asking people about
that it was more cut & paste enabled than anything else.

This is single commit that just deletes code.  Leaving just enough code
so that the deprecated sysctl warning continues to be printed.  If my
analysis turns out to be wrong and someone actually cares it will be
easy to revert this commit and have the system call again.

There was one new xtensa defconfig in linux-next that enabled the system
call this cycle and when asked about it the maintainer of the code
replied that it was not enabled on purpose.  As of today's linux-next
tree that defconfig no longer enables the system call.

I have recently amended the commit to include the review status.

Some of the mailing list choked on my patch posting, I don't know why
but here is a link to part of the review that made it to linux-kernel.
https://lore.kernel.org/lkml/201910011140.EA0181F13@keescook/

What we saw in the review discussion was that if we go a step farther
than my patch and mess with uapi headers there are pieces of code that
won't compile, but nothing minds the system call actually disappearing
from the kernel.

Eric W. Biederman (1):
      sysctl: Remove the sysctl system call

 arch/arc/configs/nps_defconfig              |    1 -
 arch/arc/configs/tb10x_defconfig            |    1 -
 arch/arm/configs/axm55xx_defconfig          |    1 -
 arch/arm/configs/keystone_defconfig         |    1 -
 arch/arm/configs/lpc32xx_defconfig          |    1 -
 arch/arm/configs/moxart_defconfig           |    1 -
 arch/arm/configs/qcom_defconfig             |    1 -
 arch/arm/configs/zx_defconfig               |    1 -
 arch/m68k/configs/m5475evb_defconfig        |    1 -
 arch/mips/configs/ci20_defconfig            |    1 -
 arch/mips/configs/loongson3_defconfig       |    1 -
 arch/mips/configs/malta_qemu_32r6_defconfig |    1 -
 arch/mips/configs/maltaaprp_defconfig       |    1 -
 arch/mips/configs/maltasmvp_defconfig       |    1 -
 arch/mips/configs/maltasmvp_eva_defconfig   |    1 -
 arch/mips/configs/maltaup_defconfig         |    1 -
 arch/mips/configs/omega2p_defconfig         |    1 -
 arch/mips/configs/qi_lb60_defconfig         |    1 -
 arch/mips/configs/vocore2_defconfig         |    1 -
 arch/nios2/configs/10m50_defconfig          |    1 -
 arch/nios2/configs/3c120_defconfig          |    1 -
 arch/parisc/configs/c8000_defconfig         |    1 -
 arch/parisc/configs/generic-32bit_defconfig |    1 -
 arch/powerpc/configs/40x/klondike_defconfig |    1 -
 arch/sh/configs/rsk7264_defconfig           |    1 -
 arch/xtensa/configs/audio_kc705_defconfig   |    1 -
 arch/xtensa/configs/cadence_csp_defconfig   |    1 -
 arch/xtensa/configs/generic_kc705_defconfig |    1 -
 arch/xtensa/configs/iss_defconfig           |    1 -
 arch/xtensa/configs/nommu_kc705_defconfig   |    1 -
 arch/xtensa/configs/smp_lx200_defconfig     |    1 -
 arch/xtensa/configs/virt_defconfig          |    1 -
 init/Kconfig                                |   17 -
 kernel/sysctl_binary.c                      | 1305 ---------------------------
 34 files changed, 1354 deletions(-)
