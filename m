From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v3 1/2] mm: introduce page reference manipulation
 functions
Date: Wed, 24 Feb 2016 17:53:33 -0800
Message-ID: <20160224175333.8957903d.akpm@linux-foundation.org>
References: <1456212078-22732-1-git-send-email-iamjoonsoo.kim@lge.com>
	<20160223153244.83a5c3ca430c4248a4a34cc0@linux-foundation.org>
	<20160225003454.GB9723@js1304-P5Q-DELUXE>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160225003454.GB9723@js1304-P5Q-DELUXE>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
Cc: Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 25 Feb 2016 09:34:55 +0900 Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org> wrote:

> > 
> > The patches will be a bit of a pain to maintain but surprisingly they
> > apply OK at present.  It's possible that by the time they hit upstream,
> > some direct ->_count references will still be present and it will
> > require a second pass to complete the conversion.
> 
> In fact, the patch doesn't change direct ->_count reference for
> *read*. That's the reason that it is surprisingly OK at present.
> 
> It's a good idea to change direct ->_count reference even for read.
> How about changing it in rc2 after mering this patch in rc1?

Sounds fair enough.

Although I'm counting only 11 such sites so perhaps we just go ahead
and do it?
