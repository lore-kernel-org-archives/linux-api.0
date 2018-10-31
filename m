From: Daniel Colascione <dancol@google.com>
Subject: Re: [RFC PATCH] Minimal non-child process exit notification support
Date: Wed, 31 Oct 2018 16:53:48 +0000
Message-ID: <CAKOZueuX6GL+rXZbtd_X2RaxF1MdNiEnHFbTRE2X8bsY9bOzuA@mail.gmail.com>
References: <20181029175322.189042-1-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029175322.189042-1-dancol@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
Cc: Tim Murray <timmurray@google.com>, Joel Fernandes <joelaf@google.com>, Daniel Colascione <dancol@google.com>
List-Id: linux-api@vger.kernel.org

+ linux-api

On Mon, Oct 29, 2018 at 5:53 PM, Daniel Colascione <dancol@google.com> wrote:
> This patch adds a new file under /proc/pid, /proc/pid/exithand.
> Attempting to read from an exithand file will block until the
> corresponding process exits, at which point the read will successfully
> complete with EOF.  The file descriptor supports both blocking
> operations and poll(2). It's intended to be a minimal interface for
> allowing a program to wait for the exit of a process that is not one
> of its children.
>
> Why might we want this interface? Android's lmkd kills processes in
> order to free memory in response to various memory pressure
> signals. It's desirable to wait until a killed process actually exits
> before moving on (if needed) to killing the next process. Since the
> processes that lmkd kills are not lmkd's children, lmkd currently
> lacks a way to wait for a proces to actually die after being sent
> SIGKILL; today, lmkd resorts to polling the proc filesystem pid
> entry. This interface allow lmkd to give up polling and instead block
> and wait for process death.
>
> Signed-off-by: Daniel Colascione <dancol@google.com>
> ---
>  fs/proc/Makefile             |   1 +
>  fs/proc/base.c               |   1 +
>  fs/proc/exithand.c           | 117 +++++++++++++++++++++++++++++++++++
>  fs/proc/internal.h           |   4 ++
>  include/linux/sched/signal.h |   7 +++
>  kernel/exit.c                |   2 +
>  kernel/signal.c              |   3 +
>  7 files changed, 135 insertions(+)
>  create mode 100644 fs/proc/exithand.c
>
> diff --git a/fs/proc/Makefile b/fs/proc/Makefile
> index ead487e80510..21322280a2c1 100644
> --- a/fs/proc/Makefile
> +++ b/fs/proc/Makefile
> @@ -27,6 +27,7 @@ proc-y        += softirqs.o
>  proc-y += namespaces.o
>  proc-y += self.o
>  proc-y += thread_self.o
> +proc-y  += exithand.o
>  proc-$(CONFIG_PROC_SYSCTL)     += proc_sysctl.o
>  proc-$(CONFIG_NET)             += proc_net.o
>  proc-$(CONFIG_PROC_KCORE)      += kcore.o
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 7e9f07bf260d..31bc6bbb6dc4 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -3006,6 +3006,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>  #ifdef CONFIG_LIVEPATCH
>         ONE("patch_state",  S_IRUSR, proc_pid_patch_state),
>  #endif
> +       REG("exithand", S_IRUGO, proc_tgid_exithand_operations),
>  };
>
>  static int proc_tgid_base_readdir(struct file *file, struct dir_context *ctx)
> diff --git a/fs/proc/exithand.c b/fs/proc/exithand.c
> new file mode 100644
> index 000000000000..358b08da6a08
> --- /dev/null
> +++ b/fs/proc/exithand.c
> @@ -0,0 +1,117 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Synchronous exit notification of non-child processes
> + *
> + * Simple file descriptor /proc/pid/exithand. Read blocks (and poll
> + * reports non-readable) until process either dies or becomes
> + * a zombie.
> + */
> +#include <linux/printk.h>
> +#include <linux/sched/signal.h>
> +#include <linux/poll.h>
> +#include "internal.h"
> +
> +static int proc_tgid_exithand_open(struct inode *inode, struct file *file)
> +{
> +       struct task_struct* task = get_proc_task(inode);
> +       /* If get_proc_task failed, it means the task is dead, which
> +        * is fine, since a subsequent read will return
> +        * immediately.  */
> +       if (task && !thread_group_leader(task))
> +               return -EINVAL;
> +       return 0;
> +}
> +
> +static ssize_t proc_tgid_exithand_read(struct file * file,
> +                                      char __user * buf,
> +                                      size_t count, loff_t *ppos)
> +{
> +       struct task_struct* task = NULL;
> +       wait_queue_entry_t wait;
> +       ssize_t res = 0;
> +       bool locked = false;
> +
> +       for (;;) {
> +               /* Retrieve the task from the struct pid each time
> +                * through the loop in case the exact struct task
> +                * changes underneath us (e.g., if in exec.c, the
> +                * execing process kills the group leader and starts
> +                * using its PID).  The struct signal should be the
> +                * same though even in this case.
> +                */
> +               task = get_proc_task(file_inode(file));
> +               res = 0;
> +               if (!task)
> +                       goto out;  /* No task?  Must have died.  */
> +
> +               BUG_ON(!thread_group_leader(task));
> +
> +               /* Synchronizes with exit.c machinery. */
> +               read_lock(&tasklist_lock);
> +               locked = true;
> +
> +               res = 0;
> +               if (task->exit_state)
> +                       goto out;
> +
> +               res = -EAGAIN;
> +               if (file->f_flags & O_NONBLOCK)
> +                       goto out;
> +
> +               /* Tell exit.c to go to the trouble of waking our
> +                * runqueue when this process gets around to
> +                * exiting. */
> +               task->signal->exithand_is_interested = true;
> +
> +               /* Even if the task identity changes, task->signal
> +                * should be invariant across the wait, making it safe
> +                * to go remove our wait record from the wait queue
> +                * after we come back from schedule.  */
> +
> +               init_waitqueue_entry(&wait, current);
> +               add_wait_queue(&wait_exithand, &wait);
> +
> +               read_unlock(&tasklist_lock);
> +               locked = false;
> +
> +               put_task_struct(task);
> +               task = NULL;
> +
> +               set_current_state(TASK_INTERRUPTIBLE);
> +               schedule();
> +               set_current_state(TASK_RUNNING);
> +               remove_wait_queue(&wait_exithand, &wait);
> +
> +               res = -ERESTARTSYS;
> +               if (signal_pending(current))
> +                       goto out;
> +       }
> +out:
> +       if (locked)
> +               read_unlock(&tasklist_lock);
> +       if (task)
> +               put_task_struct(task);
> +       return res;
> +}
> +
> +static __poll_t proc_tgid_exithand_poll(struct file *file, poll_table *wait)
> +{
> +       __poll_t mask = 0;
> +       struct task_struct* task = get_proc_task(file_inode(file));
> +       if (!task) {
> +               mask |= POLLIN;
> +       } else if (READ_ONCE(task->exit_state)) {
> +               mask |= POLLIN;
> +       } else {
> +               read_lock(&tasklist_lock);
> +               task->signal->exithand_is_interested = true;
> +               read_unlock(&tasklist_lock);
> +               poll_wait(file, &wait_exithand, wait);
> +       }
> +       return mask;
> +}
> +
> +const struct file_operations proc_tgid_exithand_operations = {
> +       .open           = proc_tgid_exithand_open,
> +       .read           = proc_tgid_exithand_read,
> +       .poll           = proc_tgid_exithand_poll,
> +};
> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index 5185d7f6a51e..1009d20475bc 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -304,3 +304,7 @@ extern unsigned long task_statm(struct mm_struct *,
>                                 unsigned long *, unsigned long *,
>                                 unsigned long *, unsigned long *);
>  extern void task_mem(struct seq_file *, struct mm_struct *);
> +
> +/* exithand.c */
> +
> +extern const struct file_operations proc_tgid_exithand_operations;
> diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
> index 13789d10a50e..44131cb6c7f4 100644
> --- a/include/linux/sched/signal.h
> +++ b/include/linux/sched/signal.h
> @@ -74,6 +74,10 @@ struct multiprocess_signals {
>         struct hlist_node node;
>  };
>
> +/* Need to stick the waitq for exithand outside process structures in
> + * case a process disappears across a poll.  */
> +extern wait_queue_head_t wait_exithand;
> +
>  /*
>   * NOTE! "signal_struct" does not have its own
>   * locking, because a shared signal_struct always
> @@ -87,6 +91,9 @@ struct signal_struct {
>         int                     nr_threads;
>         struct list_head        thread_head;
>
> +       /* Protected with tasklist_lock.  */
> +       bool                    exithand_is_interested;
> +
>         wait_queue_head_t       wait_chldexit;  /* for wait4() */
>
>         /* current thread group signal load-balancing target: */
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 0e21e6d21f35..44a4e3796f8b 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -1485,6 +1485,8 @@ void __wake_up_parent(struct task_struct *p, struct task_struct *parent)
>  {
>         __wake_up_sync_key(&parent->signal->wait_chldexit,
>                                 TASK_INTERRUPTIBLE, 1, p);
> +       if (p->signal->exithand_is_interested)
> +               __wake_up_sync(&wait_exithand, TASK_INTERRUPTIBLE, 0);
>  }
>
>  static long do_wait(struct wait_opts *wo)
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 17565240b1c6..e156d48da70a 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -454,6 +454,9 @@ void flush_sigqueue(struct sigpending *queue)
>         }
>  }
>
> +wait_queue_head_t wait_exithand =
> +       __WAIT_QUEUE_HEAD_INITIALIZER(wait_exithand);
> +
>  /*
>   * Flush all pending signals for this kthread.
>   */
> --
> 2.19.1.568.g152ad8e336-goog
>
