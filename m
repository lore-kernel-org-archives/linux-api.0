From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 0/4] pid: add pidctl()
Date: Mon, 25 Mar 2019 21:34:00 +0100
Message-ID: <CAG48ez1ZVKgwfQDYT1k4pB4-8Y8Ywv12dabh5KFFxtKmT-e7Cw@mail.gmail.com>
References: <20190325162052.28987-1-christian@brauner.io> <CAKOZueuJSAiKU7fZR2FNDKKCktdyE-sADtWprpsNMAqYQvD9Jw@mail.gmail.com>
 <20190325173614.GB25975@google.com> <CAKOZuetbZOs1Yur4OrW6hh3wVYdoKNkSqTszbpTWnuRBTmT9zA@mail.gmail.com>
 <CAGLj2rE1f4x36KFUjFLiFq8tF1RUmFuCSRTg_tCQ9W2G6LtizA@mail.gmail.com>
 <CAKOZuetCFgu0B53+mGmQ3+539MPT_tiu-PACx2ATvihHrrmUKg@mail.gmail.com>
 <CAGLj2rHETs+FjkOVP6PJ_EiePP7FKiDwxaWyjwg1gMZPYpU1fQ@mail.gmail.com> <CAKOZueuYMKdkt8BoSj1+p7=mpe2PA8r7xT5QiF6q3cTK+6HsAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZueuYMKdkt8BoSj1+p7=mpe2PA8r7xT5QiF6q3cTK+6HsAA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Jonathan Kowalski <bl0pbl33p@gmail.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <christian@brauner.io>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarat>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 25, 2019 at 9:15 PM Daniel Colascione <dancol@google.com> wrote:
> On Mon, Mar 25, 2019 at 12:42 PM Jonathan Kowalski <bl0pbl33p@gmail.com> wrote:
> > On Mon, Mar 25, 2019 at 6:57 PM Daniel Colascione <dancol@google.com> wrote:
[...]
> > Yes, but everything in /proc is not equivalent to an attribute, or an
> > option, and depending on its configuration, you may not want to allow
> > processes to even be able to see /proc for any PIDs other than those
> > running as their own user (hidepid). This means, even if this new
> > system call is added, to respect hidepid, it must, depending on if
> > /proc is mounted (and what hidepid is set to, and what gid= is set
> > to), return EPERM, because then there is a discrepancy between how the
> > two entrypoints to acquire a process handle do access control.
>
> That's why I proposed that this translation mechanism accept a procfs
> root directory --- so you'd specify *which* procfs you want and let
> the kernel apply whatever hidepid access restrictions it wants.
[...]
> > > and 2) it's
> > > "fail unsafe": IMHO, most users in practice will skip the line marked
> > > "LIVENESS CHECK", and as a result, their code will appear to work but
> > > contain subtle race conditions. An explicit interface to translate
> > > from a (PIDFD, PROCFS_ROOT) tuple to a /proc/pid directory file
> > > descriptor would be both more efficient and fail-safe.
> > >
> > > [1] as a separate matter, it'd be nice to have a batch version of close(2).
> >
> > Since /proc is full of gunk,
>
> People keep saying /proc is bad, but I haven't seen any serious
> proposals for a clean replacement. :-)
>
> > how about adding more to it and making
> > the magic symlink of /proc/self/fd for the pidfd to lead to the dirfd
> > of the /proc entry of the process it maps to, when one uses
> > O_DIRECTORY while opening it? Otherwise, it behaves as it does today.
> > It would be equivalent to opening the proc entry with usual access
> > restrictions (and hidepid made to work) but without the races, and
> > because for processes outside your and children pid ns, it shouldn't
> > work anyway, and since they wouldn't have their entry on this procfs
> > instance, it would all just fit in nicely?
>
> Thanks. That'll work. It's a bit magical, but /proc/self/fd is magical
> anyway, so that's okay.

Please don't do that. /proc/$pid/fd refers to the set of file
descriptors the process has open, and semantically doesn't have much
to do with the identity of the process. If you want to have a procfs
directory entry for getting a pidfd, please add a new entry. (Although
I don't see the point in adding a new procfs entry for this when you
could instead have an ioctl or syscall operating on the procfs
directory fd.)
