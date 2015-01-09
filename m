From: Rich Felker <dalias@aerifal.cx>
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for
 execveat(2)
Date: Fri, 9 Jan 2015 17:42:52 -0500
Message-ID: <20150109224252.GY4574@brightrain.aerifal.cx>
References: <20150109161302.GQ4574@brightrain.aerifal.cx>
 <CAHse=S88Jy5ZKM_VY5onfvxX7dTMngnxuHfuLeSuzvKvQNP19A@mail.gmail.com>
 <20150109204815.GR4574@brightrain.aerifal.cx>
 <20150109205626.GK22149@ZenIV.linux.org.uk>
 <20150109205926.GT4574@brightrain.aerifal.cx>
 <20150109210941.GL22149@ZenIV.linux.org.uk>
 <20150109212852.GU4574@brightrain.aerifal.cx>
 <20150109215042.GM22149@ZenIV.linux.org.uk>
 <20150109221728.GW4574@brightrain.aerifal.cx>
 <20150109223300.GO22149@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150109223300.GO22149@ZenIV.linux.org.uk>
Sender: sparclinux-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Drysdale <drysdale@google.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Meredydd Luff <meredydd@senatehouse.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Stephen Rothwell <sfr@canb.auug.org.au>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 09, 2015 at 10:33:00PM +0000, Al Viro wrote:
> On Fri, Jan 09, 2015 at 05:17:28PM -0500, Rich Felker wrote:
> > > Back then the procfs-free environments had been pushed as a serious argument
> > > in favour of merging the damn thing.  Now you guys turn around and say that
> > > we not only need procfs mounted, we need a yet-to-be-added kludge in there
> > > to cope with the actual intended uses.
> > 
> > Reverting does not fix the problem. There is no way to make fexecve
> > work for scripts without kernel support, and the needed kernel support
> > without fexecve would be even nastier, since handling of /proc/self/fd
> > magic-symlinks would need to be special-cased. The added fexecveat
> > syscall supports fully /proc-less operation for non-scripts.
> 
> Oh, yes it does.  It's not *our* problem if it's out of tree and not
> a part of ABI.  That way if you need it, *you* get to come up with clean
> implementation.  If it's in-tree you get leverage to push ugly kludges
> further in.  And frankly, I don't trust you to abstain from using that
> leverage in rather nasty ways.
> 
> Out of curiosity, how would you expect that "open only once" to work?
> All reliable variants I see are beyond sick...

Here's a very simple way it could work -- it could put the O_PATH fd
on a previously-unused fd number, and put a special flag on the fd,
like FD_CLOEXEC, but that causes the kernel to close it whenever it's
opened. The pathname passed could then simply be /dev/fd/%d or
/proc/self/fd/%d, and although this is presently dependent on /proc
being mounted, virtual /dev/fd/* could someday be something completely
independent of procfs. The kernel keeps all the freedom to choose how
to pass the name to the interpreter. I'm not proposing any kernel
API/ABI lock-in and I'm with you in opposing such lock-in.

Rich
