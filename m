From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCHv2 1/2] clone: Support passing tls argument via C rather
 than pt_regs magic
Date: Tue, 12 May 2015 14:49:10 -0700
Message-ID: <20150512144910.0b49c9a7a13336773449db33@linux-foundation.org>
References: <20150511192918.GA11361@jtriplet-mobl1>
	<20150512142250.dcb053da81855ae1b5861173@linux-foundation.org>
	<20150512213843.GV21418@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150512213843.GV21418-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 12 May 2015 23:38:43 +0200 Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> > What happens quite frequently is that we do something for x86 with the
> > expectation that other architectures will follow along, but this
> > doesn't happen.  The arch maintainers simply didn't know about it or
> > nobody nags them.  Nothing happens and inconsistencies hang around for
> > years.  eg, http://lkml.iu.edu/hypermail/linux/kernel/1504.2/04993.html
> > 
> > I'm thinking we should find a way to do this better.  One way might be
> > to maintain a Documentation/arch-todo which identifies each item, has a
> > little list of what-to-do instructions and perhaps a list of the
> > not-yet-done architectures.  Basically a way for everyone to
> > communicate at the arch maintainers.
> 
> If only there was a linux-arch list to which arch maintainers should
> subscribe... oh wait :-)

It was I who got linux-arch established, so I'm fairly familiar with
it.  (12 years ago, gad).

I don't think it's been very successful, particularly for this purpose.
A whole pile of randomly cc'ed lkml overflow which we're relying on each
individual maintainer to sift through and pluck out particular action
items then later remember to implement them.  It's disorganized and has
too many cracks for things to fall through.
