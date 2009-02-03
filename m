From: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/4] Convert epoll to a bitlock
Date: Tue, 03 Feb 2009 16:22:02 -0600
Message-ID: <1233699722.3243.127.camel@calx>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net>
	 <1233598811-6871-3-git-send-email-corbet@lwn.net>
	 <20090203133942.2ecec281.akpm@linux-foundation.org>
	 <4988BD4E.8080206@cosmosbay.com>
	 <20090203140543.6e915f97.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090203140543.6e915f97.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Eric Dumazet <dada1-fPLkHRcR87vqlBn2x/YWAg@public.gmane.org>, corbet-T1hC0tSOHrs@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 2009-02-03 at 14:05 -0800, Andrew Morton wrote:
> On Tue, 03 Feb 2009 22:55:26 +0100
> Eric Dumazet <dada1-fPLkHRcR87vqlBn2x/YWAg@public.gmane.org> wrote:
> 
> > Andrew Morton a __crit :
> > > On Mon,  2 Feb 2009 11:20:09 -0700
> > > Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org> wrote:
> > > 
> > >> Matt Mackall suggested converting epoll's ep_lock to a bitlock as a way of
> > >> saving space in struct file.  This patch makes that change.
> > > 
> > > hrm.  bit_spin_lock() makes people upset (large penguiny people).  iirc
> > > it doesn't have all the correct/well-understood memory/compiler
> > > ordering semantics which spinlocks have.  And lockdep doesn't know about
> > > it.
> > > 
> > 
> > In a previous attempt (2005), I suggested using a single global lock.
> > 
> > http://search.luky.org/linux-kernel.2005/msg50862.html
> 
> ok..
> 
> > Probably an array of hashed spinlocks would be more than enough.
> > 
> 
> yes, f_ep_lock is a teeny innermost lock.  Perhaps using
> f->f_dentry->d_inode->i_lock would be a decent speed/space compromise.

That seems eminently reasonable.

But that re-opens the question of what to do about poor Jon's quest.

I got confused halfway through as he went from using a global fasync
spinlock to a non-locked but atomic flag bit. Not sure why using a
per-file or per-inode lock doesn't work for the fasync code.

-- 
http://selenic.com : development and support for Mercurial and Linux


--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
