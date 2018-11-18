From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] proc: allow killing processes via file descriptors
Date: Sun, 18 Nov 2018 09:13:33 -0800
Message-ID: <CALCETrXNBNcASRtxTL_aO-KSj4ahPRpXKLUdHaWG3sPjsWx3CQ@mail.gmail.com>
References: <20181118111751.6142-1-christian@brauner.io> <CAKOZuet3s0WxxPgrtrNkq8YiOWhYAiK6yEio6PKVV9J_H4_TSA@mail.gmail.com>
 <CALCETrUd2Y2MmO8Qx8aUvQDOTNiyj35Y7bctPBZe0p2i1EUiLw@mail.gmail.com>
 <CAKOZuev1JUGFWuwsKqS6rXcFMqpCHT1VAG2kwB4O=FHo6DAFiQ@mail.gmail.com>
 <CALCETrVLP_mudJTW6EQpRr5GZ7kfuGci+QCT1uPrOVDTWcod-A@mail.gmail.com> <CAKOZuetuuxW+yFnyaqS5kW6gkVMstLa8D-7SgYtrLBUQB+sgDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuetuuxW+yFnyaqS5kW6gkVMstLa8D-7SgYtrLBUQB+sgDg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Andrew Lutomirski <luto@kernel.org>, Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 18, 2018 at 8:29 AM Daniel Colascione <dancol@google.com> wrote:
>
> On Sun, Nov 18, 2018 at 8:17 AM, Andy Lutomirski <luto@kernel.org> wrote:
> > On Sun, Nov 18, 2018 at 7:53 AM Daniel Colascione <dancol@google.com> wrote:
> >>
> >> On Sun, Nov 18, 2018 at 7:38 AM, Andy Lutomirski <luto@kernel.org> wrote:
> >> > I fully agree that a more comprehensive, less expensive API for
> >> > managing processes would be nice.  But I also think that this patch
> >> > (using the directory fd and ioctl) is better from a security
> >> > perspective than using a new file in /proc.
> >>
> >> That's an assertion, not an argument. And I'm not opposed to an
> >> operation on the directory FD, now that it's clear Linus has banned
> >> "write(2)-as-a-command" APIs. I just insist that we implement the API
> >> with a system call instead of a less-reliable ioctl due to the
> >> inherent namespace collision issues in ioctl command names.
> >
> > Linus banned it because of bugs iike the ones in the patch.
>
> Maybe: he didn't provide a reason. What's your point?

My point is that an API that involves a file like /proc/PID/kill is
very tricky to get right.  Here are some considerations:

1. The .write handler for the file must not behave differently
depending on current.  So we can't check the caller's creds.  (There
are legacy things that are generally buggy that look at current's
creds in write handlers.  They're legacy, and they're almost
universally at least a little bit buggy, and many have been
exploitable.)

2. Even if we have ioctl() or a new syscall on /proc/PID/kill, we at
least have to define whether *opening* kill checks any credentials.
It probably shouldn't, since I don't see what the semantics should be.

3. The current Linux kill_pid stuff doesn't take a cred parameter, so
it's not so easy to check f_cred even if we wanted to.

So the simplest implementation using /proc/PID/kill would be for .open
to do essentially nothing and for ioctl or a new syscall to check
credentials as usual.  But this seems to have no technical advantage
over just using /proc/PID itself, and it's a good deal slower, as it
requires an open/close cycle.

Now if we had an ioctlat() API, maybe it would make sense.  But we
don't, and I think it would be a bit crazy to add one.

--Andy
