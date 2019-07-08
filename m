From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 3/9] security: Add a hook for the point of notification
 insertion [ver #5]
Date: Mon, 8 Jul 2019 15:13:09 -0400
Message-ID: <541e5cb3-142b-fe87-dff6-260b46d34f2d@tycho.nsa.gov>
References: <156173690158.15137.3985163001079120218.stgit@warthog.procyon.org.uk>
 <156173694190.15137.8939274212328721351.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <156173694190.15137.8939274212328721351.stgit@warthog.procyon.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk
Cc: Casey Schaufler <casey@schaufler-ca.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 6/28/19 11:49 AM, David Howells wrote:
> Add a security hook that allows an LSM to rule on whether a notification
> message is allowed to be inserted into a particular watch queue.
> 
> The hook is given the following information:
> 
>   (1) The credentials of the triggerer (which may be init_cred for a system
>       notification, eg. a hardware error).
> 
>   (2) The credentials of the whoever set the watch.
> 
>   (3) The notification message.

As with the other proposed hooks, it is difficult to evaluate this hook 
without at least one implementation of the hook.  Since Casey is the 
only one requesting this hook, a Smack implementation would be the 
natural choice; I do not intend to implement this hook for SELinux. 
However, by providing this hook, you are in effect taking a position wrt 
the earlier controversy over it, i.e. that application developers must 
deal with the possibility that notifications can be dropped if a 
security module does not permit the triggerer to post the notification 
to the watcher, without any indication to either the triggerer or the 
watcher.  This is a choice you are making by providing this hook.  The 
alternative is to require that permission to set a watch imply the 
ability to receive all notifications for the watched object.  Aside from 
friendliness to application developers, the latter also yields stable, 
sane policy and better performance.

> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Casey Schaufler <casey@schaufler-ca.com>
> cc: Stephen Smalley <sds@tycho.nsa.gov>
> cc: linux-security-module@vger.kernel.org
> ---
> 
>   include/linux/lsm_hooks.h |   10 ++++++++++
>   include/linux/security.h  |   10 ++++++++++
>   security/security.c       |    6 ++++++
>   3 files changed, 26 insertions(+)
> 
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index f9d31f6445e4..fd4b2b14e7d0 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -1426,6 +1426,12 @@
>    *	from devices (as a global set).
>    *	@watch: The watch object
>    *
> + * @post_notification:
> + *	Check to see if a watch notification can be posted to a particular
> + *	queue.
> + *	@w_cred: The credentials of the whoever set the watch.
> + *	@cred: The event-triggerer's credentials
> + *	@n: The notification being posted
>    *
>    * Security hooks for using the eBPF maps and programs functionalities through
>    * eBPF syscalls.
> @@ -1705,6 +1711,9 @@ union security_list_options {
>   #ifdef CONFIG_WATCH_QUEUE
>   	int (*watch_key)(struct watch *watch, struct key *key);
>   	int (*watch_devices)(struct watch *watch);
> +	int (*post_notification)(const struct cred *w_cred,
> +				 const struct cred *cred,
> +				 struct watch_notification *n);
>   #endif /* CONFIG_WATCH_QUEUE */
>   
>   #ifdef CONFIG_SECURITY_NETWORK
> @@ -1985,6 +1994,7 @@ struct security_hook_heads {
>   #ifdef CONFIG_WATCH_QUEUE
>   	struct hlist_head watch_key;
>   	struct hlist_head watch_devices;
> +	struct hlist_head post_notification;
>   #endif /* CONFIG_WATCH_QUEUE */
>   #ifdef CONFIG_SECURITY_NETWORK
>   	struct hlist_head unix_stream_connect;
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 540863678355..5c074bf18bea 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -58,6 +58,7 @@ struct fs_context;
>   struct fs_parameter;
>   enum fs_value_type;
>   struct watch;
> +struct watch_notification;
>   
>   /* Default (no) options for the capable function */
>   #define CAP_OPT_NONE 0x0
> @@ -396,6 +397,9 @@ int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen);
>   #ifdef CONFIG_WATCH_QUEUE
>   int security_watch_key(struct watch *watch, struct key *key);
>   int security_watch_devices(struct watch *watch);
> +int security_post_notification(const struct cred *w_cred,
> +			       const struct cred *cred,
> +			       struct watch_notification *n);
>   #endif /* CONFIG_WATCH_QUEUE */
>   #else /* CONFIG_SECURITY */
>   
> @@ -1218,6 +1222,12 @@ static inline int security_watch_devices(struct watch *watch)
>   {
>   	return 0;
>   }
> +static inline int security_post_notification(const struct cred *w_cred,
> +					     const struct cred *cred,
> +					     struct watch_notification *n)
> +{
> +	return 0;
> +}
>   #endif /* CONFIG_WATCH_QUEUE */
>   #endif	/* CONFIG_SECURITY */
>   
> diff --git a/security/security.c b/security/security.c
> index 2c9919226ad1..459e87d55ac9 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -1928,6 +1928,12 @@ int security_watch_devices(struct watch *watch)
>   	return call_int_hook(watch_devices, 0, watch);
>   }
>   
> +int security_post_notification(const struct cred *w_cred,
> +			       const struct cred *cred,
> +			       struct watch_notification *n)
> +{
> +	return call_int_hook(post_notification, 0, w_cred, cred, n);
> +}
>   #endif /* CONFIG_WATCH_QUEUE */
>   
>   #ifdef CONFIG_SECURITY_NETWORK
> 
