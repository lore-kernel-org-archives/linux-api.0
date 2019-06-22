From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH V34 05/29] Restrict /dev/{mem,kmem,port} when the kernel
 is locked down
Date: Sat, 22 Jun 2019 16:52:39 -0700
Message-ID: <201906221648.F8F0741@keescook>
References: <20190622000358.19895-1-matthewgarrett@google.com>
 <20190622000358.19895-6-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190622000358.19895-6-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>, David Howells <dhowells@redhat.com>, Matthew Garrett <mjg59@google.com>, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jun 21, 2019 at 05:03:34PM -0700, Matthew Garrett wrote:
> From: Matthew Garrett <mjg59@srcf.ucam.org>
> 
> Allowing users to read and write to core kernel memory makes it possible
> for the kernel to be subverted, avoiding module loading restrictions, and
> also to steal cryptographic information.
> 
> Disallow /dev/mem and /dev/kmem from being opened this when the kernel has
> been locked down to prevent this.
> 
> Also disallow /dev/port from being opened to prevent raw ioport access and
> thus DMA from being used to accomplish the same thing.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> Cc: x86@kernel.org
> ---
>  drivers/char/mem.c           | 6 +++++-
>  include/linux/security.h     | 1 +
>  security/lockdown/lockdown.c | 1 +
>  3 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index b08dc50f9f26..93c02493f0fa 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -29,8 +29,8 @@
>  #include <linux/export.h>
>  #include <linux/io.h>
>  #include <linux/uio.h>
> -
>  #include <linux/uaccess.h>
> +#include <linux/security.h>
>  
>  #ifdef CONFIG_IA64
>  # include <linux/efi.h>
> @@ -786,6 +786,10 @@ static loff_t memory_lseek(struct file *file, loff_t offset, int orig)
>  
>  static int open_port(struct inode *inode, struct file *filp)
>  {
> +	int ret = security_locked_down(LOCKDOWN_DEV_MEM);
> +
> +	if (ret)
> +		return ret;
>  	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;

Usually the ordering for LSM tests tends to follow capable checks, which
allows for things like audit to generate logs for capability rejections,
etc. I'd expect this to be:

	if (!capable(CAP_SYS_RAWIO))
		return -EPERM;

	return security_locked_down(LOCKDOWN_DEV_MEM)

With that fixed:

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

>  }
>  
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 46d85cd63b06..200175c8605a 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -83,6 +83,7 @@ enum lsm_event {
>  enum lockdown_reason {
>  	LOCKDOWN_NONE,
>  	LOCKDOWN_MODULE_SIGNATURE,
> +	LOCKDOWN_DEV_MEM,
>  	LOCKDOWN_INTEGRITY_MAX,
>  	LOCKDOWN_CONFIDENTIALITY_MAX,
>  };
> diff --git a/security/lockdown/lockdown.c b/security/lockdown/lockdown.c
> index 25a3a5b0aa9c..565c87451f0f 100644
> --- a/security/lockdown/lockdown.c
> +++ b/security/lockdown/lockdown.c
> @@ -19,6 +19,7 @@ static enum lockdown_reason kernel_locked_down;
>  static char *lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
>  	[LOCKDOWN_NONE] = "none",
>  	[LOCKDOWN_MODULE_SIGNATURE] = "unsigned module loading",
> +	[LOCKDOWN_DEV_MEM] = "/dev/mem,kmem,port",
>  	[LOCKDOWN_INTEGRITY_MAX] = "integrity",
>  	[LOCKDOWN_CONFIDENTIALITY_MAX] = "confidentiality",
>  };
> -- 
> 2.22.0.410.gd8fdbe21b5-goog
> 

-- 
Kees Cook
