From: Sergei Zviagintsev <sergei@s15v.net>
Subject: Re: [RFC 4/8] lsm: smack: smack callbacks for kdbus security hooks
Date: Thu, 9 Jul 2015 13:08:08 +0300
Message-ID: <20150709100808.GH25971@localhost.localdomain>
References: <1436351110-5902-1-git-send-email-p.osmialowsk@samsung.com>
 <1436351110-5902-5-git-send-email-p.osmialowsk@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436351110-5902-5-git-send-email-p.osmialowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Osmialowski <p.osmialowsk@samsung.com>
Cc: Paul Moore <pmoore@redhat.com>, James Morris <james.l.morris@oracle.com>, Casey Schaufler <casey@schaufler-ca.com>, "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Stephen Smalley <sds@tycho.nsa.gov>, Neil Brown <neilb@suse.de>, Mark Rustad <mark.d.rustad@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, David Herrmann <dh.herrmann@googlemail.com>, Djalal Harouni <tixxdz@opendz.org>, Shuah Khan <shuahkh@osg.samsung.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Karol Lewandowski <k.lewandowsk@samsung.com>, Lukasz Skalski <l.skalski@samsung.com>
List-Id: linux-api@vger.kernel.org

Hi,

On Wed, Jul 08, 2015 at 12:25:06PM +0200, Paul Osmialowski wrote:
> This adds implementation of three smack callbacks sitting behind kdbus
> security hooks as proposed by Karol Lewandowski.
> 
> Originates from:
> 
> git://git.infradead.org/users/pcmoore/selinux (branch: working-kdbus)
> commit: fc3505d058c001fe72a6f66b833e0be5b2d118f3
> 
> https://github.com/lmctl/linux.git (branch: kdbus-lsm-v4.for-systemd-v212)
> commit: 103c26fd27d1ec8c32d85dd3d85681f936ac66fb
> 
> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
> Signed-off-by: Paul Osmialowski <p.osmialowsk@samsung.com>
> ---
>  security/smack/smack_lsm.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 68 insertions(+)
> 
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index a143328..033b756 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -41,6 +41,7 @@
>  #include <linux/msg.h>
>  #include <linux/shm.h>
>  #include <linux/binfmts.h>
> +#include <kdbus/connection.h>
>  #include "smack.h"
>  
>  #define TRANS_TRUE	"TRUE"
> @@ -3336,6 +3337,69 @@ static int smack_setprocattr(struct task_struct *p, char *name,
>  }
>  
>  /**
> + * smack_kdbus_connect - Set the security blob for a KDBus connection
> + * @conn: the connection
> + * @secctx: smack label
> + * @seclen: smack label length
> + *
> + * Returns 0
> + */
> +static int smack_kdbus_connect(struct kdbus_conn *conn,
> +			       const char *secctx, u32 seclen)
> +{
> +	struct smack_known *skp;
> +
> +	if (secctx && seclen > 0)
> +		skp = smk_import_entry(secctx, seclen);
> +	else
> +		skp = smk_of_current();
> +	conn->security = skp;
> +
> +	return 0;
> +}
> +
> +/**
> + * smack_kdbus_conn_free - Clear the security blob for a KDBus connection
> + * @conn: the connection
> + *
> + * Clears the blob pointer
> + */
> +static void smack_kdbus_conn_free(struct kdbus_conn *conn)
> +{
> +	conn->security = NULL;
> +}
> +
> +/**
> + * smack_kdbus_talk - Smack access on KDBus
> + * @src: source kdbus connection
> + * @dst: destination kdbus connection
> + *
> + * Return 0 if a subject with the smack of sock could access
> + * an object with the smack of other, otherwise an error code
> + */
> +static int smack_kdbus_talk(const struct kdbus_conn *src,
> +			    const struct kdbus_conn *dst)
> +{
> +	struct smk_audit_info ad;
> +	struct smack_known *sskp = src->security;
> +	struct smack_known *dskp = dst->security;
> +	int ret;
> +
> +	BUG_ON(sskp == NULL);
> +	BUG_ON(dskp == NULL);

I am not familiar with the smack code so far, but I see that current
security/smack/smack_lsm.c contains only one BUG_ON and this patch adds
another two.

> +
> +	if (smack_privileged(CAP_MAC_OVERRIDE))
> +		return 0;
> +
> +	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_NONE);
> +
> +	ret = smk_access(sskp, dskp, MAY_WRITE, &ad);
> +	if (ret)
> +		return ret;
> +	return 0;

Three redundant lines here.

> +}
> +
> +/**
>   * smack_unix_stream_connect - Smack access on UDS
>   * @sock: one sock
>   * @other: the other sock
> @@ -4393,6 +4457,10 @@ struct security_hook_list smack_hooks[] = {
>  	LSM_HOOK_INIT(inode_notifysecctx, smack_inode_notifysecctx),
>  	LSM_HOOK_INIT(inode_setsecctx, smack_inode_setsecctx),
>  	LSM_HOOK_INIT(inode_getsecctx, smack_inode_getsecctx),
> +
> +	LSM_HOOK_INIT(kdbus_connect, smack_kdbus_connect),
> +	LSM_HOOK_INIT(kdbus_conn_free, smack_kdbus_conn_free),
> +	LSM_HOOK_INIT(kdbus_talk, smack_kdbus_talk),
>  };
>  
>  
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
