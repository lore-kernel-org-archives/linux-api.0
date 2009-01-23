From: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Date: Thu, 22 Jan 2009 23:45:49 -0600
Message-ID: <1232689549.5202.385.camel@calx>
References: <20090115153211.663df310@bike.lwn.net>
	 <20090122065104.2787df2d.akpm@linux-foundation.org>
	 <20090122221500.4c62aa54@tpl>
	 <20090122213105.74142908.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090122213105.74142908.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 2009-01-22 at 21:31 -0800, Andrew Morton wrote:
> > On Thu, 22 Jan 2009 22:15:00 -0700 Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org> wrote:
> > On Thu, 22 Jan 2009 06:51:04 -0800
> > Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > 
> > > OK, replacing a lock_kernel() with a spin_lock(&global_lock) is pretty
> > > straightforwad.  But it's really really sad.  It basically leaves a
> > > great big FIXME in there.  It'd be better to fix it.
> > > 
> > > We don't have a handy lock in struct file which could be borrowed.
> > 
> > Yeah, I noticed that too.
> >  
> > > - We could add one
> > 
> > The problem there is that this bloats struct file, and that seemed like
> > something worth avoiding.
> 
> Not a big deal, really.  There's one of these for each presently-open file.
> It's not like dentries and inodes, which we cache after userspace has
> closed off the file handles.

I have to agree with Christoph. The priority here is breaking down the
BKL and document all the things being protected by it and we've got a
reasonably obvious patch in that direction. Meanwhile, there's not
currently a pressing demand to make fasync in particular scale that I'm
aware of.

Having a single big lock here is quite possibly something we'll want to
fix down the road, agreed, but until we can actually measure it hurting
us, debating about whether to use a bit lock or reuse an existing lock
or add a new lock to all struct files is a bit premature.

-- 
http://selenic.com : development and support for Mercurial and Linux


--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
