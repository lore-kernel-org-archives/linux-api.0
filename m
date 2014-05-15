From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: futex(2) man page update help request
Date: Thu, 15 May 2014 09:07:47 -0700
Message-ID: <5374E653.2080309@zytor.com>
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <537407ED.8050606@zytor.com> <CF999CD6.90A93%dvhart@linux.intel.com> <5374C54B.7040408@gmail.com> <20140515154246.GC6926@rei.Home> <5374E2A4.2070408@zytor.com> <20140515160152.GA7529@rei.Home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140515160152.GA7529-HSzIOc4LzcM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: chrubis-AlSwsSmVLrQ@public.gmane.org
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <davidlohr.bueso-VXdhtT5mjnY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 05/15/2014 09:01 AM, chrubis-AlSwsSmVLrQ@public.gmane.org wrote:
> 
>> I really believe the proper fix is to use assembly syscall stubs.  In
>> klibc I build a fairly elaborate machinery to autogenerate such syscall
>> stubs for a variety of architectures.
> 
> Then it would be nice to share these between klibc and LTP (and possible
> everybody else).
> 

It should be quite easy to extract from klibc.

	-hpa
