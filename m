From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v13 1/3] /proc/pid/status: Add support for architecture
 specific output
Date: Fri, 5 Apr 2019 21:32:35 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1904052129371.1802@nanos.tec.linutronix.de>
References: <20190224044400.34975-1-aubrey.li@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190224044400.34975-1-aubrey.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aubrey Li <aubrey.li@linux.intel.com>
Cc: mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, ak@linux.intel.com, tim.c.chen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, aubrey.li@intel.com, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Sun, 24 Feb 2019, Aubrey Li wrote:

> The architecture specific information of the running processes could
> be useful to the userland. Add support to examine process architecture
> specific information externally.
> 
> Signed-off-by: Aubrey Li <aubrey.li@linux.intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: Arjan van de Ven <arjan@linux.intel.com>

This really lacks

Cc: Linux API <linux-api@vger.kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>

Cc'ed now.

> ---
>  fs/proc/array.c         | 5 +++++
>  include/linux/proc_fs.h | 2 ++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 9d428d5a0ac8..ea7a981f289c 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -401,6 +401,10 @@ static inline void task_thp_status(struct seq_file *m, struct mm_struct *mm)
>  	seq_printf(m, "THP_enabled:\t%d\n", thp_enabled);
>  }
>  
> +void __weak arch_proc_pid_status(struct seq_file *m, struct task_struct *task)
> +{
> +}
> +
>  int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
>  			struct pid *pid, struct task_struct *task)
>  {
> @@ -424,6 +428,7 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
>  	task_cpus_allowed(m, task);
>  	cpuset_task_status_allowed(m, task);
>  	task_context_switch_counts(m, task);
> +	arch_proc_pid_status(m, task);
>  	return 0;
>  }
>  
> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
> index d0e1f1522a78..1de9ba1b064f 100644
> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -73,6 +73,8 @@ struct proc_dir_entry *proc_create_net_single_write(const char *name, umode_t mo
>  						    int (*show)(struct seq_file *, void *),
>  						    proc_write_t write,
>  						    void *data);
> +/* Add support for architecture specific output in /proc/pid/status */
> +extern void arch_proc_pid_status(struct seq_file *m, struct task_struct *task);
>  
>  #else /* CONFIG_PROC_FS */
>  
> -- 
> 2.17.1
> 
> 
