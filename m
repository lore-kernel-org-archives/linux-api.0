From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] clone: Support passing tls argument via C rather
 than pt_regs magic
Date: Tue, 12 May 2015 10:17:28 +0200
Message-ID: <20150512081727.GA6058@gmail.com>
References: <20150421174711.GA5127@jtriplet-mobl1>
 <alpine.DEB.2.11.1505052050100.4225@nanos>
 <20150505231221.GB16525@cloud>
 <20150511101313.GA18058@gmail.com>
 <20150511135526.GA6130@x>
 <20150511140043.GB5354@gmail.com>
 <20150511193050.GA11002@jtriplet-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150511193050.GA11002@jtriplet-mobl1>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org


* Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:

> > Looks good to me, but I have not looked very deeply ...
> 
> I sent out a v2 with the co-author information moved from the 
> signoffs to the commit message.  If it looks reasonable to you, can 
> you take it through the tip tree please?

So since this is multi-arch, and changes kernel/fork.c, I'd say -mm is 
a more appropriate home for it? (Assuming Linus does not object.)

Thanks,

	Ingo
