From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 1/4] kernel: add a helper to get an owning user namespace
 for a namespace
Date: Wed, 31 Aug 2016 16:59:03 -0500
Message-ID: <20160831215903.GA2206@mail.hallyn.com>
References: <1472252891-4963-1-git-send-email-avagin@openvz.org>
 <1472252891-4963-2-git-send-email-avagin@openvz.org>
 <20160831024146.GB21475@mail.hallyn.com>
 <CANaxB-zmWL7GDRSfVoTdb--sbQ_BtPrZrDrccADYbHKp6qKSgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANaxB-zmWL7GDRSfVoTdb--sbQ_BtPrZrDrccADYbHKp6qKSgw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andrey Vagin <avagin@openvz.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

Quoting Andrey Vagin (avagin@openvz.org):
> On Tue, Aug 30, 2016 at 7:41 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> > On Fri, Aug 26, 2016 at 04:08:08PM -0700, Andrei Vagin wrote:
> >> From: Andrey Vagin <avagin@openvz.org>
> >>
> >> Return -EPERM if an owning user namespace is outside of a process
> >> current user namespace.
> >>
> >> v2: In a first version ns_get_owner returned ENOENT for init_user_ns.
> >>     This special cases was removed from this version. There is nothing
> >>     outside of init_user_ns, so we can return EPERM.
> >>
> >> Signed-off-by: Andrei Vagin <avagin@openvz.org>
> >> ---
> >>  fs/namespace.c                 |  6 ++++++
> >>  include/linux/proc_ns.h        |  1 +
> >>  include/linux/user_namespace.h |  7 +++++++
> >>  ipc/namespace.c                |  6 ++++++
> >>  kernel/cgroup.c                |  6 ++++++
> >>  kernel/pid_namespace.c         |  6 ++++++
> >>  kernel/user_namespace.c        | 24 ++++++++++++++++++++++++
> >>  kernel/utsname.c               |  6 ++++++
> >>  net/core/net_namespace.c       |  6 ++++++
> >>  9 files changed, 68 insertions(+)
> >>
> >> diff --git a/fs/namespace.c b/fs/namespace.c
> >> index 491b8f3..f985817 100644
> >> --- a/fs/namespace.c
> >> +++ b/fs/namespace.c
> >> @@ -3368,10 +3368,16 @@ static int mntns_install(struct nsproxy *nsproxy, struct ns_common *ns)
> >>       return 0;
> >>  }
> >>
> >> +static struct user_namespace *mntns_get_owner(struct ns_common *ns)
> >> +{
> >> +     return to_mnt_ns(ns)->user_ns;
> >
> > Hi - sorry to be pedantic here, but *_get_owner makes me think
> > it will grab a reference too.  A bit unfortunate, maybe it doesn't
> > matter, but would mntns_owner(), netns_owner(), etc be better?
> 
> Actually it looks reasonable. Especially, when we have get_parent()
> which grabs a reference.
> 
> Serge, could you look at the attached patch? I will need to rebase
> other patches, if we accept this patch.
> 
> Thanks,
> Andrei

> From 423b2226dc9bcfefccbec21663e9287addd67e0f Mon Sep 17 00:00:00 2001
> From: Andrey Vagin <avagin@openvz.org>
> Date: Tue, 12 Jul 2016 15:32:36 -0700
> Subject: [PATCH] kernel: add a helper to get an owning user namespace for a
>  namespace
> 
> Return -EPERM if an owning user namespace is outside of a process
> current user namespace.
> 
> v2: In a first version ns_get_owner returned ENOENT for init_user_ns.
>     This special cases was removed from this version. There is nothing
>     outside of init_user_ns, so we can return EPERM.
> v3: rename ns->get_owner() to ns->owner(). get_* usually means that it
> grabs a reference.

Thanks, that should make it easier for a simpleminded fool
like myself to follow the references :)

> Signed-off-by: Andrei Vagin <avagin@openvz.org>

Acked-by: Serge Hallyn <serge@hallyn.com>

> ---
>  fs/namespace.c                 |  6 ++++++
>  include/linux/proc_ns.h        |  1 +
>  include/linux/user_namespace.h |  7 +++++++
>  ipc/namespace.c                |  6 ++++++
>  kernel/cgroup.c                |  6 ++++++
>  kernel/pid_namespace.c         |  6 ++++++
>  kernel/user_namespace.c        | 24 ++++++++++++++++++++++++
>  kernel/utsname.c               |  6 ++++++
>  net/core/net_namespace.c       |  6 ++++++
>  9 files changed, 68 insertions(+)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 491b8f3..dd27ce4 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -3368,10 +3368,16 @@ static int mntns_install(struct nsproxy *nsproxy, struct ns_common *ns)
>  	return 0;
>  }
>  
> +static struct user_namespace *mntns_owner(struct ns_common *ns)
> +{
> +	return to_mnt_ns(ns)->user_ns;
> +}
> +
>  const struct proc_ns_operations mntns_operations = {
>  	.name		= "mnt",
>  	.type		= CLONE_NEWNS,
>  	.get		= mntns_get,
>  	.put		= mntns_put,
>  	.install	= mntns_install,
> +	.owner		= mntns_owner,
>  };
> diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
> index de0e771..ca85a43 100644
> --- a/include/linux/proc_ns.h
> +++ b/include/linux/proc_ns.h
> @@ -18,6 +18,7 @@ struct proc_ns_operations {
>  	struct ns_common *(*get)(struct task_struct *task);
>  	void (*put)(struct ns_common *ns);
>  	int (*install)(struct nsproxy *nsproxy, struct ns_common *ns);
> +	struct user_namespace *(*owner)(struct ns_common *ns);
>  };
>  
>  extern const struct proc_ns_operations netns_operations;
> diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
> index 30ffe10..eb209d4 100644
> --- a/include/linux/user_namespace.h
> +++ b/include/linux/user_namespace.h
> @@ -106,6 +106,8 @@ extern ssize_t proc_setgroups_write(struct file *, const char __user *, size_t,
>  extern int proc_setgroups_show(struct seq_file *m, void *v);
>  extern bool userns_may_setgroups(const struct user_namespace *ns);
>  extern bool current_in_userns(const struct user_namespace *target_ns);
> +
> +struct ns_common *ns_get_owner(struct ns_common *ns);
>  #else
>  
>  static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
> @@ -139,6 +141,11 @@ static inline bool current_in_userns(const struct user_namespace *target_ns)
>  {
>  	return true;
>  }
> +
> +static inline struct ns_common *ns_get_owner(struct ns_common *ns)
> +{
> +	return ERR_PTR(-EPERM);
> +}
>  #endif
>  
>  #endif /* _LINUX_USER_H */
> diff --git a/ipc/namespace.c b/ipc/namespace.c
> index 7309142..465c981 100644
> --- a/ipc/namespace.c
> +++ b/ipc/namespace.c
> @@ -188,10 +188,16 @@ static int ipcns_install(struct nsproxy *nsproxy, struct ns_common *new)
>  	return 0;
>  }
>  
> +static struct user_namespace *ipcns_owner(struct ns_common *ns)
> +{
> +	return to_ipc_ns(ns)->user_ns;
> +}
> +
>  const struct proc_ns_operations ipcns_operations = {
>  	.name		= "ipc",
>  	.type		= CLONE_NEWIPC,
>  	.get		= ipcns_get,
>  	.put		= ipcns_put,
>  	.install	= ipcns_install,
> +	.owner		= ipcns_owner,
>  };
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index e9e4427..2665b58 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -6421,12 +6421,18 @@ static void cgroupns_put(struct ns_common *ns)
>  	put_cgroup_ns(to_cg_ns(ns));
>  }
>  
> +static struct user_namespace *cgroupns_owner(struct ns_common *ns)
> +{
> +	return to_cg_ns(ns)->user_ns;
> +}
> +
>  const struct proc_ns_operations cgroupns_operations = {
>  	.name		= "cgroup",
>  	.type		= CLONE_NEWCGROUP,
>  	.get		= cgroupns_get,
>  	.put		= cgroupns_put,
>  	.install	= cgroupns_install,
> +	.owner		= cgroupns_owner,
>  };
>  
>  static __init int cgroup_namespaces_init(void)
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index 30a7f33..c18f0f4f 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -405,12 +405,18 @@ static int pidns_install(struct nsproxy *nsproxy, struct ns_common *ns)
>  	return 0;
>  }
>  
> +static struct user_namespace *pidns_owner(struct ns_common *ns)
> +{
> +	return to_pid_ns(ns)->user_ns;
> +}
> +
>  const struct proc_ns_operations pidns_operations = {
>  	.name		= "pid",
>  	.type		= CLONE_NEWPID,
>  	.get		= pidns_get,
>  	.put		= pidns_put,
>  	.install	= pidns_install,
> +	.owner		= pidns_owner,
>  };
>  
>  static __init int pid_namespaces_init(void)
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 0edafe3..42a64d5 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -1050,12 +1050,36 @@ static int userns_install(struct nsproxy *nsproxy, struct ns_common *ns)
>  	return commit_creds(cred);
>  }
>  
> +struct ns_common *ns_get_owner(struct ns_common *ns)
> +{
> +	struct user_namespace *my_user_ns = current_user_ns();
> +	struct user_namespace *owner, *p;
> +
> +	/* See if the owner is in the current user namespace */
> +	owner = p = ns->ops->owner(ns);
> +	for (;;) {
> +		if (!p)
> +			return ERR_PTR(-EPERM);
> +		if (p == my_user_ns)
> +			break;
> +		p = p->parent;
> +	}
> +
> +	return &get_user_ns(owner)->ns;
> +}
> +
> +static struct user_namespace *userns_owner(struct ns_common *ns)
> +{
> +	return to_user_ns(ns)->parent;
> +}
> +
>  const struct proc_ns_operations userns_operations = {
>  	.name		= "user",
>  	.type		= CLONE_NEWUSER,
>  	.get		= userns_get,
>  	.put		= userns_put,
>  	.install	= userns_install,
> +	.owner		= userns_owner,
>  };
>  
>  static __init int user_namespaces_init(void)
> diff --git a/kernel/utsname.c b/kernel/utsname.c
> index f3b0bb4..0795e97 100644
> --- a/kernel/utsname.c
> +++ b/kernel/utsname.c
> @@ -154,10 +154,16 @@ static int utsns_install(struct nsproxy *nsproxy, struct ns_common *new)
>  	return 0;
>  }
>  
> +static struct user_namespace *utsns_owner(struct ns_common *ns)
> +{
> +	return to_uts_ns(ns)->user_ns;
> +}
> +
>  const struct proc_ns_operations utsns_operations = {
>  	.name		= "uts",
>  	.type		= CLONE_NEWUTS,
>  	.get		= utsns_get,
>  	.put		= utsns_put,
>  	.install	= utsns_install,
> +	.owner		= utsns_owner,
>  };
> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
> index 3e2812a..8619e89 100644
> --- a/net/core/net_namespace.c
> +++ b/net/core/net_namespace.c
> @@ -1016,11 +1016,17 @@ static int netns_install(struct nsproxy *nsproxy, struct ns_common *ns)
>  	return 0;
>  }
>  
> +static struct user_namespace *netns_owner(struct ns_common *ns)
> +{
> +	return to_net_ns(ns)->user_ns;
> +}
> +
>  const struct proc_ns_operations netns_operations = {
>  	.name		= "net",
>  	.type		= CLONE_NEWNET,
>  	.get		= netns_get,
>  	.put		= netns_put,
>  	.install	= netns_install,
> +	.owner		= netns_owner,
>  };
>  #endif
> -- 
> 2.5.5
> 

