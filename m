From: Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 3/3] printk: Add ability to set loglevel via "console="
 cmdline
Date: Fri, 3 Nov 2017 16:15:53 +0100
Message-ID: <20171103151553.GH31148@pathway.suse.cz>
References: <08c1dc1a96afd6b6aecc5ff3c7c0e62c36670893.1506644730.git.calvinowens@fb.com>
 <e92e65beb49412f96dd0e9359f4c0d803d09b294.1506644730.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e92e65beb49412f96dd0e9359f4c0d803d09b294.1506644730.git.calvinowens@fb.com>
Sender: linux-doc-owner@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org

On Thu 2017-09-28 17:43:57, Calvin Owens wrote:
> This extends the "console=" interface to allow setting the per-console
> loglevel by adding "/N" to the string, where N is the desired loglevel
> expressed as a base 10 integer. Invalid values are silently ignored.
> 
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Signed-off-by: Calvin Owens <calvinowens@fb.com>
> ---
>  Documentation/admin-guide/kernel-parameters.txt |  6 ++---
>  kernel/printk/console_cmdline.h                 |  1 +
>  kernel/printk/printk.c                          | 30 ++++++++++++++++++++-----
>  3 files changed, 28 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 0549662..f22b992 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -607,10 +607,10 @@
>  		ttyS<n>[,options]
>  		ttyUSB0[,options]
>  			Use the specified serial port.  The options are of
> -			the form "bbbbpnf", where "bbbb" is the baud rate,
> +			the form "bbbbpnf/l", where "bbbb" is the baud rate,
>  			"p" is parity ("n", "o", or "e"), "n" is number of
> -			bits, and "f" is flow control ("r" for RTS or
> -			omit it).  Default is "9600n8".
> +			bits, "f" is flow control ("r" for RTS or omit it),
> +			and "l" is the loglevel on [0,7]. Default is "9600n8".
>  

If I get this correctly, the patch allows to define the loglevel for any
console. I think that we need to describe it in a generic
way. Something like:

       console=        [KNL] Output console device and options.

		Format: name[,options][/min_loglevel]

		Where "name" is the console name, "options"
		are console-specific options, and "min_loglevel"
		allows to increase the loglevel for a particular
		console over the global one.

                tty<n>  Use the virtual console device <n>.

I would also add a cross reference into the loglevel= section
about that the global loglevel might be overridden by a higher
console-specific min_loglevel value.


>  			See Documentation/admin-guide/serial-console.rst for more
>  			information.  See
> diff --git a/kernel/printk/console_cmdline.h b/kernel/printk/console_cmdline.h
> index 2ca4a8b..269e666 100644
> --- a/kernel/printk/console_cmdline.h
> +++ b/kernel/printk/console_cmdline.h
> @@ -5,6 +5,7 @@ struct console_cmdline
>  {
>  	char	name[16];			/* Name of the driver	    */
>  	int	index;				/* Minor dev. to use	    */
> +	int	loglevel;			/* Loglevel to use */

Again, I would use "min_loglevel".


>  	char	*options;			/* Options for the driver   */
>  #ifdef CONFIG_A11Y_BRAILLE_CONSOLE
>  	char	*brl_options;			/* Options for braille driver */
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 488bda3..4c14cf2 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -2541,6 +2552,12 @@ void register_console(struct console *newcon)
>  			if (newcon->index < 0)
>  				newcon->index = c->index;
>  
> +			/*
> +			 * Carry over the loglevel from the cmdline
> +			 */
> +			newcon->level = c->loglevel;
> +			extant = true;

I would personally do the following:

			if (!newcon->min_loglevel)
				newcon->min_loglevel = c->min_loglevel;

It is similar to newcon->index handling above. It will use the
command line setting only when the console is registered for the first
time.

All this is based on my assumption that all non-initialized struct
console members are zero. At least I do not see any location where
some other members would be explicitly zeroed. And there might
be candidates, e.g. data, match(), next.

In each case, I do not know what the shortcut "extant" stands for
and I feel confused ;-)


>  			if (_braille_register_console(newcon, c))
>  				return;
>  
> @@ -2572,8 +2589,9 @@ void register_console(struct console *newcon)
>  	/*
>  	 * By default, the per-console minimum forces no messages through.
>  	 */
> -	newcon->level = LOGLEVEL_EMERG;
>  	newcon->kobj = NULL;
> +	if (!extant)
> +		newcon->level = LOGLEVEL_EMERG;

I believe that this is not necessary.


Otherwise, I really like this approach. I am surprised that all
consoles might be supported so easily.

Well, I am not 100% sure that '/' delimiter is the best choice.
I hope that it will not cause any confusion. But I cannot think
of anything better.

Best Regards,
Petr
