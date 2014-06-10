From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 3/3] timerfd: Implement write method
Date: Tue, 10 Jun 2014 22:03:12 +0200
Message-ID: <CAKgNAkiR2xt7xnkgGDg5zKfGRoPtveWG8Jjh5=aD76L6jK7C8w@mail.gmail.com>
References: <20140428212517.200264067@openvz.org> <20140428213301.507657833@openvz.org>
 <alpine.DEB.2.02.1405220643170.9695@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1405220656130.9695@ionos.tec.linutronix.de> <20140610163530.GF2243@moon>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140610163530.GF2243@moon>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[CC += linux-api@]

On Tue, Jun 10, 2014 at 6:35 PM, Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, May 22, 2014 at 06:58:19AM +0900, Thomas Gleixner wrote:
>> >
>> > So what wakes a potential waiter in read/poll?
>>
>> And who is updating timerfd_create(2) ?
>
> Thomas, could you please take a look if the approach below is acceptable?
> If it will be fine I update manpage then.
> ---
> From: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> Subject: timerfd: Implement timerfd_ioctl method to restore timerfd_ctx::ticks
>
> The read() of timerfd files allows to fetch the number of timer ticks
> while there is no way to set it back from userspace.
>
> To restore the timer's state as it was at checkpoint moment we need
> a path to bring @ticks back. Initially I thought about writing ticks
> back via write() interface but it seems such API is somehow obscure.
>
> Instead implement timerfd_ioctl() method with TFD_IOC_SET_TICKS
> command which requires CAP_SYS_RESOURCE capability to be able to
> set @ticks into arbitrary value. Note this command doesn't wake
> up readers/waiters and its purpose only to serve C/R needs
> (for same sake I wrapped code with CONFIG_CHECKPOINT_RESTORE).
> Still if needed the ioctl may be extended for new commands
> and CONFIG_CHECKPOINT_RESTORE dropped off.
>
> CC: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> CC: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> CC: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Signed-off-by: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> ---
>  fs/timerfd.c            |   31 +++++++++++++++++++++++++++++++
>  include/linux/timerfd.h |    5 +++++
>  2 files changed, 36 insertions(+)
>
> Index: linux-2.6.git/fs/timerfd.c
> ===================================================================
> --- linux-2.6.git.orig/fs/timerfd.c
> +++ linux-2.6.git/fs/timerfd.c
> @@ -313,11 +313,42 @@ static int timerfd_show(struct seq_file
>  }
>  #endif
>
> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +static long timerfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +       struct timerfd_ctx *ctx = file->private_data;
> +       int ret = 0;
> +
> +       switch (cmd) {
> +       case TFD_IOC_SET_TICKS: {
> +               u64 ticks;
> +
> +               if (!capable(CAP_SYS_RESOURCE))
> +                       return -EPERM;
> +               if (get_user(ticks, (u64 __user *)arg))
> +                       return -EFAULT;
> +               spin_lock_irq(&ctx->wqh.lock);
> +               ctx->ticks = ticks;
> +               spin_unlock_irq(&ctx->wqh.lock);
> +               break;
> +       }
> +       default:
> +               ret = -ENOTTY;
> +               break;
> +       }
> +
> +       return ret;
> +}
> +#endif
> +
>  static const struct file_operations timerfd_fops = {
>         .release        = timerfd_release,
>         .poll           = timerfd_poll,
>         .read           = timerfd_read,
>         .llseek         = noop_llseek,
> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +       .unlocked_ioctl = timerfd_ioctl,
> +#endif
>  #ifdef CONFIG_PROC_FS
>         .show_fdinfo    = timerfd_show,
>  #endif
> Index: linux-2.6.git/include/linux/timerfd.h
> ===================================================================
> --- linux-2.6.git.orig/include/linux/timerfd.h
> +++ linux-2.6.git/include/linux/timerfd.h
> @@ -11,6 +11,9 @@
>  /* For O_CLOEXEC and O_NONBLOCK */
>  #include <linux/fcntl.h>
>
> +/* For _IO helpers */
> +#include <linux/ioctl.h>
> +
>  /*
>   * CAREFUL: Check include/asm-generic/fcntl.h when defining
>   * new flags, since they might collide with O_* ones. We want
> @@ -29,4 +32,6 @@
>  /* Flags for timerfd_settime.  */
>  #define TFD_SETTIME_FLAGS (TFD_TIMER_ABSTIME | TFD_TIMER_CANCEL_ON_SET)
>
> +#define TFD_IOC_SET_TICKS      _IOW('T', 0, u64)
> +
>  #endif /* _LINUX_TIMERFD_H */



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
