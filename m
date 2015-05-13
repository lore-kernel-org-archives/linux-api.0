From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [RFC PATCH v6] Documentation/arch: Add
 Documentation/arch-features.txt
Date: Wed, 13 May 2015 09:53:59 -0700
Message-ID: <20150513165358.GA22979@x>
References: <20150512213843.GV21418@twins.programming.kicks-ass.net>
 <20150512144910.0b49c9a7a13336773449db33@linux-foundation.org>
 <20150513083441.GA17336@gmail.com>
 <20150513085636.GA11030@gmail.com>
 <20150513092421.GB11030@gmail.com>
 <20150513094622.GC11030@gmail.com>
 <20150513094756.GD11030@gmail.com>
 <20150513131835.GJ1517@pd.tnic>
 <20150513134842.GA1657@gmail.com>
 <20150513162757.GA21894@x>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150513162757.GA21894@x>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, May 13, 2015 at 09:27:57AM -0700, Josh Triplett wrote:
> How likely is this to get out of date?  Are people going to remember to
> patch this when they add a feature to their architecture?  If
> they found out they had work to do by reading this file, which is the
> goal, then they'll likely remember to edit the file; however, if they
> find the feature and fix it without knowing about the file, will someone
> notice?
> 
> Is there any way we can *generate* this file from Kconfig?  Can we
> extract the necessary "this is possible to enable" or "this arch selects
> this symbol" information from Kconfig, and together with the list of
> symbols for features needing architecture support, generate the table?

Just tried this.  Looks like it's pretty trivial for most of these
features: just make ARCH=thearch allyesconfig, then look for the config
symbol in the result.

For instance, after doing "make ARCH=alpha allyesconfig":

~/src/linux$ grep -x 'CONFIG_ARCH_HAS_ELF_RANDOMIZE=y' .config || echo TODO
TODO

~/src/linux$ grep -x 'CONFIG_GENERIC_CLOCKEVENTS=y' .config || echo TODO
CONFIG_GENERIC_CLOCKEVENTS=y

This seems easy to turn into a shell script or Python script, given a list of
feature descriptions and corresponding config symbols, as well as a list of
architectures.

- Josh Triplett
