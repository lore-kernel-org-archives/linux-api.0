From: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC v11][PATCH 05/13] Dump memory address space
Date: Thu, 18 Dec 2008 07:54:36 -0800
Message-ID: <1229615676.17206.518.camel@nimitz>
References: <1228498282-11804-1-git-send-email-orenl@cs.columbia.edu>
	 <1228498282-11804-6-git-send-email-orenl@cs.columbia.edu>
	 <4949B4ED.9060805@google.com>  <494A2F94.2090800@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <494A2F94.2090800-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Cc: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, jeremy-TSDbQ3PG+2Y@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Linux Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2008-12-18 at 06:10 -0500, Oren Laadan wrote:
> >> +    for (i = pgarr->nr_used; i--; /**/)
> >> +        page_cache_release(pgarr->pages[i]);
> > 
> > This is sorta hard to read (and non-intuitive).  Is it easier to do:
> > 
> > for (i = 0; i < pgarr->nr_used; i++)
> >     page_cache_release(pgarr->pages[i]);
> > 
> > It shouldn't matter what order you release the pages in..
> 
> Was meant to avoid a dereference to 'pgarr->nr_used' in the comparison.
> (though I doubt if the performance impact is at all visible)

That's a bit to aggressive an optimization.  You two piqued my
curiosity, so I tried a little experiment with this .c file:

extern void bar(int i);

struct s {
        int *array;
        int size;
};

extern struct s *s;
void foo(void)
{
        int i;
#ifdef OREN
        for (i = s->size; i--; )
#else
        for (i = 0; i < s->size; i++)
#endif
                bar(s->array[i]);
}

for O in "" -O -O1 -O2 -O3 -Os; do
	gcc -DOREN $O -c f1.c -o oren.o;
	gcc $O -c f1.c -o mike.o;
	echo -n Oren:; objdump -d oren.o | grep ret;
	echo -n Mike:; objdump -d mike.o | grep ret;
done

Smaller numbers are better, and indicate the size of that function,
basically:

Oren:  38:	c3                   	ret    
Mike:  3b:	c3                   	ret    
Oren:  44:	c3                   	ret    
Mike:  36:	c3                   	ret    
Oren:  44:	c3                   	ret    
Mike:  36:	c3                   	ret    
Oren:  43:	c3                   	ret    
Mike:  34:	c3                   	ret    
Oren:  43:	c3                   	ret    
Mike:  34:	c3                   	ret    
Oren:  3a:	c3                   	ret    
Mike:  2a:	c3                   	ret    

gcc version 4.2.4 (Ubuntu 4.2.4-1ubuntu3).  In all but the unoptimized
case, Mike's version wins.  Readability, and icache footprint all in one
package!

-- Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
