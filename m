From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v7 5/6] seccomp: add a way to pass FDs via a notification fd
Date: Thu, 27 Sep 2018 18:39:02 +0200
Message-ID: <CAG48ez2vJJQm8-Rdz4b=cvBQn2Ws-9wazVuVUXQFYqMMZh64YA@mail.gmail.com>
References: <20180927151119.9989-1-tycho@tycho.ws> <20180927151119.9989-6-tycho@tycho.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927151119.9989-6-tycho@tycho.ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, kernel list <linux-kernel@vger.kernel.org>, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, suda.akihiro@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Sep 27, 2018 at 5:11 PM Tycho Andersen <tycho@tycho.ws> wrote:
> This patch adds a way to insert FDs into the tracee's process (also
> close/overwrite fds for the tracee). This functionality is necessary to
> mock things like socketpair() or dup2() or similar, but since it depends on
> external (vfs) patches, I've left it as a separate patch as before so the
> core functionality can still be merged while we argue about this. Except
> this time it doesn't add any ugliness to the API :)
[...]
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 17685803a2af..07a05ad59731 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -41,6 +41,8 @@
>  #include <linux/tracehook.h>
>  #include <linux/uaccess.h>
>  #include <linux/anon_inodes.h>
> +#include <linux/fdtable.h>
> +#include <net/cls_cgroup.h>
>
>  enum notify_state {
>         SECCOMP_NOTIFY_INIT,
> @@ -1684,6 +1686,56 @@ static long seccomp_notify_id_valid(struct seccomp_filter *filter,
>         return ret;
>  }
>
> +static long seccomp_notify_put_fd(struct seccomp_filter *filter,
> +                                 unsigned long arg)
> +{
> +       struct seccomp_notif_put_fd req;
> +       void __user *buf = (void __user *)arg;
> +       struct seccomp_knotif *knotif = NULL;
> +       long ret;
> +
> +       if (copy_from_user(&req, buf, sizeof(req)))
> +               return -EFAULT;
> +
> +       if (req.fd < 0 && req.to_replace < 0)
> +               return -EINVAL;
> +
> +       ret = mutex_lock_interruptible(&filter->notify_lock);
> +       if (ret < 0)
> +               return ret;
> +
> +       ret = -ENOENT;
> +       list_for_each_entry(knotif, &filter->notif->notifications, list) {
> +               struct file *file = NULL;
> +
> +               if (knotif->id != req.id)
> +                       continue;
> +
> +               if (req.fd >= 0)
> +                       file = fget(req.fd);

So here we take a reference on `file`.

> +               if (req.to_replace >= 0) {
> +                       ret = replace_fd_task(knotif->task, req.to_replace,
> +                                             file, req.fd_flags);

Then here we try to place the file in knotif->task's file descriptor
table. This can either fail (e.g. due to exceeded rlimit), in which
case nothing happens, or it can do do_dup2(), which first takes an
extra reference to the file, then places it in the task's fd table.

Either way, afterwards, we still hold a reference to the file.

> +               } else {
> +                       unsigned long max_files;
> +
> +                       max_files = task_rlimit(knotif->task, RLIMIT_NOFILE);
> +                       ret = __alloc_fd(knotif->task->files, 0, max_files,
> +                                        req.fd_flags);
> +                       if (ret < 0)
> +                               break;

If we bail out here, we still hold a reference to `file`.

Suggestion: Change this to "if (ret >= 0) {" and make the following
code conditional instead of breaking.

> +                       __fd_install(knotif->task->files, ret, file);

But if we reach this point, __fd_install() consumes the file pointer,
so `file` is a dangling pointer now.

Suggestion: Add "break;" here.

> +               }

Suggestion: Add "if (file != NULL) fput(file);" here.

> +               break;
> +       }
> +
> +       mutex_unlock(&filter->notify_lock);
> +       return ret;
> +}
