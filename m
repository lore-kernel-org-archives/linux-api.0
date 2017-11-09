From: Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 2/3] printk: Add /sys/consoles/ interface
Date: Thu, 9 Nov 2017 09:03:21 +0100
Message-ID: <20171109080321.GB17098@kroah.com>
References: <08c1dc1a96afd6b6aecc5ff3c7c0e62c36670893.1506644730.git.calvinowens@fb.com>
 <afd350e1157ed3f31d37597d3c2ee5d9d5cfd30d.1506644730.git.calvinowens@fb.com>
 <20171103142114.GG31148@pathway.suse.cz>
 <20171103143234.GA7801@kroah.com>
 <519f471b-47dc-3367-f702-119a9d82ba9b@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <519f471b-47dc-3367-f702-119a9d82ba9b-b10kYP2dOMg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Calvin Owens <calvinowens-b10kYP2dOMg@public.gmane.org>
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Sergey Senozhatsky <sergey.senozhatsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Nov 08, 2017 at 01:32:53PM -0800, Calvin Owens wrote:
> On 11/03/2017 07:32 AM, Kroah-Hartman wrote:
> > On Fri, Nov 03, 2017 at 03:21:14PM +0100, Petr Mladek wrote:
> > > On Thu 2017-09-28 17:43:56, Calvin Owens wrote:
> > > > This adds a new sysfs interface that contains a directory for each
> > > > console registered on the system. Each directory contains a single
> > > > "loglevel" file for reading and setting the per-console loglevel.
> > > > 
> > > > We can let kobject destruction race with console removal: if it does,
> > > > loglevel_{show,store}() will safely fail with -ENODEV. This is a little
> > > > weird, but avoids embedding the kobject and therefore needing to totally
> > > > refactor the way we handle console struct lifetime.
> > > 
> > > It looks like a sane approach. It might be worth a comment in the code.
> > > 
> > > 
> > > >   Documentation/ABI/testing/sysfs-consoles | 13 +++++
> > > >   include/linux/console.h                  |  1 +
> > > >   kernel/printk/printk.c                   | 88 ++++++++++++++++++++++++++++++++
> > > >   3 files changed, 102 insertions(+)
> > > >   create mode 100644 Documentation/ABI/testing/sysfs-consoles
> > > > 
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
> 
> Sure. This is a placeholder I choose arbitrarily pending some real input on
> the location, sorry I didn't make that clear.
> 
> > > Alternative might be to hide this under /sys/kernel/consoles/.
> > 
> > No no no.
> > 
> > > > +Date:		September 2017
> > > > +KernelVersion:	4.15
> > > > +Contact:	Calvin Owens <calvinowens-b10kYP2dOMg@public.gmane.org>
> > > > +Description:	The /sys/consoles tree contains a directory for each console
> > > > +		configured on the system. These directories contain the
> > > > +		following attributes:
> > > > +
> > > > +		* "loglevel"	Set the per-console loglevel: the kernel uses
> > > > +				max(system_loglevel, perconsole_loglevel) when
> > > > +				deciding whether to emit a given message. The
> > > > +				default is 0, which means max() always yields
> > > > +				the system setting in the kernel.printk sysctl.
> > > 
> > > I would call the attribute "min_loglevel". The name "loglevel" should
> > > be reserved for the really used loglevel that depends also on the
> > > global loglevel value.
> > > 
> > > 
> > > > diff --git a/include/linux/console.h b/include/linux/console.h
> > > > index a5b5d79..76840be 100644
> > > > --- a/include/linux/console.h
> > > > +++ b/include/linux/console.h
> > > > @@ -148,6 +148,7 @@ struct console {
> > > >   	void	*data;
> > > >   	struct	 console *next;
> > > >   	int	level;
> > > > +	struct kobject *kobj;
> > 
> > Why are you using "raw" kobjects and not a "real" struct device?  This
> > is a device, use that interface instead please.
> > 
> > If you need a console 'bus' to place them on, fine, but the virtual bus
> > is probably best and simpler to use.
> 
> The problem is that the console corresponds to no actual device (this is what
> Petr was getting at in the other mail). A console *may* be associated with a real
> TTY device, but this isn't universally true (for example, see netconsole_ext).
> 
> Embedding a device struct in the console structure is problematic for the same
> reason embedding a raw kobject is: we'd need to rewrite all the code to deal with
> the new refcount/release semantics.

That's ok, that is what you _should_ do :)

> While that's certainly possible, it ends up being a much bigger thorny change. If
> we deal with the "get()/deregister()" race in a safe way, it becomes very simple.
> 
> (If it were as trivial as replacing kfrees with puts and adding release callbacks,
> that'd be the obvious way to go, but of course it doesn't end up being that nice...)

I agree it's not trivial, but it's the correct change here, don't try to
abuse the driver core / kobjects, they will come back to bite you :)

> > That is if you _really_ feel you need sysfs interaction with the console
> > layer (hint, I am not yet convinced...)
> 
> How would you expose this setting if not via sysfs? All I care about is having the
> setting, how exactly userspace pokes it is not at all important :)

A per-console log-level?  I don't know, how do per-console settings work
today, ioctls?

"Fixing" consoles properly would be great work to undertake...

thanks,

greg k-h
