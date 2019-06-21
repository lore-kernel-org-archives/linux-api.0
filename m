From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH V33 03/30] security: Add a static lockdown policy LSM
Date: Fri, 21 Jun 2019 18:31:15 -0400
Message-ID: <1561156275.4057.154.camel@linux.ibm.com>
References: <20190621011941.186255-1-matthewgarrett@google.com>
         <20190621011941.186255-4-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190621011941.186255-4-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>, jmorris@namei.org
Cc: linux-security@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Matthew Garrett <mjg59@google.com>, David Howells <dhowells@redhat.com>
List-Id: linux-api@vger.kernel.org

On Thu, 2019-06-20 at 18:19 -0700, Matthew Garrett wrote:

> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2239,6 +2239,15 @@
>  	lockd.nlm_udpport=M	[NFS] Assign UDP port.
>  			Format: <integer>
>  
> +	lockdown=	[SECURITY]
> +			{ integrity | confidentiality }
> +			Enable the kernel lockdown feature. If set to
> +			integrity, kernel features that allow userland to
> +			modify the running kernel are disabled. If set to
> +			confidentiality, kernel features that allow userland
> +			to extract confidential information from the kernel
> +			are also disabled.
> +

Does "also" imply "integrity" is a prereq for "confidentiality"?

> diff --git a/security/lockdown/Kconfig b/security/lockdown/Kconfig
> new file mode 100644
> index 000000000000..431cd2b9a14e
> --- /dev/null
> +++ b/security/lockdown/Kconfig
> @@ -0,0 +1,46 @@
> +config SECURITY_LOCKDOWN_LSM
> +	bool "Basic module for enforcing kernel lockdown"
> +	depends on SECURITY
> +	help
> +	  Build support for an LSM that enforces a coarse kernel lockdown
> +	  behaviour.
> +
> +config SECURITY_LOCKDOWN_LSM_EARLY
> +        bool "Enable lockdown LSM early in init"
> +	depends on SECURITY_LOCKDOWN_LSM
> +	help
> +	  Enable the lockdown LSM early in boot. This is necessary in order
> +	  to ensure that lockdown enforcement can be carried out on kernel
> +	  boot parameters that are otherwise parsed before the security
> +	  subsystem is fully initialised.
> +
> +choice
> +	prompt "Kernel default lockdown mode"
> +	default LOCK_DOWN_KERNEL_FORCE_NONE
> +	depends on SECURITY_LOCKDOWN_LSM
> +	help
> +	  The kernel can be configured to default to differing levels of
> +	  lockdown.
> +
> +config LOCK_DOWN_KERNEL_FORCE_NONE
> +       bool "None"
> +       help
> +          No lockdown functionality is enabled by default. Lockdown may be
> +	  enabled via the kernel commandline or /sys/kernel/security/lockdown.
> +
> +config LOCK_DOWN_KERNEL_FORCE_INTEGRITY
> +       bool "Integrity"
> +       help
> +         The kernel runs in integrity mode by default. Features that allow
> +	 the kernel to be modified at runtime are disabled.
> +
> +config LOCK_DOWN_KERNEL_FORCE_CONFIDENTIALITY
> +       bool "Confidentiality"
> +       help
> +         The kernel runs in confidentiality mode by default. Features that
> +	 allow the kernel to be modified at runtime or that permit userland
> +	 code to read confidential material held inside the kernel are
> +	 disabled.
> +

Is there a missing dependency on LOCK_DOWN_KERNEL_FORCE_INTEGRITY
here?

> +endchoice
> +


> diff --git a/security/lockdown/lockdown.c b/security/lockdown/lockdown.c
> new file mode 100644
> index 000000000000..1ecb2eecb245
> --- /dev/null
> +++ b/security/lockdown/lockdown.c

> +
> +static int __init lockdown_lsm_init(void)
> +{
> +#if defined(CONFIG_LOCK_DOWN_KERNEL_FORCE_INTEGRITY)
> +	lock_kernel_down("Kernel configuration", LOCKDOWN_INTEGRITY_MAX);
> +#elif defined(CONFIG_LOCK_DOWN_KERNEL_FORCE_CONFIDENTIALITY)
> +	lock_kernel_down("Kernel configuration", LOCKDOWN_CONFIDENTIALITY_MAX);
> +#endif
> +	security_add_hooks(lockdown_hooks, ARRAY_SIZE(lockdown_hooks),
> +			   "lockdown");
> +	return 0;
> +}

If there is a dependency on
"defined(CONFIG_LOCK_DOWN_KERNEL_FORCE_INTEGRITY" for
"CONFIG_LOCK_DOWN_KERNEL_FORCE_CONFIDENTIALITY", then the ordering
should be reversed.  If there isn't a dependency of one on the other,
then replace the "elif" with "endif".

Mimi
