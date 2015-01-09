From: Rich Felker <dalias@aerifal.cx>
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for
 execveat(2)
Date: Fri, 9 Jan 2015 16:28:52 -0500
Message-ID: <20150109212852.GU4574@brightrain.aerifal.cx>
References: <1416830039-21952-1-git-send-email-drysdale@google.com>
 <1416830039-21952-6-git-send-email-drysdale@google.com>
 <54AFF813.7050604@gmail.com>
 <20150109161302.GQ4574@brightrain.aerifal.cx>
 <CAHse=S88Jy5ZKM_VY5onfvxX7dTMngnxuHfuLeSuzvKvQNP19A@mail.gmail.com>
 <20150109204815.GR4574@brightrain.aerifal.cx>
 <20150109205626.GK22149@ZenIV.linux.org.uk>
 <20150109205926.GT4574@brightrain.aerifal.cx>
 <20150109210941.GL22149@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150109210941.GL22149@ZenIV.linux.org.uk>
Sender: linux-arch-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Drysdale <drysdale@google.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Meredydd Luff <meredydd@senatehouse.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Stephen Rothwell <sfr@canb.auug.org.au>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 09, 2015 at 09:09:41PM +0000, Al Viro wrote:
> On Fri, Jan 09, 2015 at 03:59:26PM -0500, Rich Felker wrote:
> 
> > > For fsck sake, folks, if you have bloody /proc, you don't need that shite
> > > at all!  Just do execve on /proc/self/fd/n, and be done with that.
> > > 
> > > The sole excuse for merging that thing in the first place had been
> > > "would anybody think of children^Wsclerotic^Whardened environments
> > > where they have no /proc at all".
> > 
> > That doesn't work. With O_CLOEXEC, /proc/self/fd/n is already gone at
> > the time the interpreter runs, whether you're using fexecveat or
> > execve with "/proc/self/fd/n" to implement POSIX fexecve(). That's the
> > problem. This breaks the intended idiom for fexecve.
> 
> Just what will your magical symlink do in case when the file is opened,
> unlinked and marked O_CLOEXEC?  When should actual freeing of disk blocks,
> etc. happen?  And no, you can't assume that interpreter will open the
> damn thing even once - there's nothing to oblige it to do so.

Unlinking is not relevant. Magical symlinks refer to open file
descriptions (either real ones or O_PATH inode-reference-only ones),
not files. There is no new complexity proposed for freeing disk blocks
here. Semantics are identical to existing O_PATH inode references.

> Al, more and more tempted to ask reverting the whole thing - this hardcoded
> /dev/fd/... (in fs/exec.c, no less) is disgraceful enough, but threats of
> even more revolting kludges in the name of "intended idiom for fexecve"...

If you have a multithreaded process that's executing an external
program via fexecve, then unless it has specialized knowledge about
what other parts of the program/libraries are doing, it needs to be
using O_CLOEXEC for the file descriptor. Otherwise, the file
descriptor could be leaked to child processes started by other
threads. This is what I mean by the "intended idiom". Note that it's
easier to use pathnames instead of fexecve, but doing so may not be an
option if the program needs to verify the file before exec'ing it.

This issue can be avoided if you're going to fork-and-fexecve rather
than replacing the calling process, since after forking it's safe to
remove the close-on-exec flag. But then you still have the issue that
the child process, after exec, keeps a spurious file descriptor to its
own process image (executable file) open which it can never close
(because it doesn't know the number). This could eventually lead to fd
exhaustion after many generations.

The "magic open-once magic symlink" approach is really the cleanest
solution I can find. In the case where the interpreter does not open
the script, nothing terribly bad happens; the magic symlink just
sticks around until _exit or exec. In the case where the interpreter
opens it more than once, you get a failure, but as far as I know
existing interpreters don't do this, and it's arguably bad design. In
any case it's a caught error.

Rich
