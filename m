From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] proc: allow killing processes via file descriptors
Date: Sun, 18 Nov 2018 08:17:55 -0800
Message-ID: <CALCETrVLP_mudJTW6EQpRr5GZ7kfuGci+QCT1uPrOVDTWcod-A@mail.gmail.com>
References: <20181118111751.6142-1-christian@brauner.io> <CAKOZuet3s0WxxPgrtrNkq8YiOWhYAiK6yEio6PKVV9J_H4_TSA@mail.gmail.com>
 <CALCETrUd2Y2MmO8Qx8aUvQDOTNiyj35Y7bctPBZe0p2i1EUiLw@mail.gmail.com> <CAKOZuev1JUGFWuwsKqS6rXcFMqpCHT1VAG2kwB4O=FHo6DAFiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuev1JUGFWuwsKqS6rXcFMqpCHT1VAG2kwB4O=FHo6DAFiQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Andrew Lutomirski <luto@kernel.org>, Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 18, 2018 at 7:53 AM Daniel Colascione <dancol@google.com> wrote:
>
> On Sun, Nov 18, 2018 at 7:38 AM, Andy Lutomirski <luto@kernel.org> wrote:
> > I fully agree that a more comprehensive, less expensive API for
> > managing processes would be nice.  But I also think that this patch
> > (using the directory fd and ioctl) is better from a security
> > perspective than using a new file in /proc.
>
> That's an assertion, not an argument. And I'm not opposed to an
> operation on the directory FD, now that it's clear Linus has banned
> "write(2)-as-a-command" APIs. I just insist that we implement the API
> with a system call instead of a less-reliable ioctl due to the
> inherent namespace collision issues in ioctl command names.

Linus banned it because of bugs iike the ones in the patch.

>
> > I have an old patch to make proc directory fds pollable:
> >
> > https://lore.kernel.org/patchwork/patch/345098/
> >
> > That patch plus the one in this thread might make a nice addition to
> > the kernel even if we expect something much better to come along
> > later.
>
> I've always commented on that patch. You never addressed my technical
> objections. Why are you bringing up this patch again as if that
> discussion had never happened? To review, that patch has various race
> conditions

I don't think I ever saw that review.

> and even if it were technically correct, it'd be an abuse
> of directory objects (in what other circumstance do we poll
> directories?) and not logically generalizable to a model in which we
> expose process exit status via the exit-monitoring API.

I agree it's weird.  It might be better to have /proc/PID/exit_status
and make *that* pollable.
