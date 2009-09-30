From: Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][v7][PATCH 8/9]: Define clone2() syscall
Date: Tue, 29 Sep 2009 23:48:39 -0700 (PDT)
Message-ID: <20090930064839.AB188A3@magilla.sf.frob.com>
References: <20090924165548.GA16586@us.ibm.com>
	<20090924170308.GH16989@us.ibm.com>
	<200909242343.59903.arnd@arndb.de>
	<20090925082346.GB4436@localdomain>
	<20090925105632.GG12824@hawkmoon.kerlabs.com>
	<20090929180537.GD4625@us.ibm.com>
	<20090929184023.532DF34@magilla.sf.frob.com>
	<4AC255A4.4030002@zytor.com>
	<20090929210207.247b94df@infradead.org>
	<alpine.LFD.2.01.0909291207410.6996@localhost.localdomain>
	<4AC267C7.4070300@zytor.com>
	<alpine.LFD.2.01.0909291501530.6996@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: Linus Torvalds's message of  Tuesday, 29 September 2009 15:11:03 -0700 <alpine.LFD.2.01.0909291501530.6996-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, mingo-X9Un+BFzKDI@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org
List-Id: linux-api@vger.kernel.org

The glibc prototype for clone uses ... and is not a direct map to the
syscall args anyway.  So that would not change for adding more optional
args enabled by certain flags, as it did not change to add the tid pointer
arguments before.  But indeed the library function would have to change to
pass on additional or different args to the existing syscall.


Thanks,
Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
