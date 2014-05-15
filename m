From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: futex(2) man page update help request
Date: Thu, 15 May 2014 07:59:46 -0700
Message-ID: <5374D662.8090002@zytor.com>
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <537407ED.8050606@zytor.com> <CF999CD6.90A93%dvhart@linux.intel.com> <5374C54B.7040408@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5374C54B.7040408-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <davidlohr.bueso-VXdhtT5mjnY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 05/15/2014 06:46 AM, Michael Kerrisk (man-pages) wrote:
> 
> People have a number of times noted that there are problems
> with syscall(), but I'm not knowledgeable on the details.
> I'd happily take a patch to the man page (which, for historical
> reasons, is actually syscall(2)) that explains the the problems 
> (and ideally notes those platforms where there are no problems).
> 

It has to do with how ABIs deal with doublewidth arguments.

There is a reason why Linux syscall ABIs generally have a 1:1 mapping
with the user space ABIs, and why the system call argument is passed not
in the first argument but in a different place (usually a separately
clobbered register, e.g. %eax on x86-64).

On some platforms, doublewidth registers have to be aligned in register
pairs.  On some other platforms, enough arguments mean some will be
passed in memory, where they are forced to be aligned, or they are not
allowed to straddle the register-memory boundary.  All of this means
that padding words might be introduced, and they will be introduced in
the wrong place because of the additional argument introduced at the
beginning of the argument sequence.

On the other hand, the old SYSCALL user-space macros just plain didn't
handle doubleword arguments.

	-hpa

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
