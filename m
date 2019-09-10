From: Daniel Colascione <dancol@google.com>
Subject: Re: [RFC] Add critical process prctl
Date: Tue, 10 Sep 2019 10:42:43 -0700
Message-ID: <CAKOZuevMiomDQwzrHVb4qU6nhKOiENWsEmFhVKrBvjVNa0ff+w@mail.gmail.com>
References: <20190905005313.126823-1-dancol@google.com> <CALCETrU2Wycgdfo8vLZQUnx1J9ro=6ddSkP37BhsfBkKL1mbMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrU2Wycgdfo8vLZQUnx1J9ro=6ddSkP37BhsfBkKL1mbMA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Tim Murray <timmurray@google.com>, Suren Baghdasaryan <surenb@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 10, 2019 at 9:57 AM Andy Lutomirski <luto@kernel.org> wrote:
>
> On Wed, Sep 4, 2019 at 5:53 PM Daniel Colascione <dancol@google.com> wrote:
> >
> > A task with CAP_SYS_ADMIN can mark itself PR_SET_TASK_CRITICAL,
> > meaning that if the task ever exits, the kernel panics. This facility
> > is intended for use by low-level core system processes that cannot
> > gracefully restart without a reboot. This prctl allows these processes
> > to ensure that the system restarts when they die regardless of whether
> > the rest of userspace is operational.
>
> The kind of panic produced by init crashing is awful -- logs don't get
> written, etc.

True today --- but that's a separate problem, and one that can be
solved in a few ways, e.g., pre-registering log buffers to be
incorporated into any kexec kernel memory dumps. If a system aiming
for reliability can't diagnose panics, that's a problem with or
without my patch.

> I'm wondering if you would be better off with a new
> watchdog-like device that, when closed, kills the system in a
> configurable way (e.g. after a certain amount of time, while still
> logging something and having a decent chance of getting the logs
> written out.)  This could plausibly even be an extension to the
> existing /dev/watchdog API.

There are lots of approaches that work today: a few people have
suggested just having init watch processes, perhaps with pidfds. What
I worry about is increasing the length (both in terms of time and
complexity) of the critical path between something going wrong in a
critical process and the system getting back into a known-good state.
A panic at the earliest moment we know that a marked-critical process
has become doomed seems like the most reliable approach, especially
since alternatives can get backed up behind things like file
descriptor closing and various forms of scheduling delay.
