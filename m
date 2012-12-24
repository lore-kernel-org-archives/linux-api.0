From: Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 3/4] signalfd: add ability to choose a private or shared queue
Date: Mon, 24 Dec 2012 21:53:33 +0100
Message-ID: <CAHO5Pa2TY3fVs4fFNdhrRN79QkVrWhR_sxD1JoEt-wSwCSN8_A@mail.gmail.com>
References: <1356336807-5517-1-git-send-email-avagin@openvz.org> <1356336807-5517-4-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1356336807-5517-4-git-send-email-avagin@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org, linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

[CC+=linux-api]

Andrey,

(Among other things, some suggested wording fixes below to improve the
eventual commit log entry).

On Mon, Dec 24, 2012 at 9:13 AM, Andrey Vagin <avagin@openvz.org> wrote:
> This patch is added two flags SFD_GROUP and SFD_SHARED.
> SFD_SHARED - read signals from a shared queue
> SFD_PRIVATE - read signals from a private queue

These names and comments are not quite meaningful I find. Also, you
use SFD_SHARED here, but the name below is SFD_GROUP. I had to read
further to confirm what I guessed the names meant. How about these
names and comments:

SFD_SHARED_QUEUE - read signals from a shared (process wide) queue
SFD_PER_THREAD_QUEUE - read signals from a per-thread queue

> Without this flags or with both flags signals are read from both queues.

Without these flags

> This functionality is requered for dumping pending signals.

"required"

> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> CC: Cyrill Gorcunov <gorcunov@openvz.org>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> ---
>  fs/signalfd.c                 | 25 +++++++++++++++++++------
>  include/uapi/linux/signalfd.h |  2 ++
>  2 files changed, 21 insertions(+), 6 deletions(-)
>
> diff --git a/fs/signalfd.c b/fs/signalfd.c
> index 95f1444..a35aeda 100644
> --- a/fs/signalfd.c
> +++ b/fs/signalfd.c
> @@ -170,13 +170,13 @@ static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
>  }
>
>  static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
> -                               int nonblock)
> +                               int nonblock, int queue)
>  {
>         ssize_t ret;
>         DECLARE_WAITQUEUE(wait, current);
>
>         spin_lock_irq(&current->sighand->siglock);
> -       ret = dequeue_signal(current, &ctx->sigmask, info);
> +       ret = do_dequeue_signal(current, &ctx->sigmask, info, queue);
>         switch (ret) {
>         case 0:
>                 if (!nonblock)
> @@ -223,14 +223,21 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
>         bool raw = file->f_flags & SFD_RAW;
>         ssize_t ret, total = 0;
>         siginfo_t info;
> +       int queue = 0;
>
>         count /= sizeof(struct signalfd_siginfo);
>         if (!count)
>                 return -EINVAL;
>
> +       if (file->f_flags & SFD_GROUP)
> +               queue++;
> +
> +       if (file->f_flags & SFD_PRIVATE)
> +               queue--;
> +
>         siginfo = (struct signalfd_siginfo __user *) buf;
>         do {
> -               ret = signalfd_dequeue(ctx, &info, nonblock);
> +               ret = signalfd_dequeue(ctx, &info, nonblock, queue);
>                 if (unlikely(ret <= 0))
>                         break;
>
> @@ -274,6 +281,8 @@ static const struct file_operations signalfd_fops = {
>         .llseek         = noop_llseek,
>  };
>
> +#define SIGNAFD_FLAGS (SFD_RAW | SFD_GROUP | SFD_PRIVATE)

This name is rather obtuse. What is the purpose of grouping these
three flags like this? Yes, I understand how you use the name below,
but the grouping seems arbitrary.

Why not have a grouping of all SFD_ 5 flags?

#define SFD_ALL_FLAGS (SFD_CLOEXEC | SFD_NONBLOCK | SFD_RAW |
SFD_GROUP | SFD_PRIVATE)

And use that appropriately below.

See also the comments below about individual flags.


> +
>  SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
>                 size_t, sizemask, int, flags)
>  {
> @@ -284,7 +293,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
>         BUILD_BUG_ON(SFD_CLOEXEC != O_CLOEXEC);
>         BUILD_BUG_ON(SFD_NONBLOCK != O_NONBLOCK);
>
> -       if (flags & ~(SFD_CLOEXEC | SFD_NONBLOCK | SFD_RAW))
> +       if (flags & ~(SFD_CLOEXEC | SFD_NONBLOCK | SIGNAFD_FLAGS))
>                 return -EINVAL;
>
>         if (sizemask != sizeof(sigset_t) ||
> @@ -308,9 +317,9 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
>                                        O_RDWR | (flags & (O_CLOEXEC | O_NONBLOCK)));
>                 if (ufd < 0)
>                         kfree(ctx);
> -               else if (flags & SFD_RAW) {
> +               else if (flags & SIGNAFD_FLAGS) {
>                         struct fd f = fdget(ufd);
> -                       f.file->f_flags |= flags & SFD_RAW;
> +                       f.file->f_flags |= flags & SIGNAFD_FLAGS;
>                         fdput(f);
>                 }
>         } else {
> @@ -322,6 +331,10 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
>                         fdput(f);
>                         return -EINVAL;
>                 }
> +
> +               f.file->f_flags = (f.file->f_flags & ~SIGNAFD_FLAGS) |
> +                                               (flags & SIGNAFD_FLAGS);
> +
>                 spin_lock_irq(&current->sighand->siglock);
>                 ctx->sigmask = sigmask;
>                 spin_unlock_irq(&current->sighand->siglock);
> diff --git a/include/uapi/linux/signalfd.h b/include/uapi/linux/signalfd.h
> index bc31849..9421321 100644
> --- a/include/uapi/linux/signalfd.h
> +++ b/include/uapi/linux/signalfd.h
> @@ -16,6 +16,8 @@
>  #define SFD_CLOEXEC O_CLOEXEC
>  #define SFD_NONBLOCK O_NONBLOCK
>  #define SFD_RAW O_DIRECT
> +#define SFD_GROUP O_DIRECTORY
> +#define SFD_PRIVATE O_EXCL

What's the reason for making these flags synonyms of existing O_*
flags, as opposed to just choosing suitable numeric values. (There is
a rationale for this, in the case of CLOEXEC and NONBLOCK, as
indicated by the names, but that rationale doesn't extend to the three
new flags.) Using synonyms here suggests that there's a relationship
between SFD_RAW and O_DIRECT and so on, when there isn't.

>  struct signalfd_siginfo {
>         __u32 ssi_signo;
> --
> 1.7.11.7

Cheers,

Michael

-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
