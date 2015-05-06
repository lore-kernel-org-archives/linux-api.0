From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v18 for v4.1-rc2 1/3] sys_membarrier(): system-wide
 memory barrier (generic, x86)
Date: Wed, 6 May 2015 20:33:42 +0000 (UTC)
Message-ID: <2014027751.44926.1430944422045.JavaMail.zimbra@efficios.com>
References: <1430940068-4326-1-git-send-email-mathieu.desnoyers@efficios.com> <1430940068-4326-2-git-send-email-mathieu.desnoyers@efficios.com> <20150506202120.GA23011@cloud> <371299002.44925.1430944039395.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <371299002.44925.1430944039395.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Nicholas Miell <nmiell-Wuw85uim5zDR7s880joybQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

----- Original Message -----
> ----- Original Message -----
> > On Wed, May 06, 2015 at 03:21:06PM -0400, Mathieu Desnoyers wrote:
[...]
> > Reviewed-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
> > 
> 
> Thanks!
> 
> > But also, the "snip" and "changes since" should not be in the commit
> > message,
> > while this list of signoffs and CCs should be.
> > 
> 
> Is there a typical way to handle this while keeping
> it attached to a commit locally in my git branch ?

Will try moving those parts under a "---" in the commit
message, and hope it does what I intend.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
