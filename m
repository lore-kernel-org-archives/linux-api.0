From: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/7] cgroup: introduce cgroup namespaces
Date: Tue, 8 Dec 2015 13:34:31 -0600
Message-ID: <20151208193431.GB14814@mail.hallyn.com>
References: <1449529582-4075-1-git-send-email-serge.hallyn@ubuntu.com>
 <1449529582-4075-4-git-send-email-serge.hallyn@ubuntu.com>
 <20151208160453.GB30240@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151208160453.GB30240-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Dec 08, 2015 at 11:04:53AM -0500, Tejun Heo wrote:
> On Mon, Dec 07, 2015 at 05:06:18PM -0600, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org wrote:
> >  static const char *proc_ns_follow_link(struct dentry *dentry, void **cookie)
> > diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> > index 2b3e2314..906f240 100644
> > --- a/include/linux/cgroup.h
> > +++ b/include/linux/cgroup.h
> > @@ -17,11 +17,36 @@
> >  #include <linux/seq_file.h>
> >  #include <linux/kernfs.h>
> >  #include <linux/jump_label.h>
> > +#include <linux/nsproxy.h>
> > +#include <linux/types.h>
> > +#include <linux/ns_common.h>
> > +#include <linux/nsproxy.h>
> > +#include <linux/user_namespace.h>
> >  
> >  #include <linux/cgroup-defs.h>
> >  
> > +struct cgroup_namespace {
> > +	atomic_t		count;
> > +	struct ns_common	ns;
> > +	struct user_namespace	*user_ns;
> > +	struct css_set          *root_cset;
> > +};
> > +
> > +extern struct cgroup_namespace init_cgroup_ns;
> > +
> > +static inline void get_cgroup_ns(struct cgroup_namespace *ns)
> > +{
> > +	if (ns)
> > +		atomic_inc(&ns->count);
> > +}
> > +
> ..
> > +void free_cgroup_ns(struct cgroup_namespace *ns);
> > +struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
> > +		struct user_namespace *user_ns,
> > +		struct cgroup_namespace *old_ns);
> ...
> > +char * __must_check cgroup_path_ns(struct cgroup *cgrp, char *buf,
> > +				   size_t buflen, struct cgroup_namespace *ns);
> > +char * __must_check cgroup_path(struct cgroup *cgrp, char *buf, size_t buflen);
> ...
> > +static inline void put_cgroup_ns(struct cgroup_namespace *ns)
> > +{
> > +	if (ns && atomic_dec_and_test(&ns->count))
> > +		free_cgroup_ns(ns);
> > +}
> 
> I'd prefer collecting all ns related declarations in a single place.

I can group some of them, but free_cgroup_ns needs the
cgroup_namespace definition, put_cgroup_ns() needs free_cgroup_ns(),
and free_cgroup_ns() is static in the !CONFIG_CGROUPS case and a
non-static function in the other case.

So I'm going to put both get_cgroup_ns() and put_cgroup_ns() at the
end of the file, with the struct namespace define at the top.  Is
that sufficient?

> > diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> > index 7f2f007..4fd07b5a 100644
> > --- a/kernel/cgroup.c
> > +++ b/kernel/cgroup.c
> > @@ -297,6 +300,13 @@ static bool cgroup_on_dfl(const struct cgroup *cgrp)
> >  {
> >  	return cgrp->root == &cgrp_dfl_root;
> >  }
> 
> New line.
> 
> > +struct cgroup_namespace init_cgroup_ns = {
> > +	.count		= { .counter = 1, },
> > +	.user_ns	= &init_user_ns,
> > +	.ns.ops		= &cgroupns_operations,
> > +	.ns.inum	= PROC_CGROUP_INIT_INO,
> > +	.root_cset	= &init_css_set,
> > +};
> 
> Also, why inbetween two function defs?  cgroup.c is messy but you can
> still put it after other variable definitions.
> 
> > @@ -430,18 +440,18 @@ static inline bool cgroup_is_dead(const struct cgroup *cgrp)
> >  	return !(cgrp->self.flags & CSS_ONLINE);
> >  }
> >  
> > -static void cgroup_get(struct cgroup *cgrp)
> > +static inline void cgroup_get(struct cgroup *cgrp)
> >  {
> >  	WARN_ON_ONCE(cgroup_is_dead(cgrp));
> >  	css_get(&cgrp->self);
> >  }
> >  
> > -static bool cgroup_tryget(struct cgroup *cgrp)
> > +static inline bool cgroup_tryget(struct cgroup *cgrp)
> >  {
> >  	return css_tryget(&cgrp->self);
> >  }
> >  
> > -static void cgroup_put(struct cgroup *cgrp)
> > +static inline void cgroup_put(struct cgroup *cgrp)
> >  {
> >  	css_put(&cgrp->self);
> >  }
> >
> > @@ -780,7 +790,7 @@ static void put_css_set_locked(struct css_set *cset)
> >  	kfree_rcu(cset, rcu_head);
> >  }
> >  
> > -static void put_css_set(struct css_set *cset)
> > +static inline void put_css_set(struct css_set *cset)
> 
> Stray diffs?
> 
> > @@ -2189,6 +2199,25 @@ static struct file_system_type cgroup2_fs_type = {
> >  	.kill_sb = cgroup_kill_sb,
> >  };
> >  
> > +char * __must_check
> > +cgroup_path_ns(struct cgroup *cgrp, char *buf, size_t buflen,
> > +	       struct cgroup_namespace *ns)
> > +{
> > +	struct cgroup *root;
> > +
> > +	BUG_ON(!ns);
> 
> Just let it crash on NULL deref.
> 
> Thanks.
> 
> -- 
> tejun
> _______________________________________________
> Containers mailing list
> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
