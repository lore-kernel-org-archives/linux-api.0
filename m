From: Daniel Colascione <dancol@google.com>
Subject: Re: For review: pidfd_send_signal(2) manual page
Date: Tue, 24 Sep 2019 14:08:33 -0700
Message-ID: <CAKOZueuJ=En9=mtFvhpmsnjqMAOjVmffaVwwzpe=ieHemxH3mw@mail.gmail.com>
References: <f21dbd73-5ef4-fb5b-003f-ff4fec34a1de@gmail.com>
 <87pnjr9rth.fsf@mid.deneb.enyo.de> <20190923142325.jowzbnwjw7g7si7j@wittgenstein>
 <90dd38d5-34b3-b72f-8e5a-b51f944f22fb@gmail.com> <20190924195701.7pw2olbviieqsg5q@wittgenstein>
 <b76adb4c-826b-6493-ba75-a9863066d3b1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b76adb4c-826b-6493-ba75-a9863066d3b1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>, Florian Weimer <fw@deneb.enyo.de>, Oleg Nesterov <oleg@redhat.com>, Jann Horn <jannh@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Joel Fernandes <joel@joelfernandes.org>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 24, 2019 at 2:00 PM Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
>
> Hello Christian,
>
> >>> If you're the parent of the process you can do this without CLONE_PID=
FD:
> >>> pid =3D fork();
> >>> pidfd =3D pidfd_open();
> >>> ret =3D pidfd_send_signal(pidfd, 0, NULL, 0);
> >>> if (ret < 0 && errno =3D=3D ESRCH)
> >>>     /* pidfd refers to another, recycled process */
> >>
> >> Although there is still the race between the fork() and the
> >> pidfd_open(), right?
> >
> > Actually no and my code is even too complex.
> > If you are the parent, and this is really a sequence that obeys the
> > ordering pidfd_open() before waiting:
> >
> > pid =3D fork();
> > if (pid =3D=3D 0)
> >       exit(EXIT_SUCCESS);
> > pidfd =3D pidfd_open(pid, 0);
> > waitid(pid, ...);
> >
> > Then you are guaranteed that pidfd will refer to pid. No recycling can
> > happen since the process has not been waited upon yet (That is,
>
> D'oh! Yes, of course.

You still have a race if you're the parent and you have SIGCHLD set to
SIG_IGN though.

> > excluding special cases such as where you have a mainloop where a
> > callback reacts to a SIGCHLD event and waits on the child behind your
> > back and your next callback in the mainloop calls pidfd_open() while th=
e
> > pid has been recycled etc.).

That's a pretty common case though, especially if you're a library.

> > A race could only appear in sequences where waiting happens before
> > pidfd_open():
> >
> > pid =3D fork();
> > if (pid =3D=3D 0)
> >       exit(EXIT_SUCCESS);
> > waitid(pid, ...);
> > pidfd =3D pidfd_open(pid, 0);
> >
> > which honestly simply doesn't make any sense. So if you're the parent
> > and you combine fork() + pidfd_open() correctly things should be fine
> > without even having to verify via pidfd_send_signal() (I missed that in
> > my first mail.).
>
> Thanks for the additional detail.
>
> I added the following to the pidfd_open() page, to
> prevent people making the same thinko as me:
>
>        The following code sequence can be used to obtain a file  descrip=
=E2=80=90
>        tor for the child of fork(2):
>
>            pid =3D fork();
>            if (pid > 0) {     /* If parent */
>                pidfd =3D pidfd_open(pid, 0);
>                ...
>            }
>
>        Even  if  the  child process has already terminated by the time of
>        the pidfd_open() call, the returned file descriptor is  guaranteed
>        to refer to the child because the parent has not yet waited on the
>        child (and therefore, the child's ID has not been recycled).

I'd prefer that sample code be robust in all cases.
