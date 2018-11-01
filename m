From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC PATCH] Implement /proc/pid/kill
Date: Wed, 31 Oct 2018 21:53:50 -0700
Message-ID: <CALCETrXYbtVyWE=iKCCyWewVs-sE3i-jHv=6g-s8rV4CDOE6sg@mail.gmail.com>
References: <20181029221037.87724-1-dancol@google.com> <CAG48ez01OWYVqEo+Qf65scG7a-48tDM4Gh3BOUKY+-b9g+9itw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez01OWYVqEo+Qf65scG7a-48tDM4Gh3BOUKY+-b9g+9itw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: dancol@google.com, LKML <linux-kernel@vger.kernel.org>, timmurray@google.com, Joel Fernandes <joelaf@google.com>, surenb@google.com, Andrew Lutomirski <luto@kernel.org>, Linux API <linux-api@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 31, 2018 at 9:23 AM Jann Horn <jannh@google.com> wrote:
>
> +linux-api, Andy Lutomirski, Eric Biederman
>
> On Wed, Oct 31, 2018 at 3:12 AM Daniel Colascione <dancol@google.com> wrote:
> > Add a simple proc-based kill interface. To use /proc/pid/kill, just
> > write the signal number in base-10 ASCII to the kill file of the
> > process to be killed: for example, 'echo 9 > /proc/$$/kill'.
>
> This is a kernel API change, you should CC the linux-api list.
>
> I think that getting the semantics of this right might be easier if
> you used an ioctl handler instead of a write handler.
>
> > Semantically, /proc/pid/kill works like kill(2), except that the
> > process ID comes from the proc filesystem context instead of from an
> > explicit system call parameter. This way, it's possible to avoid races
> > between inspecting some aspect of a process and that process's PID
> > being reused for some other process.
> >
> > With /proc/pid/kill, it's possible to write a proper race-free and
> > safe pkill(1). An approximation follows. A real program might use
> > openat(2), having opened a process's /proc/pid directory explicitly,
> > with the directory file descriptor serving as a sort of "process
> > handle".
> >
> >     #!/bin/bash
> >     set -euo pipefail
> >     pat=$1
> >     for proc_status in /proc/*/status; do (
> >         cd $(dirname $proc_status)
> >         readarray proc_argv -d'' < cmdline
> >         if ((${#proc_argv[@]} > 0)) &&
> >                [[ ${proc_argv[0]} = *$pat* ]];
> >         then
> >             echo 15 > kill
> >         fi
> >     ) || true; done
> >
> > Signed-off-by: Daniel Colascione <dancol@google.com>
> > ---
> >  fs/proc/base.c | 39 +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 39 insertions(+)
> >
> > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > index 7e9f07bf260d..923d62b21e67 100644
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -205,6 +205,44 @@ static int proc_root_link(struct dentry *dentry, struct path *path)
> >         return result;
> >  }
> >
> > +static ssize_t proc_pid_kill_write(struct file *file,
> > +                                  const char __user *buf,
> > +                                  size_t count, loff_t *ppos)
> > +{
> > +       ssize_t res;
> > +       int sig;
> > +       char buffer[4];
> > +
> > +       res = -EINVAL;
> > +       if (*ppos != 0)
> > +               goto out;
> > +
> > +       res = -EINVAL;
> > +       if (count > sizeof(buffer) - 1)
> > +               goto out;
> > +
> > +       res = -EFAULT;
> > +       if (copy_from_user(buffer, buf, count))
> > +               goto out;
> > +
> > +       buffer[count] = '\0';
> > +       res = kstrtoint(strstrip(buffer), 10, &sig);
> > +       if (res)
> > +               goto out;
> > +
> > +       res = kill_pid(proc_pid(file_inode(file)), sig, 0);

Indeed, you can't do this from .write unless you manage to pass a cred
struct pointer in.  ioctl or a new syscall would be better.

--Andy
