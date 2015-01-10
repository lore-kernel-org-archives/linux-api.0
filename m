From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for
 execveat(2)
Date: Sat, 10 Jan 2015 04:14:57 +0000
Message-ID: <20150110041457.GV22149@ZenIV.linux.org.uk>
References: <20150109212852.GU4574@brightrain.aerifal.cx>
 <20150109215042.GM22149@ZenIV.linux.org.uk>
 <20150109221728.GW4574@brightrain.aerifal.cx>
 <20150109223300.GO22149@ZenIV.linux.org.uk>
 <20150109224252.GY4574@brightrain.aerifal.cx>
 <20150109225743.GP22149@ZenIV.linux.org.uk>
 <20150109231248.GZ4574@brightrain.aerifal.cx>
 <20150109233644.GR22149@ZenIV.linux.org.uk>
 <20150110030300.GU22149@ZenIV.linux.org.uk>
 <20150110034144.GC4574@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150110034144.GC4574@brightrain.aerifal.cx>
Sender: linux-arch-owner@vger.kernel.org
To: Rich Felker <dalias@aerifal.cx>
Cc: David Drysdale <drysdale@google.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Meredydd Luff <meredydd@senatehouse.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Stephen Rothwell <sfr@canb.auug.org.au>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 09, 2015 at 10:41:44PM -0500, Rich Felker wrote:
> > _After_ the traversal it's too late to do this sort of thing - after all,
> > how do you tell if your current position had been set by the traversal of
> > your symlink or that of any normal /proc/self/fd/<n>?
> 
> Thanks for clarifying how this all works in the kernel. It makes it
> easier to understand what the costs (especially complexity costs) of
> different implementation options might be for the kernel.
> 
> > And doing that _during_ the traversal would really suck - stray ls -lR /proc
> > could race with that open() done by script interpreter.
> 
> IMO this one issue is easily solvable by limiting the special action
> to calls by the owning pid.

Except that if your interpreter does stat(2) (or access(2), or getxattr(2),
etc.) before bothering with open(2), you'll get screwed.  Moreover, if it
does so only in case when you have something specific in environment,
you'll have the devil of the time trying to figure out how to reproduce
such a bug report...
