From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/3] printk: Introduce per-console loglevel setting
Date: Fri, 3 Nov 2017 09:41:43 -0400
Message-ID: <20171103094143.460e3b63@vmware.local.home>
References: <08c1dc1a96afd6b6aecc5ff3c7c0e62c36670893.1506644730.git.calvinowens@fb.com>
        <20171103120005.GF31148@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171103120005.GF31148@pathway.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Petr Mladek <pmladek@suse.com>
Cc: Calvin Owens <calvinowens@fb.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org

On Fri, 3 Nov 2017 13:00:05 +0100
Petr Mladek <pmladek@suse.com> wrote:

> On Thu 2017-09-28 17:43:55, Calvin Owens wrote:
> > This patch introduces a new per-console loglevel setting, and changes
> > console_unlock() to use max(global_level, per_console_level) when
> > deciding whether or not to emit a given log message.  
> 
> > diff --git a/include/linux/console.h b/include/linux/console.h
> > index b8920a0..a5b5d79 100644
> > --- a/include/linux/console.h
> > +++ b/include/linux/console.h
> > @@ -147,6 +147,7 @@ struct console {
> >  	int	cflag;
> >  	void	*data;
> >  	struct	 console *next;
> > +	int	level;  
> 
> I would make the meaning more clear and call this min_loglevel.

Or just loglevel, as those of us dealing with printk should understand.
This is just a per console loglevel, and if we call it min_loglevel, it
may be confusing because there is no "min_loglevel" that is currently
used.

[ Just read what you did below, maybe min is OK ]

> 
> >  };
> >  
> >  /*
> > diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> > index 512f7c2..3f1675e 100644
> > --- a/kernel/printk/printk.c
> > +++ b/kernel/printk/printk.c
> > @@ -1141,9 +1141,14 @@ module_param(ignore_loglevel, bool, S_IRUGO | S_IWUSR);
> >  MODULE_PARM_DESC(ignore_loglevel,
> >  		 "ignore loglevel setting (prints all kernel messages to the console)");
> >  
> > -static bool suppress_message_printing(int level)
> > +static int effective_loglevel(struct console *con)
> >  {
> > -	return (level >= console_loglevel && !ignore_loglevel);
> > +	return max(console_loglevel, con ? con->level : LOGLEVEL_EMERG);
> > +}
> > +
> > +static bool suppress_message_printing(int level, struct console *con)
> > +{
> > +	return (level >= effective_loglevel(con) && !ignore_loglevel);
> >  }  
> 
> We need to be more careful here:
> 
> First, there is one ugly level called CONSOLE_LOGLEVEL_SILENT. Fortunately,
> it is used only by vkdb_printf(). I guess that the purpose is to store
> messages into the log buffer and do not show them on consoles.

Unfortunately, it is also used by
arch/mn10300/kernel/mn10300-watchdog.c.

Which calls console_silent().


> 
> It is hack and it is racy. It would hide the messages only when the
> console_lock() is not already taken. Similar hack is used on more
> locations, e.g. in __handle_sysrq() and these are racy as well.
> We need to come up with something better in the future but this
> is a task for another patchset.

Agreed.

> 
> 
> Second, this functions are called with NULL when we need to take
> all usable consoles into account. You simplified it by ignoring
> the per-console setting. But it is not correct. For example,
> you might need to delay the printing in boot_delay_msec()
> also on the fast console. Also this was the reason to remove
> one optimization in console_unlock().
> 
> I thought about a reasonable solution and came up with something like:
> 
> static bool suppress_message_printing(int level, struct console *con)
> {
> 	int callable_loglevel;
> 
> 	if (ignore_loglevel || console_loglevel == CONSOLE_LOGLEVEL_MOTORMOUTH)
> 		return false;
> 
> 	/* Make silent even fast consoles. */
> 	if (console_loglevel == CONSOLE_LOGLEVEL_SILENT)
> 		return true;
> 
> 	if (con)
> 		callable_loglevel = con->min_loglevel;
> 	else
> 		callable_loglevel = max_custom_console_loglevel;
> 
> 	/* Global setting might make all consoles more verbose. */
> 	if (callable_loglevel < console_loglevel)
> 		callable_loglevel = console_loglevel;
> 
> 	return level >= callable_loglevel();
> }
> 
> Yes, it is complicated. But the logic is complicated. IMHO, this has
> the advantage that we do most of the decisions on a single place
> and it might be easier to get the picture.

It's not that complex, and it also has the benefit to document exactly
what the console_loglevel is doing.

> 
> Anyway, max_custom_console_loglevel would be a global variable
> defined as:
> 
> /*
>  * Minimum loglevel of the most talkative registered console.
>  * It is a maximum of all registered con->min_logvevel values.
>  */
> static int max_custom_console_loglevel = LOGLEVEL_EMERG;

Ah, that is why you added min_loglevel.

-- Steve

> 
> The value should get updated when any console is registered
> and when a registered console is manipulated. It means in
> register_console(), unregister_console(), and the sysfs
> write callbacks.
> 
