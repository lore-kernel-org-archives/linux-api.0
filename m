From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for execveat(2)
Date: Sat, 10 Jan 2015 16:27:23 -0600
Message-ID: <878uhaqnjo.fsf@x220.int.ebiederm.org>
References: <20150109215042.GM22149@ZenIV.linux.org.uk>
	<20150109221728.GW4574@brightrain.aerifal.cx>
	<20150109223300.GO22149@ZenIV.linux.org.uk>
	<20150109224252.GY4574@brightrain.aerifal.cx>
	<20150109225743.GP22149@ZenIV.linux.org.uk>
	<20150109231248.GZ4574@brightrain.aerifal.cx>
	<20150109233644.GR22149@ZenIV.linux.org.uk>
	<20150110030300.GU22149@ZenIV.linux.org.uk>
	<20150110034144.GC4574@brightrain.aerifal.cx>
	<20150110041457.GV22149@ZenIV.linux.org.uk>
	<20150110055713.GE4574@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20150110055713.GE4574@brightrain.aerifal.cx> (Rich Felker's
	message of "Sat, 10 Jan 2015 00:57:13 -0500")
Sender: linux-arch-owner@vger.kernel.org
To: Rich Felker <dalias@aerifal.cx>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Drysdale <drysdale@google.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Meredydd Luff <meredydd@senatehouse.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Stephen Rothwell <sfr@canb.auug.org.au>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Rich Felker <dalias@aerifal.cx> writes:

> On Sat, Jan 10, 2015 at 04:14:57AM +0000, Al Viro wrote:

>> Except that if your interpreter does stat(2) (or access(2), or getxattr(2),
>> etc.) before bothering with open(2), you'll get screwed.
>
> Yes, but I think that would be very bad interpreter design.
> stat/getxattr/access/whatever followed by open is always a TOCTOU
> race. The correct sequence of actions is always open followed by
> fstat/fgetxattr/...

Sigh.  I think everyone who has looked at this has been blind.

If userspace is reasonable all we have to do is fix /proc/self/exe
for shell scripts to point at the actual script,
and then pass /proc/self/exe on the shell scripts command line.

At a practical level we have to worry about backwards compability and
chroot jails.  But the existence of a clean implementation with
/proc/self/exe serves a proof of concept that it would not be too
difficult.  When someone cares enough to implement it.

Eric
