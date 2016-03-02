From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v4 1/2] mm: introduce page reference manipulation
 functions
Date: Wed, 2 Mar 2016 17:44:16 +0100
Message-ID: <56D71860.7050108@suse.cz>
References: <1456448282-897-1-git-send-email-iamjoonsoo.kim@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456448282-897-1-git-send-email-iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/26/2016 01:58 AM, js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
>
> Success of CMA allocation largely depends on success of migration
> and key factor of it is page reference count. Until now, page reference
> is manipulated by direct calling atomic functions so we cannot follow up
> who and where manipulate it. Then, it is hard to find actual reason
> of CMA allocation failure. CMA allocation should be guaranteed to succeed
> so finding offending place is really important.
>
> In this patch, call sites where page reference is manipulated are converted
> to introduced wrapper function. This is preparation step to add tracepoint
> to each page reference manipulation function. With this facility, we can
> easily find reason of CMA allocation failure. There is no functional change
> in this patch.
>
> In addition, this patch also converts reference read sites. It will help
> a second step that renames page._count to something else and prevents later
> attempt to direct access to it (Suggested by Andrew).
>
> Acked-by: Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

Even without Patch 2/2 this is a nice improvement.
Acked-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>

Although somebody might be confused by page_ref_count() vs page_count(). 
Oh well.
