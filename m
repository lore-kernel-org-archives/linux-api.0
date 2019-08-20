From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH V40 10/29] hibernate: Disable when the kernel is locked down
Date: Tue, 20 Aug 2019 23:43:06 +0200
Message-ID: <2636170.u2GatYtffq@kreacher>
References: <20190820001805.241928-1-matthewgarrett@google.com> <20190820001805.241928-11-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190820001805.241928-11-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Josh Boyer <jwboyer@fedoraproject.org>, David Howells <dhowells@redhat.com>, Matthew Garrett <mjg59@google.com>, Kees Cook <keescook@chromium.org>, pavel@ucw.cz, linux-pm@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tuesday, August 20, 2019 2:17:46 AM CEST Matthew Garrett wrote:
> From: Josh Boyer <jwboyer@fedoraproject.org>
> 
> There is currently no way to verify the resume image when returning
> from hibernate.  This might compromise the signed modules trust model,
> so until we can work with signed hibernate images we disable it when the
> kernel is locked down.
> 
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Cc: rjw@rjwysocki.net
> Cc: pavel@ucw.cz
> cc: linux-pm@vger.kernel.org
> Signed-off-by: James Morris <jmorris@namei.org>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  include/linux/security.h     | 1 +
>  kernel/power/hibernate.c     | 3 ++-
>  security/lockdown/lockdown.c | 1 +
>  3 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index b607a8ac97fe..80ac7fb27aa9 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -106,6 +106,7 @@ enum lockdown_reason {
>  	LOCKDOWN_MODULE_SIGNATURE,
>  	LOCKDOWN_DEV_MEM,
>  	LOCKDOWN_KEXEC,
> +	LOCKDOWN_HIBERNATION,
>  	LOCKDOWN_INTEGRITY_MAX,
>  	LOCKDOWN_CONFIDENTIALITY_MAX,
>  };
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index cd7434e6000d..3c0a5a8170b0 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -30,6 +30,7 @@
>  #include <linux/ctype.h>
>  #include <linux/genhd.h>
>  #include <linux/ktime.h>
> +#include <linux/security.h>
>  #include <trace/events/power.h>
>  
>  #include "power.h"
> @@ -68,7 +69,7 @@ static const struct platform_hibernation_ops *hibernation_ops;
>  
>  bool hibernation_available(void)
>  {
> -	return (nohibernate == 0);
> +	return nohibernate == 0 && !security_locked_down(LOCKDOWN_HIBERNATION);
>  }
>  
>  /**
> diff --git a/security/lockdown/lockdown.c b/security/lockdown/lockdown.c
> index aaf30ad351f9..3462f7edcaac 100644
> --- a/security/lockdown/lockdown.c
> +++ b/security/lockdown/lockdown.c
> @@ -21,6 +21,7 @@ static char *lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
>  	[LOCKDOWN_MODULE_SIGNATURE] = "unsigned module loading",
>  	[LOCKDOWN_DEV_MEM] = "/dev/mem,kmem,port",
>  	[LOCKDOWN_KEXEC] = "kexec of unsigned images",
> +	[LOCKDOWN_HIBERNATION] = "hibernation",
>  	[LOCKDOWN_INTEGRITY_MAX] = "integrity",
>  	[LOCKDOWN_CONFIDENTIALITY_MAX] = "confidentiality",
>  };
> 
