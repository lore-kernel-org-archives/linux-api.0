From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/8] y2038: remove time32 ABI on rv32 and csky
Date: Mon, 18 Feb 2019 22:07:04 +0100
Message-ID: <20190218210712.3503891-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-riscv-bounces+glpr-linux-riscv=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-riscv>,
 <mailto:linux-riscv-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-riscv/>
List-Post: <mailto:linux-riscv@lists.infradead.org>
List-Help: <mailto:linux-riscv-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-riscv>,
 <mailto:linux-riscv-request@lists.infradead.org?subject=subscribe>
Sender: "linux-riscv" <linux-riscv-bounces@lists.infradead.org>
Errors-To: linux-riscv-bounces+glpr-linux-riscv=m.gmane.org@lists.infradead.org
To: y2038@lists.linaro.org
Cc: linux-arch@vger.kernel.org, uclinux-h8-devel@lists.sourceforge.jp, arnd@arndb.de, yury.norov@gmail.com, linux-api@vger.kernel.org, Palmer Dabbelt <palmer@sifive.com>, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, Vineet Gupta <vgupta@synopsys.com>, Guo Ren <guoren@kernel.org>, Greentime Hu <green.hu@gmail.com>, linux-hexagon@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Guan Xuetao <gxt@pku.edu.cn>, Stafford Horne <shorne@gmail.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

This is a follow-up to the y2038 syscall patches that Thomas already
merged. Both the csky and riscv maintainers have requested that the
time_t syscall ABI should be completely converted before an official
glibc port is merged.

The series achieves this in a few steps:

- A couple of bug fixes for minor regressions I introduced
  in the original series

- A couple of older patches from Yury Norov that I had never
  merged in the past, these fix up the openat/open_by_handle_at
  and getrlimit/setrlimit syscalls to disallow the old versions
  of off_t and rlimit.

- Hiding the deprecated system calls behind an #ifdef in
  include/uapi/asm-generic/unistd.h

- Changing the two architectures to use the new style
  syscall ABI for all three types: loff_t, rusage, and
  time_t.

Arnd Bergmann (5):
  asm-generic: Make time32 syscall numbers optional
  unicore32: Fix __ARCH_WANT_STAT64 definition
  checksyscalls: fix up mq_timedreceive and stat exceptions
  csky: Use latest system call ABI
  riscv: Use latest system call ABI

Yury Norov (3):
  compat ABI: use non-compat openat and open_by_handle_at variants
  32-bit userspace ABI: introduce ARCH_32BIT_OFF_T config option
  asm-generic: Drop getrlimit and setrlimit syscalls from default list

 arch/Kconfig                             | 15 ++++++++
 arch/arc/Kconfig                         |  1 +
 arch/arc/include/uapi/asm/unistd.h       |  2 ++
 arch/arm/Kconfig                         |  1 +
 arch/arm64/include/uapi/asm/unistd.h     |  2 ++
 arch/c6x/Kconfig                         |  1 +
 arch/c6x/include/uapi/asm/unistd.h       |  2 ++
 arch/h8300/Kconfig                       |  1 +
 arch/h8300/include/uapi/asm/unistd.h     |  2 ++
 arch/hexagon/Kconfig                     |  1 +
 arch/hexagon/include/uapi/asm/unistd.h   |  2 ++
 arch/m68k/Kconfig                        |  1 +
 arch/microblaze/Kconfig                  |  1 +
 arch/mips/Kconfig                        |  1 +
 arch/nds32/Kconfig                       |  1 +
 arch/nds32/include/uapi/asm/unistd.h     |  2 ++
 arch/nios2/Kconfig                       |  1 +
 arch/nios2/include/uapi/asm/unistd.h     |  2 ++
 arch/openrisc/Kconfig                    |  1 +
 arch/openrisc/include/uapi/asm/unistd.h  |  2 ++
 arch/parisc/Kconfig                      |  1 +
 arch/powerpc/Kconfig                     |  1 +
 arch/riscv/include/uapi/asm/unistd.h     |  1 +
 arch/riscv/kernel/vdso/Makefile          |  2 ++
 arch/sh/Kconfig                          |  1 +
 arch/sparc/Kconfig                       |  1 +
 arch/unicore32/Kconfig                   |  1 +
 arch/unicore32/include/uapi/asm/unistd.h |  4 ++-
 arch/x86/Kconfig                         |  1 +
 arch/x86/um/Kconfig                      |  1 +
 arch/xtensa/Kconfig                      |  1 +
 include/linux/fcntl.h                    |  2 +-
 include/uapi/asm-generic/unistd.h        | 46 ++++++++++++++++++++++--
 scripts/checksyscalls.sh                 | 15 ++++++--
 34 files changed, 112 insertions(+), 8 deletions(-)

-- 
2.20.0
