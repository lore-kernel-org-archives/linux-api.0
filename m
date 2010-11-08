From: Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 18/23] sys-rq: Add option to soft dump
Date: Mon, 8 Nov 2010 13:09:39 -0800
Message-ID: <20101108130939.13436673.randy.dunlap@oracle.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
	<20101108203322.22479.47929.stgit@crlf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101108203322.22479.47929.stgit-+dUuAhMFdFN6FDdRrpk8kO4/NqBCd+6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 08 Nov 2010 12:33:23 -0800 Mike Waychison wrote:

> It is very useful to provide some means to force the kernel logs to make it out
> via the kmsg_oops implementations on the console.  Add a new option 'Y' to
> sysrq to allow dumping of logs to kmsg_dumper drivers.
> 
> Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hi,

Please add 'y' to Documentation/sysrq.txt .

> ---
>  drivers/char/sysrq.c |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
> index eaa5d3e..058d3c8 100644
> --- a/drivers/char/sysrq.c
> +++ b/drivers/char/sysrq.c
> @@ -41,6 +41,7 @@
>  #include <linux/oom.h>
>  #include <linux/slab.h>
>  #include <linux/input.h>
> +#include <linux/kmsg_dump.h>
>  
>  #include <asm/ptrace.h>
>  #include <asm/irq_regs.h>
> @@ -395,6 +396,17 @@ static struct sysrq_key_op sysrq_unrt_op = {
>  	.enable_mask	= SYSRQ_ENABLE_RTNICE,
>  };
>  
> +static void sysrq_handle_softdump(int key)
> +{
> +	kmsg_dump(KMSG_DUMP_SOFT, NULL);
> +}
> +static struct sysrq_key_op sysrq_softdump_op = {
> +	.handler	= sysrq_handle_softdump,
> +	.help_msg	= "soft-dump(Y)",
> +	.action_msg	= "Trigger a soft dump",
> +	.enable_mask	= SYSRQ_ENABLE_DUMP,
> +};
> +
>  /* Key Operations table and lock */
>  static DEFINE_SPINLOCK(sysrq_key_table_lock);
>  
> @@ -451,7 +463,7 @@ static struct sysrq_key_op *sysrq_key_table[36] = {
>  	/* x: May be registered on ppc/powerpc for xmon */
>  	NULL,				/* x */
>  	/* y: May be registered on sparc64 for global register dump */
> -	NULL,				/* y */
> +	&sysrq_softdump_op,		/* y */
>  	&sysrq_ftrace_dump_op,		/* z */
>  };


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
