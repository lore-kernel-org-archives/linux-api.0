From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: Edited seccomp.2 man page for review
Date: Tue, 30 Dec 2014 13:07:18 +0100
Message-ID: <54A29576.7040508@gmail.com>
References: <545E0B06.6030706@gmail.com> <CALCETrWSz5hZJb5vavKX_kbfjm42w-e4aQjdRNsvS4m5uw4Q2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWSz5hZJb5vavKX_kbfjm42w-e4aQjdRNsvS4m5uw4Q2w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: mtk.manpages@gmail.com, Kees Cook <keescook@chromium.org>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Daniel Borkmann <dborkman@redhat.com>
List-Id: linux-api@vger.kernel.org

Hi Andy,

Apologies for the slow follow-up.

On 11/10/2014 08:37 PM, Andy Lutomirski wrote:
> On Sat, Nov 8, 2014 at 4:22 AM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>> Hi Kees, (and all),
>>
>> Thanks for the seccomp.2 draft man page that you provided a few
>> weeks ago (https://lkml.org/lkml/2014/9/25/685), and my apologies
>> for the slow follow-up.
>>
> 
> Answers to some of your questions below.
> 
>> .BR execve (2)
>> is allowed by the filter,
>> the filters and constraints on permitted system calls are preserved across an
>> .BR execve (2).
>>
>> .\" FIXME I (mtk) reworded the following paragraph substantially.
>> .\" Please check it.
>> In order to use the
>> .BR SECCOMP_SET_MODE_FILTER
>> operation, either the caller must have the
>> .BR CAP_SYS_ADMIN
>> capability or the call must be preceded by the call:
>>
>>     prctl(PR_SET_NO_NEW_PRIVS, 1);
>>
>> Otherwise, the
>> .BR SECCOMP_SET_MODE_FILTER
>> operation will fail and return
>> .BR EACCES
>> in
>> .IR errno .
>> This requirement ensures that filter programs cannot be applied to child
>> .\" FIXME What does "installed" in the following line mean?
>> processes with greater privileges than the process that installed them.
>>
> 
> This requirement ensures that an unprivileged process cannot apply a
> malicious filter and then invoke a setuid or other privileged program
> using execve, thus potentially compromising that program.

Thanks. Much easier to understand. I've taken your text pretty much as
given into the man page.

>> If
>> .BR prctl (2)
>> or
>> .BR seccomp (2)
>> is allowed by the attached filter, further filters may be added.
>> This will increase evaluation time, but allows for further reduction of
>> the attack surface during execution of a process.
>>
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
>> When adding a new filter, synchronize all other threads of the calling
>> process to the same seccomp filter tree.
>> .\" FIXME Nowhere in this page is the term "filter tree" defined.
>> .\" There should be a definition somewhere.
>> .\" Is it: "the set of filters attached to a thread"?
> 
> It's the ordered list of filters attached to a thread, where attaching
> identical filters in separate syscalls results in different filters
> from this perspective.

Thanks again. I've pretty much taken that text into the man page.

>> If any thread cannot do this,
>> the call will not attach the new seccomp filter,
>> and will fail, returning the first thread ID found that cannot synchronize.
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
>> .\"       * If there are multiple filters, in what order are they executed?
>> .\"         (The man page should probably detail the answer to this question.)
> 
> All of them are executed.  The precedence rules determine what happens
> if the filters return different values.

Got it. Thanks.

>> .\"       * If there are multiple filters, are they all always executed?
>> .\"         I assume not, but the notion that
>> .\"             "the return value for the evaluation of a given system call
>> .\"              will always use the value with the highest precedence"
>> .\"         implies that even that if one filter generates (say)
>> .\"         SECCOMP_RET_ERRNO, then further filters may still be executed,
>> .\"         including one that generates (say) the "higher priority"
>> .\"         SECCOMP_RET_KILL condition.
>> .\"       Can you clarify the above?
>> A seccomp filter returns one of the values listed below.
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
>> Results in the task exiting immediately without executing the system call.
>> The task terminates as though killed by a
>> .B SIGSYS
>> signal
>> .RI ( not
>> .BR SIGKILL ).
>> .TP
>> .BR SECCOMP_RET_TRAP
>> Results in the kernel sending a
>> .BR SIGSYS
>> signal to the triggering task without executing the system call.
>> .IR siginfo\->si_call_addr
>> will show the address of the system call instruction, and
>> .IR siginfo\->si_syscall
>> and
>> .IR siginfo\->si_arch
>> will indicate which system call was attempted.
>> The program counter will be as though the system call happened
>> (i.e., it will not point to the system call instruction).
>> The return value register will contain an architecture\-dependent value;
>> if resuming execution, set it to something sensible.
>> (The architecture dependency is because replacing it with
>> .BR ENOSYS
>> could overwrite some useful information.)
>>
>> .\" FIXME The following sentence is the first time that SECCOMP_RET_DATA
>> .\"       is mentioned. SECCOMP_RET_DATA needs to be described in this
>> .\"       man page.
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
>> .\" FIXME What does "the return value" refer to in the next sentence?
>> .\"       It is not obvious to me.
> 
> The return value is the value returned by the BPF program.

Got it!

Thanks for the comments, Andy!

Cheers,

Michael





-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
