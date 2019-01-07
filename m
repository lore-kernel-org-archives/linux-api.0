From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: [PATCH v7 00/22] ptrace: add PTRACE_GET_SYSCALL_INFO request
Date: Mon, 7 Jan 2019 05:51:01 +0300
Message-ID: <20190107025101.GA1182@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-riscv-bounces+glpr-linux-riscv=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-riscv>,
 <mailto:linux-riscv-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-riscv/>
List-Post: <mailto:linux-riscv@lists.infradead.org>
List-Help: <mailto:linux-riscv-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-riscv>,
 <mailto:linux-riscv-request@lists.infradead.org?subject=subscribe>
Sender: "linux-riscv" <linux-riscv-bounces@lists.infradead.org>
Errors-To: linux-riscv-bounces+glpr-linux-riscv=m.gmane.org@lists.infradead.org
To: Andy Lutomirski <luto@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-s390@vger.kernel.org, Rich Felker <dalias@libc.org>, linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alexey Brodkin <alexey.brodkin@synopsys.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-api@vger.kernel.org, "James E.J. Bottomley" <jejb@parisc-linux.org>, Max Filippov <jcmvbkbc@gmail.com>, Guo Ren <guoren@kernel.org>, Ralf Baechle <ralf@linux-mips.org>, linux-kselftest@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Breno Leitao <leitao@debian.org>, Russell King <linux@armlinux.org.uk>, linux-riscv@lists.infradead.org, Vincent Chen <deanbo422@gmail.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>, Jonas Bonn <jonas@southpole.se>, Elvira Khabirova <lineprinter@altlinux.org>, sparclinux@vger.kernel.org, linux-arch@vger.kernel.orgPaul
List-Id: linux-api@vger.kernel.org

PTRACE_GET_SYSCALL_INFO is a generic ptrace API that lets ptracer obtain
details of the syscall the tracee is blocked in.

There are two reasons for a special syscall-related ptrace request.

Firstly, with the current ptrace API there are cases when ptracer cannot
retrieve necessary information about syscalls.  Some examples include:
* The notorious int-0x80-from-64-bit-task issue.  See [1] for details.
In short, if a 64-bit task performs a syscall through int 0x80, its tracer
has no reliable means to find out that the syscall was, in fact,
a compat syscall, and misidentifies it.
* Syscall-enter-stop and syscall-exit-stop look the same for the tracer.
Common practice is to keep track of the sequence of ptrace-stops in order
not to mix the two syscall-stops up.  But it is not as simple as it looks;
for example, strace had a (just recently fixed) long-standing bug where
attaching strace to a tracee that is performing the execve system call
led to the tracer identifying the following syscall-exit-stop as
syscall-enter-stop, which messed up all the state tracking.
* Since the introduction of commit 84d77d3f06e7e8dea057d10e8ec77ad71f721be3
("ptrace: Don't allow accessing an undumpable mm"), both PTRACE_PEEKDATA
and process_vm_readv become unavailable when the process dumpable flag
is cleared.  On such architectures as ia64 this results in all syscall
arguments being unavailable for the tracer.

Secondly, ptracers also have to support a lot of arch-specific code for
obtaining information about the tracee.  For some architectures, this
requires a ptrace(PTRACE_PEEKUSER, ...) invocation for every syscall
argument and return value.

PTRACE_GET_SYSCALL_INFO returns the following structure:

struct ptrace_syscall_info {
	__u8 op;	/* PTRACE_SYSCALL_INFO_* */
	__u32 arch __attribute__((__aligned__(sizeof(__u32))));
	__u64 instruction_pointer;
	__u64 stack_pointer;
	union {
		struct {
			__u64 nr;
			__u64 args[6];
		} entry;
		struct {
			__s64 rval;
			__u8 is_error;
		} exit;
		struct {
			__u64 nr;
			__u64 args[6];
			__u32 ret_data;
		} seccomp;
	};
};

The structure was chosen according to [2], except for the following
changes:
* seccomp substructure was added as a superset of entry substructure;
* the type of nr field was changed from int to __u64 because syscall
numbers are, as a practical matter, 64 bits;
* stack_pointer field was added along with instruction_pointer field
since it is readily available and can save the tracer from extra
PTRACE_GETREGS/PTRACE_GETREGSET calls;
* arch is always initialized to aid with tracing system calls
* such as execve();
* instruction_pointer and stack_pointer are always initialized
so they could be easily obtained for non-syscall stops;
* a boolean is_error field was added along with rval field, this way
the tracer can more reliably distinguish a return value
from an error value.

strace has been ported to PTRACE_GET_SYSCALL_INFO.
Starting with release 4.26, strace uses PTRACE_GET_SYSCALL_INFO API
as the preferred mechanism of obtaining syscall information.

[1] https://lore.kernel.org/lkml/CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com/
[2] https://lore.kernel.org/lkml/CAObL_7GM0n80N7J_DFw_eQyfLyzq+sf4y2AvsCCV88Tb3AwEHA@mail.gmail.com/

---

Notes:
    v7:
    * Rebased to v5.0-rc1.
    * 5 arch-specific preparatory patches out of 25 have been merged
      into v5.0-rc1 via arch trees.

    v6:
    * Add syscall_get_arguments and syscall_set_arguments wrappers
      to asm-generic/syscall.h, requested by Geert.
    * Change PTRACE_GET_SYSCALL_INFO return code: do not take trailing paddings
      into account, use the end of the last field of the structure being written.
    * Change struct ptrace_syscall_info:
      * remove .frame_pointer field, is is not needed and not portable;
      * make .arch field explicitly aligned, remove no longer needed
        padding before .arch field;
      * remove trailing pads, they are no longer needed.

    v5:
    * Merge separate series and patches into the single series.
    * Change PTRACE_EVENTMSG_SYSCALL_{ENTRY,EXIT} values as requested by Oleg.
    * Change struct ptrace_syscall_info: generalize instruction_pointer,
      stack_pointer, and frame_pointer fields by moving them from
      ptrace_syscall_info.{entry,seccomp} substructures to ptrace_syscall_info
      and initializing them for all stops.
    * Add PTRACE_SYSCALL_INFO_NONE, set it when not in a syscall stop,
      so e.g. "strace -i" could use PTRACE_SYSCALL_INFO_SECCOMP to obtain
      instruction_pointer when the tracee is in a signal stop.
    * Patch all remaining architectures to provide all necessary
      syscall_get_* functions.
    * Make available for all architectures: do not conditionalize on
      CONFIG_HAVE_ARCH_TRACEHOOK since all syscall_get_* functions
      are implemented on all architectures.
    * Add a test for PTRACE_GET_SYSCALL_INFO to selftests/ptrace.
    
    v4:
    * Do not introduce task_struct.ptrace_event,
      use child->last_siginfo->si_code instead.
    * Implement PTRACE_SYSCALL_INFO_SECCOMP and ptrace_syscall_info.seccomp
      support along with PTRACE_SYSCALL_INFO_{ENTRY,EXIT} and
      ptrace_syscall_info.{entry,exit}.
    
    v3:
    * Change struct ptrace_syscall_info.
    * Support PTRACE_EVENT_SECCOMP by adding ptrace_event to task_struct.
    * Add proper defines for ptrace_syscall_info.op values.
    * Rename PT_SYSCALL_IS_ENTERING and PT_SYSCALL_IS_EXITING to
      PTRACE_EVENTMSG_SYSCALL_ENTRY and PTRACE_EVENTMSG_SYSCALL_EXIT
    * and move them to uapi.
    
    v2:
    * Do not use task->ptrace.
    * Replace entry_info.is_compat with entry_info.arch, use syscall_get_arch().
    * Use addr argument of sys_ptrace to get expected size of the struct;
      return full size of the struct.

Dmitry V. Levin (21):
  asm-generic/syscall.h: prepare for inclusion by other files
  asm-generic/syscall.h: turn syscall_[gs]et_arguments into wrappers
  alpha: define remaining syscall_get_* functions
  Move EM_ARCOMPACT and EM_ARCV2 to uapi/linux/elf-em.h
  arc: define syscall_get_arch()
  c6x: define syscall_get_arch()
  h8300: define remaining syscall_get_* functions
  Move EM_HEXAGON to uapi/linux/elf-em.h
  hexagon: define remaining syscall_get_* functions
  Move EM_NDS32 to uapi/linux/elf-em.h
  nds32: define syscall_get_arch()
  nios2: define syscall_get_arch()
  m68k: add asm/syscall.h
  mips: define syscall_get_error()
  parisc: define syscall_get_error()
  powerpc: define syscall_get_error()
  riscv: define syscall_get_arch()
  Move EM_UNICORE to uapi/linux/elf-em.h
  unicore32: add asm/syscall.h
  syscall_get_arch: add "struct task_struct *" argument
  selftests/ptrace: add a test case for PTRACE_GET_SYSCALL_INFO

Elvira Khabirova (1):
  ptrace: add PTRACE_GET_SYSCALL_INFO request

 arch/alpha/include/asm/syscall.h              |  31 +-
 arch/arc/include/asm/elf.h                    |   6 +-
 arch/arc/include/asm/syscall.h                |  11 +
 arch/arm/include/asm/syscall.h                |   2 +-
 arch/arm64/include/asm/syscall.h              |   4 +-
 arch/c6x/include/asm/syscall.h                |   7 +
 arch/csky/include/asm/syscall.h               |   2 +-
 arch/h8300/include/asm/syscall.h              |  19 ++
 arch/hexagon/include/asm/elf.h                |   6 +-
 arch/hexagon/include/asm/syscall.h            |  22 ++
 arch/ia64/include/asm/syscall.h               |   2 +-
 arch/m68k/include/asm/syscall.h               |  42 +++
 arch/microblaze/include/asm/syscall.h         |   2 +-
 arch/mips/include/asm/syscall.h               |  12 +-
 arch/mips/kernel/ptrace.c                     |   2 +-
 arch/nds32/include/asm/elf.h                  |   3 +-
 arch/nds32/include/asm/syscall.h              |   8 +
 arch/nios2/include/asm/syscall.h              |   6 +
 arch/openrisc/include/asm/syscall.h           |   2 +-
 arch/parisc/include/asm/syscall.h             |  11 +-
 arch/powerpc/include/asm/syscall.h            |  20 +-
 arch/riscv/include/asm/syscall.h              |  10 +
 arch/s390/include/asm/syscall.h               |   4 +-
 arch/sh/include/asm/syscall_32.h              |   2 +-
 arch/sh/include/asm/syscall_64.h              |   2 +-
 arch/sparc/include/asm/syscall.h              |   5 +-
 arch/unicore32/include/asm/elf.h              |   3 +-
 arch/unicore32/include/asm/syscall.h          |  47 +++
 arch/x86/include/asm/syscall.h                |   8 +-
 arch/x86/um/asm/syscall.h                     |   2 +-
 arch/xtensa/include/asm/syscall.h             |   2 +-
 include/asm-generic/syscall.h                 |  85 ++++--
 include/linux/tracehook.h                     |   9 +-
 include/uapi/linux/audit.h                    |  14 +
 include/uapi/linux/elf-em.h                   |   6 +
 include/uapi/linux/ptrace.h                   |  35 +++
 kernel/auditsc.c                              |   4 +-
 kernel/ptrace.c                               | 101 ++++++-
 kernel/seccomp.c                              |   4 +-
 tools/testing/selftests/ptrace/.gitignore     |   1 +
 tools/testing/selftests/ptrace/Makefile       |   2 +-
 .../selftests/ptrace/get_syscall_info.c       | 271 ++++++++++++++++++
 42 files changed, 771 insertions(+), 66 deletions(-)
 create mode 100644 arch/m68k/include/asm/syscall.h
 create mode 100644 arch/unicore32/include/asm/syscall.h
 create mode 100644 tools/testing/selftests/ptrace/get_syscall_info.c

-- 
ldv
