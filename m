From: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
Subject: Re: [PATCH 2/2] mm/page_ref: add tracepoint to track down page
 reference manipulation
Date: Thu, 10 Dec 2015 13:07:29 +0900
Message-ID: <20151210040729.GC17967@js1304-P5Q-DELUXE>
References: <564C9A86.1090906@suse.cz>
 <20151120063325.GB13061@js1304-P5Q-DELUXE>
 <20151120114225.7efeeafe@grimm.local.home>
 <20151123082805.GB29397@js1304-P5Q-DELUXE>
 <20151123092604.7ec1397d@gandalf.local.home>
 <20151124014527.GA32335@js1304-P5Q-DELUXE>
 <20151203041657.GB1495@js1304-P5Q-DELUXE>
 <20151209150154.31c142b9@gandalf.local.home>
 <20151210025015.GA17967@js1304-P5Q-DELUXE>
 <20151209223648.4e9122b5@grimm.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151209223648.4e9122b5-2kNGR76GQU9OHLTnHDQRgA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Dec 09, 2015 at 10:36:48PM -0500, Steven Rostedt wrote:
> On Thu, 10 Dec 2015 11:50:15 +0900
> Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org> wrote:
> 
> > Output of cpu 3, 7 are mixed and it's not easy to analyze it.
> > 
> > I think that it'd be better not to sort stack trace. How do
> > you think about it? Could you fix it, please?
> 
> It may not be that easy to fix because of the sorting algorithm. That
> would require looking going ahead one more event each time and then
> checking if its a stacktrace. I may look at it and see if I can come up
> with something that's not too invasive in the algorithms.

Okay.

> That said, for now you can use the --cpu option. I'm not sure I ever
> documented it as it was originally added for debugging, but I use it
> enough that it may be worth while to officially support it.
> 
>  trace-cmd report --cpu 3
> 
> Will show you just cpu 3 and nothing else. Which is what I use a lot.

Thanks for the input. It works but it's not sufficient to me.
Page reference is manipulated by multiple cpus so it's better to
analyze unified output.

> 
> But doing the stack trace thing may be something to fix as well. I'll
> see what I can do, but no guarantees.

Okay. Don't be hurry. :)
trace-cmd is excellent and works well for me as it is.

Thanks.
