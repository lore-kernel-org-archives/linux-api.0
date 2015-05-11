From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/2] clone: Support passing tls argument via C rather
 than pt_regs magic
Date: Mon, 11 May 2015 12:13:13 +0200
Message-ID: <20150511101313.GA18058@gmail.com>
References: <20150421174711.GA5127@jtriplet-mobl1>
 <alpine.DEB.2.11.1505052050100.4225@nanos>
 <20150505231221.GB16525@cloud>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150505231221.GB16525@cloud>
Sender: linux-kernel-owner@vger.kernel.org
To: josh@joshtriplett.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org


* josh@joshtriplett.org <josh@joshtriplett.org> wrote:

> On Tue, May 05, 2015 at 08:53:03PM +0200, Thomas Gleixner wrote:
> > On Tue, 21 Apr 2015, Josh Triplett wrote:
> > > 
> > > Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> > > Signed-off-by: Thiago Macieira <thiago.macieira@intel.com>
> > 
> > Can you please clarify that SOB chain? It does not make any sense.
> 
> Co-authored patch.  We both worked on it together, and sadly git 
> doesn't support a commit with multiple authors, so this is the next 
> best thing.

No, this is not a valid SOB chain.

For 'co authored' patches you can add credits either to the file, as 
two copyright lines, or via the changelog, no need to mess up the SOB 
chain for that.

Thanks,

	Ingo
