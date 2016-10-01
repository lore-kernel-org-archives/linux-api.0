From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 1/3] proc: Stop reporting eip and esp in /proc/PID/stat
Date: Fri, 30 Sep 2016 19:01:13 -0700
Message-ID: <CALCETrUBmsoUK5Shkjwo6n=BGaHFtZhhUZ=2uOcAzWUend-BXg@mail.gmail.com>
References: <cover.1475257877.git.luto@kernel.org> <a5fed4c3f4e33ed25d4bb03567e329bc5a712bcc.1475257877.git.luto@kernel.org>
 <20160930185642.GH14666@pc.thejh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160930185642.GH14666-J1fxOzX/cBvk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[cc: PeterZ]

On Fri, Sep 30, 2016 at 11:56 AM, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org> wrote:
> On Fri, Sep 30, 2016 at 10:58:56AM -0700, Andy Lutomirski wrote:
>> Reporting these fields on a non-current task is dangerous.  If the
>> task is in any state other than normal kernel code, they may contain
>> garbage or even kernel addresses on some architectures.
>
> Stupid question: Doesn't something similar apply to wchan?
> Am I missing something?
>
> It looks to me as if the get_wchan() implementation of X86 has the same
> issue, with the difference that it's not obviously usable as an infoleak
> because only known symbol names are printed, not numeric values.
>
> get_wchan() basically does the following:
>
>  - make sure the remote thread is sleeping (but don't take any locks to
>    ensure it stays that way)

Peter, how nasty would it be to add some lightish-weight lock that
lets us pin a task in a non-running state?  Maybe we could take the rq
lock, do something to the task to make it sleepy (steal it off the
queue?), unlock the lock, do whatever we're going, then take the lock
again and put it back.

Or if we had a seqlock-like thing, we could maybe arrange for
get_wchan to abort if the task get scheduled between when it starts
and when it finishes.

On an unrelated note, can we please lock down all the silly historical
*userspace* info leaks in /proc?  Nasty ones include: net, cmdline (at
the very least, only argv[0] should be visible if the reader lacks
ptrace access).

Less nasty ones include: limits, sched, autogroup, comm, wchan,
schedstat, cpuset, cgroup, oom_*, sessionid, coredump_filter

uid_map, gid_map, etc are just screwed up.  They should be per
*namespace* somewhere, and they should require creds on the namespace.

timerslack is totally fscked up -- it allows ugo to write and it
checks the wrong creds.  Jann, does your series fix that?

--Andy
