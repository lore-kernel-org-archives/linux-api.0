From: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 7/8] cgroup: mount cgroupns-root when inside non-init
 cgroupns
Date: Mon, 30 Nov 2015 22:07:04 -0600
Message-ID: <20151201040704.GA31067@mail.hallyn.com>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
 <1447703505-29672-8-git-send-email-serge@hallyn.com>
 <20151124171610.GS17033@mtj.duckdns.org>
 <20151127051745.GA24521@mail.hallyn.com>
 <20151130150938.GF3535@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151130150938.GF3535-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 30, 2015 at 10:09:38AM -0500, Tejun Heo wrote:
> Hello, Serge.
> 
> On Thu, Nov 26, 2015 at 11:17:45PM -0600, Serge E. Hallyn wrote:
> > > Wouldn't it be simpler to walk dentry from kernfs root than
> > > duplicating dentry instantiation?
> > 
> > Sorry I don't think I'm following.  Are you suggesting walking the
> > kn->parent chain backward and doing d_lookup() at each point starting
> > with sb->s_root?
> 
> Yeah, something like that.  I wonder whether there are already code
> paths doing that.  What we need is a straight path walk.  I could be
> wrong but it shouldn't be that complex and if it works out we can
> avoid introducing another instantiation / lookup path.
> 
> Thanks.

So actually the way the code is now, the first mount cannot
be done from a non-init user namespace; and kernfs_obtain_root()
is only called from non-init user namespace.  So can we assume
that the root dentry will be instantiated?  (or can it get
evicted?)

If we can assume that then most of that fn can go away.
