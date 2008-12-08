From: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] - support inheritance of mlocks across fork/exec V2
Date: Mon, 08 Dec 2008 15:33:05 -0600
Message-ID: <1228771985.3726.32.camel@calx>
References: <1227561707.6937.61.camel@lts-notebook>
	 <20081125152651.b4c3c18f.akpm@linux-foundation.org>
	 <1228331069.6693.73.camel@lts-notebook>
	 <20081206220729.042a926e.akpm@linux-foundation.org>
	 <1228770337.31442.44.camel@lts-notebook>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1228770337.31442.44.camel@lts-notebook>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lee Schermerhorn <Lee.Schermerhorn-VXdhtT5mjnY@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hugh-DTz5qymZ9yRBDgjK7y7TUQ@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2008-12-08 at 16:05 -0500, Lee Schermerhorn wrote:
> > > In support of a "lock prefix command"--e.g., mlock <cmd>
> <args> ...
> > > Analogous to taskset(1) for cpu affinity or numactl(8) for numa memory
> > > policy.
> > > 
> > > Together with patches to keep mlocked pages off the LRU, this will
> > > allow users/admins to lock down applications without modifying them,
> > > if their RLIMIT_MEMLOCK is sufficiently large, keeping their pages
> > > off the LRU and out of consideration for reclaim.
> > > 
> > > Potentially useful, as well, in real-time environments to force
> > > prefaulting and residency for applications that don't mlock themselves.

This is a bit scary to me. Privilege and mode inheritance across
processes is the root of many nasty surprises, security and otherwise. 

Here's a crazy alternative: add a flag to containers instead? I think
this is a better match to what you're trying to do and will keep people
from being surprised when an mlockall call in one thread causes a
fork/exec in another thread to crash their box, but only sometimes.

-- 
Mathematics is the supreme nostalgia of our time.

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
