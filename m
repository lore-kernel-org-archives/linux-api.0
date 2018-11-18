From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH] proc: allow killing processes via file descriptors
Date: Sun, 18 Nov 2018 10:43:52 -0800
Message-ID: <CAKOZuevRq-igh06zS_nsGG400zXrKFCtajpEG9-xgU2+Rtb2Pw@mail.gmail.com>
References: <20181118111751.6142-1-christian@brauner.io> <CAKOZuet3s0WxxPgrtrNkq8YiOWhYAiK6yEio6PKVV9J_H4_TSA@mail.gmail.com>
 <CALCETrUd2Y2MmO8Qx8aUvQDOTNiyj35Y7bctPBZe0p2i1EUiLw@mail.gmail.com>
 <CAKOZuev1JUGFWuwsKqS6rXcFMqpCHT1VAG2kwB4O=FHo6DAFiQ@mail.gmail.com>
 <CALCETrVLP_mudJTW6EQpRr5GZ7kfuGci+QCT1uPrOVDTWcod-A@mail.gmail.com>
 <a7f50692-667c-4efe-a2d0-fa324eebb90b@infradead.org> <CAKOZueutLc8d0Fe+7dNWiZKnALhTSST8+kCnOrL+OmB6coUmtA@mail.gmail.com>
 <CALCETrVg71XBv-gMOtL-m0Dd0HNz8_oXOUDSWin5LeViAL0UYA@mail.gmail.com>
 <CAKOZuesCKo4GH9fdum2EUFLrtTWam3aizcDQUn3-vCYg4T1P8w@mail.gmail.com>
 <CALCETrUeNZPfrSYa9vH5Ukrk1Y+Kb9GkZOh6LkqG6Z9NpK5P0w@mail.gmail.com>
 <CAKOZuevVk_aH_2TuiNcmxgMa+gHXMBXz6Uu5a6TDjoxjhaE36g@mail.gmail.com> <CALCETrVscRwQG55-j1SKc2TmSb1-=5861804ojUuviNzdyDOrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVscRwQG55-j1SKc2TmSb1-=5861804ojUuviNzdyDOrA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Kees Cook <keescook@chromium.org>, Jan Engelhardt <jengelh@inai.de>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 18, 2018 at 10:28 AM, Andy Lutomirski <luto@kernel.org> wrote:
> On Sun, Nov 18, 2018 at 9:51 AM Daniel Colascione <dancol@google.com> wrote:
>>
>> > I'm not entirely sure that ship has sailed.  In the kernel, we already
>> > have a bit of a distinction between a pid (and tid, etc -- I'm
>> > referring to struct pid) and a task.  If we make a new
>> > process-management API, we could put a distinction like this into the
>> > API.
>>
>> It would be a disaster to have different APIs give callers a different
>> idea of process identity over its lifetime. The precedent is
>> well-established that execve and setreuid do not change a process's
>> identity. Invaliding some identifiers but not others in response to
>> supposedly-internal things a process might do under rare circumstances
>> is creating a bug machine..
>
> Here's my point: if we're really going to make a new API to manipulate
> processes by their fd, I think we should have at least a decent idea
> of how that API will get extended in the future.  Right now, we have
> an extremely awkward situation where opening an fd in /proc requires
> certain capabilities or uids, and using those fds often also checks
> current's capabilities, and the target process may have changed its
> own security context, including gaining privilege via SUID, SGID, or
> LSM transition rules in the mean time.  This has been a huge source of
> security bugs.  It would be nice to have a model for future APIs that
> avoids these problems.
>
> And I didn't say in my proposal that a process's identity should
> fundamentally change when it calls execve().  I'm suggesting that
> certain operations that could cause a process to gain privilege or
> otherwise require greater permission to introspect (mainly execve)
> could be handled by invalidating the new process management fds.
> Sure, if init re-execs itself, it's still PID 1, but that doesn't
> necessarily mean that:
>
> fd = process_open_management_fd(1);
> [init reexecs]
> process_do_something(fd);
>
> needs to work.

PID 1 is a bad example here, because it doesn't get recycled. Other
PIDs do. The snippet you gave *does* need to work, in general, because
if exec invalidates the handle, and you need to reopen by PID to
re-establish your right to do something with the process, that process
may in fact have died between the invalidation and your reopen, and
your reopened FD may refer to some other random process.

The only way around this problem is to have two separate FDs --- one
to represent process identity, which *must* be continuous across
execve, and the other to represent some specific capability, some
ability to do something to that process. It's reasonable to invalidate
capability after execve, but it's not reasonable to invalidate
identity. In concrete terms, I don't see a big advantage to this
separation, and I think a single identity FD combined with
per-operation capability checks is sufficient. And much simpler.

>> > setresuid() has no effect
>> > here -- if you have W access to the process and the process calls
>> > setresuid(), you still have W access.
>>
>> Now you've created a situation in which an operation that security
>> policy previously blocked now becomes possible, invaliding previous
>> designs based on the old security invariant. That's the definition of
>> introducing a security hole.
>
> I think you're overstating your case.  To a pretty good approximation,
> setresuid() allows the caller to remove elements from the set {ruid,
> suid, euid}, unless the caller has CAP_SETUID.  If you could ptrace a
> process before it calls setresuid(), you might as well be able to
> ptrace() it after, since you could have just ptraced it and made it
> call setresuid() while still ptracing it.

What about a child that execs a setuid binary?

> Similarly, it seems like
> it's probably safe to be able to open an fd that lets you watch the
> exit status of a process, have the process call setresuid(), and still
> see the exit status.

Is it? That's an open question.

>
> Regardless of how you feel about these issues, if you're going to add
> an API by which you open an fd, wait for a process to exit, and read
> the exit status, you need to define the conditions under which you may
> open the fd and under which you may read the exit status once you have
> the fd.  There are probably multiple valid answers, but the question
> still needs to be answered.

Yes. That's the point I made in that previous message of mine that I referenced.

> My POLLERR hack, aside from being ugly,
> avoids this particular issue because it merely lets you wait for
> something you already could have observed using readdir().

Yes. I mentioned this same issue-punting as the motivation behind
exithand, initially, just reading EOF on exit.
