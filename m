From: Andreas Schwab <schwab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: F_SETOWN_EX and F_GETLK64 conflict
Date: Thu, 29 Oct 2009 18:03:48 +0100
Message-ID: <m3k4yew2rv.fsf@hase.home>
References: <Pine.LNX.4.64.0910041229300.20203@digraph.polyomino.org.uk>
	<1254691822.21044.9.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1254691822.21044.9.camel@laptop> (Peter Zijlstra's message of
	"Sun, 04 Oct 2009 23:30:22 +0200")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Cc: "Joseph S. Myers" <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <onestero-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stephane Eranian <eranian-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org> writes:

> On Sun, 2009-10-04 at 12:35 +0000, Joseph S. Myers wrote:
>> In asm-generic/fcntl.h, F_SETOWN_EX and F_GETLK64 both have value 12, and 
>> F_GETOWN_EX and F_SETLK64 both have value 13.  I don't see how this is 
>> going to work correctly.  See 
>> <http://sourceware.org/ml/libc-ports/2009-10/msg00013.html>.
>
>
> Ugh,.. yeah, non obvious collision that.
>
> How about something like:

That really needs to be fixed before 2.6.32.

Andreas.

-- 
Andreas Schwab, schwab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
