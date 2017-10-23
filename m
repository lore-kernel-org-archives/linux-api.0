From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC PATCH 1/2] security, capabilities: Add CAP_SYS_MOUNT
Date: Mon, 23 Oct 2017 08:57:39 -0400
Message-ID: <1508763459.24902.1.camel@tycho.nsa.gov>
References: <20171021134303.20685-1-nicolas@belouin.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20171021134303.20685-1-nicolas@belouin.fr>
Sender: owner-linux-security-module@vger.kernel.org
To: Nicolas Belouin <nicolas@belouin.fr>, David Howells <dhowells@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@parisplace.org>, James Morris <james.l.morris@oracle.com>, linux-cachefs@redhat.com, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

On Sat, 2017-10-21 at 15:43 +0200, Nicolas Belouin wrote:
> With CAP_SYS_ADMIN being bloated and inapropriate for actions such
> as mounting/unmounting filesystems, the creation of a new capability
> is needed.
> CAP_SYS_MOUNT is meant to give a process the ability to call for
> mount,
> umount and umount2 syscalls.

If adding a new capability isn't deemed acceptable, then another option
would be to introduce LSM hooks where there isn't already coverage and
implement finer-grained permission checks there.  In some cases, that
already occurs for mount and umount*.  That also offers the possibility
of taking the object of the operation into account, unlike capabilities
which are only subject/process-based.


> 
> Signed-off-by: Nicolas Belouin <nicolas@belouin.fr>
> ---
>  include/uapi/linux/capability.h     | 5 ++++-
>  security/selinux/include/classmap.h | 4 ++--
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/capability.h
> b/include/uapi/linux/capability.h
> index 230e05d35191..ce230aa6d928 100644
> --- a/include/uapi/linux/capability.h
> +++ b/include/uapi/linux/capability.h
> @@ -365,8 +365,11 @@ struct vfs_ns_cap_data {
>  
>  #define CAP_AUDIT_READ		37
>  
> +/* Allow mounting, unmounting filesystems */
>  
> -#define CAP_LAST_CAP         CAP_AUDIT_READ
> +#define CAP_SYS_MOUNT		38
> +
> +#define CAP_LAST_CAP         CAP_SYS_MOUNT
>  
>  #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
>  
> diff --git a/security/selinux/include/classmap.h
> b/security/selinux/include/classmap.h
> index 35ffb29a69cb..a873dce97fd5 100644
> --- a/security/selinux/include/classmap.h
> +++ b/security/selinux/include/classmap.h
> @@ -24,9 +24,9 @@
>  	    "audit_control", "setfcap"
>  
>  #define COMMON_CAP2_PERMS  "mac_override", "mac_admin", "syslog", \
> -		"wake_alarm", "block_suspend", "audit_read"
> +		"wake_alarm", "block_suspend", "audit_read",
> "sys_mount"
>  
> -#if CAP_LAST_CAP > CAP_AUDIT_READ
> +#if CAP_LAST_CAP > CAP_SYS_MOUNT
>  #error New capability defined, please update COMMON_CAP2_PERMS.
>  #endif
>  
