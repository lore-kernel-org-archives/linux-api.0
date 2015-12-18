From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH man-pages] Add membarrier system call man page
Date: Fri, 18 Dec 2015 19:37:32 +0000 (UTC)
Message-ID: <1370012029.264035.1450467452427.JavaMail.zimbra@efficios.com>
References: <1450012663-16173-1-git-send-email-mathieu.desnoyers@efficios.com> <20151218184035.GF17386@linux-uzut.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151218184035.GF17386-95RKjC4jbl+7r5TWoziOLQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Nicholas Miell <nmiell-Wuw85uim5zDR7s880joybQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Dec 18, 2015, at 1:40 PM, Davidlohr Bueso dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org wrote:

> On Sun, 13 Dec 2015, Mathieu Desnoyers wrote:
>>+.SH RETURN VALUE
>>+On success, this system call returns zero.  On error, \-1 is returned,
>>+and
> 
> For the zero return, would it make sense to specify that it is also the case
> for MEMBARRIER_CMD_SHARED under UP? Its pretty obvious it should be a no-op,
> but wouldn't hurt to make it explicit.

My understanding is that man pages should not document the internal behavior
of the system call. What matters here from a user-space perspective, independently
of UP vs SMP, is that membarrier with MEMBARRIER_CMD_SHARED command either
succeeds (0) or fails (e.g. -1, with ENOSYS or EINVAL errno).

By the way, the updated man page text now has this for MEMBARRIER_CMD_SHARED
description:

"      MEMBARRIER_CMD_SHARED
              Ensure that all threads from all processes on  the  system  pass
              through   a  state  where  all  memory  accesses  to  user-space
              addresses match program order between entry to and  return  from
              the  membarrier()  system  call.   All threads on the system are
              targeted by this command."

The text above is true both on UP and SMP.

I fear that calling out details about UP vs SMP in the man page might confuse
users, leading them to think they need to do special handling of UP, even
though this is something about which they really should not have to worry.

Thanks,

Mathieu

> 
> Thanks,
> Davidlohr

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
