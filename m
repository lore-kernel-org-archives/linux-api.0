From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH] userns,pidns: Verify the userns for new pid namespaces
Date: Sat, 29 Apr 2017 15:53:25 -0500
Message-ID: <20170429205325.GB1119@mail.hallyn.com>
References: <149329634856.21195.14196911999722279118.stgit@localhost.localdomain>
 <87mvb16fv7.fsf@xmission.com>
 <12a73543-79ea-4bac-7e96-6ab237534af2@virtuozzo.com>
 <877f254yx0.fsf@xmission.com>
 <a9941daf-861b-453c-37b8-e95389a9959b@virtuozzo.com>
 <8737crt4dz.fsf@xmission.com>
 <87vapnrp7f.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87vapnrp7f.fsf_-_@xmission.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>, serge@hallyn.com, agruenba@redhat.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, oleg@redhat.com, paul@paul-moore.com, viro@zeniv.linux.org.uk, avagin@openvz.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, mtk.manpages@gmail.com, akpm@linux-foundation.org, luto@amacapital.net, gorcunov@openvz.org, mingo@kernel.org, keescook@chromium.org, Kirill Tkhai <ktkhai@virtuozzo.com>
List-Id: linux-api@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> It is pointless and confusing to allow a pid namespace hierarchy and
> the user namespace hierarchy to get out of sync.  The owner of a child
> pid namespace should be the owner of the parent pid namespace or
> a descendant of the owner of the parent pid namespace.
> 
> Otherwise it is possible to construct scenarios where it is legal to
> do something in a parent pid namespace but in a child pid namespace.

Hi,

did you mean 'but not in a child...' above?

> It requires use of setns into a pid namespace (but not into a user
> namespace) to create such a scenario.
> 
> Add the function in_userns to help in making this determination.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
> 
> While review a patch from Kiril Tkhai I realized we were missing this
> sanity check....
> 
>  include/linux/user_namespace.h |  8 +++++++-
>  kernel/pid_namespace.c         |  4 ++++
>  kernel/user_namespace.c        | 18 ++++++++++++------
>  3 files changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
> index 32354b4b4b2b..497ed50004db 100644
> --- a/include/linux/user_namespace.h
> +++ b/include/linux/user_namespace.h
> @@ -112,8 +112,9 @@ extern ssize_t proc_projid_map_write(struct file *, const char __user *, size_t,
>  extern ssize_t proc_setgroups_write(struct file *, const char __user *, size_t, loff_t *);
>  extern int proc_setgroups_show(struct seq_file *m, void *v);
>  extern bool userns_may_setgroups(const struct user_namespace *ns);
> +extern bool in_userns(const struct user_namespace *ancestor,
> +		       const struct user_namespace *child);
>  extern bool current_in_userns(const struct user_namespace *target_ns);
> -
>  struct ns_common *ns_get_owner(struct ns_common *ns);
>  #else
>  
> @@ -144,6 +145,11 @@ static inline bool userns_may_setgroups(const struct user_namespace *ns)
>  	return true;
>  }
>  
> +static inline bool in_userns(const struct user_namespace *target_ns)
> +{
> +	return true;
> +}
> +
>  static inline bool current_in_userns(const struct user_namespace *target_ns)
>  {
>  	return true;
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index de461aa0bf9a..749147f5a613 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -101,6 +101,10 @@ static struct pid_namespace *create_pid_namespace(struct user_namespace *user_ns
>  	int i;
>  	int err;
>  
> +	err = -EINVAL;
> +	if (!in_userns(parent_pid_ns->user_ns, user_ns))
> +		goto out;
> +
>  	err = -ENOSPC;
>  	if (level > MAX_PID_NS_LEVEL)
>  		goto out;
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 2f735cbe05e8..7d8658fbabc8 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -986,19 +986,25 @@ bool userns_may_setgroups(const struct user_namespace *ns)
>  }
>  
>  /*
> - * Returns true if @ns is the same namespace as or a descendant of
> - * @target_ns.
> + * Returns true if @child is the same namespace or a descendant of
> + * @ancestor.
>   */
> -bool current_in_userns(const struct user_namespace *target_ns)
> +bool in_userns(const struct user_namespace *ancestor,
> +	       const struct user_namespace *child)
>  {
> -	struct user_namespace *ns;
> -	for (ns = current_user_ns(); ns; ns = ns->parent) {
> -		if (ns == target_ns)
> +	const struct user_namespace *ns;
> +	for (ns = child; ns; ns = ns->parent) {
> +		if (ns == ancestor)
>  			return true;
>  	}
>  	return false;
>  }
>  
> +bool current_in_userns(const struct user_namespace *target_ns)
> +{
> +	return in_userns(target_ns, current_user_ns());
> +}
> +
>  static inline struct user_namespace *to_user_ns(struct ns_common *ns)
>  {
>  	return container_of(ns, struct user_namespace, ns);
> -- 
> 2.10.1
