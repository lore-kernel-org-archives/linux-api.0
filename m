From: Ben Hutchings <ben.hutchings-4yDnlxn2s6sWdaTGBSpHTA@public.gmane.org>
Subject: Re: [Y2038] [PATCH v2 10/10] nanosleep: change time types to safe
 __kernel_* types
Date: Fri, 15 Dec 2017 00:31:31 +0000
Message-ID: <1513297891.18523.295.camel@codethink.co.uk>
References: <20171127193037.8711-1-deepa.kernel@gmail.com>
         <20171127193037.8711-11-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171127193037.8711-11-deepa.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Deepa Dinamani <deepa.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2017-11-27 at 11:30 -0800, Deepa Dinamani wrote:
[...]
> @@ -15,9 +16,7 @@ struct pollfd;
>  enum timespec_type {
>  	TT_NONE		= 0,
>  	TT_NATIVE	= 1,
> -#ifdef CONFIG_COMPAT
>  	TT_COMPAT	= 2,
> -#endif
>  };
>  
>  /*
> @@ -40,10 +39,8 @@ struct restart_block {
>  			clockid_t clockid;
>  			enum timespec_type type;
>  			union {
> -				struct timespec __user *rmtp;
> -#ifdef CONFIG_COMPAT
> +				struct __kernel_timespec __user *rmtp;
>  				struct compat_timespec __user *compat_rmtp;
> -#endif
>  			};
>  			u64 expires;
>  		} nanosleep;
[...]

The deletions of #ifdef and #endif here seem to belong in patch #6, as
that's the one that changes the condition for the compat nanosleep
implementation which uses the compat_rmtp field.

Ben.

-- 
Ben Hutchings
Software Developer, Codethink Ltd.
