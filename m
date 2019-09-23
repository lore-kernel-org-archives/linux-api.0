From: Daniel Colascione <dancol@google.com>
Subject: Re: For review: pidfd_open(2) manual page
Date: Mon, 23 Sep 2019 04:26:07 -0700
Message-ID: <CAKOZuetTgKjgWZpCaBz8q662MwVQ-UhrV4oWFqKEWr35mQTFLw@mail.gmail.com>
References: <90399dee-53d8-a82c-3871-9ec8f94601ce@gmail.com> <87tv939td6.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87tv939td6.fsf@mid.deneb.enyo.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fw@deneb.enyo.de>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Joel Fernandes <joel@joelfernandes.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 23, 2019 at 3:53 AM Florian Weimer <fw@deneb.enyo.de> wrote:
>
> * Michael Kerrisk:
>
> > SYNOPSIS
> >        int pidfd_open(pid_t pid, unsigned int flags);
>
> Should this mention <sys/types.h> for pid_t?
>
> > ERRORS
> >        EINVAL flags is not 0.
> >
> >        EINVAL pid is not valid.
> >
> >        ESRCH  The process specified by pid does not exist.
>
> Presumably, EMFILE and ENFILE are also possible errors, and so is
> ENOMEM.
>
> >        A  PID  file descriptor can be monitored using poll(2), select(2=
),
> >        and epoll(7).  When the process that it refers to terminates,  t=
he
> >        file descriptor indicates as readable.

The phrase "becomes readable" is simpler than "indicates as readable"
and conveys the same meaning. I agree with Florian's comment on this
point below.

> > Note, however, that in the
> >        current implementation, nothing can be read from the file descri=
p=E2=80=90
> >        tor.
>
> =E2=80=9Cis indicated as readable=E2=80=9D or =E2=80=9Cbecomes readable=
=E2=80=9D?  Will reading block?
>
> >        The  pidfd_open()  system call is the preferred way of obtaining=
 a
> >        PID file descriptor.  The alternative is to obtain a file descri=
p=E2=80=90
> >        tor by opening a /proc/[pid] directory.  However, the latter tec=
h=E2=80=90
> >        nique is possible only if the proc(5) file system is mounted; fu=
r=E2=80=90
> >        thermore,  the  file  descriptor  obtained in this way is not po=
l=E2=80=90
> >        lable.

Referring to procfs directory FDs as pidfds will probably confuse
people. I'd just omit this paragraph.

> One question is whether the glibc wrapper should fall back back to the
> /proc subdirectory if it is not available.  Probably not.

I'd prefer that glibc not provide this kind of fallback.
posix_fallocate-style emulation is, IMHO, too surprising.
