From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/8] cgroup: mount cgroupns-root when inside non-init
 cgroupns
Date: Wed, 25 Nov 2015 14:57:05 -0500
Message-ID: <20151125195705.GE14240@htj.duckdns.org>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
 <1447703505-29672-8-git-send-email-serge@hallyn.com>
 <20151124171610.GS17033@mtj.duckdns.org>
 <20151125060156.GA678@mail.hallyn.com>
 <20151125191041.GB14240@htj.duckdns.org>
 <20151125195553.GA5852@ubuntumail>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151125195553.GA5852@ubuntumail>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Nov 25, 2015 at 07:55:53PM +0000, Serge Hallyn wrote:
> Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> > Hello, Serge.
> > 
> > On Wed, Nov 25, 2015 at 12:01:56AM -0600, Serge E. Hallyn wrote:
> > > that was my goal with https://git.kernel.org/cgit/linux/kernel/git/sergeh/linux-security.git/commit/?h=cgroupns.v4&id=8eb75d2bb24df59e262f050dce567d2332adc5f3
> > > (which was sent inline earlier in this thread in response to Eric)  Does
> > > that look sufficient?
> > 
> > Hmmm... but that wouldn't work with non-root and user ns.  I think
> 
> Are you sure?  IIUC that code block is only hit when we didn't find
> an already-mounted subsystem.

Heh, you're right.  This should work.

Thanks.

-- 
tejun
