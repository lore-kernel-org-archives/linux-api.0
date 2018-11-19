From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH] proc: allow killing processes via file descriptors
Date: Sun, 18 Nov 2018 16:53:57 -0800
Message-ID: <CAKOZueve_r5h9_B2YV5RzJYjTf-yS5uZfAbz+Ftqy5jFSk6Xdw@mail.gmail.com>
References: <a7f50692-667c-4efe-a2d0-fa324eebb90b@infradead.org>
 <CAKOZueutLc8d0Fe+7dNWiZKnALhTSST8+kCnOrL+OmB6coUmtA@mail.gmail.com>
 <CALCETrVg71XBv-gMOtL-m0Dd0HNz8_oXOUDSWin5LeViAL0UYA@mail.gmail.com>
 <CAKOZuesCKo4GH9fdum2EUFLrtTWam3aizcDQUn3-vCYg4T1P8w@mail.gmail.com>
 <CALCETrUeNZPfrSYa9vH5Ukrk1Y+Kb9GkZOh6LkqG6Z9NpK5P0w@mail.gmail.com>
 <CAKOZuevVk_aH_2TuiNcmxgMa+gHXMBXz6Uu5a6TDjoxjhaE36g@mail.gmail.com>
 <CALCETrVscRwQG55-j1SKc2TmSb1-=5861804ojUuviNzdyDOrA@mail.gmail.com>
 <CAKOZuevRq-igh06zS_nsGG400zXrKFCtajpEG9-xgU2+Rtb2Pw@mail.gmail.com>
 <20181118190504.ixglsqbn6mxkcdzu@yavin> <CAKOZuetfqvn1uVqKJ=16iEzG4g449YOjC_tLM60eKBSkv9u+bQ@mail.gmail.com>
 <20181119000928.h2wp2rn2pnlfysp7@yavin>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181119000928.h2wp2rn2pnlfysp7@yavin>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Andy Lutomirski <luto@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Kees Cook <keescook@chromium.org>, Jan Engelhardt <jengelh@inai.de>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 18, 2018 at 4:09 PM, Aleksa Sarai <cyphar@cyphar.com> wrote:
> On 2018-11-18, Daniel Colascione <dancol@google.com> wrote:
>> On Sun, Nov 18, 2018 at 11:05 AM, Aleksa Sarai <cyphar@cyphar.com> wrote:
>> > On 2018-11-18, Daniel Colascione <dancol@google.com> wrote:
>> >> > Here's my point: if we're really going to make a new API to manipulate
>> >> > processes by their fd, I think we should have at least a decent idea
>> >> > of how that API will get extended in the future.  Right now, we have
>> >> > an extremely awkward situation where opening an fd in /proc requires
>> >> > certain capabilities or uids, and using those fds often also checks
>> >> > current's capabilities, and the target process may have changed its
>> >> > own security context, including gaining privilege via SUID, SGID, or
>> >> > LSM transition rules in the mean time.  This has been a huge source of
>> >> > security bugs.  It would be nice to have a model for future APIs that
>> >> > avoids these problems.
>> >> >
>> >> > And I didn't say in my proposal that a process's identity should
>> >> > fundamentally change when it calls execve().  I'm suggesting that
>> >> > certain operations that could cause a process to gain privilege or
>> >> > otherwise require greater permission to introspect (mainly execve)
>> >> > could be handled by invalidating the new process management fds.
>> >> > Sure, if init re-execs itself, it's still PID 1, but that doesn't
>> >> > necessarily mean that:
>> >> >
>> >> > fd = process_open_management_fd(1);
>> >> > [init reexecs]
>> >> > process_do_something(fd);
>> >> >
>> >> > needs to work.
>> >>
>> >> PID 1 is a bad example here, because it doesn't get recycled. Other
>> >> PIDs do. The snippet you gave *does* need to work, in general, because
>> >> if exec invalidates the handle, and you need to reopen by PID to
>> >> re-establish your right to do something with the process, that process
>> >> may in fact have died between the invalidation and your reopen, and
>> >> your reopened FD may refer to some other random process.
>> >
>> > I imagine the error would be -EPERM rather than -ESRCH in this case,
>> > which would be incredibly trivial for userspace to differentiate
>> > between.
>>
>> Why would userspace necessarily see EPERM? The PID might get recycled
>> into a different random process that the caller has the ability to
>> affect.
>
> I'm not sure what you're talking about. execve() doesn't change the PID
> of a process, and in the case we are talking about:
>
>   pidX_handle = open_pid_handle(pidX);
>   [ pidX execs a setuid binary ]
>   do_something(pidX_handle);
>
> pidX still has the same PID (so PID recycling is irrelevant in this
> case). The key point is whether do_something() should give you an error
> in such a state transition, and in that case I would say you'd get
> -EPERM which would indicate (obviously) insufficient privileges.

EPERM is the wrong error. All that's happened here is that the process
has execed itself; you may still have permission to operate on the
post-execve process. ESTALE is the right error here.

But yes, there is a PID trace. What do you do after getting ESTALE?
You reopen the handle and retry your operation. How do you open a new
handle? Unless you're using some awful /proc/self/fd/... hack, you
reopen by PID. And at that point, you've introduced a PID race again.
That's why, in my sketch below, I imagined creating the capability
handle from the process-identity handle and not, as in the snippet
above, directly from the PID.

>> Anyway: what other API requires, for correct operation, occasional
>> reopening through /proc/self/fd? It's cumbersome, and it doesn't add
>> anything. If we invalidate process handles on execve, and processes
>> are legally allowed to re-exec themselves for arbitrary reasons at any
>> time, that's tantamount to saying that handles might become invalid at
>> any time and that all callers must be prepared to go through the
>> reopen-and-retry path before any operation.
>
> O_PATH. In container runtimes this is necessary for several reasons to
> protect against malicious container root filesystems as well as avoiding
> exposing a dirfd to the container.
>
> In LXC, O_PATH re-opening is used for /dev/ptmx as well as some other
> operations. In runc we use it for FIFO re-opening so that we can signal
> pid1 in a container to execve() into user code.
>
> So this isn't a new thing.

Yuck. I'd still argue that 1) the reopen trick isn't really intended
as the mainline path for that kernel functionality, and 2) there ought
to be a way to do what you're describing in a cleaner way. I'd
classify this approach as a hack. It's one thing to require a hack in
specialized container initialization code, but it's another to bake it
into a hopefully-common API for something as fundamental as process
management, especially when there's a perfectly good alternative that
doesn't require this hack.

>> Why are we making them do that? So that a process can have an open FD
>> that represents a process-operation capability? Which capability does
>> the open FD represent?
>
> The re-opening part was just an argument to show that there isn't a
> condition where you wouldn't be able to get access to the 'struct pid'.
> I doubt that anyone would actually need to use this -- since you'd need
> to pass "/proc/pid/fd/..." to a more privileged process in order to use
> the re-opening.
>
> But this also means that we don't need to have a concept of a pidfd that
> isn't actually associated with a PID but is instead associated with
> current->mm (which is what you appear to be proposing with the whole
> "identity fd" concept).

Not current->mm; that can be shared with clone. struct signal is the
right long-term identity. It's usually easier to keep the struct pid
around though, which is exactly what a procfs FD is today: just a
lightweight handle to a struct pid.

>> I think when you and Andy must be talking about is an API that looks like this:
>>
>> int open_process_operation_handle(int procfs_dirfd, int capability_bitmask)
>>
>> capability_bitmask would have bits like
>>
>> PROCESS_CAPABILITY_KILL --- send a signal
>> PROCESS_CAPABILITY_PTRACE --- attach to a process
>> PROCESS_CAPABILITY_READ_EXIT_STATUS --- what it says on the tin
>> PROCESS_CAPABILITY_READ_CMDLINE --- etc.
>>
>> Then you'd have system calls like
>>
>> int process_kill(int process_capability_fd, int signo, const union sigval data)
>> int process_ptrace_attach(int process_capability_fd)
>> int process_wait_for_exit(int process_capability_fd, siginfo_t* exit_info)
>>
>> that worked on these capability bits. If a process execs or does
>> something else to change its security capabilities, operations on
>> these capability FDs would fail with ESTALE or something and callers
>> would have to re-acquire their capabilities.
>>
>> This approach works fine. It has some nice theoretical properties, and
>> could allow for things like nicer privilege separation for debuggers.
>> I wouldn't mind something like this getting into the kernel.
>
> Andy might be arguing for this (and as you said, I can see the benefit
> of doing it this way).
>
> I'm not convinced that doing permission checks on-open is necessary here
> -- I get Andy's point about write(2) semantics but I think a new set of
> proc_* syscalls wouldn't need to follow those semantics. I might be
> wrong though.

For now, it's fine to just expose system calls that operate directly
on the procfs dfd.

>> I just don't think this model is necessary right now. I want a small
>> change from what we have today, one likely to actually make it into
>> the tree. And bypassing the capability FDs and just allowing callers
>> to operate directly on process *identity* FDs, using privileges in
>> effect at the time of all, is at least no worse than what we have now.
>>
>> That is, I'm proposing an API that looks like this:
>>
>> int process_kill(int procfs_dfd, int signo, const union sigval value)
>>
>> If, later, process_kill were to *also* accept process-capability FDs,
>> nothing would break.
>
> Again, I think we should agree on whether it's necessary to have both
> types of fds before we commit to maintaining both APIs forever...

I don't think noting that an API *could* be extended in a certain way
in the future creates any obligation to decide, immediately, whether
that extension will ever be needed. Right now, I don't see a reason to
supply the capability FD API I described. I'm just saying that it
could be added in a low-friction way if necessary one day.

>> >> > Similarly, it seems like
>> >> > it's probably safe to be able to open an fd that lets you watch the
>> >> > exit status of a process, have the process call setresuid(), and still
>> >> > see the exit status.
>> >>
>> >> Is it? That's an open question.
>> >
>> > Well, if we consider wait4(2) it seems that this is already the case.
>> > If you fork+exec a setuid binary you can definitely see its exit code.
>>
>> Only if you're the parent. Otherwise, you can't see the process exit
>> status unless you pass a ptrace access check and consult
>> /proc/pid/stat after the process dies, but before the zombie
>> disappears. Random unrelated and unprivileged processes can't see exit
>> statuses from distant parts of the system.
>
> Sure, I'd propose that ptrace_may_access() is what we should use for
> operation permission checks.

The tricky part is that ptrace_may_access takes a struct task. We want
logic that's *like* ptrace_may_access, but that works posthumously.
It's especially tricky because there's an LSM hook that lets
__ptrace_may_access do arbitrary things. And we can't just run that
hook upon process death, since *after* a process dies, a process
holding an exithand FD (or whatever we call it) may pass that FD to
another process, and *that* process can read(2) from it.

Another option is doing the exithand access check at open time. I
think that's probably fine, and it would make things a lot simpler.
But if we use this option, we should understand what we're doing, and
get some security-conscious people to think through the implications.
