From: Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 2/3] printk: Add /sys/consoles/ interface
Date: Fri, 3 Nov 2017 16:46:51 +0100
Message-ID: <20171103154651.GJ20040@pathway.suse.cz>
References: <08c1dc1a96afd6b6aecc5ff3c7c0e62c36670893.1506644730.git.calvinowens@fb.com>
 <afd350e1157ed3f31d37597d3c2ee5d9d5cfd30d.1506644730.git.calvinowens@fb.com>
 <20171103142114.GG31148@pathway.suse.cz>
 <20171103143234.GA7801@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171103143234.GA7801@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Calvin Owens <calvinowens@fb.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org

On Fri 2017-11-03 15:32:34, Kroah-Hartman wrote:
> > > diff --git a/Documentation/ABI/testing/sysfs-consoles b/Documentation/ABI/testing/sysfs-consoles
> > > new file mode 100644
> > > index 0000000..6a1593e
> > > --- /dev/null
> > > +++ b/Documentation/ABI/testing/sysfs-consoles
> > > @@ -0,0 +1,13 @@
> > > +What:		/sys/consoles/
> 
> Eeek, what!
> 
> > I rather add Greg in CC. I am not 100% sure that the top level
> > directory is the right thing to do.
> 
> Neither do I.
> 
> > Alternative might be to hide this under /sys/kernel/consoles/.
> 
> No no no.
> 
> > > diff --git a/include/linux/console.h b/include/linux/console.h
> > > index a5b5d79..76840be 100644
> > > --- a/include/linux/console.h
> > > +++ b/include/linux/console.h
> > > @@ -148,6 +148,7 @@ struct console {
> > >  	void	*data;
> > >  	struct	 console *next;
> > >  	int	level;
> > > +	struct kobject *kobj;
> 
> Why are you using "raw" kobjects and not a "real" struct device?  This
> is a device, use that interface instead please.

Hmm, struct console has a member

	struct tty_driver *(*device)(struct console *, int *);

but it is set only when the console has tty binding.

> If you need a console 'bus' to place them on, fine, but the virtual bus
> is probably best and simpler to use.
> 
> That is if you _really_ feel you need sysfs interaction with the console
> layer (hint, I am not yet convinced...)

The purpose of this patch is to make a userfriendly interface
for setting console-specific loglevel (message filtering).

It curretnly uses kobject for creating a simple directory
structure under /sys/. It is inspired by /sys/power/, /sys/kernel/mm/,
/sys/kernel/debug/tracing/ stuff.

There are ideas to add more files that would allow to modify even the
global setting. This is currectly possible by the four numbers in
/proc/sys/kernel/printk. Nobody knows what the four numbers mean.
IMHO, the following interface would be easier to work with:

       /sys/console/loglevel
       /sys/console/min_loglevel
       /sys/condole/default_loglevel

> > 	/*
> > 	 * Find the related struct console a safe way. The kobject
> > 	 * desctruction is asynchronous.
> > 	 */
> > > +	console_lock();
> > > +	for_each_console(con) {
> > > +		if (con->kobj == kobj) {
> 
> You are doing something wrong, go from kobj to your console directly,
> the fact that you can not do that here is a _huge_ hint that your
> structure is not correct.
> 
> Hint, it's not correct at all :)

I know that we are not following the original purpose of sysfs.
But there are more (mis)users.

> Please cc: me on stuff like this if you want a review, and as you are
> adding a random new sysfs root directory, please always cc: me on that
> so I can talk you out of it...

Good to know.

Best Regards,
Petr
