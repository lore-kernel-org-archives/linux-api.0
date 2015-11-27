From: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/8] kernfs: Add API to generate relative kernfs path
Date: Thu, 26 Nov 2015 23:25:11 -0600
Message-ID: <20151127052511.GA25490@mail.hallyn.com>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
 <1447703505-29672-2-git-send-email-serge@hallyn.com>
 <20151124161630.GL17033@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151124161630.GL17033-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 24, 2015 at 11:16:30AM -0500, Tejun Heo wrote:
> Hello,
> 
> On Mon, Nov 16, 2015 at 01:51:38PM -0600, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org wrote:
> > +static char * __must_check kernfs_path_from_node_locked(

(Note I've rewritten this to find a common ancestor and walk back to
and from that, as you suggested later in this email)

> > +	/* Short-circuit the easy case - kn_to is the root node. */
> > +	if ((kn_from == kn_to) || (!kn_from && !kn_to->parent)) {
> > +		*p = '/';
> > +		*(p + 1) = '\0';
> 
> Hmm... so if kn_from == kn_to, the output is "/"?

Yes, that's what seems to make the most sense for cgroup namespaces.  I
could see a case for '.' being used instead in general, but for cgroup
namespaces I think we'd have to convert those back to '/'.  Otherwise
we'll fail in being able to run legacy software, which would get
confused.

-serge
