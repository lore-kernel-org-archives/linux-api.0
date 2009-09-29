From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFC][v7][PATCH 8/9]: Define clone2() syscall
Date: Tue, 29 Sep 2009 12:10:50 -0700 (PDT)
Message-ID: <alpine.LFD.2.01.0909291207410.6996@localhost.localdomain>
References: <20090924165548.GA16586@us.ibm.com> <20090924170308.GH16989@us.ibm.com> <200909242343.59903.arnd@arndb.de> <20090925082346.GB4436@localdomain> <20090925105632.GG12824@hawkmoon.kerlabs.com> <20090929180537.GD4625@us.ibm.com>
 <20090929184023.532DF34@magilla.sf.frob.com> <4AC255A4.4030002@zytor.com> <20090929210207.247b94df@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090929210207.247b94df-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, mingo-X9Un+BFzKDI@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org
List-Id: linux-api@vger.kernel.org



On Tue, 29 Sep 2009, Arjan van de Ven wrote:
> > 
> > We already have a syscall layer which is painful to thunk in places,
> > and this would make it much worse.
> 
> syscalls are cheap as well.
> cheaper than decades of dealing with such multiplexer mess ;/

Well, I'd agree, except the clone flags really _are_ about multiplexer 
issues, and the new flag woudln't really change anything. 

If the new system call actually had appreciably separate code-paths, I'd 
buy the "multiplexer" argument. But it doesn't really. It's going to call 
down to the same basic clone functionality, and the core clone code ends 
up de-multiplexing the cases anyway.

So this would not at all be like the socket calls (to pick the traditional 
Linux system call multiplexing example) in that sense.

			Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
