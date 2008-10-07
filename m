From: "Michael Kerrisk" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] proc: show personality via /proc/pid/personality
Date: Tue, 7 Oct 2008 15:39:26 +0200
Message-ID: <517f3f820810070639q549ed2a1pe297e45108dfa007@mail.gmail.com>
References: <20081002211424.GJ10632@outflux.net>
	 <20081004145149.52c34ee7@infradead.org>
	 <20081004220220.GK10632@outflux.net>
	 <20081004164239.0c1483a4@infradead.org>
	 <20081005004233.GL10632@outflux.net>
	 <20081004174843.6fe48a8e@infradead.org>
	 <20081005091120.GA21003@x200.localdomain>
	 <20081005101438.GR10632@outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081005101438.GR10632-oSa+0FWJbaXR7s880joybQ@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <kees.cook-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Kees,

On Sun, Oct 5, 2008 at 12:14 PM, Kees Cook <kees.cook-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> Make process personality flags visible in /proc.  Since a process's
> personality is potentially sensitive (e.g. READ_IMPLIES_EXEC), make this
> file only readable by the process owner.

Please CC userland interface changes to linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Ceers,

Michael

> Signed-off-by: Kees Cook <kees.cook-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
> Please revert the prior patch against the "status" file -- this is the
> alternative.
> ---
>  fs/proc/array.c    |    8 ++++++++
>  fs/proc/base.c     |    2 ++
>  fs/proc/internal.h |    2 ++
>  3 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 71c9be5..6b6b492 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -337,6 +337,14 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
>        return 0;
>  }
>
> +int proc_pid_personality(struct seq_file *m, struct pid_namespace *ns,
> +                       struct pid *pid, struct task_struct *task)
> +{
> +       seq_printf(m, "%08x\n", task->personality);
> +
> +       return 0;
> +}
> +
>  static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
>                        struct pid *pid, struct task_struct *task, int whole)
>  {
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index a28840b..c675c62 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2459,6 +2459,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>        REG("environ",    S_IRUSR, environ),
>        INF("auxv",       S_IRUSR, pid_auxv),
>        ONE("status",     S_IRUGO, pid_status),
> +       ONE("personality", S_IRUSR, pid_personality),
>        INF("limits",     S_IRUSR, pid_limits),
>  #ifdef CONFIG_SCHED_DEBUG
>        REG("sched",      S_IRUGO|S_IWUSR, pid_sched),
> @@ -2794,6 +2795,7 @@ static const struct pid_entry tid_base_stuff[] = {
>        REG("environ",   S_IRUSR, environ),
>        INF("auxv",      S_IRUSR, pid_auxv),
>        ONE("status",    S_IRUGO, pid_status),
> +       ONE("personality", S_IRUSR, pid_personality),
>        INF("limits",    S_IRUSR, pid_limits),
>  #ifdef CONFIG_SCHED_DEBUG
>        REG("sched",     S_IRUGO|S_IWUSR, pid_sched),
> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index 4422023..747e3de 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -53,6 +53,8 @@ extern int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns,
>                                struct pid *pid, struct task_struct *task);
>  extern int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
>                                struct pid *pid, struct task_struct *task);
> +extern int proc_pid_personality(struct seq_file *m, struct pid_namespace *ns,
> +                               struct pid *pid, struct task_struct *task);
>  extern int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
>                                struct pid *pid, struct task_struct *task);
>  extern loff_t mem_lseek(struct file *file, loff_t offset, int orig);
> --
> 1.5.6.3
>
>
> --
> Kees Cook
> Ubuntu Security Team
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/ Found a documentation bug?
http://www.kernel.org/doc/man-pages/reporting_bugs.html
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
