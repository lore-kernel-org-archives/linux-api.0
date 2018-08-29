From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v5 2/5] seccomp: make get_nth_filter available outside of
 CHECKPOINT_RESTORE
Date: Wed, 29 Aug 2018 21:07:59 +0200
Message-ID: <20180829190758.ajmmfdugq6xdoqdh@mailbox.org>
References: <20180828143603.8127-1-tycho@tycho.ws>
 <20180828143603.8127-3-tycho@tycho.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180828143603.8127-3-tycho@tycho.ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org, "Eric W . Biederman" <ebiederm@xmission.com>, Christian Brauner <christian.brauner@ubuntu.com>, Andy Lutomirski <luto@amacapital.net>, Serge Hallyn <serge@hallyn.com>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 28, 2018 at 08:36:00AM -0600, Tycho Andersen wrote:
> In the next commit we'll use this same mnemonic to get a listener for the
> nth filter, so we need it available outside of CHECKPOINT_RESTORE in the
> USER_NOTIFICATION case as well.
> 
> v2: new in v2
> v3: no changes
> v4: no changes
> v5: switch to CHECKPOINT_RESTORE || USER_NOTIFICATION to avoid warning when
>     only CONFIG_SECCOMP_FILTER is enabled.
> 
> Signed-off-by: Tycho Andersen <tycho@tycho.ws>
> CC: Kees Cook <keescook@chromium.org>
> CC: Andy Lutomirski <luto@amacapital.net>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: Eric W. Biederman <ebiederm@xmission.com>
> CC: "Serge E. Hallyn" <serge@hallyn.com>
> CC: Christian Brauner <christian.brauner@ubuntu.com>
> CC: Tyler Hicks <tyhicks@canonical.com>
> CC: Akihiro Suda <suda.akihiro@lab.ntt.co.jp>
> ---
>  kernel/seccomp.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

(Putting Serge and Jann in Cc. They seem to have been left out on
accident. :))

Acked-by: Christian Brauner <christian@brauner.io>

> 
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index a09eb5c05f68..ed786655186d 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -1188,7 +1188,8 @@ long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
>  	return do_seccomp(op, 0, uargs);
>  }
>  
> -#if defined(CONFIG_SECCOMP_FILTER) && defined(CONFIG_CHECKPOINT_RESTORE)
> +#if defined(CONFIG_CHECKPOINT_RESTORE) || \
> +	defined(CONFIG_SECCOMP_USER_NOTIFICATION)
>  static struct seccomp_filter *get_nth_filter(struct task_struct *task,
>  					     unsigned long filter_off)
>  {
> @@ -1235,6 +1236,7 @@ static struct seccomp_filter *get_nth_filter(struct task_struct *task,
>  	return filter;
>  }
>  
> +#if defined(CONFIG_CHECKPOINT_RESTORE)
>  long seccomp_get_filter(struct task_struct *task, unsigned long filter_off,
>  			void __user *data)
>  {
> @@ -1307,7 +1309,8 @@ long seccomp_get_metadata(struct task_struct *task,
>  	__put_seccomp_filter(filter);
>  	return ret;
>  }
> -#endif
> +#endif /* CONFIG_CHECKPOINT_RESTORE */
> +#endif /* CONFIG_SECCOMP_FILTER */
>  
>  #ifdef CONFIG_SYSCTL
>  
> -- 
> 2.17.1
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
