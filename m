From: Elvira Khabirova <lineprinter-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: [PATCH RESEND v3 0/3] ptrace: add PTRACE_GET_SYSCALL_INFO request
Date: Sun, 25 Nov 2018 02:21:50 +0100
Message-ID: <20181125022150.46258a20@akathisia>
Reply-To: strace development discussions <strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
List-Unsubscribe: <https://lists.strace.io/mailman/options/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.strace.io/pipermail/strace-devel/>
List-Post: <mailto:strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
List-Help: <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.strace.io/mailman/listinfo/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
Sender: "Strace-devel" <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
To: oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org, strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
List-Id: linux-api@vger.kernel.org

Resent with linux-api@ Cc'ed.

PTRACE_GET_SYSCALL_INFO lets ptracer obtain details of the syscall
the tracee is blocked in.  The request succeeds when the tracee is in a
syscall-enter-stop, syscall-exit-stop or PTRACE_EVENT_SECCOMP stop,
and fails with -EINVAL otherwise.

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
arguments being unavailable.

Secondly, ptracers also have to support a lot of arch-specific code for
obtaining information about the tracee.  For some architectures, this
requires a ptrace(PTRACE_PEEKUSER, ...) invocation for every syscall
argument and return value.

PTRACE_GET_SYSCALL_INFO returns the following structure:

struct ptrace_syscall_info {
	__u8 op;	/* PTRACE_SYSCALL_INFO_* */
	__u8 __pad0[3];
	__u32 arch;
	union {
		struct {
			__u64 nr;
			__u64 instruction_pointer;
			__u64 stack_pointer;
			__u64 frame_pointer;
			__u64 args[6];
		} entry;
		struct {
			__s64 rval;
			__u8 is_error;
			__u8 __pad1[7];
		} exit;
	};
};

The structure was chosen according to [2], except for the following
changes:
* arch is returned unconditionally to aid with tracing system calls such as
execve();
* the type of nr field was changed from int to __u64 because syscall
numbers are, as a practical matter, 64 bits;
* stack_pointer and frame_pointer fields were added along with
instruction_pointer field since they are readily available and can save
the tracer from extra PTRACE_GETREGSET calls;
* a boolean is_error field was added along with rval field, this way
the tracer can more reliably distinguish a return value
from an error value.

This changeset should be applied on top of [3] and [4].

[1] https://lore.kernel.org/lkml/CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/
[2] https://lore.kernel.org/lkml/CAObL_7GM0n80N7J_DFw_eQyfLyzq+sf4y2AvsCCV88Tb3AwEHA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/
[3] https://lore.kernel.org/lkml/20181119210139.GA8360-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org/
[4] https://lore.kernel.org/lkml/20181120001128.GA11300-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org/

v3: Split into three changes.
    Change struct ptrace_syscall_info.
    Support PTRACE_EVENT_SECCOMP by adding ptrace_event to task_struct.
    Add proper defines for ptrace_syscall_info.op values.
    Rename PT_SYSCALL_IS_ENTERING and PT_SYSCALL_IS_EXITING to
    PTRACE_EVENTMSG_SYSCALL_ENTRY and PTRACE_EVENTMSG_SYSCALL_EXIT and move
    them to uapi.

Elvira Khabirova (3):
  ptrace: pass type of a syscall-stop in ptrace_message
  ptrace: add PTRACE_GET_SYSCALL_INFO request
  ptrace: add PTRACE_EVENT_SECCOMP support to PTRACE_GET_SYSCALL_INFO

 include/linux/ptrace.h      |  1 +
 include/linux/sched.h       |  1 +
 include/linux/tracehook.h   | 10 ++++---
 include/uapi/linux/ptrace.h | 34 ++++++++++++++++++++++++
 kernel/ptrace.c             | 53 +++++++++++++++++++++++++++++++++++++
 5 files changed, 96 insertions(+), 3 deletions(-)

-- 
2.19.1

-- 
Strace-devel mailing list
Strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
https://lists.strace.io/mailman/listinfo/strace-devel
