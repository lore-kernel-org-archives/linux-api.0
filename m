From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] mountinfo: implement show_path for kernfs and cgroup
Date: Mon, 18 Apr 2016 20:44:19 -0500
Message-ID: <20160419014419.GA19080@mail.hallyn.com>
References: <1460923472-29370-1-git-send-email-serge.hallyn@ubuntu.com>
 <1460923472-29370-3-git-send-email-serge.hallyn@ubuntu.com>
 <20160418041126.GA424@mail.hallyn.com>
 <87mvoqqu48.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87mvoqqu48.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
> "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> writes:
> 
> >> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> >> index 671dc05..9a0d7b3 100644
> >> --- a/kernel/cgroup.c
> >> +++ b/kernel/cgroup.c
> >> @@ -1593,6 +1593,40 @@ static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
> >>  	return 0;
> >>  }
> >>  
> >> +static int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
> >> +			    struct kernfs_root *kf_root)
> >> +{
> >> +	int len = 0, ret = 0;
> >> +	char *buf = NULL;
> >> +	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
> >> +	struct cgroup_root *kf_cgroot = cgroup_root_from_kf(kf_root);
> >> +	struct cgroup *ns_cgroup;
> >> +
> >> +	mutex_lock(&cgroup_mutex);
> >
> > Hm, I can't grab the cgroup mutex here because I already have the
> > namespace_sem.  But that's required by cset_cgroup_from_root().  Can
> > I just call that under rcu_read_lock() instead?  (Not without
> > changing the lockdep_assert_help()).  Is there another way to get the
> > info needed here?
> 
> Do we need the current cgroup namespace information at all?
> 
> Could we not get the relevant cgroup namespace from the mount of
> cgroupfs?

I don't think so.  That was my first inclination.  But at show_path()
all we have is the vfsmunt->mnt_root.  Since all cgroup namespaces
for a hierarchy share the same dentry tree and superblock, there's
no way to tell where the mount's namespace root is supposed to be.

whether we did

# enter new cgroup namespace rooted at cgroup /user.slice/user-1000.slice
mount -t cgroup -o freezer freezer /mnt

or

mount --bind /sys/fs/cgroup/freezer/user.slice/user-1000.slice /mnt

the mountinfo entry will be the same.

> In general the better path is not to have the contents of files depend on
> who is reading the file.

-serge
