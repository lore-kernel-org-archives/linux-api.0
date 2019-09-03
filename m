From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 11/11] smack: Implement the watch_key and
 post_notification hooks [untested] [ver #7]
Date: Tue, 3 Sep 2019 08:20:46 -0700
Message-ID: <e36fa722-a300-2abf-ae9c-a0246fc66d0e@schaufler-ca.com>
References: <156717343223.2204.15875738850129174524.stgit@warthog.procyon.org.uk>
 <156717352917.2204.17206219813087348132.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <156717352917.2204.17206219813087348132.stgit@warthog.procyon.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, casey@schaufler-ca.com
List-Id: linux-api@vger.kernel.org

On 8/30/2019 6:58 AM, David Howells wrote:
> Implement the watch_key security hook in Smack to make sure that a key
> grants the caller Read permission in order to set a watch on a key.
>
> Also implement the post_notification security hook to make sure that th=
e
> notification source is granted Write permission by the watch queue.
>
> For the moment, the watch_devices security hook is left unimplemented a=
s
> it's not obvious what the object should be since the queue is global an=
d
> didn't previously exist.
>
> Signed-off-by: David Howells <dhowells@redhat.com>

I tried running your key tests and they fail in "keyctl/move/valid",
with 11 FAILED messages, finally hanging after "UNLINK KEY FROM SESSION".=

It's possible that my Fedora26 system is somehow incompatible with the
tests. I don't see anything in your code that would cause this, as the
Smack policy on the system shouldn't restrict any access.

> ---
>
>  include/linux/lsm_audit.h  |    1 +
>  security/smack/smack_lsm.c |   82 ++++++++++++++++++++++++++++++++++++=
+++++++-
>  2 files changed, 82 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/lsm_audit.h b/include/linux/lsm_audit.h
> index 915330abf6e5..734d67889826 100644
> --- a/include/linux/lsm_audit.h
> +++ b/include/linux/lsm_audit.h
> @@ -74,6 +74,7 @@ struct common_audit_data {
>  #define LSM_AUDIT_DATA_FILE	12
>  #define LSM_AUDIT_DATA_IBPKEY	13
>  #define LSM_AUDIT_DATA_IBENDPORT 14
> +#define LSM_AUDIT_DATA_NOTIFICATION 15
>  	union 	{
>  		struct path path;
>  		struct dentry *dentry;
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 4c5e5a438f8b..1c2a908c6446 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -4274,7 +4274,7 @@ static int smack_key_permission(key_ref_t key_ref=
,
>  	if (tkp =3D=3D NULL)
>  		return -EACCES;
> =20
> -	if (smack_privileged_cred(CAP_MAC_OVERRIDE, cred))
> +	if (smack_privileged(CAP_MAC_OVERRIDE))
>  		return 0;
> =20
>  #ifdef CONFIG_AUDIT
> @@ -4320,8 +4320,81 @@ static int smack_key_getsecurity(struct key *key=
, char **_buffer)
>  	return length;
>  }
> =20
> +
> +#ifdef CONFIG_KEY_NOTIFICATIONS
> +/**
> + * smack_watch_key - Smack access to watch a key for notifications.
> + * @key: The key to be watched
> + *
> + * Return 0 if the @watch->cred has permission to read from the key ob=
ject and
> + * an error otherwise.
> + */
> +static int smack_watch_key(struct key *key)
> +{
> +	struct smk_audit_info ad;
> +	struct smack_known *tkp =3D smk_of_current();
> +	int rc;
> +
> +	if (key =3D=3D NULL)
> +		return -EINVAL;
> +	/*
> +	 * If the key hasn't been initialized give it access so that
> +	 * it may do so.
> +	 */
> +	if (key->security =3D=3D NULL)
> +		return 0;
> +	/*
> +	 * This should not occur
> +	 */
> +	if (tkp =3D=3D NULL)
> +		return -EACCES;
> +
> +	if (smack_privileged_cred(CAP_MAC_OVERRIDE, current_cred()))
> +		return 0;
> +
> +#ifdef CONFIG_AUDIT
> +	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_KEY);
> +	ad.a.u.key_struct.key =3D key->serial;
> +	ad.a.u.key_struct.key_desc =3D key->description;
> +#endif
> +	rc =3D smk_access(tkp, key->security, MAY_READ, &ad);
> +	rc =3D smk_bu_note("key watch", tkp, key->security, MAY_READ, rc);
> +	return rc;
> +}
> +#endif /* CONFIG_KEY_NOTIFICATIONS */
>  #endif /* CONFIG_KEYS */
> =20
> +#ifdef CONFIG_WATCH_QUEUE
> +/**
> + * smack_post_notification - Smack access to post a notification to a =
queue
> + * @w_cred: The credentials of the watcher.
> + * @cred: The credentials of the event source (may be NULL).
> + * @n: The notification message to be posted.
> + */
> +static int smack_post_notification(const struct cred *w_cred,
> +				   const struct cred *cred,
> +				   struct watch_notification *n)
> +{
> +	struct smk_audit_info ad;
> +	struct smack_known *subj, *obj;
> +	int rc;
> +
> +	/* Always let maintenance notifications through. */
> +	if (n->type =3D=3D WATCH_TYPE_META)
> +		return 0;
> +
> +	if (!cred)
> +		return 0;
> +	subj =3D smk_of_task(smack_cred(cred));
> +	obj =3D smk_of_task(smack_cred(w_cred));
> +
> +	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_NOTIFICATION);
> +	rc =3D smk_access(subj, obj, MAY_WRITE, &ad);
> +	rc =3D smk_bu_note("notification", subj, obj, MAY_WRITE, rc);
> +	return rc;
> +}
> +#endif /* CONFIG_WATCH_QUEUE */
> +
>  /*
>   * Smack Audit hooks
>   *
> @@ -4710,8 +4783,15 @@ static struct security_hook_list smack_hooks[] _=
_lsm_ro_after_init =3D {
>  	LSM_HOOK_INIT(key_free, smack_key_free),
>  	LSM_HOOK_INIT(key_permission, smack_key_permission),
>  	LSM_HOOK_INIT(key_getsecurity, smack_key_getsecurity),
> +#ifdef CONFIG_KEY_NOTIFICATIONS
> +	LSM_HOOK_INIT(watch_key, smack_watch_key),
> +#endif
>  #endif /* CONFIG_KEYS */
> =20
> +#ifdef CONFIG_WATCH_QUEUE
> +	LSM_HOOK_INIT(post_notification, smack_post_notification),
> +#endif
> +
>   /* Audit hooks */
>  #ifdef CONFIG_AUDIT
>  	LSM_HOOK_INIT(audit_rule_init, smack_audit_rule_init),
>
