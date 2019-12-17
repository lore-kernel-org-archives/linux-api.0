From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 2/4] pid: Add PIDFD_IOCTL_GETFD to fetch file
 descriptors from processes
Date: Tue, 17 Dec 2019 09:54:40 +0100
Message-ID: <CAK8P3a3G-W8s0G2-XKuDw9dRmupZSyiF6FRRAnvDt9=kMMzS8w@mail.gmail.com>
References: <20191217010001.GA14461@ircssh-2.c.rugged-nimbus-611.internal>
 <20191217015001.sp6mrhuiqrivkq3u@wittgenstein> <CAMp4zn8fzeiJVSn6EtRi6UAGh6AL3QWu=PZxw+=TAYJORjn_Sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMp4zn8fzeiJVSn6EtRi6UAGh6AL3QWu=PZxw+=TAYJORjn_Sw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: Christian Brauner <christian.brauner@ubuntu.com>, LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Tycho Andersen <tycho@tycho.ws>, Jann Horn <jannh@google.com>, Aleksa Sarai <cyphar@cyphar.com>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, gpascutto@mozilla.com, ealvarez@mozilla.com, Florian Weimer <fweimer@redhat.com>, jld@mozilla.com
List-Id: linux-api@vger.kernel.org

On Tue, Dec 17, 2019 at 3:50 AM Sargun Dhillon <sargun@sargun.me> wrote:
> On Mon, Dec 16, 2019 at 5:50 PM Christian Brauner <christian.brauner@ubuntu.com> wrote:
> > > +
> > > +#include <linux/types.h>
> > > +#include <linux/ioctl.h>
> > > +
> > > +/* options to pass in to pidfd_getfd_args flags */
> > > +#define PIDFD_GETFD_CLOEXEC (1 << 0) /* open the fd with cloexec */
> >
> > Please, make them cloexec by default unless there's a very good reason
> > not to.
> >
> For now then, should I have flags, and just say "reserved for future usage",
> or would you prefer that I drop flags entirely?

There is no need for adding reserved fields in an ioctl, just add a new ioctl
number if you need it later.

> > > +
> > > +struct pidfd_getfd_args {
> > > +     __u32 size;             /* sizeof(pidfd_getfd_args) */
> > > +     __u32 fd;       /* the tracee's file descriptor to get */
> > > +     __u32 flags;
> > > +};
> >
> > I think you want to either want to pad this
> >
> > +struct pidfd_getfd_args {
> > +       __u32 size;             /* sizeof(pidfd_getfd_args) */
> > +       __u32 fd;       /* the tracee's file descriptor to get */
> > +       __u32 flags;
> >         __u32 reserved;
> > +};
> >
> > or use __aligned_u64 everywhere which I'd personally prefer instead of
> > this manual padding everywhere.

No, don't make ioctl structures extensible. If there is no 64-bit member
in it, 32-bit alignment is sufficient.

Also, having implicit padding is dangerous because it makes it easier to
leave it uninitialized, leaking kernel stack information on the copy_to_user().

Please drop the '__u32 size' argument, too: the size is fixed by definition
(through the _IOWR macro) and if you need to extend it you get a new
command anyway.

> Wouldn't __attribute__((packed)) achieve a similar thing of making sure
> the struct is a constant size across all compilers?
>
> I'll go with __aligned_u64 instead of packed, if you don't want to use packed.

__attribute__((packed)) is worse because it forces compilers to use byte
access on architectures that have no fast unaligned 32-bit load/store.
Basically you should never put __packed on a structure, but instead add
it to members that need to be unaligned within a sturct for compatibility
reasons.

> > > +
> > > +#define PIDFD_IOC_MAGIC                      'p'
> > > +#define PIDFD_IO(nr)                 _IO(PIDFD_IOC_MAGIC, nr)
> > > +#define PIDFD_IOR(nr, type)          _IOR(PIDFD_IOC_MAGIC, nr, type)
> > > +#define PIDFD_IOW(nr, type)          _IOW(PIDFD_IOC_MAGIC, nr, type)
> > > +#define PIDFD_IOWR(nr, type)         _IOWR(PIDFD_IOC_MAGIC, nr, type)

Drop these macros, they just make it harder to grep or script around the use
of _IOWR/_IOR/_IOW

> > > +#define PIDFD_IOCTL_GETFD            PIDFD_IOWR(0xb0, \
> > > +                                             struct pidfd_getfd_args)

Without the size and flag members, this can become the simpler

#define PIDFD_IOCTL_GETFD  _IOWR('p', 0xb0, __u32)

> > > +
> > >  const struct file_operations pidfd_fops = {
> > >       .release = pidfd_release,
> > >       .poll = pidfd_poll,
> > > +     .unlocked_ioctl = pidfd_ioctl,

This needs

+    .compat_ioctl = compat_ptr_ioctl,

To work on compat tasks.

Finally, there is the question whether this should be an ioctl
operation at all, or
if it would better be done as a proper syscall. Functionally the two
are the same
here, but doing such a fundamental operation as an ioctl doesn't feel
quite right
to me. As a system call, this could be something like

int pidfd_get_fd(int pidfd, int their_fd, int flags);

along the lines of dup3().

        Arnd
