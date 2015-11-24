From: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
Subject: Re: [PATCH 2/2] mm/page_ref: add tracepoint to track down page
 reference manipulation
Date: Tue, 24 Nov 2015 10:56:04 +0900
Message-ID: <20151124015604.GB32335@js1304-P5Q-DELUXE>
References: <1447053784-27811-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1447053784-27811-2-git-send-email-iamjoonsoo.kim@lge.com>
 <564C9A86.1090906@suse.cz>
 <20151120063325.GB13061@js1304-P5Q-DELUXE>
 <20151120114225.7efeeafe@grimm.local.home>
 <20151123082805.GB29397@js1304-P5Q-DELUXE>
 <20151123092604.7ec1397d@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151123092604.7ec1397d-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 23, 2015 at 09:26:04AM -0500, Steven Rostedt wrote:
> On Mon, 23 Nov 2015 17:28:05 +0900
> Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org> wrote:
> 
> > On Fri, Nov 20, 2015 at 11:42:25AM -0500, Steven Rostedt wrote:
> > > On Fri, 20 Nov 2015 15:33:25 +0900
> > > Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org> wrote:
> > > 
> > >   
> > > > Steven, is it possible to add tracepoint to inlined fucntion such as
> > > > get_page() in include/linux/mm.h?  
> > > 
> > > I highly recommend against it. The tracepoint code adds a bit of bloat,
> > > and if you inline it, you add that bloat to every use case. Also, it  
> > 
> > Is it worse than adding function call to my own stub function into
> > inlined function such as get_page(). I implemented it as following.
> > 
> > get_page()
> > {
> >         atomic_inc()
> >         stub_get_page()
> > }
> > 
> > stub_get_page() in foo.c
> > {
> >         trace_page_ref_get_page()
> > }
> 
> Now you just slowed down the fast path. But what you could do is:
> 
> get_page()
> {
> 	atomic_inc();
> 	if (trace_page_ref_get_page_enabled())
> 		stub_get_page();
> }
> 
> Now that "trace_page_ref_get_page_enabled()" will turn into:
> 
> 	if (static_key_false(&__tracepoint_page_ref_get_page.key)) {
> 
> which is a jump label (nop when disabled, a jmp when enabled). That's
> less bloat but doesn't solve the include problem. You still need to add
> the include of that will cause havoc with other tracepoints.

Yes, it also has include dependency problem so I can't use
trace_page_ref_get_page_enabled() in mm.h.

BTW, I try to open code trace_page_ref_get_page_enabled() in
get_page() as following and it works fine.

extern struct tracepoint __tracepoint_page_ref_get_page;

get_page()
{
        atomic_inc()
        if (static_key_false(&__tracepoint_page_ref_get_page.key))
                stub_get_page()
}

I know that it's not good coding practice to use raw data structure,
but, page reference management functions has complex dependency
so I'm not sure I can solve it completely. For this special case, can
I use it?

Thanks.
