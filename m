From: Dmitry Safonov <0x7f454c46@gmail.com>
Subject: Re: [PATCH] proc: allow killing processes via file descriptors
Date: Mon, 19 Nov 2018 16:13:30 +0000
Message-ID: <CAJwJo6aXQUtciO7kPSENoajV6JUqUGJxCh_0yPf5D8GfbLegzA@mail.gmail.com>
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
Cc: dancol@google.com, rdunlap@infradead.org, christian@brauner.io, "Eric W. Biederman" <ebiederm@xmission.com>, open list <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>, jannh@google.com, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, cyphar@cyphar.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, timmurray@google.com, Kees Cook <keescook@chromium.org>, jengelh@inai.de, Andrei Vagin <avagin@gmail.com>
List-Id: linux-api@vger.kernel.org

On Sun, 18 Nov 2018 at 18:30, Andy Lutomirski <luto@kernel.org> wrote:
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
>
> >
> > > setresuid() has no effect
> > > here -- if you have W access to the process and the process calls
> > > setresuid(), you still have W access.
> >
> > Now you've created a situation in which an operation that security
> > policy previously blocked now becomes possible, invaliding previous
> > designs based on the old security invariant. That's the definition of
> > introducing a security hole.
>
> I think you're overstating your case.  To a pretty good approximation,
> setresuid() allows the caller to remove elements from the set {ruid,
> suid, euid}, unless the caller has CAP_SETUID.  If you could ptrace a
> process before it calls setresuid(), you might as well be able to
> ptrace() it after, since you could have just ptraced it and made it
> call setresuid() while still ptracing it.  Similarly, it seems like
> it's probably safe to be able to open an fd that lets you watch the
> exit status of a process, have the process call setresuid(), and still
> see the exit status.
>
> Regardless of how you feel about these issues, if you're going to add
> an API by which you open an fd, wait for a process to exit, and read
> the exit status, you need to define the conditions under which you may
> open the fd and under which you may read the exit status once you have
> the fd.  There are probably multiple valid answers, but the question
> still needs to be answered.  My POLLERR hack, aside from being ugly,
> avoids this particular issue because it merely lets you wait for
> something you already could have observed using readdir().

Beg your pardon for hijacking the thread..

I wonder how fast it would be holding a pid with another open()ed fd.
And then you need to read comm (or how you filter whom to kill).
It seems to me that procfs will be even slower with this safe-way.
But I might misunderstand the idea, excuses.

So, I just wanted to gently remind about procfs with netlink socket[1].
It seems to me that whenever you receive() pid information, you
can request some uniq 64(?) bit number and kill the process using it.
Whenever uniqueness of 64-bit number to handle pids will be a question
the netlink message might be painlessly extended to 128 or whatever.

Also, it may provide the facilities to atomically kill process say by name
by adding another field to netlink message.

Probably, if it's time to add a new API for procfs, netlink may be more
desirable.

[1]: https://lwn.net/Articles/650243/

Thanks,
             Dmitry
