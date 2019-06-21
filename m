From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH V31 07/25] kexec_file: Restrict at runtime if the kernel
 is locked down
Date: Fri, 21 Jun 2019 14:43:40 +0800
Message-ID: <20190621064340.GB4528@localhost.localdomain>
References: <20190326182742.16950-1-matthewgarrett@google.com>
 <20190326182742.16950-8-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190326182742.16950-8-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: jmorris@namei.org, Jiri Bohac <jbohac@suse.cz>, linux-api@vger.kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@google.com>, dhowells@redhat.com, linux-security-module@vger.kernel.org, luto@kernel.org
List-Id: linux-api@vger.kernel.org

On 03/26/19 at 11:27am, Matthew Garrett wrote:
> From: Jiri Bohac <jbohac@suse.cz>
> 
> When KEXEC_SIG is not enabled, kernel should not load images through
> kexec_file systemcall if the kernel is locked down.
> 
> [Modified by David Howells to fit with modifications to the previous patch
>  and to return -EPERM if the kernel is locked down for consistency with
>  other lockdowns. Modified by Matthew Garrett to remove the IMA
>  integration, which will be replaced by integrating with the IMA
>  architecture policy patches.]
> 
> Signed-off-by: Jiri Bohac <jbohac@suse.cz>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> Reviewed-by: Jiri Bohac <jbohac@suse.cz>
> cc: kexec@lists.infradead.org
> ---
>  kernel/kexec_file.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
> index 67f3a866eabe..a1cc37c8b43b 100644
> --- a/kernel/kexec_file.c
> +++ b/kernel/kexec_file.c
> @@ -239,6 +239,12 @@ kimage_file_prepare_segments(struct kimage *image, int kernel_fd, int initrd_fd,
>  		}
>  
>  		ret = 0;
> +
> +		if (kernel_is_locked_down(reason, LOCKDOWN_INTEGRITY)) {
> +			ret = -EPERM;
> +			goto out;
> +		}
> +

Checking here is late, it would be good to move the check to earlier
code around below code:
        /* We only trust the superuser with rebooting the system. */
        if (!capable(CAP_SYS_BOOT) || kexec_load_disabled)
                return -EPERM;

>  		break;
>  
>  		/* All other errors are fatal, including nomem, unparseable
> -- 
> 2.21.0.392.gf8f6787159e-goog
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec

Thanks
Dave
