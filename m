From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH V34 04/29] Enforce module signatures if the kernel is
 locked down
Date: Sat, 22 Jun 2019 16:48:17 -0700
Message-ID: <201906221647.181A170A1B@keescook>
References: <20190622000358.19895-1-matthewgarrett@google.com>
 <20190622000358.19895-5-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190622000358.19895-5-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>, Jessica Yu <jeyu@kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 21, 2019 at 05:03:33PM -0700, Matthew Garrett wrote:
> From: David Howells <dhowells@redhat.com>
> 
> If the kernel is locked down, require that all modules have valid
> signatures that we can verify.
> 
> I have adjusted the errors generated:
> 
>  (1) If there's no signature (ENODATA) or we can't check it (ENOPKG,
>      ENOKEY), then:
> 
>      (a) If signatures are enforced then EKEYREJECTED is returned.
> 
>      (b) If there's no signature or we can't check it, but the kernel is
> 	 locked down then EPERM is returned (this is then consistent with
> 	 other lockdown cases).
> 
>  (2) If the signature is unparseable (EBADMSG, EINVAL), the signature fails
>      the check (EKEYREJECTED) or a system error occurs (eg. ENOMEM), we
>      return the error we got.
> 
> Note that the X.509 code doesn't check for key expiry as the RTC might not
> be valid or might not have been transferred to the kernel's clock yet.
> 
>  [Modified by Matthew Garrett to remove the IMA integration. This will
>   be replaced with integration with the IMA architecture policy
>   patchset.]
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Matthew Garrett <matthewgarrett@google.com>
> Cc: Jessica Yu <jeyu@kernel.org>
> ---
>  include/linux/security.h     |  1 +
>  kernel/module.c              | 38 +++++++++++++++++++++++++++++-------
>  security/lockdown/lockdown.c |  1 +
>  3 files changed, 33 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index c808d344ec75..46d85cd63b06 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -82,6 +82,7 @@ enum lsm_event {
>   */
>  enum lockdown_reason {
>  	LOCKDOWN_NONE,
> +	LOCKDOWN_MODULE_SIGNATURE,
>  	LOCKDOWN_INTEGRITY_MAX,
>  	LOCKDOWN_CONFIDENTIALITY_MAX,
>  };
> diff --git a/kernel/module.c b/kernel/module.c
> index 0b9aa8ab89f0..6aa681edd660 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2763,8 +2763,9 @@ static inline void kmemleak_load_module(const struct module *mod,
>  #ifdef CONFIG_MODULE_SIG
>  static int module_sig_check(struct load_info *info, int flags)
>  {
> -	int err = -ENOKEY;
> +	int ret, err = -ENODATA;
>  	const unsigned long markerlen = sizeof(MODULE_SIG_STRING) - 1;
> +	const char *reason;
>  	const void *mod = info->hdr;
>  
>  	/*
> @@ -2779,16 +2780,39 @@ static int module_sig_check(struct load_info *info, int flags)
>  		err = mod_verify_sig(mod, info);
>  	}
>  
> -	if (!err) {
> +	switch (err) {
> +	case 0:
>  		info->sig_ok = true;
>  		return 0;
> -	}
>  
> -	/* Not having a signature is only an error if we're strict. */
> -	if (err == -ENOKEY && !is_module_sig_enforced())
> -		err = 0;
> +		/* We don't permit modules to be loaded into trusted kernels
> +		 * without a valid signature on them, but if we're not
> +		 * enforcing, certain errors are non-fatal.
> +		 */
> +	case -ENODATA:
> +		reason = "Loading of unsigned module";
> +		goto decide;
> +	case -ENOPKG:
> +		reason = "Loading of module with unsupported crypto";
> +		goto decide;
> +	case -ENOKEY:
> +		reason = "Loading of module with unavailable key";
> +	decide:
> +		if (is_module_sig_enforced()) {
> +			pr_notice("%s is rejected\n", reason);
> +			return -EKEYREJECTED;
> +		}
>  
> -	return err;
> +		ret = security_locked_down(LOCKDOWN_MODULE_SIGNATURE);
> +		return ret;

return security_locked_down(LOCKDOWN_MODULE_SIGNATURE); ? Means no need
to add "ret". Regardless:

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees


> +
> +		/* All other errors are fatal, including nomem, unparseable
> +		 * signatures and signature check failures - even if signatures
> +		 * aren't required.
> +		 */
> +	default:
> +		return err;
> +	}
>  }
>  #else /* !CONFIG_MODULE_SIG */
>  static int module_sig_check(struct load_info *info, int flags)
> diff --git a/security/lockdown/lockdown.c b/security/lockdown/lockdown.c
> index 8e39b36b8f33..25a3a5b0aa9c 100644
> --- a/security/lockdown/lockdown.c
> +++ b/security/lockdown/lockdown.c
> @@ -18,6 +18,7 @@ static enum lockdown_reason kernel_locked_down;
>  
>  static char *lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
>  	[LOCKDOWN_NONE] = "none",
> +	[LOCKDOWN_MODULE_SIGNATURE] = "unsigned module loading",
>  	[LOCKDOWN_INTEGRITY_MAX] = "integrity",
>  	[LOCKDOWN_CONFIDENTIALITY_MAX] = "confidentiality",
>  };
> -- 
> 2.22.0.410.gd8fdbe21b5-goog
> 

-- 
Kees Cook
