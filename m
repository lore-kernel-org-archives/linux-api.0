From: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 7/8] cgroup: mount cgroupns-root when inside non-init
 cgroupns
Date: Thu, 26 Nov 2015 23:17:45 -0600
Message-ID: <20151127051745.GA24521@mail.hallyn.com>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
 <1447703505-29672-8-git-send-email-serge@hallyn.com>
 <20151124171610.GS17033@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151124171610.GS17033-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 24, 2015 at 12:16:10PM -0500, Tejun Heo wrote:
> Hello,
> 
> On Mon, Nov 16, 2015 at 01:51:44PM -0600, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org wrote:
> > +struct dentry *kernfs_obtain_root(struct super_block *sb,
> > +				  struct kernfs_node *kn)
> > +{
> > +	struct dentry *dentry;
> > +	struct inode *inode;
> > +
> > +	BUG_ON(sb->s_op != &kernfs_sops);
> > +
> > +	/* inode for the given kernfs_node should already exist. */
> > +	inode = ilookup(sb, kn->ino);
> > +	if (!inode) {
> > +		pr_debug("kernfs: could not get inode for '");
> > +		pr_cont_kernfs_path(kn);
> > +		pr_cont("'.\n");
> > +		return ERR_PTR(-EINVAL);
> > +	}
> 
> Hmmm... but inode might not have been instantiated yet.  Why not use
> kernfs_get_inode()?
> 
> > +	/* instantiate and link root dentry */
> > +	dentry = d_obtain_root(inode);
> > +	if (!dentry) {
> > +		pr_debug("kernfs: could not get dentry for '");
> > +		pr_cont_kernfs_path(kn);
> > +		pr_cont("'.\n");
> > +		return ERR_PTR(-ENOMEM);
> > +	}
> > +
> > +	/* If this is a new dentry, set it up. We need kernfs_mutex because this
> > +	 * may be called by callers other than kernfs_fill_super. */
> 
> Formatting.
> 
> > +	mutex_lock(&kernfs_mutex);
> > +	if (!dentry->d_fsdata) {
> > +		kernfs_get(kn);
> > +		dentry->d_fsdata = kn;
> > +	} else {
> > +		WARN_ON(dentry->d_fsdata != kn);
> > +	}
> > +	mutex_unlock(&kernfs_mutex);
> > +
> > +	return dentry;
> > +}
> 
> Wouldn't it be simpler to walk dentry from kernfs root than
> duplicating dentry instantiation?

Sorry I don't think I'm following.  Are you suggesting walking the
kn->parent chain backward and doing d_lookup() at each point starting
with sb->s_root?
