From: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: binfmts.h MAX_ARG_STRINGS excessive value allows heap spraying
Date: Thu, 9 Mar 2017 15:34:37 -0500
Message-ID: <81d8e14e-e110-4b96-5d45-8bb3b56f4866@redhat.com>
References: <1488897868.5178.3.camel@quad>
 <f7f9f60b-0f39-7dce-1778-3aa40ba198ef@redhat.com>
 <1488997111.5155.10.camel@quad>
 <f16cd7f8-f996-cf66-d640-50b0ccee06c7@redhat.com>
 <1489068854.1026.14.camel@quad>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489068854.1026.14.camel@quad>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leonard den Ottolander <leonard-lists-2Avth2y2NeLyQNdsBcn8aGZHpeb/A1Y/@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/09/2017 09:14 AM, Leonard den Ottolander wrote:
> --- a/include/uapi/linux/binfmts.h	2016-11-23 21:02:31.000000000 +0100
> +++ b/include/uapi/linux/binfmts.h	2017-03-09 01:52:14.716319950 +0100
> @@ -9,10 +9,15 @@ struct pt_regs;
>   * These are the maximum length and maximum number of strings passed to the
>   * execve() system call.  MAX_ARG_STRLEN is essentially random but serves to
>   * prevent the kernel from being unduly impacted by misaddressed pointers.
> - * MAX_ARG_STRINGS is chosen to fit in a signed 32-bit integer.
> + * MAX_ARG_STRINGS * MAX_ARG_STRLEN should be smaller than the 4GiB
> + *  address space on 32 bit to avoid heap spraying.

OK

> + * MAX_ARG_STRSLEN to the rescue - the MAX_ARG_PAGES concept was there
> + *  for a reason.

Why not just use MAX_ARG_PAGES?

Define it in include/linux/binfmts.h for !CONFIG_MMU case.

> + * We can now safely increase STRINGS * STRLEN beyond 4GiB if need be.


>   */
> -#define MAX_ARG_STRLEN (PAGE_SIZE * 32)
> -#define MAX_ARG_STRINGS 0x7FFFFFFF
> +#define MAX_ARG_STRSLEN 262144

You don't need this if you define MAX_ARG_PAGES.

> +#define MAX_ARG_STRLEN 65536
> +#define MAX_ARG_STRINGS 4096

These should be left untouched at their original values.

>  /* sizeof(linux_binprm->buf) */
>  #define BINPRM_BUF_SIZE 128
> --- a/fs/exec.c	2017-02-20 08:04:43.000000000 +0100
> +++ b/fs/exec.c	2017-03-09 01:54:25.931476370 +0100
> @@ -459,6 +459,7 @@ static int copy_strings(int argc, struct
>  	char *kaddr = NULL;
>  	unsigned long kpos = 0;
>  	int ret;
> +	int total_bytes = 0;
>  
>  	while (argc-- > 0) {
>  		const char __user *str;
> @@ -478,6 +479,11 @@ static int copy_strings(int argc, struct
>  		if (!valid_arg_len(bprm, len))
>  			goto out;
>  
> +		/* -E2BIG is fine for now */
> +		total_bytes += len;
> +		if (total_bytes > MAX_ARG_STRSLEN)

Should be PAGE_SIZE * MAX_ARG_PAGES, similar to the !CONFIG_MMU case.

> +			goto out;
> +
>  		/* We're going to work our way backwords. */
>  		pos = bprm->p;
>  		str += len;
> 
> I've successfully built a kernel on a system with a kernel using above
> values.
> 
> As we have now introduced a safeguard (MAX_ARG_STRSLEN capping the total
> amount of memory reserved) the values of MAX_ARG_STRLEN and
> MAX_ARG_STRINGS can be increased beyond where their multiplication
> reaches 2^32.
> 
> So if we really want to support lets say users having directories of
> 128k files we can now safely set MAX_ARG_STRINGS to 131072 and assuming
> an average file name length of 32 set MAX_ARG_STRSLEN to 4194304.
> 
> Seems a little excessive to me for a default, but it is now safe.

We're getting closer to a solution.

There is still no justification for the value of MAX_ARG_PAGES though.

My objection that build systems will break still stands.

The point of memory is to be used.

A reasonable limit might be 1/4 of the virtual address space used for
argument pages though.

-- 
Cheers,
Carlos.
