From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] proc: allow killing processes via file descriptors
Date: Sun, 18 Nov 2018 09:42:35 -0800
Message-ID: <CALCETrUeNZPfrSYa9vH5Ukrk1Y+Kb9GkZOh6LkqG6Z9NpK5P0w@mail.gmail.com>
References: <20181118111751.6142-1-christian@brauner.io> <CAKOZuet3s0WxxPgrtrNkq8YiOWhYAiK6yEio6PKVV9J_H4_TSA@mail.gmail.com>
 <CALCETrUd2Y2MmO8Qx8aUvQDOTNiyj35Y7bctPBZe0p2i1EUiLw@mail.gmail.com>
 <CAKOZuev1JUGFWuwsKqS6rXcFMqpCHT1VAG2kwB4O=FHo6DAFiQ@mail.gmail.com>
 <CALCETrVLP_mudJTW6EQpRr5GZ7kfuGci+QCT1uPrOVDTWcod-A@mail.gmail.com>
 <a7f50692-667c-4efe-a2d0-fa324eebb90b@infradead.org> <CAKOZueutLc8d0Fe+7dNWiZKnALhTSST8+kCnOrL+OmB6coUmtA@mail.gmail.com>
 <CALCETrVg71XBv-gMOtL-m0Dd0HNz8_oXOUDSWin5LeViAL0UYA@mail.gmail.com> <CAKOZuesCKo4GH9fdum2EUFLrtTWam3aizcDQUn3-vCYg4T1P8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuesCKo4GH9fdum2EUFLrtTWam3aizcDQUn3-vCYg4T1P8w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Andrew Lutomirski <luto@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Kees Cook <keescook@chromium.org>, Jan Engelhardt <jengelh@inai.de>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 18, 2018 at 9:24 AM Daniel Colascione <dancol@google.com> wrote:
> Assuming we don't broaden exit status readability (which would make a
> lot of things simpler), the exit notification mechanism must work like
> this: if you can see a process in /proc, you should be able to wait on
> it. If you learn that process's exit status through some other means
> --- e.g., you're the process's parent, you can ptrace the process, you
> have CAP_WHATEVER_IT_IS_ --- then you should be able to learn the fate
> of the process. Otherwise you just be able to learn that the process
> exited.

Sounds reasonable to me.  Except for the obvious turd that, if you
open /proc/PID/whatever, and the process calls execve(), then the
resulting semantics are awkward at best.

>
> >  Windows has an easy time of it because
>
> Windows has an easier time of it because it doesn't use an ad-hoc
> ambient authority permission model. In Windows, if you can open a
> handle to do something, that handle lets you do the thing. Period.
> There's none of this "well, I opened this process FD, but since I
> opened it, the process called setuid, so now I can't get its exit
> status" nonsense. Privilege elevation is always accomplished via a
> separate call to CreateProcessWithToken, which creates a *new* process
> with the elevated privileges. An existing process can't suddenly and
> magically become this special thing that you can't inspect, but that
> has the same PID and identity as this other process that you used to
> be able to inspect. The model is just better, because permission is
> baked into the HANDLE. Now, that ship has sailed. We're stuck with
> setreuid and exec. But let's be clear about what's causing the
> complexity.

I'm not entirely sure that ship has sailed.  In the kernel, we already
have a bit of a distinction between a pid (and tid, etc -- I'm
referring to struct pid) and a task.  If we make a new
process-management API, we could put a distinction like this into the
API.  As a straw-man proposal (highly incomplete and probably wrong,
but maybe it gets the idea across):

Have a way to get an fd that refers to a "running program".  (I'm
calling it that to distinguish it from "task" and "pid", both of which
already mean something.)  You'd be able to open such an fd given a
pid, and your permissions would be checked at that time.  R access
means you can read the running program's memory and otherwise
introspect it.  W means you can modify it's memory and otherwise mess
with it.  X means you can send it signals.  We might need more bits to
really do this right.

Now here's the kicker: if the "running program" calls execve(), it
goes away.  The fd gets some sort of notification that this happened
and there's an API to get a handle to the new running program *if the
caller has the appropriate permissions*.  setresuid() has no effect
here -- if you have W access to the process and the process calls
setresuid(), you still have W access.

To make this fully useful, we'd probably want to elaborate it with a
race-free way to track all descendents and, if needed, kill them all,
subject to permissions.

This API ought to be extensible to replace ptrace() eventually.

Does this seem like a reasonable direction to go in?
