From: Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 2/3] printk: Add /sys/consoles/ interface
Date: Fri, 3 Nov 2017 15:21:14 +0100
Message-ID: <20171103142114.GG31148@pathway.suse.cz>
References: <08c1dc1a96afd6b6aecc5ff3c7c0e62c36670893.1506644730.git.calvinowens@fb.com>
 <afd350e1157ed3f31d37597d3c2ee5d9d5cfd30d.1506644730.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <afd350e1157ed3f31d37597d3c2ee5d9d5cfd30d.1506644730.git.calvinowens@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

On Thu 2017-09-28 17:43:56, Calvin Owens wrote:
> This adds a new sysfs interface that contains a directory for each
> console registered on the system. Each directory contains a single
> "loglevel" file for reading and setting the per-console loglevel.
> 
> We can let kobject destruction race with console removal: if it does,
> loglevel_{show,store}() will safely fail with -ENODEV. This is a little
> weird, but avoids embedding the kobject and therefore needing to totally
> refactor the way we handle console struct lifetime.

It looks like a sane approach. It might be worth a comment in the code.


>  Documentation/ABI/testing/sysfs-consoles | 13 +++++
>  include/linux/console.h                  |  1 +
>  kernel/printk/printk.c                   | 88 ++++++++++++++++++++++++++++++++
>  3 files changed, 102 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-consoles
> 
> diff --git a/Documentation/ABI/testing/sysfs-consoles b/Documentation/ABI/testing/sysfs-consoles
> new file mode 100644
> index 0000000..6a1593e
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-consoles
> @@ -0,0 +1,13 @@
> +What:		/sys/consoles/

I rather add Greg in CC. I am not 100% sure that the top level
directory is the right thing to do.

Alternative might be to hide this under /sys/kernel/consoles/.


> +Date:		September 2017
> +KernelVersion:	4.15
> +Contact:	Calvin Owens <calvinowens@fb.com>
> +Description:	The /sys/consoles tree contains a directory for each console
> +		configured on the system. These directories contain the
> +		following attributes:
> +
> +		* "loglevel"	Set the per-console loglevel: the kernel uses
> +				max(system_loglevel, perconsole_loglevel) when
> +				deciding whether to emit a given message. The
> +				default is 0, which means max() always yields
> +				the system setting in the kernel.printk sysctl.

I would call the attribute "min_loglevel". The name "loglevel" should
be reserved for the really used loglevel that depends also on the
global loglevel value.


> diff --git a/include/linux/console.h b/include/linux/console.h
> index a5b5d79..76840be 100644
> --- a/include/linux/console.h
> +++ b/include/linux/console.h
> @@ -148,6 +148,7 @@ struct console {
>  	void	*data;
>  	struct	 console *next;
>  	int	level;
> +	struct kobject *kobj;
>  };
>  
>  /*
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 3f1675e..488bda3 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -105,6 +105,8 @@ enum devkmsg_log_masks {
>  
>  static unsigned int __read_mostly devkmsg_log = DEVKMSG_LOG_MASK_DEFAULT;
>  
> +static struct kobject *consoles_dir_kobj;
>
>  static int __control_devkmsg(char *str)
>  {
>  	if (!str)
> @@ -2371,6 +2373,82 @@ static int __init keep_bootcon_setup(char *str)
>  
>  early_param("keep_bootcon", keep_bootcon_setup);
>  
> +static ssize_t loglevel_show(struct kobject *kobj, struct kobj_attribute *attr,
> +			     char *buf)
> +{
> +	struct console *con;
> +	ssize_t ret = -ENODEV;
> +

This might deserve a comment. Something like:

	/*
	 * Find the related struct console a safe way. The kobject
	 * desctruction is asynchronous.
	 */
> +	console_lock();
> +	for_each_console(con) {
> +		if (con->kobj == kobj) {
> +			ret = sprintf(buf, "%d\n", con->level);
> +			break;
> +		}
> +	}
> +	console_unlock();
> +
> +	return ret;
> +}
> +
> +static ssize_t loglevel_store(struct kobject *kobj, struct kobj_attribute *attr,
> +			      const char *buf, size_t count)
> +{
> +	struct console *con;
> +	ssize_t ret;
> +	int tmp;

I would use some meaningful name, e.g. new_level ;-)

> +	ret = kstrtoint(buf, 10, &tmp);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (tmp < LOGLEVEL_EMERG)
> +		return -ERANGE;
> +
> +	/*
> +	 * Mimic the behavior of /dev/kmsg with respect to minimum_loglevel
> +	 */
> +	if (tmp < minimum_console_loglevel)
> +		tmp = minimum_console_loglevel;

Hmm, I would remove this "mimic" stuff. minimum_console_loglevel is currently
used to limit operations by the syslog system call. But root is still
able modify the minimum_console_loglevel by writing into
/proc/sys/kernel/printk.

My plan is that /sys/console interface would eventually replace the
crazy /proc/sys/kernel/printk one.

In each case, the default con->level value is zero. It would be
weird if people were not able to set this value.

> +
> +	ret = -ENODEV;

I would repeat the same comment here:

	/*
	 * Find the related struct console a safe way. The kobject
	 * desctruction is asynchronous.
	 */

> +	console_lock();
> +	for_each_console(con) {
> +		if (con->kobj == kobj) {
> +			con->level = tmp;
> +			ret = count;
> +			break;
> +		}
> +	}
> +	console_unlock();
> +
> +	return ret;
> +}
> +
> +static const struct kobj_attribute console_loglevel_attr =
> +	__ATTR(loglevel, 0644, loglevel_show, loglevel_store);
> +
> +static void console_register_sysfs(struct console *newcon)
> +{
Please, add a sanity check to make sure that this API is used the
right way.

	if (WARN_ON(newcon->kobj))
		return;

> +	/*
> +	 * We might be called very early from register_console(): in that case,
> +	 * printk_late_init() will take care of this later.
> +	 */
> +	if (!consoles_dir_kobj)
> +		return;
> +
> +	newcon->kobj = kobject_create_and_add(newcon->name, consoles_dir_kobj);
> +	if (WARN_ON(!newcon->kobj))

I would just return in case of error. The error messages from
kobject_create_and_add() should be enough and actually more useful.

> +		return;
> +
> +	WARN_ON(sysfs_create_file(newcon->kobj, &console_loglevel_attr.attr));

Similar here. Well, I would destroy the kobject if the sysfs file
cannot be created:

       if (sysfs_create_file(newcon->kobj, &console_loglevel_attr.attr))
	       console_unregister_sysfs(newcon);

> +}
> +
> +static void console_unregister_sysfs(struct console *oldcon)
> +{
> +	kobject_put(oldcon->kobj);

We need to make that the carefull access in the show()/store() methods work.

	oldcon->kobj = NULL;

> +}
> +
>  /*
>   * The console driver calls this routine during kernel initialization
>   * to register the console printing procedure with printk() and to
> @@ -2495,6 +2573,7 @@ void register_console(struct console *newcon)
>  	 * By default, the per-console minimum forces no messages through.
>  	 */
>  	newcon->level = LOGLEVEL_EMERG;
> +	newcon->kobj = NULL;

IMHO, we do not need this. The pointer should already be NULL.

>  	/*
>  	 *	Put this console in the list - keep the
> @@ -2531,6 +2610,7 @@ void register_console(struct console *newcon)
>  		 */
>  		exclusive_console = newcon;
>  	}
> +	console_register_sysfs(newcon);
>  	console_unlock();
>  	console_sysfs_notify();
>  
> @@ -2597,6 +2677,7 @@ int unregister_console(struct console *console)
>  		console_drivers->flags |= CON_CONSDEV;
>  
>  	console->flags &= ~CON_ENABLED;
> +	console_unregister_sysfs(console);
>  	console_unlock();
>  	console_sysfs_notify();
>  	return res;
> @@ -2672,6 +2753,13 @@ static int __init printk_late_init(void)
>  	ret = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN, "printk:online",
>  					console_cpu_notify, NULL);
>  	WARN_ON(ret < 0);
> +
> +	consoles_dir_kobj = kobject_create_and_add("consoles", NULL);
> +	WARN_ON(!consoles_dir_kobj);

Again, I would just return in case of error.

> +	for_each_console(con)
> +		console_register_sysfs(con);
> +
>  	return 0;

Best Regards,
Petr
