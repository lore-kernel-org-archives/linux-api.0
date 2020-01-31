From: David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH] move_pages.2: Returning positive value is a new error
 case
Date: Fri, 31 Jan 2020 11:49:19 +0100
Message-ID: <9aac5bff-3a18-ec5f-5aa0-82c38d367590@redhat.com>
References: <1580322632-93332-1-git-send-email-yang.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1580322632-93332-1-git-send-email-yang.shi@linux.alibaba.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yang Shi <yang.shi@linux.alibaba.com>, mhocko@suse.com, mtk.manpages@gmail.com, akpm@linux-foundation.org
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 29.01.20 19:30, Yang Shi wrote:
> Since commit a49bd4d71637 ("mm, numa: rework do_pages_move"),
> the semantic of move_pages() has changed to return the number of
> non-migrated pages if they were result of a non-fatal reasons (usually a
> busy page).  This was an unintentional change that hasn't been noticed
> except for LTP tests which checked for the documented behavior.
> 
> There are two ways to go around this change.  We can even get back to the
> original behavior and return -EAGAIN whenever migrate_pages is not able
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
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
> ---
>  man2/move_pages.2 | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/man2/move_pages.2 b/man2/move_pages.2
> index 1bf1053..c6cf3f8 100644
> --- a/man2/move_pages.2
> +++ b/man2/move_pages.2
> @@ -164,9 +164,13 @@ returns zero.
>  .\" do the right thing?
>  On error, it returns \-1, and sets
>  .I errno
> -to indicate the error.
> +to indicate the error. Or positive value to report the number of
> +non-migrated pages.

"If a positive value is returned, it's the number of non-migrated pages".

>  .SH ERRORS
>  .TP
> +.B Positive value
> +The number of non-migrated pages if they were result of a non-fatal
> +reasons since version 4.17.

s/result/the result/ ?

s/a reasons/reasons/ ?

s/since version 4.17/(since 4.17)/ ?

>  .B E2BIG
>  Too many pages to move.
>  Since Linux 2.6.29,
> 


-- 
Thanks,

David / dhildenb
