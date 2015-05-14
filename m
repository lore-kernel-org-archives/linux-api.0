From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH v6] Documentation/arch: Add
 Documentation/arch-features.txt
Date: Thu, 14 May 2015 12:16:15 +0200
Message-ID: <20150514101615.GB27550@gmail.com>
References: <20150512144910.0b49c9a7a13336773449db33@linux-foundation.org>
 <20150513083441.GA17336@gmail.com>
 <20150513085636.GA11030@gmail.com>
 <20150513092421.GB11030@gmail.com>
 <20150513094622.GC11030@gmail.com>
 <20150513094756.GD11030@gmail.com>
 <20150513131835.GJ1517@pd.tnic>
 <20150513134842.GA1657@gmail.com>
 <20150513162757.GA21894@x>
 <20150513165358.GA22979@x>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150513165358.GA22979@x>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org


* Josh Triplett <josh@joshtriplett.org> wrote:

> On Wed, May 13, 2015 at 09:27:57AM -0700, Josh Triplett wrote:
>
> > How likely is this to get out of date?  Are people going to 
> > remember to patch this when they add a feature to their 
> > architecture?  If they found out they had work to do by reading 
> > this file, which is the goal, then they'll likely remember to edit 
> > the file; however, if they find the feature and fix it without 
> > knowing about the file, will someone notice?
> > 
> > Is there any way we can *generate* this file from Kconfig?  Can we 
> > extract the necessary "this is possible to enable" or "this arch 
> > selects this symbol" information from Kconfig, and together with 
> > the list of symbols for features needing architecture support, 
> > generate the table?
> 
> Just tried this.  Looks like it's pretty trivial for most of these 
> features: just make ARCH=thearch allyesconfig, then look for the 
> config symbol in the result.

No, that's not nearly enough to do a correct support matrix, for 
example due to subarchitectures that aren't included in an 
allyesconfig. There are also many #define driven features.

Thanks,

	Ingo
