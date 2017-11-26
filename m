From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 1/2] capability: introduce sysctl for controlled
 user-ns capability whitelist
Date: Sun, 26 Nov 2017 00:34:54 -0600
Message-ID: <20171126063454.GA30279@mail.hallyn.com>
References: <20171110053747.21093-1-mahesh@bandewar.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171110053747.21093-1-mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mahesh Bandewar <mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel-hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mahesh Bandewar <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Mahesh Bandewar (mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org):
> From: Mahesh Bandewar <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> Add a sysctl variable kernel.controlled_userns_caps_whitelist. This
> takes input as capability mask expressed as two comma separated hex
> u32 words. The mask, however, is stored in kernel as kernel_cap_t type.
> 
> Any capabilities that are not part of this mask will be controlled and
> will not be allowed to processes in controlled user-ns.
> 
> Signed-off-by: Mahesh Bandewar <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>

> ---
> v2:
>   Rebase
> v1:
>   Initial submission
> 
>  Documentation/sysctl/kernel.txt | 21 ++++++++++++++++++
>  include/linux/capability.h      |  3 +++
>  kernel/capability.c             | 47 +++++++++++++++++++++++++++++++++++++++++
>  kernel/sysctl.c                 |  5 +++++
>  4 files changed, 76 insertions(+)
> 
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index 694968c7523c..a1d39dbae847 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -25,6 +25,7 @@ show up in /proc/sys/kernel:
>  - bootloader_version	     [ X86 only ]
>  - callhome		     [ S390 only ]
>  - cap_last_cap
> +- controlled_userns_caps_whitelist
>  - core_pattern
>  - core_pipe_limit
>  - core_uses_pid
> @@ -187,6 +188,26 @@ CAP_LAST_CAP from the kernel.
>  
>  ==============================================================
>  
> +controlled_userns_caps_whitelist
> +
> +Capability mask that is whitelisted for "controlled" user namespaces.
> +Any capability that is missing from this mask will not be allowed to
> +any process that is attached to a controlled-userns. e.g. if CAP_NET_RAW
> +is not part of this mask, then processes running inside any controlled
> +userns's will not be allowed to perform action that needs CAP_NET_RAW
> +capability. However, processes that are attached to a parent user-ns
> +hierarchy that is *not* controlled and has CAP_NET_RAW can continue
> +performing those actions. User-namespaces are marked "controlled" at
> +the time of their creation based on the capabilities of the creator.
> +A process that does not have CAP_SYS_ADMIN will create user-namespaces
> +that are controlled.
> +
> +The value is expressed as two comma separated hex words (u32). This
> +sysctl is avaialble in init-ns and users with CAP_SYS_ADMIN in init-ns
> +are allowed to make changes.
> +
> +==============================================================
> +
>  core_pattern:
>  
>  core_pattern is used to specify a core dumpfile pattern name.
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index f640dcbc880c..7d79a4689625 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -14,6 +14,7 @@
>  #define _LINUX_CAPABILITY_H
>  
>  #include <uapi/linux/capability.h>
> +#include <linux/sysctl.h>
>  
>  
>  #define _KERNEL_CAPABILITY_VERSION _LINUX_CAPABILITY_VERSION_3
> @@ -248,6 +249,8 @@ extern bool ptracer_capable(struct task_struct *tsk, struct user_namespace *ns);
>  
>  /* audit system wants to get cap info from files as well */
>  extern int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps);
> +int proc_douserns_caps_whitelist(struct ctl_table *table, int write,
> +				 void __user *buff, size_t *lenp, loff_t *ppos);
>  
>  extern int cap_convert_nscap(struct dentry *dentry, void **ivalue, size_t size);
>  
> diff --git a/kernel/capability.c b/kernel/capability.c
> index 1e1c0236f55b..4a859b7d4902 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -29,6 +29,8 @@ EXPORT_SYMBOL(__cap_empty_set);
>  
>  int file_caps_enabled = 1;
>  
> +kernel_cap_t controlled_userns_caps_whitelist = CAP_FULL_SET;
> +
>  static int __init file_caps_disable(char *str)
>  {
>  	file_caps_enabled = 0;
> @@ -507,3 +509,48 @@ bool ptracer_capable(struct task_struct *tsk, struct user_namespace *ns)
>  	rcu_read_unlock();
>  	return (ret == 0);
>  }
> +
> +/* Controlled-userns capabilities routines */
> +#ifdef CONFIG_SYSCTL
> +int proc_douserns_caps_whitelist(struct ctl_table *table, int write,
> +				 void __user *buff, size_t *lenp, loff_t *ppos)
> +{
> +	DECLARE_BITMAP(caps_bitmap, CAP_LAST_CAP);
> +	struct ctl_table caps_table;
> +	char tbuf[NAME_MAX];
> +	int ret;
> +
> +	ret = bitmap_from_u32array(caps_bitmap, CAP_LAST_CAP,
> +				   controlled_userns_caps_whitelist.cap,
> +				   _KERNEL_CAPABILITY_U32S);
> +	if (ret != CAP_LAST_CAP)
> +		return -1;
> +
> +	scnprintf(tbuf, NAME_MAX, "%*pb", CAP_LAST_CAP, caps_bitmap);
> +
> +	caps_table.data = tbuf;
> +	caps_table.maxlen = NAME_MAX;
> +	caps_table.mode = table->mode;
> +	ret = proc_dostring(&caps_table, write, buff, lenp, ppos);
> +	if (ret)
> +		return ret;
> +	if (write) {
> +		kernel_cap_t tmp;
> +
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EPERM;
> +
> +		ret = bitmap_parse_user(buff, *lenp, caps_bitmap, CAP_LAST_CAP);
> +		if (ret)
> +			return ret;
> +
> +		ret = bitmap_to_u32array(tmp.cap, _KERNEL_CAPABILITY_U32S,
> +					 caps_bitmap, CAP_LAST_CAP);
> +		if (ret != CAP_LAST_CAP)
> +			return -1;
> +
> +		controlled_userns_caps_whitelist = tmp;
> +	}
> +	return 0;
> +}
> +#endif /* CONFIG_SYSCTL */
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index d9c31bc2eaea..25c3f7b76ece 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1226,6 +1226,11 @@ static struct ctl_table kern_table[] = {
>  		.extra2		= &one,
>  	},
>  #endif
> +	{
> +		.procname	= "controlled_userns_caps_whitelist",
> +		.mode		= 0644,
> +		.proc_handler	= proc_douserns_caps_whitelist,
> +	},
>  	{ }
>  };
>  
> -- 
> 2.15.0.448.gf294e3d99a-goog
