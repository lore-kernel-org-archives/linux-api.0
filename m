From: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Date: Tue, 20 Apr 2010 22:45:32 -0500
Message-ID: <20100421034532.GA9254@us.ibm.com>
References: <20100421012749.GA21338@us.ibm.com>
 <20100421012908.GB24251@us.ibm.com>
 <20100421030406.GB10258@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100421030406.GB10258-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ashwin Ganti <ashwin.ganti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, rsc-kPPrOchjzlEAvxtiuMwx3w@public.gmane.org, ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ron Minnich <rminnich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, jt.beard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morgan <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, oleg-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Greg KH (greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org):
> On Tue, Apr 20, 2010 at 08:29:08PM -0500, Serge E. Hallyn wrote:
> > This is a driver that adds Plan 9 style capability device
> > implementation.  See Documentation/p9auth.txt for a description
> > of how to use this.
> 
> Hm, you didn't originally write this driver, so it would be good to get
> some original authorship information in here to keep everything correct,
> right?

That's why I left the MODULE_AUTHOR line in there - not sure what
else to do for that.  I'll add a comment in p9auth.txt, especially
pointing back to Ashwin's original paper.

> >  Documentation/p9auth.txt     |   47 ++++
> >  drivers/char/Kconfig         |    2 +
> >  drivers/char/Makefile        |    2 +
> >  drivers/char/p9auth/Kconfig  |    9 +
> >  drivers/char/p9auth/Makefile |    1 +
> >  drivers/char/p9auth/p9auth.c |  517 ++++++++++++++++++++++++++++++++++++++++++
> 
> Is this code really ready for drivers/char/?  What has changed in it
> that makes it ok to move out of the staging tree?

It was dropped from staging :)  I don't particularly care to see it
go back into staging, as opposed to working out issues out of tree
(assuming they are solvable).  For one thing, as you note below,
there is the question of whether it should be a device driver at
all.

> And who is going to maintain it?  You?  Or someone else?

If Ashwin doesn't want to maintain it, I'll do it.  Either way.

> >  6 files changed, 578 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/p9auth.txt
> >  create mode 100644 drivers/char/p9auth/Kconfig
> >  create mode 100644 drivers/char/p9auth/Makefile
> >  create mode 100644 drivers/char/p9auth/p9auth.c
> > 
> > diff --git a/Documentation/p9auth.txt b/Documentation/p9auth.txt
> > new file mode 100644
> > index 0000000..14a69d8
> > --- /dev/null
> > +++ b/Documentation/p9auth.txt
> > @@ -0,0 +1,47 @@
> > +The p9auth device driver implements a plan-9 factotum-like
> > +capability API.  Tasks which are privileged (authorized by
> > +possession of the CAP_GRANT_ID privilege (POSIX capability))
> > +can write new capabilities to /dev/caphash.  The kernel then
> > +stores these until a task uses them by writing to the
> > +/dev/capuse device.  Each capability represents the ability
> > +for a task running as userid X to switch to userid Y and
> > +some set of groups.  Each capability may be used only once,
> > +and unused capabilities are cleared after two minutes.
> > +
> > +The following examples shows how to use the API.  Shell 1
> > +contains a privileged root shell.  Shell 2 contains an
> > +unprivileged shell as user 501 in the same user namespace.  If
> > +not already done, the privileged shell should create the p9auth
> > +devices:
> > +
> > +	majfile=/sys/module/p9auth/parameters/cap_major
> > +	minfile=/sys/module/p9auth/parameters/cap_minor
> > +	maj=`cat $majfile`
> > +	mknod /dev/caphash c $maj 0
> > +	min=`cat $minfile`
> > +	mknod /dev/capuse c $maj 1
> > +	chmod ugo+w /dev/capuse
> 
> That is incorrect, you don't need the cap_major/minor files at all, the
> device node should be automatically created for you, right?

Hmm, where?  Not in /dev on my SLES11 partition...

> And do you really want to do all of this control through a device node?
> Why?

Well...

At first I was thinking same as you were.  So I was going to switch
to a pure syscall-based approach.  But it just turned out more
complicated.  The factotum server would call sys_grantid(), and
the target task would end up doing some huge sys_setresugid() or
else multiple syscalls using the granted id.  It just was uglier.
I think there's an experimental patchset sitting somewhere I could
point to (if I weren't embarassed :).

Another possibility would be to use netlink, but that doesn't
appear as amenable to segragation by user namespaces.  The pid
(presumably/hopefully global pid, as __u32) is available, so it
shouldn't be impossible, but a simple device with simple synchronous
read/write certainly has its appeal.  Firing off a message hoping
that at some point our credentials will be changes, less so.

> > +DEFINE_MUTEX(cap_mutex); /* TODO fix up the locking one day */
> 
> One might hope that today would be that day...

Well there's nothing actually wrong with the cap_mutex.  I put in
this comment thinking I'd switch to rcu at some point, but it doesn't
seem worthwhile at the moment, by a long shot.

> Also, please run this through sparse.  This is a variable that doesn't
> need to be global.
> 
> > +struct cap_dev {
> > +	struct cdev cdev;
> > +};
> 
> Do you really need to do it this way?  A cdev for a single device node?
> That's major overkill.
> 
> > +static int cap_major = CAP_MAJOR;
> > +static int cap_minor;
> 
> Just always use a dynamic misc device, you never need a whole major for
> this.

Right - will switch that over, assuming we don't nix the whole idea
first.

> > +module_param(cap_major, int, S_IRUGO);
> > +module_param(cap_minor, int, S_IRUGO);
> 
> Can be removed.
> 
> > +MODULE_AUTHOR("Ashwin Ganti");
> 
> Hm, who is going to maintain this, you, or Ashwin?

I haven't asked Ashwin, and will be happy either way.  Ashwin, did
you want to maintain it?

> > +static void hexdump(unsigned char *buf, unsigned int len)
> > +{
> > +	while (len--)
> > +		printk(KERN_DEBUG "%02x", *buf++);
> > +	printk(KERN_DEBUG "\n");
> > +}
> 
> We have a built-in function for this already.
> 
> Oh, this function is also incorrect, which is a good reason to use the
> built-in ones.

Really I prefer to get rid of that altogether.  Anyone who wants
to see that can use a kprobe hooked to the exit of cap_hash().

> I'm going to stop now, this doesn't belong in drivers/char/ yet, it
> needs work...

/me rolls up his sleeves.

> thanks,
> 
> greg k-h
> 
> > +/*
> > + * read an entry.  For now it is
> > + * source_user@target_user@rand
> > + * Next it will become
> > + * source_user@target_user@target_group@numgroups@grp1..@grpn@rand
> > + */
> 
> Hm, wait, one more....  The kernel/user api is going to change some time
> in the future?  Please fix this now before it gets merged.

Huh, no that change already happened.

thanks,
-serge
