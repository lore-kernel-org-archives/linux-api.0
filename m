From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v7 5/6] seccomp: add a way to pass FDs via a notification
 fd
Date: Thu, 27 Sep 2018 16:15:40 -0600
Message-ID: <20180927221540.GE15491@cisco.cisco.com>
References: <20180927151119.9989-1-tycho@tycho.ws>
 <20180927151119.9989-6-tycho@tycho.ws>
 <CAGXu5jLs1sOKMktS2MG+rer5n+cy=A8YL0LH5X0MJCdNTv8WuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jLs1sOKMktS2MG+rer5n+cy=A8YL0LH5X0MJCdNTv8WuA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Jann Horn <jannh@google.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 27, 2018 at 03:09:06PM -0700, Kees Cook wrote:
> On Thu, Sep 27, 2018 at 8:11 AM, Tycho Andersen <tycho@tycho.ws> wrote:
> > This patch adds a way to insert FDs into the tracee's process (also
> > close/overwrite fds for the tracee). This functionality is necessary to
> > mock things like socketpair() or dup2() or similar, but since it depends on
> > external (vfs) patches, I've left it as a separate patch as before so the
> > core functionality can still be merged while we argue about this. Except
> > this time it doesn't add any ugliness to the API :)
> >
> > v7: new in v7
> >
> > Signed-off-by: Tycho Andersen <tycho@tycho.ws>
> > CC: Kees Cook <keescook@chromium.org>
> > CC: Andy Lutomirski <luto@amacapital.net>
> > CC: Oleg Nesterov <oleg@redhat.com>
> > CC: Eric W. Biederman <ebiederm@xmission.com>
> > CC: "Serge E. Hallyn" <serge@hallyn.com>
> > CC: Christian Brauner <christian.brauner@ubuntu.com>
> > CC: Tyler Hicks <tyhicks@canonical.com>
> > CC: Akihiro Suda <suda.akihiro@lab.ntt.co.jp>
> > ---
> >  .../userspace-api/seccomp_filter.rst          |  16 +++
> >  include/uapi/linux/seccomp.h                  |   9 ++
> >  kernel/seccomp.c                              |  54 ++++++++
> >  tools/testing/selftests/seccomp/seccomp_bpf.c | 126 ++++++++++++++++++
> >  4 files changed, 205 insertions(+)
> >
> > diff --git a/Documentation/userspace-api/seccomp_filter.rst b/Documentation/userspace-api/seccomp_filter.rst
> > index d2e61f1c0a0b..383a8dbae304 100644
> > --- a/Documentation/userspace-api/seccomp_filter.rst
> > +++ b/Documentation/userspace-api/seccomp_filter.rst
> > @@ -237,6 +237,13 @@ The interface for a seccomp notification fd consists of two structures:
> >          __s64 val;
> >      };
> >
> > +    struct seccomp_notif_put_fd {
> > +        __u64 id;
> > +        __s32 fd;
> > +        __u32 fd_flags;
> > +        __s32 to_replace;
> > +    };
> > +
> >  Users can read via ``ioctl(SECCOMP_NOTIF_RECV)``  (or ``poll()``) on a seccomp
> >  notification fd to receive a ``struct seccomp_notif``, which contains five
> >  members: the input length of the structure, a unique-per-filter ``id``, the
> > @@ -256,6 +263,15 @@ mentioned above in this document: all arguments being read from the tracee's
> >  memory should be read into the tracer's memory before any policy decisions are
> >  made. This allows for an atomic decision on syscall arguments.
> >
> > +Userspace can also insert (or overwrite) file descriptors of the tracee using
> > +``ioctl(SECCOMP_NOTIF_PUT_FD)``. The ``id`` member is the request/pid to insert
> > +the fd into. The ``fd`` is the fd in the listener's table to send or ``-1`` if
> > +an fd should be closed instead. The ``to_replace`` fd is the fd in the tracee's
> > +table that should be overwritten, or -1 if a new fd is installed. ``fd_flags``
> > +should be the flags that the fd in the tracee's table is opened with (e.g.
> > +``O_CLOEXEC`` or similar). The return value from this ioctl is the fd number
> > +that was installed.
> > +
> >  Sysctls
> >  =======
> >
> > diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
> > index d4ccb32fe089..91d77f041fbb 100644
> > --- a/include/uapi/linux/seccomp.h
> > +++ b/include/uapi/linux/seccomp.h
> > @@ -77,6 +77,13 @@ struct seccomp_notif_resp {
> >         __s64 val;
> >  };
> >
> > +struct seccomp_notif_put_fd {
> > +       __u64 id;
> > +       __s32 fd;
> > +       __u32 fd_flags;
> > +       __s32 to_replace;
> > +};
> > +
> >  #define SECCOMP_IOC_MAGIC              0xF7
> >
> >  /* Flags for seccomp notification fd ioctl. */
> > @@ -86,5 +93,7 @@ struct seccomp_notif_resp {
> >                                         struct seccomp_notif_resp)
> >  #define SECCOMP_NOTIF_ID_VALID _IOR(SECCOMP_IOC_MAGIC, 2,      \
> >                                         __u64)
> > +#define SECCOMP_NOTIF_PUT_FD   _IOR(SECCOMP_IOC_MAGIC, 3,      \
> > +                                       struct seccomp_notif_put_fd)
> >
> >  #endif /* _UAPI_LINUX_SECCOMP_H */
> > diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> > index 17685803a2af..07a05ad59731 100644
> > --- a/kernel/seccomp.c
> > +++ b/kernel/seccomp.c
> > @@ -41,6 +41,8 @@
> >  #include <linux/tracehook.h>
> >  #include <linux/uaccess.h>
> >  #include <linux/anon_inodes.h>
> > +#include <linux/fdtable.h>
> > +#include <net/cls_cgroup.h>
> >
> >  enum notify_state {
> >         SECCOMP_NOTIFY_INIT,
> > @@ -1684,6 +1686,56 @@ static long seccomp_notify_id_valid(struct seccomp_filter *filter,
> >         return ret;
> >  }
> >
> > +static long seccomp_notify_put_fd(struct seccomp_filter *filter,
> > +                                 unsigned long arg)
> > +{
> > +       struct seccomp_notif_put_fd req;
> > +       void __user *buf = (void __user *)arg;
> > +       struct seccomp_knotif *knotif = NULL;
> > +       long ret;
> > +
> > +       if (copy_from_user(&req, buf, sizeof(req)))
> > +               return -EFAULT;
> > +
> > +       if (req.fd < 0 && req.to_replace < 0)
> > +               return -EINVAL;
> > +
> > +       ret = mutex_lock_interruptible(&filter->notify_lock);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       ret = -ENOENT;
> > +       list_for_each_entry(knotif, &filter->notif->notifications, list) {
> > +               struct file *file = NULL;
> > +
> > +               if (knotif->id != req.id)
> > +                       continue;
> > +
> > +               if (req.fd >= 0)
> > +                       file = fget(req.fd);
> 
> Shouldn't we test for !file here?

Yes. Derp.

Tycho
