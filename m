From: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/7] cgroup: mount cgroupns-root when inside non-init
 cgroupns
Date: Tue, 8 Dec 2015 17:21:24 -0600
Message-ID: <20151208232124.GA17234@mail.hallyn.com>
References: <1449529582-4075-1-git-send-email-serge.hallyn@ubuntu.com>
 <1449529582-4075-6-git-send-email-serge.hallyn@ubuntu.com>
 <20151208162040.GC30240@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151208162040.GC30240-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Dec 08, 2015 at 11:20:40AM -0500, Tejun Heo wrote:
> Hello,
> 
> On Mon, Dec 07, 2015 at 05:06:20PM -0600, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org wrote:
> >  fs/kernfs/mount.c      |   74 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/kernfs.h |    2 ++
> >  kernel/cgroup.c        |   39 ++++++++++++++++++++++++-
> >  3 files changed, 114 insertions(+), 1 deletion(-)
> 
> Please put kernfs changes in a spearate patch.
> 
> > diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
> > index 8eaf417..9219444 100644
> > --- a/fs/kernfs/mount.c
> > +++ b/fs/kernfs/mount.c
> > @@ -62,6 +63,79 @@ struct kernfs_root *kernfs_root_from_sb(struct super_block *sb)
> >  	return NULL;
> >  }
> >  
> > +/*
> > + * find the next ancestor in the path down to @child, where @parent was the
> > + * parent whose child we want to find.
> 
> s/parent/ancestor/ s/child/descendant/ ?
> 
> > + *
> > + * Say the path is /a/b/c/d.  @child is d, @parent is NULL.  We return the root
> > + * node.  If @parent is b, then we return the node for c.
> > + * Passing in d as @parent is not ok.
> > + */
> > +static struct kernfs_node *
> > +find_next_ancestor(struct kernfs_node *child, struct kernfs_node *parent)
> > +{
> > +	if (child == parent) {
> > +		pr_crit_once("BUG in find_next_ancestor: called with parent == child");
> > +		return NULL;
> > +	}
> > +
> > +	while (child->parent != parent) {
> > +		if (!child->parent)
> > +			return NULL;
> > +		child = child->parent;
> > +	}
> > +
> > +	return child;
> > +}
> > +
> > +/**
> > + * kernfs_obtain_root - get a dentry for the given kernfs_node
> > + * @sb: the kernfs super_block
> > + * @kn: kernfs_node for which a dentry is needed
> > + *
> > + * This can be used by callers which want to mount only a part of the kernfs
> > + * as root of the filesystem.
> > + */
> > +struct dentry *kernfs_obtain_root(struct super_block *sb,
> > +				  struct kernfs_node *kn)
> 
> Wouldn't @kn, @sb be a better order?  Also, kernfs super_blocks are
> determined by the kernfs_root and its namespace.  I wonder whether
> specifying @ns would be better.

That would require kernfs to keep a mapping from an opaque void* to the
kernfs_nodes, though.  This way the caller can worry about how to choose a
kernfs_node from the namespace object.

It might be worth it to make 'namespacing' of kernfs more boilerplate, but OTOH
this could also fall under the old kernel rule of don't add it until there's a
user, i.e. until there's a second user to justify the abstraction.

> > +{
> > +	struct dentry *dentry;
> > +	struct kernfs_node *knparent = NULL;
> > +
> > +	BUG_ON(sb->s_op != &kernfs_sops);
> > +
> > +	dentry = dget(sb->s_root);
> > +	if (!kn->parent) // this is the root
> 			^^^
> 			Do we do this now?
> 
> > +		return dentry;
> > +
> > +	knparent = find_next_ancestor(kn, NULL);
> > +	if (!knparent) {
> > +		pr_crit("BUG: find_next_ancestor for root dentry returned NULL\n");
> 
> Wouldn't stack dump helpful here?  Why not
> 
> 	if (WARN_ONCE(!knparent, "find_next..."))
> 		return ERR_PTR(-EINVAL);
> 
> or even just WARN_ON_ONCE().
> 
> > +		return ERR_PTR(-EINVAL);
> > +	}
> > +
> > +	do {
> > +		struct dentry *dtmp;
> > +		struct kernfs_node *kntmp;
> > +
> > +		if (kn == knparent)
> > +			return dentry;
> > +		kntmp = find_next_ancestor(kn, knparent);
> > +		if (!kntmp) {
> > +			pr_crit("BUG: find_next_ancestor returned NULL for node\n");
> 
> Ditto.  It'd be a kernel bug.  WARN is usually the better way.
> 
> > diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> > index a5ab74d..09cd718 100644
> > --- a/kernel/cgroup.c
> > +++ b/kernel/cgroup.c
> > @@ -2011,6 +2011,15 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
> >  	int ret;
> >  	int i;
> >  	bool new_sb;
> > +	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
> 
> Please move this upwards so that it's below other initialized
> variables.
> 
> > +
> > +	get_cgroup_ns(ns);
> > +
> > +	/* Check if the caller has permission to mount. */
> > +	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN)) {
> > +		put_cgroup_ns(ns);
> > +		return ERR_PTR(-EPERM);
> > +	}
> >  
> >  	/*
> >  	 * The first time anyone tries to mount a cgroup, enable the list
> > @@ -2127,6 +2136,11 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
> >  		goto out_unlock;
> >  	}
> >  
> > +	if (!opts.none && !capable(CAP_SYS_ADMIN)) {
> > +		ret = -EPERM;
> > +		goto out_unlock;
> > +	}
> 
> Hmmm... why is !opts.none necessary?  Please add a comment explaining
> why the above is necessary.
> 
> >  out_mount:
> >  	dentry = kernfs_mount(fs_type, flags, root->kf_root,
> >  			      is_v2 ? CGROUP2_SUPER_MAGIC : CGROUP_SUPER_MAGIC,
> >  			      &new_sb);
> > +
> > +	if (!IS_ERR(dentry)) {
> > +		/*
> > +		 * In non-init cgroup namespace, instead of root cgroup's
> > +		 * dentry, we return the dentry corresponding to the
> > +		 * cgroupns->root_cgrp.
> > +		 */
> > +		if (ns != &init_cgroup_ns) {
> 
> 	if (!IS_ERR(dentry) && ns != &init_cgroup_ns) {
> 
> > +			struct dentry *nsdentry;
> > +			struct cgroup *cgrp;
> > +
> > +			cgrp = cset_cgroup_from_root(ns->root_cset, root);
> > +			nsdentry = kernfs_obtain_root(dentry->d_sb,
> > +				cgrp->kn);
> 
> Heh, is kernfs_obtain_root() the right name?  Maybe
> kernfs_node_to_inode()?

kernfs_node_to_dentry?

This would presumably make the question of whether to pass in a namespace
moot?
