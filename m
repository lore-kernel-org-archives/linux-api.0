From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [v2 PATCH] move_pages.2: Returning positive value is a new error
 case
Date: Thu, 30 Jan 2020 10:06:28 +0100
Message-ID: <f276d8ec-b1be-4f8e-792b-5c3ca2de4714@suse.cz>
References: <1580334531-80354-1-git-send-email-yang.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1580334531-80354-1-git-send-email-yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, mhocko-IBi9RG/b67k@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 1/29/20 10:48 PM, Yang Shi wrote:
> Since commit a49bd4d71637 ("mm, numa: rework do_pages_move"),
> the semantic of move_pages() has changed to return the number of
> non-migrated pages if they were result of a non-fatal reasons (usually a
> busy page).  This was an unintentional change that hasn't been noticed
> except for LTP tests which checked for the documented behavior.
> 
> There are two ways to go around this change.  We can even get back to the
> original behavior and return -EAGAIN whenever migrate_pages is not able

The manpage says EBUSY, not EAGAIN? And should its description be
updated too? I.e. that it's no longer returned since 4.17?

> to migrate pages due to non-fatal reasons.  Another option would be to
> simply continue with the changed semantic and extend move_pages
> documentation to clarify that -errno is returned on an invalid input or
> when migration simply cannot succeed (e.g. -ENOMEM, -EBUSY) or the
> number of pages that couldn't have been migrated due to ephemeral
> reasons (e.g. page is pinned or locked for other reasons).
> 
> We decided to keep the second option in kernel because this behavior is in
> place for some time without anybody complaining and possibly new users
> depending on it.  Also it allows to have a slightly easier error handling
> as the caller knows that it is worth to retry when err > 0.
> 
> Update man pages to reflect the new semantic.
> 
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> ---
> v2: * Added notes about status array per Michal.
>     * Added Michal's Acked-by.
> 
>  man2/move_pages.2 | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/man2/move_pages.2 b/man2/move_pages.2
> index 1bf1053..83d5c81 100644
> --- a/man2/move_pages.2
> +++ b/man2/move_pages.2
> @@ -104,7 +104,9 @@ pages that need to be moved.
>  is an array of integers that return the status of each page.
>  The array contains valid values only if
>  .BR move_pages ()
> -did not return an error.
> +did not return an error.  Pre-initialization of the array to -1 or
> +similar value which cannot represent a real numa node could help to
> +identify pages that have been migrated
>  .PP
>  .I flags
>  specify what types of pages to move.
> @@ -164,9 +166,13 @@ returns zero.
>  .\" do the right thing?
>  On error, it returns \-1, and sets
>  .I errno
> -to indicate the error.
> +to indicate the error. Or positive value to report the number of
> +non-migrated pages.
>  .SH ERRORS
>  .TP
> +.B Positive value
> +The number of non-migrated pages if they were result of a non-fatal
> +reasons since version 4.17.
>  .B E2BIG
>  Too many pages to move.
>  Since Linux 2.6.29,
> 
