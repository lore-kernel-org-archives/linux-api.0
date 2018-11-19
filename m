From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] proc: allow killing processes via file descriptors
Date: Sun, 18 Nov 2018 17:43:34 -0800
Message-ID: <CALCETrUAX72MNB8yPmzuwjW=yvMB=CHSSdowuZNperv3aDHFcQ@mail.gmail.com>
References: <CAKOZuev1JUGFWuwsKqS6rXcFMqpCHT1VAG2kwB4O=FHo6DAFiQ@mail.gmail.com>
 <CALCETrVLP_mudJTW6EQpRr5GZ7kfuGci+QCT1uPrOVDTWcod-A@mail.gmail.com>
 <a7f50692-667c-4efe-a2d0-fa324eebb90b@infradead.org> <CAKOZueutLc8d0Fe+7dNWiZKnALhTSST8+kCnOrL+OmB6coUmtA@mail.gmail.com>
 <CALCETrVg71XBv-gMOtL-m0Dd0HNz8_oXOUDSWin5LeViAL0UYA@mail.gmail.com>
 <CAKOZuesCKo4GH9fdum2EUFLrtTWam3aizcDQUn3-vCYg4T1P8w@mail.gmail.com>
 <CALCETrUeNZPfrSYa9vH5Ukrk1Y+Kb9GkZOh6LkqG6Z9NpK5P0w@mail.gmail.com>
 <CAKOZuevVk_aH_2TuiNcmxgMa+gHXMBXz6Uu5a6TDjoxjhaE36g@mail.gmail.com>
 <CALCETrVscRwQG55-j1SKc2TmSb1-=5861804ojUuviNzdyDOrA@mail.gmail.com>
 <CAKOZuevRq-igh06zS_nsGG400zXrKFCtajpEG9-xgU2+Rtb2Pw@mail.gmail.com>
 <20181118190504.ixglsqbn6mxkcdzu@yavin> <CAKOZuetfqvn1uVqKJ=16iEzG4g449YOjC_tLM60eKBSkv9u+bQ@mail.gmail.com>
 <608F2959-800D-46EE-A7CD-8C972ACD2F02@amacapital.net> <CAKOZuet4uzYjvNznfUvid2RH8kAuxteWWc26vLhJHKSfS6MjAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuet4uzYjvNznfUvid2RH8kAuxteWWc26vLhJHKSfS6MjAA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Andrew Lutomirski <luto@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Kees Cook <keescook@chromium.org>, Jan Engelhardt <jengelh@inai.de>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 18, 2018 at 12:32 PM Daniel Colascione <dancol@google.com> wrot=
e:
>
> On Sun, Nov 18, 2018 at 12:28 PM, Andy Lutomirski <luto@amacapital.net> w=
rote:
> >> That is, I'm proposing an API that looks like this:
> >>
> >> int process_kill(int procfs_dfd, int signo, const union sigval value)
> >>
> >> If, later, process_kill were to *also* accept process-capability FDs,
> >> nothing would break.
> >
> > Except that this makes it ambiguous to the caller as to whether their c=
urrent creds are considered.  So it would need to be a different syscall or=
 at least a flag.  Otherwise a lot of those nice theoretical properties go =
away.
>
> Sure. A flag might make for better ergonomics.
>
> >> Yes, that's what I have in mind. A siginfo_t is small enough that we
> >> could just store it as a blob allocated off the procfs inode or
> >> something like that without bothering with a shmfs file. You'd be able
> >> to read(2) the exit status as many times as you wanted.
> >
> > I think that, if the syscall in question is read(2), then it should wor=
k *once* per struct file.  Otherwise running cat on the file would behave v=
ery oddly.
>
> Why? The file pointer would work normally.

Can you explain the exact semantics?  If I have an fd where read(2)
returns the same 4-byte value every time read(2) is called, then cat
will just return an infinite sequence of the same value.  This is not
a complete disaster, but it's not really a good thing.

>
> > Read and poll have the same problem as write: we can=E2=80=99t check ca=
ps in read or poll either.
>
> Why not? Reading /proc/pid/stat does an access check today and
> conditionally replaces the exit status with zero.

And that's probably a bug.  It's at least a giant kludge that we shouldn't =
copy.

Here is the general rule: the basic operations that are expected to
treat file descriptors as capabilities *must* treat file descriptors
as capabilities, at least for new APIs.  This includes read(2),
write(2), and poll(2).  We should have an exceedingly good reason to
check current's creds, mm, or anything else about current in those
syscalls.

There is a good reason for this: consider what happens if you type:

sudo >/proc/PID/whatever

or

sudo </proc/PID/whatever
