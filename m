From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup namespaces: add a 'nsroot=' mountinfo field
Date: Wed, 13 Apr 2016 13:46:39 -0500
Message-ID: <20160413184639.GA29483@mail.hallyn.com>
References: <20160321234133.GA22463@mail.hallyn.com>
 <20160413175736.GC3676@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160413175736.GC3676-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Linux Containers <containers-qjLDD68F18O7TbgM5vRIOg@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> Hello, Serge.
> 
> Sorry about the delay.
> 
> On Mon, Mar 21, 2016 at 06:41:33PM -0500, Serge E. Hallyn wrote:
> >  struct kernfs_syscall_ops {
> >  	int (*remount_fs)(struct kernfs_root *root, int *flags, char *data);
> > -	int (*show_options)(struct seq_file *sf, struct kernfs_root *root);
> > +	int (*show_options)(struct seq_file *sf, struct dentry *dentry,
> > +			    struct kernfs_root *root);
> 
> Wouldn't it make more sense to pass in kernfs_node pointer instead of
> dentry pointer?

Yeah that definately seems better.

> > +static void cgroup_show_nsroot(struct seq_file *seq, struct dentry *dentry,
> > +			       struct kernfs_root *kf_root)
> > +{
> > +	struct kernfs_node *d_kn = dentry->d_fsdata;
> > +	char *nsroot;
> > +	int len, ret;
> > +
> > +	if (!kf_root)
> > +		return;
> > +	len = kernfs_path_from_node(d_kn, kf_root->kn, NULL, 0);
> > +	if (len <= 0)
> > +		return;
> > +	nsroot = kzalloc(len + 1, GFP_ATOMIC);
> > +	if (!nsroot)
> > +		return;
> > +	ret = kernfs_path_from_node(d_kn, kf_root->kn, nsroot, len + 1);
> > +	if (ret <= 0 || ret > len)
> > +		goto out;
> 
> Hmmm.... does this mean that someone inside cgroup ns would be able to
> find out the absolute cgroup path of the ns root from inside?  If so,
> wouldn't that be an unnecessary information leak?

It's not a leak of any information we're trying to hide.  I realize
something like 8 years have passed, but I still basically go by the
ksummit guidance that containers are ok but the kernel's first priority
is to facilitate containers but not trick containers into thinking
they're not containerized.  So long as the container is properly set
up, I don't think there's anything the workload could do with the
nsroot= info other than *know* that it is in a ns cgroup.

If we did change that guidance, there's a slew of proc info that we
could better virtualize :)

thanks,
-serge
