From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH V34 07/29] Copy secure_boot flag in boot params across
 kexec reboot
Date: Sat, 22 Jun 2019 16:53:19 -0700
Message-ID: <201906221653.DDCB3C898@keescook>
References: <20190622000358.19895-1-matthewgarrett@google.com>
 <20190622000358.19895-8-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190622000358.19895-8-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Dave Young <dyoung@redhat.com>, David Howells <dhowells@redhat.com>, Matthew Garrett <mjg59@google.com>, kexec@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On Fri, Jun 21, 2019 at 05:03:36PM -0700, Matthew Garrett wrote:
> From: Dave Young <dyoung@redhat.com>
> 
> Kexec reboot in case secure boot being enabled does not keep the secure
> boot mode in new kernel, so later one can load unsigned kernel via legacy
> kexec_load.  In this state, the system is missing the protections provided
> by secure boot.
> 
> Adding a patch to fix this by retain the secure_boot flag in original
> kernel.
> 
> secure_boot flag in boot_params is set in EFI stub, but kexec bypasses the
> stub.  Fixing this issue by copying secure_boot flag across kexec reboot.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> cc: kexec@lists.infradead.org
> ---
>  arch/x86/kernel/kexec-bzimage64.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kernel/kexec-bzimage64.c b/arch/x86/kernel/kexec-bzimage64.c
> index 22f60dd26460..4243359ac509 100644
> --- a/arch/x86/kernel/kexec-bzimage64.c
> +++ b/arch/x86/kernel/kexec-bzimage64.c
> @@ -182,6 +182,7 @@ setup_efi_state(struct boot_params *params, unsigned long params_load_addr,
>  	if (efi_enabled(EFI_OLD_MEMMAP))
>  		return 0;
>  
> +	params->secure_boot = boot_params.secure_boot;
>  	ei->efi_loader_signature = current_ei->efi_loader_signature;
>  	ei->efi_systab = current_ei->efi_systab;
>  	ei->efi_systab_hi = current_ei->efi_systab_hi;
> -- 
> 2.22.0.410.gd8fdbe21b5-goog
> 

-- 
Kees Cook
