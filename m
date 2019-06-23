From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH V34 21/29] Lock down /proc/kcore
Date: Sat, 22 Jun 2019 17:05:29 -0700
Message-ID: <201906221705.258B22D1@keescook>
References: <20190622000358.19895-1-matthewgarrett@google.com>
 <20190622000358.19895-22-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190622000358.19895-22-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>, Matthew Garrett <mjg59@google.com>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 21, 2019 at 05:03:50PM -0700, Matthew Garrett wrote:
> From: David Howells <dhowells@redhat.com>
> 
> Disallow access to /proc/kcore when the kernel is locked down to prevent
> access to cryptographic data. This is limited to lockdown
> confidentiality mode and is still permitted in integrity mode.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> ---
>  fs/proc/kcore.c              | 5 +++++
>  include/linux/security.h     | 1 +
>  security/lockdown/lockdown.c | 1 +
>  3 files changed, 7 insertions(+)
> 
> diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
> index d29d869abec1..4e95edb1e282 100644
> --- a/fs/proc/kcore.c
> +++ b/fs/proc/kcore.c
> @@ -31,6 +31,7 @@
>  #include <linux/ioport.h>
>  #include <linux/memory.h>
>  #include <linux/sched/task.h>
> +#include <linux/security.h>
>  #include <asm/sections.h>
>  #include "internal.h"
>  
> @@ -545,6 +546,10 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
>  
>  static int open_kcore(struct inode *inode, struct file *filp)
>  {
> +	int ret = security_locked_down(LOCKDOWN_KCORE);
> +
> +	if (ret)
> +		return ret;
>  	if (!capable(CAP_SYS_RAWIO))
>  		return -EPERM;

Another capable() check ordering fix needed. With that:

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

>  
> diff --git a/include/linux/security.h b/include/linux/security.h
> index c649cb91e762..3875f6df2ecc 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -95,6 +95,7 @@ enum lockdown_reason {
>  	LOCKDOWN_MODULE_PARAMETERS,
>  	LOCKDOWN_MMIOTRACE,
>  	LOCKDOWN_INTEGRITY_MAX,
> +	LOCKDOWN_KCORE,
>  	LOCKDOWN_CONFIDENTIALITY_MAX,
>  };
>  
> diff --git a/security/lockdown/lockdown.c b/security/lockdown/lockdown.c
> index cd86ed9f4d4b..4c9b324dfc55 100644
> --- a/security/lockdown/lockdown.c
> +++ b/security/lockdown/lockdown.c
> @@ -31,6 +31,7 @@ static char *lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
>  	[LOCKDOWN_MODULE_PARAMETERS] = "unsafe module parameters",
>  	[LOCKDOWN_MMIOTRACE] = "unsafe mmio",
>  	[LOCKDOWN_INTEGRITY_MAX] = "integrity",
> +	[LOCKDOWN_KCORE] = "/proc/kcore access",
>  	[LOCKDOWN_CONFIDENTIALITY_MAX] = "confidentiality",
>  };
>  
> -- 
> 2.22.0.410.gd8fdbe21b5-goog
> 

-- 
Kees Cook
