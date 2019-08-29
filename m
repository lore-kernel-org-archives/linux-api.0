From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 10/11] selinux: Implement the watch_key security hook [ver
 #6]
Date: Thu, 29 Aug 2019 14:44:33 -0400
Message-ID: <03eb0974-3996-f356-5fbe-17cf598b0e31@tycho.nsa.gov>
References: <156710338860.10009.12524626894838499011.stgit@warthog.procyon.org.uk>
 <156710348066.10009.17986469867635955040.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <156710348066.10009.17986469867635955040.stgit@warthog.procyon.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk
Cc: Casey Schaufler <casey@schaufler-ca.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 8/29/19 2:31 PM, David Howells wrote:
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
>   security/selinux/hooks.c |   17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 74dd46de01b6..371f2ebc879b 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -6533,6 +6533,20 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
>   	*_buffer = context;
>   	return rc;
>   }
> +
> +#ifdef CONFIG_KEY_NOTIFICATIONS
> +static int selinux_watch_key(struct watch *watch, struct key *key)
> +{
> +	struct key_security_struct *ksec;
> +	u32 sid;
> +
> +	sid = cred_sid(watch->cred);

Can watch->cred ever differ from current's cred here?  If not, why can't 
we just use current_sid() here and why do we need the watch object at all?

> +	ksec = key->security;
> +
> +	return avc_has_perm(&selinux_state,
> +			    sid, ksec->sid, SECCLASS_KEY, KEY_NEED_VIEW, NULL);
> +}
> +#endif
>   #endif
>   
>   #ifdef CONFIG_SECURITY_INFINIBAND
> @@ -6965,6 +6979,9 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
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
