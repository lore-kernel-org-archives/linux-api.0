From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v14 1/3] /proc/pid/status: Add support for architecture
 specific output
Date: Tue, 9 Apr 2019 18:58:41 -0700
Message-ID: <CALCETrWV9SVDGQmzvZuub4aOPGyVqx7gPdk6D0s2_7j471jT_g@mail.gmail.com>
References: <20190410015326.24500-1-aubrey.li@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190410015326.24500-1-aubrey.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aubrey Li <aubrey.li@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>, Arjan van de Ven <arjan@linux.intel.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, aubrey.li@intel.com, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 9, 2019 at 6:55 PM Aubrey Li <aubrey.li@linux.intel.com> wrote:
>
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
> Cc: Linux API <linux-api@vger.kernel.org>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  fs/proc/array.c         | 5 +++++
>  include/linux/proc_fs.h | 2 ++
>  2 files changed, 7 insertions(+)
>
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 2edbb657f859..331592a61718 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -401,6 +401,10 @@ static inline void task_thp_status(struct seq_file *m, struct mm_struct *mm)
>         seq_printf(m, "THP_enabled:\t%d\n", thp_enabled);
>  }
>
> +void __weak arch_proc_pid_status(struct seq_file *m, struct task_struct *task)
> +{
> +}

This pointlessly bloats other architectures.  Do this instead in an
appropriate header:

#ifndef arch_proc_pid_status
static inline void arch_proc_pid_status(...)
{
}
#endif

Or add /proc/PID/x86_status, which sounds better in most respects to me.
