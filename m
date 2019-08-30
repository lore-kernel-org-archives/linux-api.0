From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 10/11] selinux: Implement the watch_key security hook [ver
 #7]
Date: Fri, 30 Aug 2019 10:15:16 -0400
Message-ID: <21eb33e8-5624-0124-8690-bbea41a1b589@tycho.nsa.gov>
References: <156717343223.2204.15875738850129174524.stgit@warthog.procyon.org.uk>
 <156717352079.2204.16378075382991665807.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <156717352079.2204.16378075382991665807.stgit@warthog.procyon.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk
Cc: Casey Schaufler <casey@schaufler-ca.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 8/30/19 9:58 AM, David Howells wrote:
> Implement the watch_key security hook to make sure that a key grants the
> caller View permission in order to set a watch on a key.
> 
> For the moment, the watch_devices security hook is left unimplemented as
> it's not obvious what the object should be since the queue is global and
> didn't previously exist.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>   security/selinux/hooks.c |   14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 74dd46de01b6..a63249ad98ab 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -6533,6 +6533,17 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
>   	*_buffer = context;
>   	return rc;
>   }
> +
> +#ifdef CONFIG_KEY_NOTIFICATIONS
> +static int selinux_watch_key(struct key *key)
> +{
> +	struct key_security_struct *ksec = key->security;
> +	u32 sid = cred_sid(current_cred());

How does this differ from current_sid()?

And has current_sid() not been converted to use selinux_cred()? Looks 
like selinux_kernfs_init_security() also uses current_security() directly.

> +
> +	return avc_has_perm(&selinux_state,
> +			    sid, ksec->sid, SECCLASS_KEY, KEY_NEED_VIEW, NULL);
> +}
> +#endif
>   #endif
>   
>   #ifdef CONFIG_SECURITY_INFINIBAND
> @@ -6965,6 +6976,9 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
>   	LSM_HOOK_INIT(key_free, selinux_key_free),
>   	LSM_HOOK_INIT(key_permission, selinux_key_permission),
>   	LSM_HOOK_INIT(key_getsecurity, selinux_key_getsecurity),
> +#ifdef CONFIG_KEY_NOTIFICATIONS
> +	LSM_HOOK_INIT(watch_key, selinux_watch_key),
> +#endif
>   #endif
>   
>   #ifdef CONFIG_AUDIT
> 
