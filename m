From: Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v6 3/8] kmsg: introduce additional kmsg devices support
Date: Fri, 26 Feb 2016 15:05:10 +0100
Message-ID: <20160226140510.GE3305@pathway.suse.cz>
References: <1456314801-32738-1-git-send-email-k.krosman@samsung.com>
 <1456314801-32738-4-git-send-email-k.krosman@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1456314801-32738-4-git-send-email-k.krosman@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kazimierz Krosman <k.krosman@samsung.com>
Cc: akpm@linux-foundation.org, peter@hurleysoftware.com, tj@kernel.org, vvs@virtuozzo.com, corbet@lwn.net, arnd@arndb.de, gregkh@linuxfoundation.org, daniel@zonque.org, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, k.lewandowsk@samsung.com, m.niesluchow@samsung.com, richard.weinberger@gmail.com, b.zolnierkie@samsung.com, luto@amacapital.net, knhoon.baik@samsung.com
List-Id: linux-api@vger.kernel.org

On Wed 2016-02-24 12:53:16, Kazimierz Krosman wrote:
> From: Marcin Niesluchowski <m.niesluchow@samsung.com>
> 
> kmsg device provides operations on cyclic logging buffer used mainly
> by kernel but also in userspace by privileged processes.
> 
> Additional kmsg devices keep the same log format but may be added
> dynamically with custom size.
> 
> Signed-off-by: Marcin Niesluchowski <m.niesluchow@samsung.com>
> Signed-off-by: Paul Osmialowski <p.osmialowsk@samsung.com>
> [Rebased kmsg patch v5 on Linux 4.5-rc5]
> Signed-off-by: Kazimierz Krosman <k.krosman@samsung.com>
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 3653a8e..b99403b 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -584,9 +595,11 @@ ssize_t msg_print_ext_body(char *buf, size_t size,
>  void log_buf_kexec_setup(void)
>  {
>  	VMCOREINFO_SYMBOL(log_buf);
> -	VMCOREINFO_SYMBOL(log_buf_len);
> -	VMCOREINFO_SYMBOL(log_first_idx);
> -	VMCOREINFO_SYMBOL(log_next_idx);
> +	VMCOREINFO_STRUCT_SIZE(log_buffer);
> +	VMCOREINFO_OFFSET(log_buffer, buf);
> +	VMCOREINFO_OFFSET(log_buffer, len);
> +	VMCOREINFO_OFFSET(log_buffer, first_idx);
> +	VMCOREINFO_OFFSET(log_buffer, next_idx);

This breaks makedumpfile, crash and possibly other tools
that use this information to access the log buffer.

Best Regards,
Petr
