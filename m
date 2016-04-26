From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] mountinfo: implement show_path for kernfs and cgroup
Date: Mon, 25 Apr 2016 21:42:07 -0500
Message-ID: <20160426024207.GA2783@mail.hallyn.com>
References: <1460923472-29370-1-git-send-email-serge.hallyn@ubuntu.com>
	<1460923472-29370-3-git-send-email-serge.hallyn@ubuntu.com>
	<20160418041126.GA424@mail.hallyn.com>
	<87mvoqqu48.fsf@x220.int.ebiederm.org>
	<20160419014419.GA19080@mail.hallyn.com>
	<20160419040546.GA20350@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160419040546.GA20350-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Serge E. Hallyn (serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org):
> Quoting Serge E. Hallyn (serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org):
> > Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
> > > "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> writes:
> > > 
> > > >> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> > > >> index 671dc05..9a0d7b3 100644
> > > >> --- a/kernel/cgroup.c
> > > >> +++ b/kernel/cgroup.c
> > > >> @@ -1593,6 +1593,40 @@ static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
> > > >>  	return 0;
> > > >>  }
> > > >>  
> > > >> +static int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
> > > >> +			    struct kernfs_root *kf_root)
> > > >> +{
> > > >> +	int len = 0, ret = 0;
> > > >> +	char *buf = NULL;
> > > >> +	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
> > > >> +	struct cgroup_root *kf_cgroot = cgroup_root_from_kf(kf_root);
> > > >> +	struct cgroup *ns_cgroup;
> > > >> +
> > > >> +	mutex_lock(&cgroup_mutex);
> > > >
> > > > Hm, I can't grab the cgroup mutex here because I already have the
> > > > namespace_sem.  But that's required by cset_cgroup_from_root().  Can
> > > > I just call that under rcu_read_lock() instead?  (Not without
> > > > changing the lockdep_assert_help()).  Is there another way to get the
> > > > info needed here?
> > > 
> > > Do we need the current cgroup namespace information at all?
> > > 
> > > Could we not get the relevant cgroup namespace from the mount of
> > > cgroupfs?
> > 
> > I don't think so.  That was my first inclination.  But at show_path()
> > all we have is the vfsmunt->mnt_root.  Since all cgroup namespaces
> > for a hierarchy share the same dentry tree and superblock, there's
> > no way to tell where the mount's namespace root is supposed to be.
> > 
> > whether we did
> > 
> > # enter new cgroup namespace rooted at cgroup /user.slice/user-1000.slice
> > mount -t cgroup -o freezer freezer /mnt
> > 
> > or
> > 
> > mount --bind /sys/fs/cgroup/freezer/user.slice/user-1000.slice /mnt
> > 
> > the mountinfo entry will be the same.
> > 
> > > In general the better path is not to have the contents of files depend on
> > > who is reading the file.
> 
> And actually, while as i said above this was my first inclination, I now
> think that's wrong.  /proc/$$/cgroup is virtualized per the reader.  The
> point of this patch is to make mountinfo virtualized analogously to
> /proc/$$/cgroup, so that we can be certain how a particular cgroup dentry
> relates to a task's actual cgroup.  So the mountinfo dentry root path
> should in fact depend on the reader.
> 
> Looking at it another way...  The value we're talking about shows us
> the path of the root dentry of a cgroup mount.  If a task in cgns2
> rooted at /a/b/c mounts a cgroupfs, it will see '/' as the root dentry.
> If a task in cgns1 rooted at /a/b looks at that mountinfo, '/' would
> be misleading.  It really should be '/c'.

So I think that for cgroup mount entries in mountinfo to be useful (i.e.
to criu) we either need the root dentry path to be given as relative to
the reader's cgroup namespace (as I have it in this patchset), or else
we need to add another piece of information in the mountinfo entry, such
as the nsfd inode number of the cgroup namespace in which it was
mounted.

-serge
