From: Rich Felker <dalias@aerifal.cx>
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for
 execveat(2)
Date: Fri, 9 Jan 2015 18:37:25 -0500
Message-ID: <20150109233725.GA4574@brightrain.aerifal.cx>
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
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUpr5kqNm5M5z=RxM9T7DOQB3-Le2gxGM=D7+cpWVRQaQ@mail.gmail.com>
Sender: sparclinux-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Drysdale <drysdale@google.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Meredydd Luff <meredydd@senatehouse.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Stephen Rothwell <sfr@canb.auug.org.au>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 09, 2015 at 03:24:12PM -0800, Andy Lutomirski wrote:
> On Fri, Jan 9, 2015 at 3:12 PM, Rich Felker <dalias@aerifal.cx> wrote:
> > On Fri, Jan 09, 2015 at 10:57:43PM +0000, Al Viro wrote:
> >> On Fri, Jan 09, 2015 at 05:42:52PM -0500, Rich Felker wrote:
> >>
> >> > Here's a very simple way it could work -- it could put the O_PATH fd
> >> > on a previously-unused fd number, and put a special flag on the fd,
> >> > like FD_CLOEXEC, but that causes the kernel to close it whenever it's
> >> > opened. The pathname passed could then simply be /dev/fd/%d or
> >> > /proc/self/fd/%d, and although this is presently dependent on /proc
> >> > being mounted, virtual /dev/fd/* could someday be something completely
> >> > independent of procfs. The kernel keeps all the freedom to choose how
> >> > to pass the name to the interpreter. I'm not proposing any kernel
> >> > API/ABI lock-in and I'm with you in opposing such lock-in.
> >>
> >> Huh?  open() on procfs symlinks does *NOT* work the way - the symlink is
> >> traversed and after that point there is no information whatsoever how we
> >> got to that vfsmount/dentry pair.  I can imagine several kludges that would
> >> work, but they are unspeakably ugly, and do_last() is already far too
> >> convoluted as it is.
> >
> > I'm not sure where you're disagreeing with me. open of procfs symlinks
> > does not resolve the symlink and open the resulting pathname. They are
> > "magic symlinks" which are bound to the inode of the open file. I
> > don't see why this action, which is already special for magic
> > symlinks, can't check a flag on the magic symlink and possibly close
> > the corresponding file descriptor as part of its action.
> >
> > In any case, whether/how fexecve works with interpreters is something
> > the kernel can change without breaking userspace expectations. My goal
> > is to avoid creating any new API/ABI requirement here.
> 
> I think that, if we really want to support clean fexecve on O_CLOEXEC
> scripts some day, the right way to do it is to fix the script
> interface for real.  Have a special flag in the headers of script
> interpreters that support a new interface that says "when I'm a script
> interpreter, I expect an auxv entry AT_SCRIPT_FD with an  open fd with
> CLOEXEC set".  Then we can directly exec scripts by fd, even with
> O_CLOEXEC set, without any races.

This is also acceptable, but I don't think you'd really need a special
header flag. Just pass it, and also pass /dev/fd/%d or
/proc/self/fd/%d in argv[]. If the interpreter supports it, everything
works fine. If not, it still works as long as /proc is mounted, but
with a partial fd leak. (Note: the leak is not so bad since the
interpreter would inherit a close-on-exec fd and thus would not leak
it further.)

Aside from setting up the new auxv entry, the main trick the kernel
would have to do is bypassing FD_CLOEXEC at exec time while keeping
the FD_CLOEXEC flag present on the fd after exec.

Rich
