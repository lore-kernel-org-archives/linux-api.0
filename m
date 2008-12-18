From: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC v11][PATCH 05/13] Dump memory address space
Date: Thu, 18 Dec 2008 10:21:39 -0800
Message-ID: <1229624499.17206.576.camel@nimitz>
References: <1228498282-11804-1-git-send-email-orenl@cs.columbia.edu>
	 <1228498282-11804-6-git-send-email-orenl@cs.columbia.edu>
	 <4949B4ED.9060805@google.com> <494A2F94.2090800@cs.columbia.edu>
	 <494A9350.1060309@google.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <494A9350.1060309-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>, jeremy-TSDbQ3PG+2Y@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Linux Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2008-12-18 at 10:15 -0800, Mike Waychison wrote:
> 
> >>> +    pgarr = kzalloc(sizeof(*pgarr), GFP_KERNEL);
> >>> +    if (!pgarr)
> >>> +        return NULL;
> >>> +
> >>> +    pgarr->vaddrs = kmalloc(CR_PGARR_TOTAL * sizeof(unsigned
> long),
> >> You used PAGE_SIZE / sizeof(void *) above.   Why not
> __get_free_page()?
> > 
> > Hahaha .. well, it's a guaranteed method to keep Dave Hansen from
> > barking about not using kmalloc ...
> > 
> > Personally I prefer __get_free_page() here, but not enough to keep
> > arguing with him. Let me know when the two of you settle it :)
> 
> Alright, I just wasn't sure if it had been considered.

__get_free_page() sucks.  It doesn't do cool stuff like redzoning when
you have slab debugging turned on.  :)

I would personally suggest never using __get_free_page() unless you
truly need a *PAGE*.  That's an aligned, and PAGE_SIZE chunk.  If you
don't need alignment, or don't literally need a 'struct page', don't use
it.

-- Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
