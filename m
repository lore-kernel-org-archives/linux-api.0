From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] proc: allow killing processes via file descriptors
Date: Sun, 18 Nov 2018 19:01:18 -0800
Message-ID: <CALCETrU_-PK=EoJZJSV0W1y_2tju0RzkyZvwK3ZPaYf6rvpQJg@mail.gmail.com>
References: <20181118111751.6142-1-christian@brauner.io> <CAKOZuet3s0WxxPgrtrNkq8YiOWhYAiK6yEio6PKVV9J_H4_TSA@mail.gmail.com>
 <CALCETrUd2Y2MmO8Qx8aUvQDOTNiyj35Y7bctPBZe0p2i1EUiLw@mail.gmail.com>
 <CAKOZuev1JUGFWuwsKqS6rXcFMqpCHT1VAG2kwB4O=FHo6DAFiQ@mail.gmail.com>
 <CALCETrVLP_mudJTW6EQpRr5GZ7kfuGci+QCT1uPrOVDTWcod-A@mail.gmail.com>
 <a7f50692-667c-4efe-a2d0-fa324eebb90b@infradead.org> <CAKOZueutLc8d0Fe+7dNWiZKnALhTSST8+kCnOrL+OmB6coUmtA@mail.gmail.com>
 <CALCETrVg71XBv-gMOtL-m0Dd0HNz8_oXOUDSWin5LeViAL0UYA@mail.gmail.com>
 <CAKOZuesCKo4GH9fdum2EUFLrtTWam3aizcDQUn3-vCYg4T1P8w@mail.gmail.com>
 <CALCETrUeNZPfrSYa9vH5Ukrk1Y+Kb9GkZOh6LkqG6Z9NpK5P0w@mail.gmail.com> <20181119024704.GK32577@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181119024704.GK32577@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Lutomirski <luto@kernel.org>, Daniel Colascione <dancol@google.com>, Randy Dunlap <rdunlap@infradead.org>, Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Kees Cook <keescook@chromium.org>, Jan Engelhardt <jengelh@inai.de>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 18, 2018 at 6:47 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Sun, Nov 18, 2018 at 09:42:35AM -0800, Andy Lutomirski wrote:
>
> > Now here's the kicker: if the "running program" calls execve(), it
> > goes away.  The fd gets some sort of notification that this happened
>
> Type error, parser failed.
>
> Define "fd", please.  If it's a "file descriptor", thank you do playing,
> you've lost.  That's not going to work.  If it's "opened file" (aka
> "file description" in horrible POSIXese), who's going to get notifications
> and what kind of exclusion are you going to use?

What I meant was: a program that has one of these fds would be able to
find out that an execve() happened and the program needs to refresh
its access to the target task.  This could be as simple as POLLHUP
and, if needed, some syscall indicating exactly why we got POLLHUP
(e.g. execve vs exit).

There would be some sort of indication that a program that holds an fd
pointing at an "opened file" could get -- probably poll() would return
some status indicating that execve() happened and our capability is
gone, and, if needed
