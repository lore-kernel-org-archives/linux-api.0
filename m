From: Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/3] printk: Add /sys/consoles/ interface
Date: Fri, 3 Nov 2017 15:32:34 +0100
Message-ID: <20171103143234.GA7801@kroah.com>
References: <08c1dc1a96afd6b6aecc5ff3c7c0e62c36670893.1506644730.git.calvinowens@fb.com>
 <afd350e1157ed3f31d37597d3c2ee5d9d5cfd30d.1506644730.git.calvinowens@fb.com>
 <20171103142114.GG31148@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171103142114.GG31148@pathway.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Petr Mladek <pmladek@suse.com>
Cc: Calvin Owens <calvinowens@fb.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org

On Fri, Nov 03, 2017 at 03:21:14PM +0100, Petr Mladek wrote:
> On Thu 2017-09-28 17:43:56, Calvin Owens wrote:
> > This adds a new sysfs interface that contains a directory for each
> > console registered on the system. Each directory contains a single
> > "loglevel" file for reading and setting the per-console loglevel.
> > 
> > We can let kobject destruction race with console removal: if it does,
> > loglevel_{show,store}() will safely fail with -ENODEV. This is a little
> > weird, but avoids embedding the kobject and therefore needing to totally
> > refactor the way we handle console struct lifetime.
> 
> It looks like a sane approach. It might be worth a comment in the code.
> 
> 
> >  Documentation/ABI/testing/sysfs-consoles | 13 +++++
> >  include/linux/console.h                  |  1 +
> >  kernel/printk/printk.c                   | 88 ++++++++++++++++++++++++++++++++
> >  3 files changed, 102 insertions(+)
> >  create mode 100644 Documentation/ABI/testing/sysfs-consoles
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-consoles b/Documentation/ABI/testing/sysfs-consoles
> > new file mode 100644
> > index 0000000..6a1593e
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-consoles
> > @@ -0,0 +1,13 @@
> > +What:		/sys/consoles/

Eeek, what!

> I rather add Greg in CC. I am not 100% sure that the top level
> directory is the right thing to do.

Neither do I.

> Alternative might be to hide this under /sys/kernel/consoles/.

No no no.

> > +Date:		September 2017
> > +KernelVersion:	4.15
> > +Contact:	Calvin Owens <calvinowens@fb.com>
> > +Description:	The /sys/consoles tree contains a directory for each console
> > +		configured on the system. These directories contain the
> > +		following attributes:
> > +
> > +		* "loglevel"	Set the per-console loglevel: the kernel uses
> > +				max(system_loglevel, perconsole_loglevel) when
> > +				deciding whether to emit a given message. The
> > +				default is 0, which means max() always yields
> > +				the system setting in the kernel.printk sysctl.
> 
> I would call the attribute "min_loglevel". The name "loglevel" should
> be reserved for the really used loglevel that depends also on the
> global loglevel value.
> 
> 
> > diff --git a/include/linux/console.h b/include/linux/console.h
> > index a5b5d79..76840be 100644
> > --- a/include/linux/console.h
> > +++ b/include/linux/console.h
> > @@ -148,6 +148,7 @@ struct console {
> >  	void	*data;
> >  	struct	 console *next;
> >  	int	level;
> > +	struct kobject *kobj;

Why are you using "raw" kobjects and not a "real" struct device?  This
is a device, use that interface instead please.

If you need a console 'bus' to place them on, fine, but the virtual bus
is probably best and simpler to use.

That is if you _really_ feel you need sysfs interaction with the console
layer (hint, I am not yet convinced...)

> >  };
> >  
> >  /*
> > diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> > index 3f1675e..488bda3 100644
> > --- a/kernel/printk/printk.c
> > +++ b/kernel/printk/printk.c
> > @@ -105,6 +105,8 @@ enum devkmsg_log_masks {
> >  
> >  static unsigned int __read_mostly devkmsg_log = DEVKMSG_LOG_MASK_DEFAULT;
> >  
> > +static struct kobject *consoles_dir_kobj;
> >
> >  static int __control_devkmsg(char *str)
> >  {
> >  	if (!str)
> > @@ -2371,6 +2373,82 @@ static int __init keep_bootcon_setup(char *str)
> >  
> >  early_param("keep_bootcon", keep_bootcon_setup);
> >  
> > +static ssize_t loglevel_show(struct kobject *kobj, struct kobj_attribute *attr,
> > +			     char *buf)
> > +{
> > +	struct console *con;
> > +	ssize_t ret = -ENODEV;
> > +
> 
> This might deserve a comment. Something like:
> 
> 	/*
> 	 * Find the related struct console a safe way. The kobject
> 	 * desctruction is asynchronous.
> 	 */
> > +	console_lock();
> > +	for_each_console(con) {
> > +		if (con->kobj == kobj) {

You are doing something wrong, go from kobj to your console directly,
the fact that you can not do that here is a _huge_ hint that your
structure is not correct.

Hint, it's not correct at all :)

Please cc: me on stuff like this if you want a review, and as you are
adding a random new sysfs root directory, please always cc: me on that
so I can talk you out of it...

thanks,

greg k-h
