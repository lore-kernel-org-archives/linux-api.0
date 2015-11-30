From: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/8] kernfs: Add API to generate relative kernfs path
Date: Mon, 30 Nov 2015 12:37:58 -0600
Message-ID: <20151130183758.GA25433@mail.hallyn.com>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
 <1447703505-29672-2-git-send-email-serge@hallyn.com>
 <20151124161630.GL17033@mtj.duckdns.org>
 <20151127052511.GA25490@mail.hallyn.com>
 <20151130151147.GG3535@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151130151147.GG3535-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 30, 2015 at 10:11:47AM -0500, Tejun Heo wrote:
> Hello,
> 
> On Thu, Nov 26, 2015 at 11:25:11PM -0600, Serge E. Hallyn wrote:
> > > > +	/* Short-circuit the easy case - kn_to is the root node. */
> > > > +	if ((kn_from == kn_to) || (!kn_from && !kn_to->parent)) {
> > > > +		*p = '/';
> > > > +		*(p + 1) = '\0';
> > > 
> > > Hmm... so if kn_from == kn_to, the output is "/"?
> > 
> > Yes, that's what seems to make the most sense for cgroup namespaces.  I
> > could see a case for '.' being used instead in general, but for cgroup
> > namespaces I think we'd have to convert those back to '/'.  Otherwise
> > we'll fail in being able to run legacy software, which would get
> > confused.
> 
> Yeah, I agree but the name is kinda misleading tho.  The output isn't
> really a relative path but rather absolute path against the specified
> root.  Maybe updating the function and parameter names would be
> helpful?
> 
> Thanks.

Ok - updating the comment is simple enough.  Though the name/params
kernfs_path_from_node_locked(from, to) still seem to make sense.  Would
you prefer something like kernfs_absolute_path_from node_locked()?  I
hesitate to call 'from' 'root' since kernfs_root is a thing and this
is not that.
