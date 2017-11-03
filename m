From: Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 2/3] printk: Add /sys/consoles/ interface
Date: Fri, 3 Nov 2017 16:58:00 +0100
Message-ID: <20171103155800.GA15085@kroah.com>
References: <08c1dc1a96afd6b6aecc5ff3c7c0e62c36670893.1506644730.git.calvinowens@fb.com>
 <afd350e1157ed3f31d37597d3c2ee5d9d5cfd30d.1506644730.git.calvinowens@fb.com>
 <20171103142114.GG31148@pathway.suse.cz>
 <20171103143234.GA7801@kroah.com>
 <20171103154651.GJ20040@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171103154651.GJ20040-KsEp0d+Q8qECVLCxKZUutA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Cc: Calvin Owens <calvinowens-b10kYP2dOMg@public.gmane.org>, Sergey Senozhatsky <sergey.senozhatsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 03, 2017 at 04:46:51PM +0100, Petr Mladek wrote:
> On Fri 2017-11-03 15:32:34, Kroah-Hartman wrote:
> > > > diff --git a/Documentation/ABI/testing/sysfs-consoles b/Documentation/ABI/testing/sysfs-consoles
> > > > new file mode 100644
> > > > index 0000000..6a1593e
> > > > --- /dev/null
> > > > +++ b/Documentation/ABI/testing/sysfs-consoles
> > > > @@ -0,0 +1,13 @@
> > > > +What:		/sys/consoles/
> > 
> > Eeek, what!
> > 
> > > I rather add Greg in CC. I am not 100% sure that the top level
> > > directory is the right thing to do.
> > 
> > Neither do I.
> > 
> > > Alternative might be to hide this under /sys/kernel/consoles/.
> > 
> > No no no.
> > 
> > > > diff --git a/include/linux/console.h b/include/linux/console.h
> > > > index a5b5d79..76840be 100644
> > > > --- a/include/linux/console.h
> > > > +++ b/include/linux/console.h
> > > > @@ -148,6 +148,7 @@ struct console {
> > > >  	void	*data;
> > > >  	struct	 console *next;
> > > >  	int	level;
> > > > +	struct kobject *kobj;
> > 
> > Why are you using "raw" kobjects and not a "real" struct device?  This
> > is a device, use that interface instead please.
> 
> Hmm, struct console has a member
> 
> 	struct tty_driver *(*device)(struct console *, int *);
> 
> but it is set only when the console has tty binding.

I don't understand what you are referring to here, sorry.

> > If you need a console 'bus' to place them on, fine, but the virtual bus
> > is probably best and simpler to use.
> > 
> > That is if you _really_ feel you need sysfs interaction with the console
> > layer (hint, I am not yet convinced...)
> 
> The purpose of this patch is to make a userfriendly interface
> for setting console-specific loglevel (message filtering).
> 
> It curretnly uses kobject for creating a simple directory
> structure under /sys/. It is inspired by /sys/power/, /sys/kernel/mm/,
> /sys/kernel/debug/tracing/ stuff.
> 
> There are ideas to add more files that would allow to modify even the
> global setting. This is currectly possible by the four numbers in
> /proc/sys/kernel/printk. Nobody knows what the four numbers mean.
> IMHO, the following interface would be easier to work with:
> 
>        /sys/console/loglevel
>        /sys/console/min_loglevel
>        /sys/condole/default_loglevel

No, please do not polute the /sys/* namespace with stuff like this.  If
this is associated with a specific device, hang the sysfs files off of
it.  Your console is in the /sys/device/ tree, right?

> > > 	/*
> > > 	 * Find the related struct console a safe way. The kobject
> > > 	 * desctruction is asynchronous.
> > > 	 */
> > > > +	console_lock();
> > > > +	for_each_console(con) {
> > > > +		if (con->kobj == kobj) {
> > 
> > You are doing something wrong, go from kobj to your console directly,
> > the fact that you can not do that here is a _huge_ hint that your
> > structure is not correct.
> > 
> > Hint, it's not correct at all :)
> 
> I know that we are not following the original purpose of sysfs.
> But there are more (mis)users.

Sure, and I will gladly work to fix those.  But do not add known-broken
code to the tree :)

thanks,

greg k-h
