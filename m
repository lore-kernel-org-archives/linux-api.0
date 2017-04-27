From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] uapi: change the type of struct statx_timestamp.tv_nsec
 to unsigned
Date: Wed, 26 Apr 2017 23:46:36 -0700
Message-ID: <20170427064636.GA7956@infradead.org>
References: <149321460018.18277.7857539856722003605.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <149321460018.18277.7857539856722003605.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

I think this is the right thing to do, but we'd really need to get this
in before 4.11 is release and the syscall is out in the wild..

On Wed, Apr 26, 2017 at 02:50:00PM +0100, David Howells wrote:
> The more generic comment asserting that the value of struct
> statx_timestamp.tv_nsec might be negative is confusing to say the least.
> 
> It contradicts both the struct stat.st_[acm]time_nsec tradition and
> struct timespec.tv_nsec requirements in utimensat syscall.
> If statx syscall ever returns a stx_[acm]time containing a negative
> tv_nsec that cannot be passed unmodified to utimensat syscall,
> it will cause an immense confusion.
> 
> Fix this source of confusion by changing the type of struct
> statx_timestamp.tv_nsec from __s32 to __u32.
> 
> Fixes: a528d35e8bfc ("statx: Add a system call to make enhanced file info available")
> Signed-off-by: Dmitry V. Levin <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> ---
> 
>  include/uapi/linux/stat.h |    8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
> index d538897b8e08..17b10304c393 100644
> --- a/include/uapi/linux/stat.h
> +++ b/include/uapi/linux/stat.h
> @@ -48,17 +48,13 @@
>   * tv_sec holds the number of seconds before (negative) or after (positive)
>   * 00:00:00 1st January 1970 UTC.
>   *
> - * tv_nsec holds a number of nanoseconds before (0..-999,999,999 if tv_sec is
> - * negative) or after (0..999,999,999 if tv_sec is positive) the tv_sec time.
> - *
> - * Note that if both tv_sec and tv_nsec are non-zero, then the two values must
> - * either be both positive or both negative.
> + * tv_nsec holds a number of nanoseconds (0..999,999,999) after the tv_sec time.
>   *
>   * __reserved is held in case we need a yet finer resolution.
>   */
>  struct statx_timestamp {
>  	__s64	tv_sec;
> -	__s32	tv_nsec;
> +	__u32	tv_nsec;
>  	__s32	__reserved;
>  };
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
