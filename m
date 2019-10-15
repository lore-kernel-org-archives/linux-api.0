From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v4 1/2] pidfd: add NSpid entries to fdinfo
Date: Tue, 15 Oct 2019 11:40:41 +0200
Message-ID: <20191015094039.gtc637trfxmnjzw7@wittgenstein>
References: <20191011122323.7770-1-ckellner@redhat.com>
 <20191014162034.2185-1-ckellner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191014162034.2185-1-ckellner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Kellner <ckellner@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Jann Horn <jannh@google.com>, Christian Kellner <christian@kellner.me>, Christian Brauner <christian@brauner.io>, Andrew Morton <akpm@linux-foundation.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@linutronix.de>, Elena Reshetova <elena.reshetova@intel.com>, Roman Gushchin <guro@fb.com>, Andrea Arcangeli <aarcange@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Aleksa Sarai <cyphar@cyphar.com>, "Dmitry V. Levin" <ldv@altlinux.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 14, 2019 at 06:20:32PM +0200, Christian Kellner wrote:
> From: Christian Kellner <christian@kellner.me>
> 
> Currently, the fdinfo file contains the Pid field which shows the
> pid a given pidfd refers to in the pid namespace of the procfs
> instance. If pid namespaces are configured, also show an NSpid field
> for easy retrieval of the pid in all descendant pid namespaces. If
> the pid namespace of the process is not a descendant of the pid
> namespace of the procfs instance 0 will be shown as its first NSpid
> entry and no other entries will be shown. Add a block comment to
> pidfd_show_fdinfo with a detailed explanation of Pid and NSpid fields.
> 
> Co-developed-by: Christian Brauner <christian.brauner@ubuntu.com>
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> Signed-off-by: Christian Kellner <christian@kellner.me>

Thanks!
Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>

> ---
> Changes in v4:
> - Reworked to properly handle the case where the pidfd is from a
>   different branch in the pid namespace hierarchy; also add block
>   comment with an in-depth explanation (Christian Brauner)
> 
>  kernel/fork.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 52 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index bcdf53125210..782986962d47 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1695,12 +1695,63 @@ static int pidfd_release(struct inode *inode, struct file *file)
>  }
>  
>  #ifdef CONFIG_PROC_FS
> +/**
> + * pidfd_show_fdinfo - print information about a pidfd
> + * @m: proc fdinfo file
> + * @f: file referencing a pidfd
> + *
> + * Pid:
> + * This function will print the pid that a given pidfd refers to in the
> + * pid namespace of the procfs instance.
> + * If the pid namespace of the process is not a descendant of the pid
> + * namespace of the procfs instance 0 will be shown as its pid. This is
> + * similar to calling getppid() on a process whose parent is outside of
> + * its pid namespace.
> + *
> + * NSpid:
> + * If pid namespaces are supported then this function will also print
> + * the pid of a given pidfd refers to for all descendant pid namespaces
> + * starting from the current pid namespace of the instance, i.e. the
> + * Pid field and the first entry in the NSpid field will be identical.
> + * If the pid namespace of the process is not a descendant of the pid
> + * namespace of the procfs instance 0 will be shown as its first NSpid
> + * entry and no others will be shown.
> + * Note that this differs from the Pid and NSpid fields in
> + * /proc/<pid>/status where Pid and NSpid are always shown relative to
> + * the  pid namespace of the procfs instance. The difference becomes
> + * obvious when sending around a pidfd between pid namespaces from a
> + * different branch of the tree, i.e. where no ancestoral relation is
> + * present between the pid namespaces:
> + * - create two new pid namespaces ns1 and ns2 in the initial pid
> + *   namespace (also take care to create new mount namespaces in the
> + *   new pid namespace and mount procfs)
> + * - create a process with a pidfd in ns1
> + * - send pidfd from ns1 to ns2
> + * - read /proc/self/fdinfo/<pidfd> and observe that both Pid and NSpid
> + *   have exactly one entry, which is 0
> + */
>  static void pidfd_show_fdinfo(struct seq_file *m, struct file *f)
>  {
>  	struct pid_namespace *ns = proc_pid_ns(file_inode(m->file));
>  	struct pid *pid = f->private_data;
> +	pid_t nr = pid_nr_ns(pid, ns);
> +
> +	seq_put_decimal_ull(m, "Pid:\t", nr);
>  
> -	seq_put_decimal_ull(m, "Pid:\t", pid_nr_ns(pid, ns));
> +#ifdef CONFIG_PID_NS
> +	seq_put_decimal_ull(m, "\nNSpid:\t", nr);
> +	if (nr) {
> +		int i;
> +
> +		/* If nr is non-zero it means that 'pid' is valid and that

Nit: multiline kernel comment style is usually

/* 
 * bla
 * bla
 */

but I'll just fix this up when applying. No need to resend.

> +		 * ns, i.e. the pid namespace associated with the procfs
> +		 * instance, is in the pid namespace hierarchy of pid.
> +		 * Start at one below the already printed level.
> +		 */
> +		for (i = ns->level + 1; i <= pid->level; i++)
> +			seq_put_decimal_ull(m, "\t", pid->numbers[i].nr);
> +	}
> +#endif
>  	seq_putc(m, '\n');
>  }
>  #endif
> -- 
> 2.21.0
> 
