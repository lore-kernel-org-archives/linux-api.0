From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH RESEND v3 4/4] perf_event_open: switch to
 copy_struct_from_user()
Date: Mon, 30 Sep 2019 16:44:24 -0700
Message-ID: <201909301644.7106650E14@keescook>
References: <20190930191526.19544-1-asarai@suse.de>
 <20190930191526.19544-5-asarai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190930191526.19544-5-asarai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <asarai@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Christian Brauner <christian@brauner.io>, Aleksa Sarai <cyphar@cyphar.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 01, 2019 at 05:15:26AM +1000, Aleksa Sarai wrote:
> From: Aleksa Sarai <cyphar@cyphar.com>
> 
> The change is very straightforward, and helps unify the syscall
> interface for struct-from-userspace syscalls.
> 
> Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  kernel/events/core.c | 47 +++++++++-----------------------------------
>  1 file changed, 9 insertions(+), 38 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 4655adbbae10..3f0cb82e4fbc 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -10586,55 +10586,26 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
>  	u32 size;
>  	int ret;
>  
> -	if (!access_ok(uattr, PERF_ATTR_SIZE_VER0))
> -		return -EFAULT;
> -
> -	/*
> -	 * zero the full structure, so that a short copy will be nice.
> -	 */
> +	/* Zero the full structure, so that a short copy will be nice. */
>  	memset(attr, 0, sizeof(*attr));
>  
>  	ret = get_user(size, &uattr->size);
>  	if (ret)
>  		return ret;
>  
> -	if (size > PAGE_SIZE)	/* silly large */
> -		goto err_size;
> -
> -	if (!size)		/* abi compat */
> +	/* ABI compatibility quirk: */
> +	if (!size)
>  		size = PERF_ATTR_SIZE_VER0;
> -
> -	if (size < PERF_ATTR_SIZE_VER0)
> +	if (size < PERF_ATTR_SIZE_VER0 || size > PAGE_SIZE)
>  		goto err_size;
>  
> -	/*
> -	 * If we're handed a bigger struct than we know of,
> -	 * ensure all the unknown bits are 0 - i.e. new
> -	 * user-space does not rely on any kernel feature
> -	 * extensions we dont know about yet.
> -	 */
> -	if (size > sizeof(*attr)) {
> -		unsigned char __user *addr;
> -		unsigned char __user *end;
> -		unsigned char val;
> -
> -		addr = (void __user *)uattr + sizeof(*attr);
> -		end  = (void __user *)uattr + size;
> -
> -		for (; addr < end; addr++) {
> -			ret = get_user(val, addr);
> -			if (ret)
> -				return ret;
> -			if (val)
> -				goto err_size;
> -		}
> -		size = sizeof(*attr);
> +	ret = copy_struct_from_user(attr, sizeof(*attr), uattr, size);
> +	if (ret) {
> +		if (ret == -E2BIG)
> +			goto err_size;
> +		return ret;
>  	}
>  
> -	ret = copy_from_user(attr, uattr, size);
> -	if (ret)
> -		return -EFAULT;
> -
>  	attr->size = size;
>  
>  	if (attr->__reserved_1)
> -- 
> 2.23.0
> 

-- 
Kees Cook
