From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [RFC PATCH v6] Documentation/arch: Add
 Documentation/arch-features.txt
Date: Thu, 14 May 2015 03:31:01 -0700
Message-ID: <20150514103101.GA30945@x>
References: <20150513083441.GA17336@gmail.com>
 <20150513085636.GA11030@gmail.com>
 <20150513092421.GB11030@gmail.com>
 <20150513094622.GC11030@gmail.com>
 <20150513094756.GD11030@gmail.com>
 <20150513131835.GJ1517@pd.tnic>
 <20150513134842.GA1657@gmail.com>
 <20150513162757.GA21894@x>
 <20150513165358.GA22979@x>
 <20150514101615.GB27550@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150514101615.GB27550-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, May 14, 2015 at 12:16:15PM +0200, Ingo Molnar wrote:
> 
> * Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
> 
> > On Wed, May 13, 2015 at 09:27:57AM -0700, Josh Triplett wrote:
> >
> > > How likely is this to get out of date?  Are people going to 
> > > remember to patch this when they add a feature to their 
> > > architecture?  If they found out they had work to do by reading 
> > > this file, which is the goal, then they'll likely remember to edit 
> > > the file; however, if they find the feature and fix it without 
> > > knowing about the file, will someone notice?
> > > 
> > > Is there any way we can *generate* this file from Kconfig?  Can we 
> > > extract the necessary "this is possible to enable" or "this arch 
> > > selects this symbol" information from Kconfig, and together with 
> > > the list of symbols for features needing architecture support, 
> > > generate the table?
> > 
> > Just tried this.  Looks like it's pretty trivial for most of these 
> > features: just make ARCH=thearch allyesconfig, then look for the 
> > config symbol in the result.
> 
> No, that's not nearly enough to do a correct support matrix, for 
> example due to subarchitectures that aren't included in an 
> allyesconfig.

Still feasible to automate with a bit more scripting.

> There are also many #define driven features.

It'd be nice to move those over to Kconfig.

- Josh Triplett
