From: =?UTF-8?Q?Colm_MacC=C3=A1rthaigh?= <colm-ZXBCfW2eEe/k1uMJSBkQmQ@public.gmane.org>
Subject: Re: [patch] madvise.2: Add MADV_WIPEONFORK documentation
Date: Thu, 14 Sep 2017 10:09:05 -0700
Message-ID: <CAAF6GDdnY2AmzKx+t4ffCFxJ+RZS++4tmWvoazdVNVSYjra_WA@mail.gmail.com>
References: <20170914130040.6faabb18@cuia.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170914130040.6faabb18-3y8d1Ellc6BvD/m4c++uL6fLeoKvNuZc@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Great change, just some suggestions ...

On Thu, Sep 14, 2017 at 10:00 AM, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Add MADV_WIPEONFORK and MADV_KEEPONFORK documentation to
> madvise.2.  The new functionality was recently merged by
> Linus, and should be in the 4.14 kernel.
>
> While documenting what EINVAL means for MADV_WIPEONFORK,
> I realized that MADV_FREE has the same thing going on,
> so I documented EINVAL for both in the ERRORS section.
>
> This patch documents the following kernel commit:
>
> commit d2cd9ede6e193dd7d88b6d27399e96229a551b19
> Author: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Date:   Wed Sep 6 16:25:15 2017 -0700
>
>     mm,fork: introduce MADV_WIPEONFORK
>
> Signed-off-by: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> index dfb31b63dba3..4f987ddfae79 100644
> --- a/man2/madvise.2
> +++ b/man2/madvise.2
> @@ -31,6 +31,8 @@
>  .\" 2010-06-19, Andi Kleen, Add documentation of MADV_SOFT_OFFLINE.
>  .\" 2011-09-18, Doug Goldstein <cardoe-VPKZcK2rSRzQT0dZR+AlfA@public.gmane.org>
>  .\"     Document MADV_HUGEPAGE and MADV_NOHUGEPAGE
> +.\" 2017-09-14, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> +.\"     Document MADV_WIPEONFORK and MADV_KEEPONFORK
>  .\"

It seems to be idiomatic to reference the commit adding the options in
the hidden man-page comments.  Probably needs:

.\" commit d2cd9ede6e193dd7d88b6d27399e96229a551b19

here. (That's the commit adding MADV_WIPEONFORK/MADV_KEEPONFORK to Linus' tree.


>  .TH MADVISE 2 2017-07-13 "Linux" "Linux Programmer's Manual"
>  .SH NAME
> @@ -405,6 +407,22 @@ can be applied only to private anonymous pages (see
>  .BR mmap (2)).
>  On a swapless system, freeing pages in a given range happens instantly,
>  regardless of memory pressure.
> +.TP
> +.BR MADV_WIPEONFORK " (since Linux 4.14)"
> +Present the child process with zero-filled memory in this range after a
> +.BR fork (2).
> +This is useful for per-process data in forking servers that should be
> +re-initialized in the child process after a fork, for example PRNG seeds,
> +cryptographic data, etc.

Instead of cryptographic data, I would say more broadly "secrets" - to
help nudge best-practise. For example in an application that buffers
decrypted plaintext, it's smart to mark it as WIPEONFORK so that there
aren't unnecessary copies of the plaintext floating around.

I'd suggest patching fork.2 also, with something like:

index b5af58ca0..b11e750e3 100644
--- a/man2/fork.2
+++ b/man2/fork.2
@@ -140,6 +140,12 @@ Memory mappings that have been marked with the
 flag are not inherited across a
 .BR fork ().
 .IP *
+Memory in mappings that have been marked with the
+.BR madvise (2)
+.B MADV_WIPEONFORK
+flag is zeroed in the child after a
+.BR fork ().
+.IP *
 The termination signal of the child is always
 .B SIGCHLD
 (see



-- 
Colm
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
