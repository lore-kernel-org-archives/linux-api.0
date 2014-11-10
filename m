From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: Edited seccomp.2 man page for review
Date: Mon, 10 Nov 2014 13:13:12 -0800
Message-ID: <CAGXu5jJ4MMZ66JzWqenaz4h5nYLnE8o_H0D5sr+M=j1YYnf0AQ@mail.gmail.com>
References: <545E0B06.6030706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <545E0B06.6030706-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Nov 8, 2014 at 4:22 AM, Michael Kerrisk (man-pages)
<mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Kees, (and all),
>
> Thanks for the seccomp.2 draft man page that you provided a few
> weeks ago (https://lkml.org/lkml/2014/9/25/685), and my apologies
> for the slow follow-up.
>
> I have done some substantial editing of the page. Therefore, could
> you please carefully read the revised version below, in case I have
> somewhere injected errors.

Woo! Thanks for all your work on it!

> In addition, I've added a number of FIXMEs to the page source. Could
> you please review these.

Sure, I'll try to avoid being redundant with Andy. :)

> I've also added long piece to the example section, describing the
> program and demonstrating its use. Again, I'd appreciate it if you
> could check that over.
>
> One other question about these man-pages changes: should we add
> a note in prctl(2) to say that seccomp(2) is preferred over
> PR_SET_SECCOMP for new code?

Given how new it is, I was shy to suggest it. Anything needed the new
features (TSYNC) obviously must use it, but it'll be a while before
this syscall is in distros. I think it should be used over prctl, but
there's no strong reason to change existing code.

> I've appended the revised page at the foot of this mail. You can also
> find the branch holding this page (and thus, the series of changes
> I've made in Git at:
> http://git.kernel.org/cgit/docs/man-pages/man-pages.git/log/?h=draft_seccomp
>
> Feedback either as inline comments to the below, or as a patch based on
> the Git branch, would be great!
>
> Cheers,
>
> Michael
>
> .\" Copyright (C) 2014 Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> .\" and Copyright (C) 2012 Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> .\" and Copyright (C) 2008, 2014 Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> .\"
> .\" %%%LICENSE_START(VERBATIM)
> .\" Permission is granted to make and distribute verbatim copies of this
> .\" manual provided the copyright notice and this permission notice are
> .\" preserved on all copies.
> .\"
> .\" Permission is granted to copy and distribute modified versions of this
> .\" manual under the conditions for verbatim copying, provided that the
> .\" entire resulting derived work is distributed under the terms of a
> .\" permission notice identical to this one.
> .\"
> .\" Since the Linux kernel and libraries are constantly changing, this
> .\" manual page may be incorrect or out-of-date.  The author(s) assume no
> .\" responsibility for errors or omissions, or for damages resulting from
> .\" the use of the information contained herein.  The author(s) may not
> .\" have taken the same level of care in the production of this manual,
> .\" which is licensed free of charge, as they might when working
> .\" professionally.
> .\"
> .\" Formatted or processed versions of this manual, if unaccompanied by
> .\" the source, must acknowledge the copyright and authors of this work.
> .\" %%%LICENSE_END
> .\"
> .TH SECCOMP 2 2014-06-23 "Linux" "Linux Programmer's Manual"
> .SH NAME
> seccomp \- operate on Secure Computing state of the process
> .SH SYNOPSIS
> .nf
> .B #include <linux/seccomp.h>
> .B #include <linux/filter.h>
> .B #include <linux/audit.h>
> .B #include <linux/signal.h>
> .\" FIXME Is sys/ptrace.h really required? It is not used in
> .\"       the example program below.
> .B #include <sys/ptrace.h>

It's not required for this example, but anything uses the
SECCOMP_RET_TRACE returns, it'll want it. And given the mention of
things like PTRACE_O_TRACESECCOMP, it seemed like we should include
the #include. I'll leave it to your discretion on what's appropriate
for a man-page header, though. :)

>
> .BI "int seccomp(unsigned int " operation ", unsigned int " flags \
> ", void *" args );
> .fi
> .SH DESCRIPTION
> The
> .BR seccomp ()
> system call operates on the Secure Computing (seccomp) state of the
> calling process.
> .\" FIXME: This page various uses the terms "process', "thread" and "task".
> .\" Probably only one of these (not "task"!) should be used in all
> .\" cases. I suspect it should be "thread".

Yeah, "task" should be avoided, my mistake! I will try to correct them
below. The above general case is correct, since TSYNC can change the
state on all threads of the process.

> Currently, Linux supports the following
> .IR operation
> values:
> .TP
> .BR SECCOMP_SET_MODE_STRICT
> The only system calls that the thread is permitted to make are

Should this be clarified to "the calling thread", or is that implied?

> .BR read (2),
> .BR write (2),
> .BR _exit (2),
> and
> .BR sigreturn (2).
> Other system calls result in the delivery of a
> .BR SIGKILL
> signal

"signal" needs a period ending the sentence above.

> Strict secure computing mode is useful for number-crunching
> applications that may need to execute untrusted byte code, perhaps
> obtained by reading from a pipe or socket.
>
> This operation is available only if the kernel is configured with
> .BR CONFIG_SECCOMP
> enabled.
>
> The value of
> .IR flags
> must be 0, and
> .IR args
> must be NULL.
>
> This operation is functionally identical to the call:
>
>     prctl(PR_SET_SECCOMP, SECCOMP_MODE_STRICT);
> .TP
> .BR SECCOMP_SET_MODE_FILTER
> The system calls allowed are defined by a pointer to a Berkeley Packet
> Filter (BPF) passed via
> .IR args .
> This arguMent is a pointer to a

s/M/m/

> .IR "struct\ sock_fprog" ;
> it can be designed to filter arbitrary system calls and system call
> arguments.
> If the filter is invalid,
> .BR seccomp ()
> fails, returning
> .BR EACCESS

EINVAL (EACCESS would be for lacking CAP_SYS_ADMIN or no-new-privs).

> in
> .IR errno .
>
> .\" FIXME I (mtk) reworded the following paragraph substantially.
> .\" Please check it.
> If
> .BR fork (2)
> or
> .BR clone (2)
> is allowed by the filter, any child processes will be constrained to
> the same filters and system calls as the parent.

To me, "and system calls" implies something other than filters. Maybe:
"the same system call filters as the parent"?

> If
> .BR execve (2)
> is allowed by the filter,
> the filters and constraints on permitted system calls are preserved across an
> .BR execve (2).

Perhaps "Similarly, if execve is allowed, the existing filters will be
preserved across the call to execve." The filter _is_ the "constraints
on permitted system calls", but since it can do more than constrain,
I'm shy to imply a limit to the scope of this description.

> .\" FIXME I (mtk) reworded the following paragraph substantially.
> .\" Please check it.
> In order to use the
> .BR SECCOMP_SET_MODE_FILTER
> operation, either the caller must have the
> .BR CAP_SYS_ADMIN
> capability or the call must be preceded by the call:
>
>     prctl(PR_SET_NO_NEW_PRIVS, 1);

Strictly speaking, if any ancestor ever called PR_SET_NO_NEW_PRIVS,
the process already has it set. Perhaps "... capability, or the thread
must already have thew "no new privs" prctl bit set. If not already
set by an ancestory, the thread must call: ..."

>
> Otherwise, the
> .BR SECCOMP_SET_MODE_FILTER
> operation will fail and return
> .BR EACCES
> in
> .IR errno .
> This requirement ensures that filter programs cannot be applied to child
> .\" FIXME What does "installed" in the following line mean?
> processes with greater privileges than the process that installed them.

Andy mentioned the "why", but "installed" here means "called seccomp()
to add filters", e.g. add (install) a filter to have
"setuid(non-root)" return 0 instead of actually getting called, and
then exec a setuid process that tries to drop privileges, which
doesn't happen, and now the original caller (non-root) has a setuid
process running as root that it may be able to influence into doing
dangerous things because it didn't _actually_ drop privileges.

>
> If
> .BR prctl (2)
> or
> .BR seccomp (2)
> is allowed by the attached filter, further filters may be added.
> This will increase evaluation time, but allows for further reduction of
> the attack surface during execution of a process.

Strictly speaking, "process" -> "thread"

>
> The
> .BR SECCOMP_SET_MODE_FILTER
> operation is available only if the kernel is configured with
> .BR CONFIG_SECCOMP_FILTER
> enabled.
>
> When
> .IR flags
> is 0, this operation is functionally identical to the call:
>
>     prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, args);
>
> The recognized
> .IR flags
> are:
> .RS
> .TP
> .BR SECCOMP_FILTER_FLAG_TSYNC
> When adding a new filter, synchronize all other threads of the calling
> process to the same seccomp filter tree.
> .\" FIXME Nowhere in this page is the term "filter tree" defined.
> .\" There should be a definition somewhere.
> .\" Is it: "the set of filters attached to a thread"?

As Andy said, the list of filters attached to the process. A process
may have multiple threads adding filters, which would cause those
threads to have separate branches of seccomp filters (though they
would share a common root from when the process started). It is only
possible to use TSYNC if threads haven't diverged in this way.

> If any thread cannot do this,
> the call will not attach the new seccomp filter,
> and will fail, returning the first thread ID found that cannot synchronize.
> Synchronization will fail if another thread is in
> .BR SECCOMP_MODE_STRICT
> or if it has attached new seccomp filters to itself,
> diverging from the calling thread's filter tree.
> .RE
> .SH FILTERS
> When adding filters via
> .BR SECCOMP_SET_MODE_FILTER ,
> .IR args
> points to a filter program:
>
> .in +4n
> .nf
> struct sock_fprog {
>     unsigned short      len;    /* Number of BPF instructions */
>     struct sock_filter *filter;
> };
> .fi
> .in
>
> Each program must contain one or more BPF instructions:
>
> .in +4n
> .nf
> struct sock_filter {    /* Filter block */
>     __u16   code;       /* Actual filter code */
>     __u8    jt;         /* Jump true */
>     __u8    jf;         /* Jump false */
>     __u32   k;          /* Generic multiuse field */
> };
> .fi
> .in
>
> When executing the instructions, the BPF program executes over the
> system call information made available via:
>
> .in +4n
> .nf
> struct seccomp_data {
>     int nr;                     /* system call number */
>     __u32 arch;                 /* AUDIT_ARCH_* value */
>     __u64 instruction_pointer;  /* CPU instruction pointer */
>     __u64 args[6];              /* up to 6 system call arguments */
> };
> .fi
> .in
>
> .\" FIXME I find the next piece a little hard to understand, so,
> .\"       some questions:
> .\"       * If there are multiple filters, in what order are they executed?
> .\"         (The man page should probably detail the answer to this question.)

They are executed in reverse order (most recently added is executed first).

> .\"       * If there are multiple filters, are they all always executed?
> .\"         I assume not, but the notion that
> .\"             "the return value for the evaluation of a given system call
> .\"              will always use the value with the highest precedence"
> .\"         implies that even that if one filter generates (say)
> .\"         SECCOMP_RET_ERRNO, then further filters may still be executed,
> .\"         including one that generates (say) the "higher priority"
> .\"         SECCOMP_RET_KILL condition.
> .\"       Can you clarify the above?

Correct. All filters are executed. The returned value is the one with
the first seen highest priority (lowest numerical value) action of
those returned by each filter. For example, if a filter was installed
that returned SECCOMP_RET_ERRNO|1, and then another filter installed
SECCOMP_RET_ERRNO|22, and then another filter installed
SECCOMP_RET_ALLOW, SECCOMP_RET_ERRNO|22 would be returned.
SECCOMP_RET_ERRNO is higher priority than SECCOMP_RET_ALLOW, but since
the SECCOMP_RET_ERRNO|22 was seen first, it's data (22) will be used,
even though the last filter returned a lower data (1), as only action
values are compared.

> A seccomp filter returns one of the values listed below.

Based on discussion further below, perhaps "value" should be called
"action" here? Maybe:

A seccomp filter returns a value. The high 16 bits
(SECCOMP_RET_ACTION) is the seccomp filter "action" to take. The low
16 bits (SECCOMP_RET_DATA) is data specific to the action.

> If multiple filters exist,
> the return value for the evaluation of a given system call
> will always use the value with the highest precedence.
> (For example,
> .BR SECCOMP_RET_KILL
> will always take precedence.)
>
> In decreasing order order of precedence,
> the values that may be returned by a seccomp filter are:
> .TP
> .BR SECCOMP_RET_KILL
> Results in the task exiting immediately without executing the system call.
> The task terminates as though killed by a

Both "task" -> "process" above.

> .B SIGSYS
> signal
> .RI ( not
> .BR SIGKILL ).
> .TP
> .BR SECCOMP_RET_TRAP
> Results in the kernel sending a
> .BR SIGSYS
> signal to the triggering task without executing the system call.

"task" -> "process"

> .IR siginfo\->si_call_addr
> will show the address of the system call instruction, and
> .IR siginfo\->si_syscall
> and
> .IR siginfo\->si_arch
> will indicate which system call was attempted.
> The program counter will be as though the system call happened
> (i.e., it will not point to the system call instruction).
> The return value register will contain an architecture\-dependent value;
> if resuming execution, set it to something sensible.
> (The architecture dependency is because replacing it with
> .BR ENOSYS
> could overwrite some useful information.)
>
> .\" FIXME The following sentence is the first time that SECCOMP_RET_DATA
> .\"       is mentioned. SECCOMP_RET_DATA needs to be described in this
> .\"       man page.

How should these be detailed? (I took a stab at it further above.)
#define SECCOMP_RET_ACTION      0x7fff0000U
#define SECCOMP_RET_DATA        0x0000ffffU

> The
> .BR SECCOMP_RET_DATA
> portion of the return value will be passed as
> .IR si_errno .
>
> .BR SIGSYS
> triggered by seccomp will have the value
> .BR SYS_SECCOMP
> in the
> .IR si_code
> field.
> .TP
> .BR SECCOMP_RET_ERRNO
> .\" FIXME What does "the return value" refer to in the next sentence?
> .\"       It is not obvious to me.

As Andy said, the 32 bit value returned by the BPF filter.

> Results in the lower 16-bits of the return value being passed
> to user space as the
> .IR errno
> without executing the system call.
> .TP
> .BR SECCOMP_RET_TRACE
> When returned, this value will cause the kernel to attempt to notify a
> .BR ptrace (2)-based
> tracer prior to executing the system call.
> .\" FIXME I (mtk) reworded the following sentence substantially.
> .\" Please check it.

Yes, correct.

> If there is no tracer present,
> the system call is not executed and returns a failure status with
> .I errno
> set to
> .BR ENOSYS .
>
> A tracer will be notified if it requests
> .BR PTRACE_O_TRACESECCOMP
> using
> .IR ptrace(PTRACE_SETOPTIONS) .
> The tracer will be notified of a
> .BR PTRACE_EVENT_SECCOMP
> and the
> .BR SECCOMP_RET_DATA
> portion of the BPF program return value will be available to the tracer
> via
> .BR PTRACE_GETEVENTMSG .
>
> The tracer can skip the system call by changing the system call number
> to \-1.
> Alternatively, the tracer can change the system call
> requested by changing the system call to a valid system call number.
> If the tracer asks to skip the system call, then the system call will
> appear to return the value that the tracer puts in the return value register.
>
> The seccomp check will not be run again after the tracer is notified.
> (This means that seccomp-based sandboxes
> .B "must not"
> allow use of
> .BR ptrace (2)\(emeven
> of other
> sandboxed processes\(emwithout extreme care;
> ptracers can use this mechanism to escape.)
> .TP
> .BR SECCOMP_RET_ALLOW
> Results in the system call being executed.
> .PP
> If multiple filters exist, the return value for the evaluation of a
> given system call will always use the highest precedent value.
>
> .\" FIXME The following sentence is the first time that SECCOMP_RET_ACTION
> .\"       is mentioned. SECCOMP_RET_ACTION needs to be described in this
> .\"       man page.

Attempted earlier...

> Precedence is determined using only the
> .BR SECCOMP_RET_ACTION
> mask.
> When multiple filters return values of the same precedence,
> only the
> .BR SECCOMP_RET_DATA
> from the most recently installed filter will be returned.

The above tries to document what was mentioned about the order of
return value parsing I discussed further above.

> .SH RETURN VALUE
> On success,
> .BR seccomp ()
> returns 0.
> On error, if
> .BR SECCOMP_FILTER_FLAG_TSYNC
> was used,
> the return value is the thread ID that caused the synchronization failure.
> On other errors, \-1 is returned, and
> .IR errno
> is set to indicate the cause of the error.
> .SH ERRORS
> .BR seccomp ()
> can fail for the following reasons:
> .TP
> .BR EACCESS
> The caller did not have the
> .BR CAP_SYS_ADMIN
> capability, or had not set
> .IR no_new_privs
> before using
> .BR SECCOMP_SET_MODE_FILTER .
> .TP
> .BR EFAULT
> .IR args
> was required to be a valid address.
> .TP
> .BR EINVAL
> .IR operation
> is unknown; or
> .IR flags
> are invalid for the given
> .IR operation
> .TP
> .BR ESRCH
> Another thread caused a failure during thread sync, but its ID could not
> be determined.
> .SH VERSIONS
> The
> .BR seccomp()
> system call first appeared in Linux 3.17.
> .\" FIXME Add glibc version
> .SH CONFORMING TO
> The
> .BR seccomp()
> system call is a nonstandard Linux extension.
> .SH NOTES
> .BR seccomp ()
> provides a superset of the functionality provided by the
> .BR prctl (2)
> .BR PR_SET_SECCOMP
> operation (which does not support
> .IR flags ).
> .SH EXAMPLE
> .\" FIXME Please carefully review the following new piece that
> .\"       demonstrates the use of your example program.

This is great! Thanks for expanding this.

> The program below accepts four or more arguments.
> The first three arguments are a system call number,
> a numeric architecture identifier, and an error number.
> The program uses these values to construct a BPF filter
> that is used at run time to perform the following checks:
> .IP [1] 4
> If the program is not running on the specified architecture,
> the BPF filter causes system calls to fail with the error
> .BR ENOSYS .
> .IP [2]
> If the program attempts to execute the system call with the specified number,
> the BPF filter causes the system call to fail, with
> .I errno
> being set to the specified error number.
> .PP
> The remaining command-line arguments specify
> the pathname and additional arguments of a program
> that the example program should attempt to execute using
> .BR execve (3)
> (a library function that employs the
> .BR execve (2)
> system call).
> Some example runs of the program are shown below.
>
> First, we display the architecture that we are running on (x86-64)
> and then construct a shell function that looks up system call
> numbers on this architecture:
>
> .nf
> .in +4n
> $ \fBuname -m\fP
> x86_64
> $ \fBsyscall_nr() {
>     cat /usr/src/linux/arch/x86/syscalls/syscall_64.tbl | \\
>     awk '$2 != "x32" && $3 == "'$1'" { print $1 }'
> }\fP
> .in
> .fi
>
> When the BPF filter rejects a system call (case [2] above),
> it causes the system call to fail with the error number
> specified on the command line.
> In the experiments shown here, we'll use error number 99:
>
> .nf
> .in +4n
> $ \fBerrno 99\fP
> EADDRNOTAVAIL 99 Cannot assign requested address
> .in
> .fi
>
> In the following example, we attempt to run the command
> .BR whoami (1),
> but the BPF filter rejects the
> .BR execve (2)
> system call, so that the command is not even executed:
>
> .nf
> .in +4n
> $ \fBsyscall_nr execve\fP
> 59
> $ \fB./a.out 59 0xC000003E 99 /bin/whoami\fP

It it worth showing where you got the 0xC000003E value from? (i.e.
from just running ./a.out and looking at its hints)

> execv: Cannot assign requested address
> .in
> .fi
>
> In the next example, the BPF filter rejects the
> .BR write (2)
> system call, so that, although it is successfully started, the
> .BR whoami (1)
> command is not able to write output:
>
> .nf
> .in +4n
> $ \fBsyscall_nr write\fP
> 1
> $ \fB./a.out 1 0xC000003E 99 /bin/whoami\fP
> .in
> .fi
>
> In the final example,
> the BPF filter rejects a system call that is not used by the
> .BR whoami (1)
> command, so it is able to successfully execute and produce output:
>
> .nf
> .in +4n
> $ \fBsyscall_nr preadv\fP
> 295
> $ \fB./a.out 295 0xC000003E 99 /bin/whoami\fP
> cecilia
> .in
> .fi
> .SS Program source
> .fi
> .nf
> #include <errno.h>
> #include <stddef.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <linux/audit.h>
> #include <linux/filter.h>
> #include <linux/seccomp.h>
> #include <sys/prctl.h>
>
> static int
> install_filter(int syscall, int arch, int error)
> {
>     struct sock_filter filter[] = {
>         /* [0] Load architecture */
>         BPF_STMT(BPF_LD + BPF_W + BPF_ABS,
>                  (offsetof(struct seccomp_data, arch))),
>
>         /* [1] Jump forward 4 instructions on architecture mismatch */
>         BPF_JUMP(BPF_JMP + BPF_JEQ + BPF_K, arch, 0, 4),
>
>         /* [2] Load system call number */
>         BPF_STMT(BPF_LD + BPF_W + BPF_ABS,
>                  (offsetof(struct seccomp_data, nr))),
>
>         /* [3] Jump forward 1 instruction on system call number
>                mismatch */
>         BPF_JUMP(BPF_JMP + BPF_JEQ + BPF_K, syscall, 0, 1),
>
>         /* [4] Matching architecture and system call: return
>                specific errno */
>         BPF_STMT(BPF_RET + BPF_K,
>                  SECCOMP_RET_ERRNO | (error & SECCOMP_RET_DATA)),
>
>         /* [5] Destination of system call number mismatch: allow other
>                system calls */
>         BPF_STMT(BPF_RET + BPF_K, SECCOMP_RET_ALLOW),
>
>         /* [6] Destination of architecture mismatch: kill process */
>         BPF_STMT(BPF_RET + BPF_K, SECCOMP_RET_KILL),
>     };
>
>     struct sock_fprog prog = {
>         .len = (unsigned short) (sizeof(filter) / sizeof(filter[0])),
>         .filter = filter,
>     };
>
>     if (seccomp(SECCOMP_SET_MODE_FILTER, 0, &prog)) {
>         perror("seccomp");
>         return 1;
>     }
>
>     return 0;
> }
>
> int
> main(int argc, char **argv)
> {
>     if (argc < 5) {
>         fprintf(stderr, "Usage:\\n"
>                 "refuse <syscall_nr> <arch> <errno> <prog> [<args>]\\n"
>                 "Hint:  AUDIT_ARCH_I386: 0x%X\\n"
>                 "       AUDIT_ARCH_X86_64: 0x%X\\n"
>                 "\\n", AUDIT_ARCH_I386, AUDIT_ARCH_X86_64);
>         exit(EXIT_FAILURE);
>     }
>
>     if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
>         perror("prctl");
>         exit(EXIT_FAILURE);
>     }
>
>     if (install_filter(strtol(argv[1], NULL, 0),
>                        strtol(argv[2], NULL, 0),
>                        strtol(argv[3], NULL, 0)))
>         exit(EXIT_FAILURE);
>
>     execv(argv[4], &argv[4]);
>     perror("execv");
>     exit(EXIT_FAILURE);
> }
> .fi
> .SH SEE ALSO
> .BR prctl (2),
> .BR ptrace (2),
> .BR signal (7),
> .BR socket (7)
> .sp
> .\" FIXME: Is the following the best source of info on the BPF language?
> The kernel source file
> .IR Documentation/networking/filter.txt .

I don't know of anything better.

>
> --
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/

Thanks! This is looking really good. :)

-Kees

-- 
Kees Cook
Chrome OS Security
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
