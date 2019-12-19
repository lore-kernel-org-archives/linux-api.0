From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 2/5] pid: Add PIDFD_IOCTL_GETFD to fetch file
 descriptors from processes
Date: Thu, 19 Dec 2019 09:03:09 +0100
Message-ID: <CAK8P3a2eT=bHkUamyp-P3Y2adNq1KBk7UknCYBY5_aR4zJmYaQ@mail.gmail.com>
References: <20191218235459.GA17271@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191218235459.GA17271@ircssh-2.c.rugged-nimbus-611.internal>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Tycho Andersen <tycho@tycho.ws>, Jann Horn <jannh@google.com>, Aleksa Sarai <cyphar@cyphar.com>, Christian Brauner <christian.brauner@ubuntu.com>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, gpascutto@mozilla.com, ealvarez@mozilla.com, Florian Weimer <fweimer@redhat.com>, jld@mozilla.com
List-Id: linux-api@vger.kernel.org

On Thu, Dec 19, 2019 at 12:55 AM Sargun Dhillon <sargun@sargun.me> wrote:

> +#define PIDFD_IOCTL_GETFD      _IOWR('p', 0xb0, __u32)

This describes an ioctl command that reads and writes a __u32 variable
using a pointer passed as the argument, which doesn't match the
implementation:

> +static long pidfd_getfd(struct pid *pid, u32 fd)
> +{
...
> +       return retfd;

This function passes an fd as the argument and returns a new
fd, so the command number would be

#define PIDFD_IOCTL_GETFD      _IO('p', 0xb0)

While this implementation looks easy enough, and it is roughly what
I would do in case of a system call, I would recommend for an ioctl
implementation to use the __u32 pointer instead:

static long pidfd_getfd_ioctl(struct pid *pid, u32 __user *arg)
{
         int their_fd, new_fd;
         int ret;

         ret = get_user(their_fd, arg);
         if (ret)
              return ret;

        new_fd = pidfd_getfd(pid, their_fd);
        if (new_fd < 0)
                return new_fd;

         return put_user(new_fd, arg);
}

Direct argument passing in ioctls may confuse readers because it
is fairly unusual, and it doesn't work with this:

>  const struct file_operations pidfd_fops = {
>         .release = pidfd_release,
>         .poll = pidfd_poll,
> +       .unlocked_ioctl = pidfd_ioctl,
> +       .compat_ioctl = compat_ptr_ioctl,

compat_ptr_ioctl() only works if the argument is a pointer, as it
mangles the argument to turn it from a 32-bit pointer value into
a 64-bit pointer value. These are almost always the same
(arch/s390 being the sole exception), but you should not rely
on it. For now it would be find to do '.compat_ioctl = pidfd_ioctl',
but that in turn is wrong if you ever add another ioctl command
that does pass a pointer.

       Arnd
