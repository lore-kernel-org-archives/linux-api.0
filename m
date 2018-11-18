From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH] proc: allow killing processes via file descriptors
Date: Sun, 18 Nov 2018 11:44:19 -0800
Message-ID: <CAKOZuetfqvn1uVqKJ=16iEzG4g449YOjC_tLM60eKBSkv9u+bQ@mail.gmail.com>
References: <CAKOZuev1JUGFWuwsKqS6rXcFMqpCHT1VAG2kwB4O=FHo6DAFiQ@mail.gmail.com>
 <CALCETrVLP_mudJTW6EQpRr5GZ7kfuGci+QCT1uPrOVDTWcod-A@mail.gmail.com>
 <a7f50692-667c-4efe-a2d0-fa324eebb90b@infradead.org> <CAKOZueutLc8d0Fe+7dNWiZKnALhTSST8+kCnOrL+OmB6coUmtA@mail.gmail.com>
 <CALCETrVg71XBv-gMOtL-m0Dd0HNz8_oXOUDSWin5LeViAL0UYA@mail.gmail.com>
 <CAKOZuesCKo4GH9fdum2EUFLrtTWam3aizcDQUn3-vCYg4T1P8w@mail.gmail.com>
 <CALCETrUeNZPfrSYa9vH5Ukrk1Y+Kb9GkZOh6LkqG6Z9NpK5P0w@mail.gmail.com>
 <CAKOZuevVk_aH_2TuiNcmxgMa+gHXMBXz6Uu5a6TDjoxjhaE36g@mail.gmail.com>
 <CALCETrVscRwQG55-j1SKc2TmSb1-=5861804ojUuviNzdyDOrA@mail.gmail.com>
 <CAKOZuevRq-igh06zS_nsGG400zXrKFCtajpEG9-xgU2+Rtb2Pw@mail.gmail.com> <20181118190504.ixglsqbn6mxkcdzu@yavin>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181118190504.ixglsqbn6mxkcdzu@yavin>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Andy Lutomirski <luto@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Kees Cook <keescook@chromium.org>, Jan Engelhardt <jengelh@inai.de>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 18, 2018 at 11:05 AM, Aleksa Sarai <cyphar@cyphar.com> wrote:
> On 2018-11-18, Daniel Colascione <dancol@google.com> wrote:
>> > Here's my point: if we're really going to make a new API to manipulate
>> > processes by their fd, I think we should have at least a decent idea
>> > of how that API will get extended in the future.  Right now, we have
>> > an extremely awkward situation where opening an fd in /proc requires
>> > certain capabilities or uids, and using those fds often also checks
>> > current's capabilities, and the target process may have changed its
>> > own security context, including gaining privilege via SUID, SGID, or
>> > LSM transition rules in the mean time.  This has been a huge source of
>> > security bugs.  It would be nice to have a model for future APIs that
>> > avoids these problems.
>> >
>> > And I didn't say in my proposal that a process's identity should
>> > fundamentally change when it calls execve().  I'm suggesting that
>> > certain operations that could cause a process to gain privilege or
>> > otherwise require greater permission to introspect (mainly execve)
>> > could be handled by invalidating the new process management fds.
>> > Sure, if init re-execs itself, it's still PID 1, but that doesn't
>> > necessarily mean that:
>> >
>> > fd = process_open_management_fd(1);
>> > [init reexecs]
>> > process_do_something(fd);
>> >
>> > needs to work.
>>
>> PID 1 is a bad example here, because it doesn't get recycled. Other
>> PIDs do. The snippet you gave *does* need to work, in general, because
>> if exec invalidates the handle, and you need to reopen by PID to
>> re-establish your right to do something with the process, that process
>> may in fact have died between the invalidation and your reopen, and
>> your reopened FD may refer to some other random process.
>
> I imagine the error would be -EPERM rather than -ESRCH in this case,
> which would be incredibly trivial for userspace to differentiate
> between.

Why would userspace necessarily see EPERM? The PID might get recycled
into a different random process that the caller has the ability to
affect.

> If you wish to re-open the path that is also trivial by
> re-opening through /proc/self/fd/$fd -- which will re-do any permission
> checks and will guarantee that you are re-opening the same 'struct file'
> and thus the same 'struct pid'.

When you reopen via /proc/self/fd, you get a new struct file
referencing the existing inode, not the same struct file. A new
reference to the old struct file would just be dup.

Anyway: what other API requires, for correct operation, occasional
reopening through /proc/self/fd? It's cumbersome, and it doesn't add
anything. If we invalidate process handles on execve, and processes
are legally allowed to re-exec themselves for arbitrary reasons at any
time, that's tantamount to saying that handles might become invalid at
any time and that all callers must be prepared to go through the
reopen-and-retry path before any operation.

Why are we making them do that? So that a process can have an open FD
that represents a process-operation capability? Which capability does
the open FD represent?

I think when you and Andy must be talking about is an API that looks like this:

int open_process_operation_handle(int procfs_dirfd, int capability_bitmask)

capability_bitmask would have bits like

PROCESS_CAPABILITY_KILL --- send a signal
PROCESS_CAPABILITY_PTRACE --- attach to a process
PROCESS_CAPABILITY_READ_EXIT_STATUS --- what it says on the tin
PROCESS_CAPABILITY_READ_CMDLINE --- etc.

Then you'd have system calls like

int process_kill(int process_capability_fd, int signo, const union sigval data)
int process_ptrace_attach(int process_capability_fd)
int process_wait_for_exit(int process_capability_fd, siginfo_t* exit_info)

that worked on these capability bits. If a process execs or does
something else to change its security capabilities, operations on
these capability FDs would fail with ESTALE or something and callers
would have to re-acquire their capabilities.

This approach works fine. It has some nice theoretical properties, and
could allow for things like nicer privilege separation for debuggers.
I wouldn't mind something like this getting into the kernel.

I just don't think this model is necessary right now. I want a small
change from what we have today, one likely to actually make it into
the tree. And bypassing the capability FDs and just allowing callers
to operate directly on process *identity* FDs, using privileges in
effect at the time of all, is at least no worse than what we have now.

That is, I'm proposing an API that looks like this:

int process_kill(int procfs_dfd, int signo, const union sigval value)

If, later, process_kill were to *also* accept process-capability FDs,
nothing would break.

>> The only way around this problem is to have two separate FDs --- one
>> to represent process identity, which *must* be continuous across
>> execve, and the other to represent some specific capability, some
>> ability to do something to that process. It's reasonable to invalidate
>> capability after execve, but it's not reasonable to invalidate
>> identity. In concrete terms, I don't see a big advantage to this
>> separation, and I think a single identity FD combined with
>> per-operation capability checks is sufficient. And much simpler.
>
> I think that the error separation above would trivially allow user-space
> to know whether the identity or capability of a process being monitored
> has changed.
>
> Currently, all operations on a '/proc/$pid' which you've previously
> opened and has died will give you -ESRCH.

Not the case. Zombies have died, but profs operations work fine on zombies.

>> > Similarly, it seems like
>> > it's probably safe to be able to open an fd that lets you watch the
>> > exit status of a process, have the process call setresuid(), and still
>> > see the exit status.
>>
>> Is it? That's an open question.
>
> Well, if we consider wait4(2) it seems that this is already the case.
> If you fork+exec a setuid binary you can definitely see its exit code.

Only if you're the parent. Otherwise, you can't see the process exit
status unless you pass a ptrace access check and consult
/proc/pid/stat after the process dies, but before the zombie
disappears. Random unrelated and unprivileged processes can't see exit
statuses from distant parts of the system.

>> > My POLLERR hack, aside from being ugly,
>> > avoids this particular issue because it merely lets you wait for
>> > something you already could have observed using readdir().
>>
>> Yes. I mentioned this same issue-punting as the motivation behind
>> exithand, initially, just reading EOF on exit.
>
> One question I have about EOF-on-exit is that if we wish to extend it to
> allow providing the exit status (which is something we discussed in the
> original thread), how will multiple-readers be handled in such a
> scenario?
> Would we be storing the exit status or siginfo in the
> equivalent of a locked memfd?

Yes, that's what I have in mind. A siginfo_t is small enough that we
could just store it as a blob allocated off the procfs inode or
something like that without bothering with a shmfs file. You'd be able
to read(2) the exit status as many times as you wanted.
