From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 1/2] clone: Support passing tls argument via C rather
 than pt_regs magic
Date: Mon, 11 May 2015 12:30:51 -0700
Message-ID: <20150511193050.GA11002@jtriplet-mobl1>
References: <20150421174711.GA5127@jtriplet-mobl1>
 <alpine.DEB.2.11.1505052050100.4225@nanos>
 <20150505231221.GB16525@cloud>
 <20150511101313.GA18058@gmail.com>
 <20150511135526.GA6130@x>
 <20150511140043.GB5354@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150511140043.GB5354@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, May 11, 2015 at 04:00:43PM +0200, Ingo Molnar wrote:
> 
> * Josh Triplett <josh@joshtriplett.org> wrote:
> 
> > On Mon, May 11, 2015 at 12:13:13PM +0200, Ingo Molnar wrote:
> > > 
> > > * josh@joshtriplett.org <josh@joshtriplett.org> wrote:
> > > 
> > > > On Tue, May 05, 2015 at 08:53:03PM +0200, Thomas Gleixner wrote:
> > > > > On Tue, 21 Apr 2015, Josh Triplett wrote:
> > > > > > 
> > > > > > Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> > > > > > Signed-off-by: Thiago Macieira <thiago.macieira@intel.com>
> > > > > 
> > > > > Can you please clarify that SOB chain? It does not make any sense.
> > > > 
> > > > Co-authored patch.  We both worked on it together, and sadly git 
> > > > doesn't support a commit with multiple authors, so this is the next 
> > > > best thing.
> > > 
> > > No, this is not a valid SOB chain.
> > > 
> > > For 'co authored' patches you can add credits either to the file, 
> > > as two copyright lines, or via the changelog, no need to mess up 
> > > the SOB chain for that.
> > 
> > Fine, I'll write it another way.
> > 
> > Do you see any other issues with the patch other than the signoffs?
> 
> Looks good to me, but I have not looked very deeply ...

I sent out a v2 with the co-author information moved from the signoffs
to the commit message.  If it looks reasonable to you, can you take it
through the tip tree please?

- Josh Triplett
