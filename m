From: Jonathan Kowalski <bl0pbl33p@gmail.com>
Subject: Re: [PATCH v2 2/5] pid: add pidfd_open()
Date: Sat, 30 Mar 2019 14:51:09 +0000
Message-ID: <CAGLj2rGH9FLoydpDZtp9nGHGmpkJQQNaHQvZ9iTtgCnUCFPmYg@mail.gmail.com>
References: <20190329155425.26059-1-christian@brauner.io> <20190329155425.26059-3-christian@brauner.io>
 <f0d590b96b7d11ae21a9a06040b8ffa85fa74e2a.camel@bitron.ch> <20190330143726.6aaxz4sctu3pzpyx@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190330143726.6aaxz4sctu3pzpyx@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: =?UTF-8?Q?J=C3=BCrg_Billeter?= <j@bitron.ch>, torvalds@linux-foundation.org, Jann Horn <jannh@google.com>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
List-Id: linux-api@vger.kernel.org

On Sat, Mar 30, 2019 at 2:37 PM Christian Brauner <christian@brauner.io> wr=
ote:
>
> On Sat, Mar 30, 2019 at 12:53:57PM +0100, J=C3=BCrg Billeter wrote:
> > On Fri, 2019-03-29 at 16:54 +0100, Christian Brauner wrote:
> > > diff --git a/include/uapi/linux/wait.h b/include/uapi/linux/wait.h
> > > index ac49a220cf2a..d6c7c0701997 100644
> > > --- a/include/uapi/linux/wait.h
> > > +++ b/include/uapi/linux/wait.h
> > > @@ -18,5 +18,7 @@
> > >  #define P_PID              1
> > >  #define P_PGID             2
> > >
> > > +/* Get a file descriptor for /proc/<pid> of the corresponding pidfd
> > > */
> > > +#define PIDFD_GET_PROCFD _IOR('p', 1, int)
> > >
> > >  #endif /* _UAPI_LINUX_WAIT_H */
> >
> > This is missing an entry in Documentation/ioctl/ioctl-number.txt and is
> > actually conflicting with existing entries.
>
> Thanks. Yes, Jann mentioned this too.
>
> >
> > However, I'd actually prefer a syscall to allow strict whitelisting via
> > seccomp and avoid the other ioctl disadvantages that Daniel has already
> > mentioned.
>
> You can filter ioctls with seccomp.
>

You probably wouldn't even need to, because the only way the ioctl
would be useful is to have a dir fd to the procfs root. As such, the
pidfd file descriptor itself is useless with the ioctl. There's also
no filtering to be done, as one pidfd strictly maps to a specific
task, so it's not that you get access to other things than what you
weren't permitted to, and that's pretty neat the way it is. If /proc
is not mounted in its namespace, you'd need to pass it to the process
explicitly, and if it is, then it doesn't matter anyway (even if it
can open /proc, hidepid based restrictions still work -- it's
essentially a race free openat).
