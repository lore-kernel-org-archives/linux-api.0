From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for
 execveat(2)
Date: Sat, 10 Jan 2015 00:01:08 +0000
Message-ID: <20150110000108.GT22149@ZenIV.linux.org.uk>
References: <20150109205926.GT4574@brightrain.aerifal.cx>
 <20150109210941.GL22149@ZenIV.linux.org.uk>
 <20150109212852.GU4574@brightrain.aerifal.cx>
 <20150109215042.GM22149@ZenIV.linux.org.uk>
 <20150109221728.GW4574@brightrain.aerifal.cx>
 <20150109223300.GO22149@ZenIV.linux.org.uk>
 <20150109224252.GY4574@brightrain.aerifal.cx>
 <20150109225743.GP22149@ZenIV.linux.org.uk>
 <20150109231248.GZ4574@brightrain.aerifal.cx>
 <CALCETrUpr5kqNm5M5z=RxM9T7DOQB3-Le2gxGM=D7+cpWVRQaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUpr5kqNm5M5z=RxM9T7DOQB3-Le2gxGM=D7+cpWVRQaQ@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Rich Felker <dalias@aerifal.cx>, David Drysdale <drysdale@google.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Meredydd Luff <meredydd@senatehouse.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Stephen Rothwell <sfr@canb.auug.org.au>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 09, 2015 at 03:24:12PM -0800, Andy Lutomirski wrote:

> I think that, if we really want to support clean fexecve on O_CLOEXEC
> scripts some day, the right way to do it is to fix the script
> interface for real.  Have a special flag in the headers of script
> interpreters that support a new interface that says "when I'm a script
> interpreter, I expect an auxv entry AT_SCRIPT_FD with an  open fd with
> CLOEXEC set".  Then we can directly exec scripts by fd, even with
> O_CLOEXEC set, without any races.

Amazing.  Let me see if I got it straight - you want a magical Linux-only
flag to mark the binaries that might be used as interpreters.  _Plus_ the
Linux-only logics in their source to go with that.  With corresponding kludges
to parsing the command line (you know, like #!/usr/bin/make -f as the first
line in a script - somehow it should recognize the deep magic of the oh
so fucking superior interface and suppress the normal behaviour).  Maintained
by hell knows whom.  Onna stick.  Inna bun.  CMOT Dibbler would be proud...
