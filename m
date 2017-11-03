From: Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 1/3] printk: Introduce per-console loglevel setting
Date: Fri, 3 Nov 2017 13:00:05 +0100
Message-ID: <20171103120005.GF31148@pathway.suse.cz>
References: <08c1dc1a96afd6b6aecc5ff3c7c0e62c36670893.1506644730.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <08c1dc1a96afd6b6aecc5ff3c7c0e62c36670893.1506644730.git.calvinowens@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org

On Thu 2017-09-28 17:43:55, Calvin Owens wrote:
> This patch introduces a new per-console loglevel setting, and changes
> console_unlock() to use max(global_level, per_console_level) when
> deciding whether or not to emit a given log message.

> diff --git a/include/linux/console.h b/include/linux/console.h
> index b8920a0..a5b5d79 100644
> --- a/include/linux/console.h
> +++ b/include/linux/console.h
> @@ -147,6 +147,7 @@ struct console {
>  	int	cflag;
>  	void	*data;
>  	struct	 console *next;
> +	int	level;

I would make the meaning more clear and call this min_loglevel.

>  };
>  
>  /*
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 512f7c2..3f1675e 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -1141,9 +1141,14 @@ module_param(ignore_loglevel, bool, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(ignore_loglevel,
>  		 "ignore loglevel setting (prints all kernel messages to the console)");
>  
> -static bool suppress_message_printing(int level)
> +static int effective_loglevel(struct console *con)
>  {
> -	return (level >= console_loglevel && !ignore_loglevel);
> +	return max(console_loglevel, con ? con->level : LOGLEVEL_EMERG);
> +}
> +
> +static bool suppress_message_printing(int level, struct console *con)
> +{
> +	return (level >= effective_loglevel(con) && !ignore_loglevel);
>  }

We need to be more careful here:

First, there is one ugly level called CONSOLE_LOGLEVEL_SILENT. Fortunately,
it is used only by vkdb_printf(). I guess that the purpose is to store
messages into the log buffer and do not show them on consoles.

It is hack and it is racy. It would hide the messages only when the
console_lock() is not already taken. Similar hack is used on more
locations, e.g. in __handle_sysrq() and these are racy as well.
We need to come up with something better in the future but this
is a task for another patchset.


Second, this functions are called with NULL when we need to take
all usable consoles into account. You simplified it by ignoring
the per-console setting. But it is not correct. For example,
you might need to delay the printing in boot_delay_msec()
also on the fast console. Also this was the reason to remove
one optimization in console_unlock().

I thought about a reasonable solution and came up with something like:

static bool suppress_message_printing(int level, struct console *con)
{
	int callable_loglevel;

	if (ignore_loglevel || console_loglevel == CONSOLE_LOGLEVEL_MOTORMOUTH)
		return false;

	/* Make silent even fast consoles. */
	if (console_loglevel == CONSOLE_LOGLEVEL_SILENT)
		return true;

	if (con)
		callable_loglevel = con->min_loglevel;
	else
		callable_loglevel = max_custom_console_loglevel;

	/* Global setting might make all consoles more verbose. */
	if (callable_loglevel < console_loglevel)
		callable_loglevel = console_loglevel;

	return level >= callable_loglevel();
}

Yes, it is complicated. But the logic is complicated. IMHO, this has
the advantage that we do most of the decisions on a single place
and it might be easier to get the picture.

Anyway, max_custom_console_loglevel would be a global variable
defined as:

/*
 * Minimum loglevel of the most talkative registered console.
 * It is a maximum of all registered con->min_logvevel values.
 */
static int max_custom_console_loglevel = LOGLEVEL_EMERG;

The value should get updated when any console is registered
and when a registered console is manipulated. It means in
register_console(), unregister_console(), and the sysfs
write callbacks.


>  #ifdef CONFIG_BOOT_PRINTK_DELAY
> @@ -2199,22 +2205,11 @@ void console_unlock(void)
>  		} else {
>  			len = 0;
>  		}
> -skip:
> +
>  		if (console_seq == log_next_seq)
>  			break;
>  
>  		msg = log_from_idx(console_idx);
> -		if (suppress_message_printing(msg->level)) {
> -			/*
> -			 * Skip record we have buffered and already printed
> -			 * directly to the console when we received it, and
> -			 * record that has level above the console loglevel.
> -			 */
> -			console_idx = log_next(console_idx);
> -			console_seq++;
> -			goto skip;
> -		}

I would like to keep this code. It does not make sense to prepare the
text buffer if it won't be used at all. It would work with the change
that I proposed above.


>  		len += msg_print_text(msg, false, text + len, sizeof(text) - len);
>  		if (nr_ext_console_drivers) {
>  			ext_len = msg_print_ext_header(ext_text,
> @@ -2230,7 +2225,7 @@ void console_unlock(void)
>  		raw_spin_unlock(&logbuf_lock);
>  
>  		stop_critical_timings();	/* don't trace print latency */
> -		call_console_drivers(ext_text, ext_len, text, len);
> +		call_console_drivers(ext_text, ext_len, text, len, msg->level);
>  		start_critical_timings();
>  		printk_safe_exit_irqrestore(flags);
>  
> @@ -2497,6 +2492,11 @@ void register_console(struct console *newcon)
>  		newcon->flags &= ~CON_PRINTBUFFER;
>  
>  	/*
> +	 * By default, the per-console minimum forces no messages through.
> +	 */
> +	newcon->level = LOGLEVEL_EMERG;

I wonder if we need this. I am not aware of any console where the
structure would not be defined globally. It means that all
non-initialized members should be zero.


Finally, I think that this feature makes sense. Thanks a lot for
working on it. I am sorry for the late reply. I need to get more
efficient in the patch review skill.

Best Regards,
Petr
