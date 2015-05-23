From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/2] capabilities: Add a securebit to disable
 PR_CAP_AMBIENT_RAISE
Date: Sat, 23 May 2015 14:45:35 -0500
Message-ID: <20150523194535.GB30563@mail.hallyn.com>
References: <cover.1431671529.git.luto@kernel.org>
 <003b2a2d3e6ad9f4853e248d853f73448ca7b002.1431671529.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <003b2a2d3e6ad9f4853e248d853f73448ca7b002.1431671529.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 14, 2015 at 11:39:49PM -0700, Andy Lutomirski wrote:
> Per Andrew Morgan's request, add a securebit to allow admins to
> disable PR_CAP_AMBIENT_RAISE.  This securebit will prevent processes
> from adding capabilities to their ambient set.
> 
> For simplicity, this disables PR_CAP_AMBIENT_RAISE entirely rather
> than just disabling setting previously cleared bits.
> 
> Requested-by: Andrew G. Morgan <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
> Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
> Cc: Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> CC: Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
> Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
> Cc: Andrew G. Morgan <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Cc: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>
> Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Interesting - at first I thought this wouldn't please Andrew as he'd
want the inverse, but I guess this way keeps the pure-capabilities
mode (with SECURE_ALL_BITS set) ambient-free which I suppose is
really the important thing.

Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

> ---
>  include/uapi/linux/securebits.h | 11 ++++++++++-
>  security/commoncap.c            |  3 ++-
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/securebits.h b/include/uapi/linux/securebits.h
> index 985aac9e6bf8..35ac35cef217 100644
> --- a/include/uapi/linux/securebits.h
> +++ b/include/uapi/linux/securebits.h
> @@ -43,9 +43,18 @@
>  #define SECBIT_KEEP_CAPS	(issecure_mask(SECURE_KEEP_CAPS))
>  #define SECBIT_KEEP_CAPS_LOCKED (issecure_mask(SECURE_KEEP_CAPS_LOCKED))
>  
> +/* When set, a process cannot add new capabilities to its ambient set. */
> +#define SECURE_NO_CAP_AMBIENT_RAISE		6
> +#define SECURE_NO_CAP_AMBIENT_RAISE_LOCKED	7  /* make bit-6 immutable */
> +
> +#define SECBIT_NO_CAP_AMBIENT_RAISE (issecure_mask(SECURE_NO_CAP_AMBIENT_RAISE))
> +#define SECBIT_NO_CAP_AMBIENT_RAISE_LOCKED \
> +			(issecure_mask(SECURE_NO_CAP_AMBIENT_RAISE_LOCKED))
> +
>  #define SECURE_ALL_BITS		(issecure_mask(SECURE_NOROOT) | \
>  				 issecure_mask(SECURE_NO_SETUID_FIXUP) | \
> -				 issecure_mask(SECURE_KEEP_CAPS))
> +				 issecure_mask(SECURE_KEEP_CAPS) | \
> +				 issecure_mask(SECURE_NO_CAP_AMBIENT_RAISE))
>  #define SECURE_ALL_LOCKS	(SECURE_ALL_BITS << 1)
>  
>  #endif /* _UAPI_LINUX_SECUREBITS_H */
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 09541a6a85a0..98aa1b129c12 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -983,7 +983,8 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
>  			if (arg2 == PR_CAP_AMBIENT_RAISE &&
>  			    (!cap_raised(current_cred()->cap_permitted, arg3) ||
>  			     !cap_raised(current_cred()->cap_inheritable,
> -					 arg3)))
> +					 arg3) ||
> +			     issecure(SECURE_NO_CAP_AMBIENT_RAISE)))
>  				return -EPERM;
>  
>  			new = prepare_creds();
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
