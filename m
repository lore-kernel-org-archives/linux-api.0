From: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Subject: Re: [PATCH 2/4] Convert epoll to a bitlock
Date: Wed, 4 Feb 2009 06:34:07 -0700
Message-ID: <20090204063407.611d5436@bike.lwn.net>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net>
	<20090203161931.4054a25e@bike.lwn.net>
	<20090204071320.GA19348@lst.de>
	<200902041820.20535.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <200902041820.20535.nickpiggin-/E1597aS9LT0CCvOHzKKcA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nick Piggin <nickpiggin-/E1597aS9LT0CCvOHzKKcA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org, dada1-fPLkHRcR87vqlBn2x/YWAg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 4 Feb 2009 18:20:18 +1100
Nick Piggin <nickpiggin-/E1597aS9LT0CCvOHzKKcA@public.gmane.org> wrote:

> On Wednesday 04 February 2009 18:13:20 Christoph Hellwig wrote:
> > On Tue, Feb 03, 2009 at 04:19:31PM -0700, Jonathan Corbet wrote:  
> > >  1) Use i_lock to protect accesses to f_flags.  This would enable
> > > some BKL usage to be removed, but would not fix fasync.  
> >
> > What about just turning f_ep_lock into f_lock and using it?  
> 
> Ah, yes I was going to say that too, but I confused i_lock with
> i_mutex because it sounded like Jon needed a sleeping lock here?

Sigh, obviously that's what I should do.  Sorry for being so dense.
Consider it done.

[About sleeping locks: *if* one puts a lock around ->fasync(), it needs
to be a sleeping lock.  But moving FASYNC bit handling down gets rid of
the need to do that, so f_lock would be fine.]

Thanks,

jon
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
