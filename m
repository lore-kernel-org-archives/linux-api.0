From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v4 2/2] mm/page_ref: add tracepoint to track down page
 reference manipulation
Date: Fri, 4 Mar 2016 12:04:39 -0800
Message-ID: <20160304120439.a38a15e0fe5b989fe5b8edfc@linux-foundation.org>
References: <1456448282-897-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1456448282-897-2-git-send-email-iamjoonsoo.kim@lge.com>
	<56D71BB2.5060503@suse.cz>
	<CAAmzW4NwhSKw432qw0Ry+gi=yGpRU-MtC-zQGL27o+XEawLKrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAmzW4NwhSKw432qw0Ry+gi=yGpRU-MtC-zQGL27o+XEawLKrg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 3 Mar 2016 16:43:49 +0900 Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> > Acked-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
> >
> >> +config DEBUG_PAGE_REF
> >> +       bool "Enable tracepoint to track down page reference manipulation"
> >> +       depends on DEBUG_KERNEL
> >> +       depends on TRACEPOINTS
> >> +       ---help---
> >> +         This is the feature to add tracepoint for tracking down page
> >> reference
> >> +         manipulation. This tracking is useful to diagnosis functional
> >> failure
> >> +         due to migration failure caused by page reference mismatch. Be
> >
> >
> > OK.
> >
> >> +         careful to turn on this feature because it could bloat some
> >> kernel
> >> +         text. In my configuration, it bloats 30 KB. Although kernel text
> >> will
> >> +         be bloated, there would be no runtime performance overhead if
> >> +         tracepoint isn't enabled thanks to jump label.
> >
> >
> > I would just write something like:
> >
> > Enabling this feature adds about 30 KB to the kernel code, but runtime
> > performance overhead is virtually none until the tracepoints are actually
> > enabled.
> 
> Okay, better!
> Andrew, do you want fixup patch from me or could you simply handle it?
> 

This?

--- a/mm/Kconfig.debug~mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix
+++ a/mm/Kconfig.debug
@@ -82,10 +82,9 @@ config DEBUG_PAGE_REF
 	depends on DEBUG_KERNEL
 	depends on TRACEPOINTS
 	---help---
-	  This is the feature to add tracepoint for tracking down page reference
-	  manipulation. This tracking is useful to diagnosis functional failure
-	  due to migration failure caused by page reference mismatch. Be
-	  careful to turn on this feature because it could bloat some kernel
-	  text. In my configuration, it bloats 30 KB. Although kernel text will
-	  be bloated, there would be no runtime performance overhead if
-	  tracepoint isn't enabled thanks to jump label.
+	  This is a feature to add tracepoint for tracking down page reference
+	  manipulation. This tracking is useful to diagnose functional failure
+	  due to migration failures caused by page reference mismatches.  Be
+	  careful when enabling this feature because it adds about 30 KB to the
+	  kernel code.  However the runtime performance overhead is virtually
+	  nil until the tracepoints are actually enabled.
_
