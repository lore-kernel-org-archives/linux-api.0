From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] clone: Support passing tls argument via C rather
 than pt_regs magic
Date: Mon, 11 May 2015 16:00:43 +0200
Message-ID: <20150511140043.GB5354@gmail.com>
References: <20150421174711.GA5127@jtriplet-mobl1>
 <alpine.DEB.2.11.1505052050100.4225@nanos>
 <20150505231221.GB16525@cloud>
 <20150511101313.GA18058@gmail.com>
 <20150511135526.GA6130@x>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150511135526.GA6130@x>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org


* Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:

> On Mon, May 11, 2015 at 12:13:13PM +0200, Ingo Molnar wrote:
> > 
> > * josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
> > 
> > > On Tue, May 05, 2015 at 08:53:03PM +0200, Thomas Gleixner wrote:
> > > > On Tue, 21 Apr 2015, Josh Triplett wrote:
> > > > > 
> > > > > Signed-off-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
> > > > > Signed-off-by: Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > 
> > > > Can you please clarify that SOB chain? It does not make any sense.
> > > 
> > > Co-authored patch.  We both worked on it together, and sadly git 
> > > doesn't support a commit with multiple authors, so this is the next 
> > > best thing.
> > 
> > No, this is not a valid SOB chain.
> > 
> > For 'co authored' patches you can add credits either to the file, 
> > as two copyright lines, or via the changelog, no need to mess up 
> > the SOB chain for that.
> 
> Fine, I'll write it another way.
> 
> Do you see any other issues with the patch other than the signoffs?

Looks good to me, but I have not looked very deeply ...

Thanks,

	Ingo
