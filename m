From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Date: Thu, 22 Jan 2009 21:31:05 -0800
Message-ID: <20090122213105.74142908.akpm@linux-foundation.org>
References: <20090115153211.663df310@bike.lwn.net>
	<20090122065104.2787df2d.akpm@linux-foundation.org>
	<20090122221500.4c62aa54@tpl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090122221500.4c62aa54@tpl>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org
List-Id: linux-api@vger.kernel.org

> On Thu, 22 Jan 2009 22:15:00 -0700 Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org> wrote:
> On Thu, 22 Jan 2009 06:51:04 -0800
> Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> 
> > OK, replacing a lock_kernel() with a spin_lock(&global_lock) is pretty
> > straightforwad.  But it's really really sad.  It basically leaves a
> > great big FIXME in there.  It'd be better to fix it.
> > 
> > We don't have a handy lock in struct file which could be borrowed.
> 
> Yeah, I noticed that too.
>  
> > - We could add one
> 
> The problem there is that this bloats struct file, and that seemed like
> something worth avoiding.

Not a big deal, really.  There's one of these for each presently-open file.
It's not like dentries and inodes, which we cache after userspace has
closed off the file handles.

>  It could easily be done, but I don't know
> why we would before knowing that the global spinlock is a problem. 
> 
> But... it's *already* protected by a global spinlock (the BKL) which is
> (still) more widely used.
> 
> > - We could borrow file->f_path.dentry->d_inode->i_lock
> 
> I didn't think of that one.  Using a lock which is three indirections
> away seems a little obscure; again, I guess we could do that if the
> global spinlock actually turns out to be a problem.
> 
> > - We could convert that field to long and use bitops (sounds nice?)
> 
> I did think of that one.  Reasons not to include growing struct file
> and the fact that there are places which set more than one flag at
> once.  So we'd replace assignments with loops - and we still don't
> solve the fasync() problem.
> 

I don't know what "the fasync() problem" is?
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
