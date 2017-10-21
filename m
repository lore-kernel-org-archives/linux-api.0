From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC PATCH 1/2] security, capabilities: Add
 CAP_SYS_MOUNT
Date: Sat, 21 Oct 2017 10:31:24 -0700
Message-ID: <edfdfc70-fd07-4930-c7f5-0d2b6355b09b@schaufler-ca.com>
References: <20171021134303.20685-1-nicolas@belouin.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-hardening-return-10232-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20171021134303.20685-1-nicolas@belouin.fr>
Content-Language: en-US
To: Nicolas Belouin <nicolas@belouin.fr>, David Howells <dhowells@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, James Morris <james.l.morris@oracle.com>, linux-cachefs@redhat.com, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

On 10/21/2017 6:43 AM, Nicolas Belouin wrote:
> With CAP_SYS_ADMIN being bloated and inapropriate for actions such
> as mounting/unmounting filesystems, the creation of a new capability
> is needed.
> CAP_SYS_MOUNT is meant to give a process the ability to call for mount,
> umount and umount2 syscalls.

This is increased granularity for it's own sake. There is no
compelling reason to break out this capability in particular.
Can you identify existing use cases where you would have
CAP_SYS_MOUNT without also having CAP_SYS_ADMIN? I should think
that all the work that's gone into unprivileged mounts over
the past couple years would make this unnecessary.

> Signed-off-by: Nicolas Belouin <nicolas@belouin.fr>
> ---
>  include/uapi/linux/capability.h     | 5 ++++-
>  security/selinux/include/classmap.h | 4 ++--
>  2 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
> index 230e05d35191..ce230aa6d928 100644
> --- a/include/uapi/linux/capability.h
> +++ b/include/uapi/linux/capability.h
> @@ -365,8 +365,11 @@ struct vfs_ns_cap_data {
>  
>  #define CAP_AUDIT_READ		37
>  
> +/* Allow mounting, unmounting filesystems */
>  
> -#define CAP_LAST_CAP         CAP_AUDIT_READ
> +#define CAP_SYS_MOUNT		38
> +
> +#define CAP_LAST_CAP         CAP_SYS_MOUNT
>  
>  #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
>  
> diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
> index 35ffb29a69cb..a873dce97fd5 100644
> --- a/security/selinux/include/classmap.h
> +++ b/security/selinux/include/classmap.h
> @@ -24,9 +24,9 @@
>  	    "audit_control", "setfcap"
>  
>  #define COMMON_CAP2_PERMS  "mac_override", "mac_admin", "syslog", \
> -		"wake_alarm", "block_suspend", "audit_read"
> +		"wake_alarm", "block_suspend", "audit_read", "sys_mount"
>  
> -#if CAP_LAST_CAP > CAP_AUDIT_READ
> +#if CAP_LAST_CAP > CAP_SYS_MOUNT
>  #error New capability defined, please update COMMON_CAP2_PERMS.
>  #endif
>  
