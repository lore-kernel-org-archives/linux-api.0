From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v18 for v4.1-rc2 1/3] sys_membarrier(): system-wide memory
 barrier (generic, x86)
Date: Wed, 6 May 2015 19:50:26 -0700
Message-ID: <CALCETrX4RSAgJ+A-GtQy_zoECSRDqQ456FV8-JmOqRD=eftiNA@mail.gmail.com>
References: <1430940068-4326-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1430940068-4326-2-git-send-email-mathieu.desnoyers@efficios.com>
 <20150506202120.GA23011@cloud> <371299002.44925.1430944039395.JavaMail.zimbra@efficios.com>
 <2014027751.44926.1430944422045.JavaMail.zimbra@efficios.com> <CA+55aFwQbE0pvb2XRRT33rDEwwwQHKN27w5A8f4GWWJ_j6w1EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFwQbE0pvb2XRRT33rDEwwwQHKN27w5A8f4GWWJ_j6w1EA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Nicholas Miell <nmiell-Wuw85uim5zDR7s880joybQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, May 6, 2015 at 1:39 PM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Wed, May 6, 2015 at 1:33 PM, Mathieu Desnoyers
> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>>
>> Will try moving those parts under a "---" in the commit
>> message, and hope it does what I intend.
>
> Yeah, that should do it for anybody who then uses "git am" to apply
> the patches you send out. It's kind of hacky, and I've always worried
> a bit that somebody uses "^---$' for real in a commit message and
> things get lost, but it is *such* a useful way to add notes to emails
> that aren't fit for actually committing, that the risk has never
> outweighed the benefits.

There's also 'git format-patch --notes', which is less hacky but more
complicated.

--Andy

>
>                   Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Andy Lutomirski
AMA Capital Management, LLC
