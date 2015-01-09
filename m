From: Rich Felker <dalias@aerifal.cx>
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for
 execveat(2)
Date: Fri, 9 Jan 2015 17:38:43 -0500
Message-ID: <20150109223843.GX4574@brightrain.aerifal.cx>
References: <1416830039-21952-6-git-send-email-drysdale@google.com>
 <54AFF813.7050604@gmail.com>
 <20150109161302.GQ4574@brightrain.aerifal.cx>
 <CAHse=S88Jy5ZKM_VY5onfvxX7dTMngnxuHfuLeSuzvKvQNP19A@mail.gmail.com>
 <20150109204815.GR4574@brightrain.aerifal.cx>
 <20150109205626.GK22149@ZenIV.linux.org.uk>
 <20150109205926.GT4574@brightrain.aerifal.cx>
 <20150109210941.GL22149@ZenIV.linux.org.uk>
 <20150109212852.GU4574@brightrain.aerifal.cx>
 <87lhlbvbzs.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87lhlbvbzs.fsf@x220.int.ebiederm.org>
Sender: sparclinux-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Drysdale <drysdale@google.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Meredydd Luff <meredydd@senatehouse.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Stephen Rothwell <sfr@canb.auug.org.au>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 09, 2015 at 04:13:27PM -0600, Eric W. Biederman wrote:
> Rich Felker <dalias@aerifal.cx> writes:
> 
> > On Fri, Jan 09, 2015 at 09:09:41PM +0000, Al Viro wrote:
> 
> > The "magic open-once magic symlink" approach is really the cleanest
> > solution I can find. In the case where the interpreter does not open
> > the script, nothing terribly bad happens; the magic symlink just
> > sticks around until _exit or exec. In the case where the interpreter
> > opens it more than once, you get a failure, but as far as I know
> > existing interpreters don't do this, and it's arguably bad design. In
> > any case it's a caught error.
> 
> And it doesn't work without introducing security vulnerabilities into
> the kernel, because it breaks close-on-exec semantics.

I'm curious what those security vulnerabilities would be. The standard
issue with close-on-exec failure (e.g. races) is the leaking of
arbitrary file descriptors (typically, ones opened by other threads or
other unrelated portions of the program) to resources the new process
should not have. "Leaking" of an inode-reference-only (no permissions)
O_PATH fd or pseudo-fd to the script that's to be run does not seem
like a vulnerability to me, and it would only be "leaked" if the
interpreter does something unexpected.

> All you have to do is pick a file descriptor, good canidates are 0 and
> 255 and make it a convention that that file descriptor is used for
> fexecve.  At least when you want to support scripts.  Otherwise you can
> set close-on-exec.

0 is obviously not a candidate; it's stdin. 255 is also not a
candidate though. Consider for example something like irssi's /upgrade
that's going to have the child inheriting an arbitrary set of file
descriptors that need to keep their original numbers, possibly
including 255. Imposing a script in between should not cause arbitrary
file descriptors to be lost.

> That results in no accumulation of file descriptors  because everyone
> always uses the same file descriptor.
> 
> Regardless you don't have a patch and you aren't proposing code and the
> code isn't actually broken so please go away.

I'm not proposing code because I'm a libc developer not a kernel
developer. I know what's needed for userspace to provide a conforming
fexecve to applications, not how to implement that on the kernel side,
although I'm trying to provide constructive ideas. The hostility is
really not necessary.

Rich
