From: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: binfmts.h MAX_ARG_STRINGS excessive value allows heap spraying
Date: Wed, 8 Mar 2017 12:54:55 -0500
Message-ID: <f7f9f60b-0f39-7dce-1778-3aa40ba198ef@redhat.com>
References: <1488897868.5178.3.camel@quad>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488897868.5178.3.camel@quad>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leonard den Ottolander <leonard-lists-2Avth2y2NeLyQNdsBcn8aGZHpeb/A1Y/@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/07/2017 09:44 AM, Leonard den Ottolander wrote:
> After some experimentation with
> $ rpmbuild -ba kernel.spec
> on CentOS-7 I've come up with values that allow this kernel compilation.
> As this kind of build is probably one of the most demanding actions in
> relation to MAX_ARG_STRINGS and MAX_ARG_STRLEN I believe below values to
> be sensible and much safer defaults:

The most demanding application I've ever seen when playing with this is the
compiler because it has to pass some very large strings from the driver
to a subprocess. So much so that we have `@file` to use intermediate file
storage to workaround kernel limits on various operating systems.
 
> #define MAX_ARG_STRLEN 65536
> #define MAX_ARG_STRINGS 4096
> 
> allow me to build a kernel on a system using those values.
> 
> Since the above value of MAX_ARG_STRLEN is half of the current value we
> might leave it alone and only alter MAX_ARG_STRINGS, resulting in
> 
> --- a/include/uapi/linux/binfmts.h	2016-11-23 21:02:31.000000000 +0100
> +++ b/include/uapi/linux/binfmts.h	2017-02-07 15:40:13.548403615 +0100
> @@ -12,7 +12,7 @@ struct pt_regs;
>   * MAX_ARG_STRINGS is chosen to fit in a signed 32-bit integer.
>   */
>  #define MAX_ARG_STRLEN (PAGE_SIZE * 32)
> -#define MAX_ARG_STRINGS 0x7FFFFFFF
> +#define MAX_ARG_STRINGS 4096

In glibc we limit setuid applications, for example sanitizing their
environment where it would cause problems or alter behaviour in 
unintended ways.

Can we avoid imposing a limit on all applications?

-- 
Cheers,
Carlos.
