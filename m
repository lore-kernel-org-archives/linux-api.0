From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Edited seccomp.2 man page for review
Date: Tue, 30 Dec 2014 13:08:49 +0100
Message-ID: <54A295D1.7060106@gmail.com>
References: <545E0B06.6030706@gmail.com> <CAGXu5jJ4MMZ66JzWqenaz4h5nYLnE8o_H0D5sr+M=j1YYnf0AQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jJ4MMZ66JzWqenaz4h5nYLnE8o_H0D5sr+M=j1YYnf0AQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Kees,

My apologies for the slow follow-up.

On 11/10/2014 10:13 PM, Kees Cook wrote:
> On Sat, Nov 8, 2014 at 4:22 AM, Michael Kerrisk (man-pages)
> <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hi Kees, (and all),
>>
>> Thanks for the seccomp.2 draft man page that you provided a few
>> weeks ago (https://lkml.org/lkml/2014/9/25/685), and my apologies
>> for the slow follow-up.
>>
>> I have done some substantial editing of the page. Therefore, could
>> you please carefully read the revised version below, in case I have
>> somewhere injected errors.
>=20
> Woo! Thanks for all your work on it!
>=20
>> In addition, I've added a number of FIXMEs to the page source. Could
>> you please review these.
>=20
> Sure, I'll try to avoid being redundant with Andy. :)
>=20
>> I've also added long piece to the example section, describing the
>> program and demonstrating its use. Again, I'd appreciate it if you
>> could check that over.
>>
>> One other question about these man-pages changes: should we add
>> a note in prctl(2) to say that seccomp(2) is preferred over
>> PR_SET_SECCOMP for new code?
>=20
> Given how new it is, I was shy to suggest it. Anything needed the new
> features (TSYNC) obviously must use it, but it'll be a while before
> this syscall is in distros. I think it should be used over prctl, but
> there's no strong reason to change existing code.

I've settled for adding the following under the description of
PR_SET_SECCOMP in prctl(2)

     The more recent seccomp(2) system call provides a superset
     of the functionality of PR_SET_SECCOMP .

Okay?

>> I've appended the revised page at the foot of this mail. You can als=
o
>> find the branch holding this page (and thus, the series of changes
>> I've made in Git at:
>> http://git.kernel.org/cgit/docs/man-pages/man-pages.git/log/?h=3Ddra=
ft_seccomp
>>
>> Feedback either as inline comments to the below, or as a patch based=
 on
>> the Git branch, would be great!
>>
>> Cheers,
>>
>> Michael
>>
>> .\" Copyright (C) 2014 Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>> .\" and Copyright (C) 2012 Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>> .\" and Copyright (C) 2008, 2014 Michael Kerrisk <mtk.manpages@gmail=
=2Ecom>
>> .\"
>> .\" %%%LICENSE_START(VERBATIM)
>> .\" Permission is granted to make and distribute verbatim copies of =
this
>> .\" manual provided the copyright notice and this permission notice =
are
>> .\" preserved on all copies.
>> .\"
>> .\" Permission is granted to copy and distribute modified versions o=
f this
>> .\" manual under the conditions for verbatim copying, provided that =
the
>> .\" entire resulting derived work is distributed under the terms of =
a
>> .\" permission notice identical to this one.
>> .\"
>> .\" Since the Linux kernel and libraries are constantly changing, th=
is
>> .\" manual page may be incorrect or out-of-date.  The author(s) assu=
me no
>> .\" responsibility for errors or omissions, or for damages resulting=
 from
>> .\" the use of the information contained herein.  The author(s) may =
not
>> .\" have taken the same level of care in the production of this manu=
al,
>> .\" which is licensed free of charge, as they might when working
>> .\" professionally.
>> .\"
>> .\" Formatted or processed versions of this manual, if unaccompanied=
 by
>> .\" the source, must acknowledge the copyright and authors of this w=
ork.
>> .\" %%%LICENSE_END
>> .\"
>> .TH SECCOMP 2 2014-06-23 "Linux" "Linux Programmer's Manual"
>> .SH NAME
>> seccomp \- operate on Secure Computing state of the process
>> .SH SYNOPSIS
>> .nf
>> .B #include <linux/seccomp.h>
>> .B #include <linux/filter.h>
>> .B #include <linux/audit.h>
>> .B #include <linux/signal.h>
>> .\" FIXME Is sys/ptrace.h really required? It is not used in
>> .\"       the example program below.
>> .B #include <sys/ptrace.h>
>=20
> It's not required for this example, but anything uses the
> SECCOMP_RET_TRACE returns, it'll want it. And given the mention of
> things like PTRACE_O_TRACESECCOMP, it seemed like we should include
> the #include. I'll leave it to your discretion on what's appropriate
> for a man-page header, though. :)

Okay -- I'll keep it. (Thanks for providing the background detail.)

>> .BI "int seccomp(unsigned int " operation ", unsigned int " flags \
>> ", void *" args );
>> .fi
>> .SH DESCRIPTION
>> The
>> .BR seccomp ()
>> system call operates on the Secure Computing (seccomp) state of the
>> calling process.
>> .\" FIXME: This page various uses the terms "process', "thread" and =
"task".
>> .\" Probably only one of these (not "task"!) should be used in all
>> .\" cases. I suspect it should be "thread".
>=20
> Yeah, "task" should be avoided, my mistake! I will try to correct the=
m
> below. The above general case is correct, since TSYNC can change the
> state on all threads of the process.

Okay.

>> Currently, Linux supports the following
>> .IR operation
>> values:
>> .TP
>> .BR SECCOMP_SET_MODE_STRICT
>> The only system calls that the thread is permitted to make are
>=20
> Should this be clarified to "the calling thread", or is that implied?

Thanks. It's better to be clearer. Changed.

>> .BR read (2),
>> .BR write (2),
>> .BR _exit (2),
>> and
>> .BR sigreturn (2).
>> Other system calls result in the delivery of a
>> .BR SIGKILL
>> signal
>=20
> "signal" needs a period ending the sentence above.

Thanks.

>> Strict secure computing mode is useful for number-crunching
>> applications that may need to execute untrusted byte code, perhaps
>> obtained by reading from a pipe or socket.
>>
>> This operation is available only if the kernel is configured with
>> .BR CONFIG_SECCOMP
>> enabled.
>>
>> The value of
>> .IR flags
>> must be 0, and
>> .IR args
>> must be NULL.
>>
>> This operation is functionally identical to the call:
>>
>>     prctl(PR_SET_SECCOMP, SECCOMP_MODE_STRICT);
>> .TP
>> .BR SECCOMP_SET_MODE_FILTER
>> The system calls allowed are defined by a pointer to a Berkeley Pack=
et
>> Filter (BPF) passed via
>> .IR args .
>> This arguMent is a pointer to a
>=20
> s/M/m/

=46ixed.

>> .IR "struct\ sock_fprog" ;
>> it can be designed to filter arbitrary system calls and system call
>> arguments.
>> If the filter is invalid,
>> .BR seccomp ()
>> fails, returning
>> .BR EACCESS
>=20
> EINVAL (EACCESS would be for lacking CAP_SYS_ADMIN or no-new-privs).

=46ixed.

>> in
>> .IR errno .
>>
>> .\" FIXME I (mtk) reworded the following paragraph substantially.
>> .\" Please check it.
>> If
>> .BR fork (2)
>> or
>> .BR clone (2)
>> is allowed by the filter, any child processes will be constrained to
>> the same filters and system calls as the parent.
>=20
> To me, "and system calls" implies something other than filters. Maybe=
:
> "the same system call filters as the parent"?

=46ixed.

>> If
>> .BR execve (2)
>> is allowed by the filter,
>> the filters and constraints on permitted system calls are preserved =
across an
>> .BR execve (2).
>=20
> Perhaps "Similarly, if execve is allowed, the existing filters will b=
e
> preserved across the call to execve." The filter _is_ the "constraint=
s
> on permitted system calls", but since it can do more than constrain,
> I'm shy to imply a limit to the scope of this description.

Changed as you suggest. Thanks.

>> .\" FIXME I (mtk) reworded the following paragraph substantially.
>> .\" Please check it.
>> In order to use the
>> .BR SECCOMP_SET_MODE_FILTER
>> operation, either the caller must have the
>> .BR CAP_SYS_ADMIN
>> capability or the call must be preceded by the call:
>>
>>     prctl(PR_SET_NO_NEW_PRIVS, 1);
>=20
> Strictly speaking, if any ancestor ever called PR_SET_NO_NEW_PRIVS,
> the process already has it set. Perhaps "... capability, or the threa=
d
> must already have thew "no new privs" prctl bit set. If not already
> set by an ancestory, the thread must call: ..."

Changed as you suggest.

>> Otherwise, the
>> .BR SECCOMP_SET_MODE_FILTER
>> operation will fail and return
>> .BR EACCES
>> in
>> .IR errno .
>> This requirement ensures that filter programs cannot be applied to c=
hild
>> .\" FIXME What does "installed" in the following line mean?
>> processes with greater privileges than the process that installed th=
em.
>=20
> Andy mentioned the "why", but "installed" here means "called seccomp(=
)
> to add filters", e.g. add (install) a filter to have
> "setuid(non-root)" return 0 instead of actually getting called, and
> then exec a setuid process that tries to drop privileges, which
> doesn't happen, and now the original caller (non-root) has a setuid
> process running as root that it may be able to influence into doing
> dangerous things because it didn't _actually_ drop privileges.

Thanks. That's a really good example. I incorporated your text, revisin=
g slightly:

[[
(Such a malicious filter might, for example, cause an attempt to use
=2EBR setuid (2)
to set the caller's user IDs to non-zero values to instead
return 0 without actually making the system call.
Thus, the program might be tricked into retaining superuser privileges
in circumstances where it is possible to influence it to do
dangerous things because it did not actually drop privileges.)
]]

Okay?

>> If
>> .BR prctl (2)
>> or
>> .BR seccomp (2)
>> is allowed by the attached filter, further filters may be added.
>> This will increase evaluation time, but allows for further reduction=
 of
>> the attack surface during execution of a process.
>=20
> Strictly speaking, "process" -> "thread"

=46ixed.

>> The
>> .BR SECCOMP_SET_MODE_FILTER
>> operation is available only if the kernel is configured with
>> .BR CONFIG_SECCOMP_FILTER
>> enabled.
>>
>> When
>> .IR flags
>> is 0, this operation is functionally identical to the call:
>>
>>     prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, args);
>>
>> The recognized
>> .IR flags
>> are:
>> .RS
>> .TP
>> .BR SECCOMP_FILTER_FLAG_TSYNC
>> When adding a new filter, synchronize all other threads of the calli=
ng
>> process to the same seccomp filter tree.
>> .\" FIXME Nowhere in this page is the term "filter tree" defined.
>> .\" There should be a definition somewhere.
>> .\" Is it: "the set of filters attached to a thread"?
>=20
> As Andy said, the list of filters attached to the process. A process
> may have multiple threads adding filters, which would cause those
> threads to have separate branches of seccomp filters (though they
> would share a common root from when the process started). It is only
> possible to use TSYNC if threads haven't diverged in this way.

Yup, got it already, thanks to Andy's explanation. Thanks for the
further detail though, which helped me tweak the wording a little.

>> If any thread cannot do this,
>> the call will not attach the new seccomp filter,
>> and will fail, returning the first thread ID found that cannot synch=
ronize.
>> Synchronization will fail if another thread is in
>> .BR SECCOMP_MODE_STRICT
>> or if it has attached new seccomp filters to itself,
>> diverging from the calling thread's filter tree.
>> .RE
>> .SH FILTERS
>> When adding filters via
>> .BR SECCOMP_SET_MODE_FILTER ,
>> .IR args
>> points to a filter program:
>>
>> .in +4n
>> .nf
>> struct sock_fprog {
>>     unsigned short      len;    /* Number of BPF instructions */
>>     struct sock_filter *filter;
>> };
>> .fi
>> .in
>>
>> Each program must contain one or more BPF instructions:
>>
>> .in +4n
>> .nf
>> struct sock_filter {    /* Filter block */
>>     __u16   code;       /* Actual filter code */
>>     __u8    jt;         /* Jump true */
>>     __u8    jf;         /* Jump false */
>>     __u32   k;          /* Generic multiuse field */
>> };
>> .fi
>> .in
>>
>> When executing the instructions, the BPF program executes over the
>> system call information made available via:
>>
>> .in +4n
>> .nf
>> struct seccomp_data {
>>     int nr;                     /* system call number */
>>     __u32 arch;                 /* AUDIT_ARCH_* value */
>>     __u64 instruction_pointer;  /* CPU instruction pointer */
>>     __u64 args[6];              /* up to 6 system call arguments */
>> };
>> .fi
>> .in
>>
>> .\" FIXME I find the next piece a little hard to understand, so,
>> .\"       some questions:
>> .\"       * If there are multiple filters, in what order are they ex=
ecuted?
>> .\"         (The man page should probably detail the answer to this =
question.)
>=20
> They are executed in reverse order (most recently added is executed f=
irst).

Thanks. I integrated that point into the page.
=20
>> .\"       * If there are multiple filters, are they all always execu=
ted?
>> .\"         I assume not, but the notion that
>> .\"             "the return value for the evaluation of a given syst=
em call
>> .\"              will always use the value with the highest preceden=
ce"
>> .\"         implies that even that if one filter generates (say)
>> .\"         SECCOMP_RET_ERRNO, then further filters may still be exe=
cuted,
>> .\"         including one that generates (say) the "higher priority"
>> .\"         SECCOMP_RET_KILL condition.
>> .\"       Can you clarify the above?
>=20
> Correct. All filters are executed. The returned value is the one with
> the first seen highest priority (lowest numerical value) action of
> those returned by each filter. For example, if a filter was installed
> that returned SECCOMP_RET_ERRNO|1, and then another filter installed
> SECCOMP_RET_ERRNO|22, and then another filter installed
> SECCOMP_RET_ALLOW, SECCOMP_RET_ERRNO|22 would be returned.
> SECCOMP_RET_ERRNO is higher priority than SECCOMP_RET_ALLOW, but sinc=
e
> the SECCOMP_RET_ERRNO|22 was seen first, it's data (22) will be used,
> even though the last filter returned a lower data (1), as only action
> values are compared.

So, the penny finally dropped here (and I confirmed by looking at the
code, which I didn't find time to do earlier). The return value consist=
s
of two parts: SECCOMP_RET_ACTION and SECCOMP_RET_DATA. This was hinted=20
at in various places in the text, but was not made explicit.

>> A seccomp filter returns one of the values listed below.
>=20
> Based on discussion further below, perhaps "value" should be called
> "action" here? Maybe:
>=20
> A seccomp filter returns a value. The high 16 bits
> (SECCOMP_RET_ACTION) is the seccomp filter "action" to take. The low
> 16 bits (SECCOMP_RET_DATA) is data specific to the action.

Ahhh -- and then I see you explain it as I (now) understand it ;-).

I added some text that conveys the same info. So, by now this piece of=20
the page reads:

       A seccomp filter returns a 32-bit value consisting of two  parts=
:
       the  most  significant 16 bits (corresponding to the mask define=
d
       by the constant SECCOMP_RET_ACTION) contain one of  the  "action=
"
       values  listed  below;  the least significant 16-bits (defined b=
y
       the constant SECCOMP_RET_DATA) are "data" to be  associated  wit=
h
       this return value.

       If  multiple  filters  exist,  they  are all executed, in revers=
e
       order of their addition  to  the  filter  tree  (i.e.,  the  mos=
t
       recently  installed  filter is executed first).  The return valu=
e
       for the evaluation of a given system call is the first-seen  SEC=
=E2=80=90
       COMP_RET_ACTION  value  of  highest  precedence  (along  with it=
s
       accompanying data) returned by execution of all of the filters.

(And I've removed some repetition of the same points later in the page.=
)

>> If multiple filters exist,
>> the return value for the evaluation of a given system call
>> will always use the value with the highest precedence.
>> (For example,
>> .BR SECCOMP_RET_KILL
>> will always take precedence.)
>>
>> In decreasing order order of precedence,
>> the values that may be returned by a seccomp filter are:
>> .TP
>> .BR SECCOMP_RET_KILL
>> Results in the task exiting immediately without executing the system=
 call.
>> The task terminates as though killed by a
>=20
> Both "task" -> "process" above.

=46ixed.

>> .B SIGSYS
>> signal
>> .RI ( not
>> .BR SIGKILL ).
>> .TP
>> .BR SECCOMP_RET_TRAP
>> Results in the kernel sending a
>> .BR SIGSYS
>> signal to the triggering task without executing the system call.
>=20
> "task" -> "process"

=46ixed.

>> .IR siginfo\->si_call_addr
>> will show the address of the system call instruction, and
>> .IR siginfo\->si_syscall
>> and
>> .IR siginfo\->si_arch
>> will indicate which system call was attempted.
>> The program counter will be as though the system call happened
>> (i.e., it will not point to the system call instruction).
>> The return value register will contain an architecture\-dependent va=
lue;
>> if resuming execution, set it to something sensible.
>> (The architecture dependency is because replacing it with
>> .BR ENOSYS
>> could overwrite some useful information.)
>>
>> .\" FIXME The following sentence is the first time that SECCOMP_RET_=
DATA
>> .\"       is mentioned. SECCOMP_RET_DATA needs to be described in th=
is
>> .\"       man page.
>=20
> How should these be detailed? (I took a stab at it further above.)

I think the text above suffices. probably no need to actually show the=20
constant definitions.

> #define SECCOMP_RET_ACTION      0x7fff0000U
> #define SECCOMP_RET_DATA        0x0000ffffU
>
>> The
>> .BR SECCOMP_RET_DATA
>> portion of the return value will be passed as
>> .IR si_errno .
>>
>> .BR SIGSYS
>> triggered by seccomp will have the value
>> .BR SYS_SECCOMP
>> in the
>> .IR si_code
>> field.
>> .TP
>> .BR SECCOMP_RET_ERRNO
>> .\" FIXME What does "the return value" refer to in the next sentence=
?
>> .\"       It is not obvious to me.
>=20
> As Andy said, the 32 bit value returned by the BPF filter.

Yep, got it now.

>> Results in the lower 16-bits of the return value being passed
>> to user space as the
>> .IR errno
>> without executing the system call.
>> .TP
>> .BR SECCOMP_RET_TRACE
>> When returned, this value will cause the kernel to attempt to notify=
 a
>> .BR ptrace (2)-based
>> tracer prior to executing the system call.
>> .\" FIXME I (mtk) reworded the following sentence substantially.
>> .\" Please check it.
>=20
> Yes, correct.

Thanks for checking.

>> If there is no tracer present,
>> the system call is not executed and returns a failure status with
>> .I errno
>> set to
>> .BR ENOSYS .
>>
>> A tracer will be notified if it requests
>> .BR PTRACE_O_TRACESECCOMP
>> using
>> .IR ptrace(PTRACE_SETOPTIONS) .
>> The tracer will be notified of a
>> .BR PTRACE_EVENT_SECCOMP
>> and the
>> .BR SECCOMP_RET_DATA
>> portion of the BPF program return value will be available to the tra=
cer
>> via
>> .BR PTRACE_GETEVENTMSG .
>>
>> The tracer can skip the system call by changing the system call numb=
er
>> to \-1.
>> Alternatively, the tracer can change the system call
>> requested by changing the system call to a valid system call number.
>> If the tracer asks to skip the system call, then the system call wil=
l
>> appear to return the value that the tracer puts in the return value =
register.
>>
>> The seccomp check will not be run again after the tracer is notified=
=2E
>> (This means that seccomp-based sandboxes
>> .B "must not"
>> allow use of
>> .BR ptrace (2)\(emeven
>> of other
>> sandboxed processes\(emwithout extreme care;
>> ptracers can use this mechanism to escape.)
>> .TP
>> .BR SECCOMP_RET_ALLOW
>> Results in the system call being executed.
>> .PP
>> If multiple filters exist, the return value for the evaluation of a
>> given system call will always use the highest precedent value.
>>
>> .\" FIXME The following sentence is the first time that SECCOMP_RET_=
ACTION
>> .\"       is mentioned. SECCOMP_RET_ACTION needs to be described in =
this
>> .\"       man page.
>=20
> Attempted earlier...

Yep, we're good now.
=20
>> Precedence is determined using only the
>> .BR SECCOMP_RET_ACTION
>> mask.
>> When multiple filters return values of the same precedence,
>> only the
>> .BR SECCOMP_RET_DATA
>> from the most recently installed filter will be returned.
>=20
> The above tries to document what was mentioned about the order of
> return value parsing I discussed further above.

Yep, got it.

>> .SH RETURN VALUE
>> On success,
>> .BR seccomp ()
>> returns 0.
>> On error, if
>> .BR SECCOMP_FILTER_FLAG_TSYNC
>> was used,
>> the return value is the thread ID that caused the synchronization fa=
ilure.
>> On other errors, \-1 is returned, and
>> .IR errno
>> is set to indicate the cause of the error.
>> .SH ERRORS
>> .BR seccomp ()
>> can fail for the following reasons:
>> .TP
>> .BR EACCESS
>> The caller did not have the
>> .BR CAP_SYS_ADMIN
>> capability, or had not set
>> .IR no_new_privs
>> before using
>> .BR SECCOMP_SET_MODE_FILTER .
>> .TP
>> .BR EFAULT
>> .IR args
>> was required to be a valid address.
>> .TP
>> .BR EINVAL
>> .IR operation
>> is unknown; or
>> .IR flags
>> are invalid for the given
>> .IR operation
>> .TP
>> .BR ESRCH
>> Another thread caused a failure during thread sync, but its ID could=
 not
>> be determined.
>> .SH VERSIONS
>> The
>> .BR seccomp()
>> system call first appeared in Linux 3.17.
>> .\" FIXME Add glibc version
>> .SH CONFORMING TO
>> The
>> .BR seccomp()
>> system call is a nonstandard Linux extension.
>> .SH NOTES
>> .BR seccomp ()
>> provides a superset of the functionality provided by the
>> .BR prctl (2)
>> .BR PR_SET_SECCOMP
>> operation (which does not support
>> .IR flags ).
>> .SH EXAMPLE
>> .\" FIXME Please carefully review the following new piece that
>> .\"       demonstrates the use of your example program.
>=20
> This is great! Thanks for expanding this.

You're welcome. In the first instance, I was just experimenting
to ensure that I understood what was going on. Then it seemed
worthwhile to include such experiments in the page itself.

>> The program below accepts four or more arguments.
>> The first three arguments are a system call number,
>> a numeric architecture identifier, and an error number.
>> The program uses these values to construct a BPF filter
>> that is used at run time to perform the following checks:
>> .IP [1] 4
>> If the program is not running on the specified architecture,
>> the BPF filter causes system calls to fail with the error
>> .BR ENOSYS .
>> .IP [2]
>> If the program attempts to execute the system call with the specifie=
d number,
>> the BPF filter causes the system call to fail, with
>> .I errno
>> being set to the specified error number.
>> .PP
>> The remaining command-line arguments specify
>> the pathname and additional arguments of a program
>> that the example program should attempt to execute using
>> .BR execve (3)
>> (a library function that employs the
>> .BR execve (2)
>> system call).
>> Some example runs of the program are shown below.
>>
>> First, we display the architecture that we are running on (x86-64)
>> and then construct a shell function that looks up system call
>> numbers on this architecture:
>>
>> .nf
>> .in +4n
>> $ \fBuname -m\fP
>> x86_64
>> $ \fBsyscall_nr() {
>>     cat /usr/src/linux/arch/x86/syscalls/syscall_64.tbl | \\
>>     awk '$2 !=3D "x32" && $3 =3D=3D "'$1'" { print $1 }'
>> }\fP
>> .in
>> .fi
>>
>> When the BPF filter rejects a system call (case [2] above),
>> it causes the system call to fail with the error number
>> specified on the command line.
>> In the experiments shown here, we'll use error number 99:
>>
>> .nf
>> .in +4n
>> $ \fBerrno 99\fP
>> EADDRNOTAVAIL 99 Cannot assign requested address
>> .in
>> .fi
>>
>> In the following example, we attempt to run the command
>> .BR whoami (1),
>> but the BPF filter rejects the
>> .BR execve (2)
>> system call, so that the command is not even executed:
>>
>> .nf
>> .in +4n
>> $ \fBsyscall_nr execve\fP
>> 59
>> $ \fB./a.out 59 0xC000003E 99 /bin/whoami\fP
>=20
> It it worth showing where you got the 0xC000003E value from? (i.e.
> from just running ./a.out and looking at its hints)

Yes, that seems worthwhile. Done.

>> execv: Cannot assign requested address
>> .in
>> .fi
>>
>> In the next example, the BPF filter rejects the
>> .BR write (2)
>> system call, so that, although it is successfully started, the
>> .BR whoami (1)
>> command is not able to write output:
>>
>> .nf
>> .in +4n
>> $ \fBsyscall_nr write\fP
>> 1
>> $ \fB./a.out 1 0xC000003E 99 /bin/whoami\fP
>> .in
>> .fi
>>
>> In the final example,
>> the BPF filter rejects a system call that is not used by the
>> .BR whoami (1)
>> command, so it is able to successfully execute and produce output:
>>
>> .nf
>> .in +4n
>> $ \fBsyscall_nr preadv\fP
>> 295
>> $ \fB./a.out 295 0xC000003E 99 /bin/whoami\fP
>> cecilia
>> .in
>> .fi
>> .SS Program source
>> .fi
>> .nf
>> #include <errno.h>
>> #include <stddef.h>
>> #include <stdio.h>
>> #include <stdlib.h>
>> #include <unistd.h>
>> #include <linux/audit.h>
>> #include <linux/filter.h>
>> #include <linux/seccomp.h>
>> #include <sys/prctl.h>
>>
>> static int
>> install_filter(int syscall, int arch, int error)
>> {
>>     struct sock_filter filter[] =3D {
>>         /* [0] Load architecture */
>>         BPF_STMT(BPF_LD + BPF_W + BPF_ABS,
>>                  (offsetof(struct seccomp_data, arch))),
>>
>>         /* [1] Jump forward 4 instructions on architecture mismatch =
*/
>>         BPF_JUMP(BPF_JMP + BPF_JEQ + BPF_K, arch, 0, 4),
>>
>>         /* [2] Load system call number */
>>         BPF_STMT(BPF_LD + BPF_W + BPF_ABS,
>>                  (offsetof(struct seccomp_data, nr))),
>>
>>         /* [3] Jump forward 1 instruction on system call number
>>                mismatch */
>>         BPF_JUMP(BPF_JMP + BPF_JEQ + BPF_K, syscall, 0, 1),
>>
>>         /* [4] Matching architecture and system call: return
>>                specific errno */
>>         BPF_STMT(BPF_RET + BPF_K,
>>                  SECCOMP_RET_ERRNO | (error & SECCOMP_RET_DATA)),
>>
>>         /* [5] Destination of system call number mismatch: allow oth=
er
>>                system calls */
>>         BPF_STMT(BPF_RET + BPF_K, SECCOMP_RET_ALLOW),
>>
>>         /* [6] Destination of architecture mismatch: kill process */
>>         BPF_STMT(BPF_RET + BPF_K, SECCOMP_RET_KILL),
>>     };
>>
>>     struct sock_fprog prog =3D {
>>         .len =3D (unsigned short) (sizeof(filter) / sizeof(filter[0]=
)),
>>         .filter =3D filter,
>>     };
>>
>>     if (seccomp(SECCOMP_SET_MODE_FILTER, 0, &prog)) {
>>         perror("seccomp");
>>         return 1;
>>     }
>>
>>     return 0;
>> }
>>
>> int
>> main(int argc, char **argv)
>> {
>>     if (argc < 5) {
>>         fprintf(stderr, "Usage:\\n"
>>                 "refuse <syscall_nr> <arch> <errno> <prog> [<args>]\=
\n"
>>                 "Hint:  AUDIT_ARCH_I386: 0x%X\\n"
>>                 "       AUDIT_ARCH_X86_64: 0x%X\\n"
>>                 "\\n", AUDIT_ARCH_I386, AUDIT_ARCH_X86_64);
>>         exit(EXIT_FAILURE);
>>     }
>>
>>     if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
>>         perror("prctl");
>>         exit(EXIT_FAILURE);
>>     }
>>
>>     if (install_filter(strtol(argv[1], NULL, 0),
>>                        strtol(argv[2], NULL, 0),
>>                        strtol(argv[3], NULL, 0)))
>>         exit(EXIT_FAILURE);
>>
>>     execv(argv[4], &argv[4]);
>>     perror("execv");
>>     exit(EXIT_FAILURE);
>> }
>> .fi
>> .SH SEE ALSO
>> .BR prctl (2),
>> .BR ptrace (2),
>> .BR signal (7),
>> .BR socket (7)
>> .sp
>> .\" FIXME: Is the following the best source of info on the BPF langu=
age?
>> The kernel source file
>> .IR Documentation/networking/filter.txt .
>=20
> I don't know of anything better.

Okay.

>=20
> Thanks! This is looking really good. :)

Thanks for all these comments, Kees. I've now taken a further pass thro=
ugh=20
the page, and made further edits, and some more FIXMEs as a result. I'l=
l=20
send the new draft in a separate message.

Cheers,

Michael


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
