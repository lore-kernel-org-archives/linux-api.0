From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH V36 02/29] security: Add a "locked down" LSM hook
Date: Thu, 18 Jul 2019 13:03:41 -0700
Message-ID: <b2d853d9-4968-d0ea-9d9b-cba2b9957394@schaufler-ca.com>
References: <20190718194415.108476-1-matthewgarrett@google.com>
 <20190718194415.108476-3-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190718194415.108476-3-matthewgarrett@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>, jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Matthew Garrett <mjg59@google.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On 7/18/2019 12:43 PM, Matthew Garrett wrote:
> Add a mechanism to allow LSMs to make a policy decision around whether
> kernel functionality that would allow tampering with or examining the
> runtime state of the kernel should be permitted.
>
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> Acked-by: Kees Cook <keescook@chromium.org>

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

> ---
>  include/linux/lsm_hooks.h |  2 ++
>  include/linux/security.h  | 32 ++++++++++++++++++++++++++++++++
>  security/security.c       |  6 ++++++
>  3 files changed, 40 insertions(+)
>
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index aebb0e032072..29c22cf40113 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -1807,6 +1807,7 @@ union security_list_options {
>  	int (*bpf_prog_alloc_security)(struct bpf_prog_aux *aux);
>  	void (*bpf_prog_free_security)(struct bpf_prog_aux *aux);
>  #endif /* CONFIG_BPF_SYSCALL */
> +	int (*locked_down)(enum lockdown_reason what);
>  };
>  
>  struct security_hook_heads {
> @@ -2046,6 +2047,7 @@ struct security_hook_heads {
>  	struct hlist_head bpf_prog_alloc_security;
>  	struct hlist_head bpf_prog_free_security;
>  #endif /* CONFIG_BPF_SYSCALL */
> +	struct hlist_head locked_down;
>  } __randomize_layout;
>  
>  /*
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 66a2fcbe6ab0..c2b1204e8e26 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -77,6 +77,33 @@ enum lsm_event {
>  	LSM_POLICY_CHANGE,
>  };
>  
> +/*
> + * These are reasons that can be passed to the security_locked_down()
> + * LSM hook. Lockdown reasons that protect kernel integrity (ie, the
> + * ability for userland to modify kernel code) are placed before
> + * LOCKDOWN_INTEGRITY_MAX.  Lockdown reasons that protect kernel
> + * confidentiality (ie, the ability for userland to extract
> + * information from the running kernel that would otherwise be
> + * restricted) are placed before LOCKDOWN_CONFIDENTIALITY_MAX.
> + *
> + * LSM authors should note that the semantics of any given lockdown
> + * reason are not guaranteed to be stable - the same reason may block
> + * one set of features in one kernel release, and a slightly different
> + * set of features in a later kernel release. LSMs that seek to expose
> + * lockdown policy at any level of granularity other than "none",
> + * "integrity" or "confidentiality" are responsible for either
> + * ensuring that they expose a consistent level of functionality to
> + * userland, or ensuring that userland is aware that this is
> + * potentially a moving target. It is easy to misuse this information
> + * in a way that could break userspace. Please be careful not to do
> + * so.
> + */
> +enum lockdown_reason {
> +	LOCKDOWN_NONE,
> +	LOCKDOWN_INTEGRITY_MAX,
> +	LOCKDOWN_CONFIDENTIALITY_MAX,
> +};
> +
>  /* These functions are in security/commoncap.c */
>  extern int cap_capable(const struct cred *cred, struct user_namespace *ns,
>  		       int cap, unsigned int opts);
> @@ -393,6 +420,7 @@ void security_inode_invalidate_secctx(struct inode *inode);
>  int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
>  int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
>  int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen);
> +int security_locked_down(enum lockdown_reason what);
>  #else /* CONFIG_SECURITY */
>  
>  static inline int call_blocking_lsm_notifier(enum lsm_event event, void *data)
> @@ -1205,6 +1233,10 @@ static inline int security_inode_getsecctx(struct inode *inode, void **ctx, u32
>  {
>  	return -EOPNOTSUPP;
>  }
> +static inline int security_locked_down(enum lockdown_reason what)
> +{
> +	return 0;
> +}
>  #endif	/* CONFIG_SECURITY */
>  
>  #ifdef CONFIG_SECURITY_NETWORK
> diff --git a/security/security.c b/security/security.c
> index 90f1e291c800..ce6c945bf347 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -2392,3 +2392,9 @@ void security_bpf_prog_free(struct bpf_prog_aux *aux)
>  	call_void_hook(bpf_prog_free_security, aux);
>  }
>  #endif /* CONFIG_BPF_SYSCALL */
> +
> +int security_locked_down(enum lockdown_reason what)
> +{
> +	return call_int_hook(locked_down, 0, what);
> +}
> +EXPORT_SYMBOL(security_locked_down);
