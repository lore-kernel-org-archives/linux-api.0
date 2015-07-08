From: Petr Mladek <pmladek@suse.com>
Subject: Re: [RFC 3/8] kmsg: introduce additional kmsg devices support
Date: Wed, 8 Jul 2015 13:10:58 +0200
Message-ID: <20150708111058.GL32664@pathway.suse.cz>
References: <1435920595-30879-1-git-send-email-m.niesluchow@samsung.com>
 <1435920595-30879-4-git-send-email-m.niesluchow@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1435920595-30879-4-git-send-email-m.niesluchow@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marcin Niesluchowski <m.niesluchow@samsung.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Kay Sievers <kay@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
List-Id: linux-api@vger.kernel.org

On Fri 2015-07-03 12:49:50, Marcin Niesluchowski wrote:
> kmsg device provides operations on cyclic logging buffer used mainly
> by kernel but also in userspace by privileged processes.
> 
> Additional kmsg devices keep the same log format but may be added
> dynamically with custom size.
> 
> Signed-off-by: Marcin Niesluchowski <m.niesluchow@samsung.com>

> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -234,29 +234,37 @@ struct printk_log {
>  	u8 level:3;		/* syslog level */
>  };

Just in case, this is accepted. If you already touch the API, I would
suggest to rename struct printk_log to printk_msg. The current name
is pretty misleading.

> +struct log_buffer {
> +#ifdef CONFIG_PRINTK
> +	struct list_head list;	/* kmsg as head of the list */
> +	char *buf;		/* cyclic log buffer */
> +	u32 len;		/* buffer length */
> +	wait_queue_head_t wait;	/* wait queue for kmsg buffer */
> +#endif
>  /*
> - * The logbuf_lock protects kmsg buffer, indices, counters.  This can be taken
> - * within the scheduler's rq lock. It must be released before calling
> - * console_unlock() or anything else that might wake up a process.
> + * The lock protects kmsg buffer, indices, counters. This can be taken within
> + * the scheduler's rq lock. It must be released before calling console_unlock()
> + * or anything else that might wake up a process.
>   */
> -static DEFINE_RAW_SPINLOCK(logbuf_lock);
> +	raw_spinlock_t lock;
> +	u64 first_seq;		/* sequence number of the first record stored */
> +	u32 first_idx;		/* index of the first record stored */
> +/* sequence number of the next record to store */
> +	u64 next_seq;
> +#ifdef CONFIG_PRINTK
> +	u32 next_idx;		/* index of the next record to store */
> +	int mode;		/* mode of device (kmsg_sys only) */
> +	int minor;		/* minor representing buffer device */
> +#endif
> +};


> @@ -1069,10 +1253,10 @@ const struct file_operations kmsg_fops = {
>   */
>  void log_buf_kexec_setup(void)
>  {
> -	VMCOREINFO_SYMBOL(log_buf);
> -	VMCOREINFO_SYMBOL(log_buf_len);
> -	VMCOREINFO_SYMBOL(log_first_idx);
> -	VMCOREINFO_SYMBOL(log_next_idx);
> +	VMCOREINFO_SYMBOL(log_buf.buf);
> +	VMCOREINFO_SYMBOL(log_buf.len);
> +	VMCOREINFO_SYMBOL(log_buf.first_idx);
> +	VMCOREINFO_SYMBOL(log_buf.next_idx);

Have you tried to use this in crash or some other utility, please?
I guess that it will need to be exported a similar way like
struct printk_log, something like:

	VMCOREINFO_SYMBOL(log_buf);
	VMCOREINFO_STRUCT_SIZE(log_buffer);
	VMCOREINFO_OFFSET(log_buffer, buf);
	VMCOREINFO_OFFSET(log_buffer, len);
	VMCOREINFO_OFFSET(log_buffer, first_idx);
	VMCOREINFO_OFFSET(log_buffer, next_idx);

Best Regards,
Petr
