From: Rich Felker <dalias@aerifal.cx>
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for
 execveat(2)
Date: Mon, 12 Jan 2015 11:07:21 -0500
Message-ID: <20150112160721.GJ4574@brightrain.aerifal.cx>
References: <20150109204815.GR4574@brightrain.aerifal.cx>
 <20150109205626.GK22149@ZenIV.linux.org.uk>
 <20150109205926.GT4574@brightrain.aerifal.cx>
 <20150109210941.GL22149@ZenIV.linux.org.uk>
 <20150109212852.GU4574@brightrain.aerifal.cx>
 <87lhlbvbzs.fsf@x220.int.ebiederm.org>
 <20150109223843.GX4574@brightrain.aerifal.cx>
 <87mw5rtowa.fsf@x220.int.ebiederm.org>
 <20150110013324.GB4574@brightrain.aerifal.cx>
 <CAHse=S822QjRE_FF6JHi-5cUsrXHJnyjRwYJuyYn2O6tsz2dHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHse=S822QjRE_FF6JHi-5cUsrXHJnyjRwYJuyYn2O6tsz2dHQ@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Meredydd Luff <meredydd@senatehouse.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Stephen Rothwell <sfr@canb.auug.org.au>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jan 12, 2015 at 11:33:49AM +0000, David Drysdale wrote:
> On Sat, Jan 10, 2015 at 1:33 AM, Rich Felker <dalias@aerifal.cx> wrote:
> > On Fri, Jan 09, 2015 at 07:17:41PM -0600, Eric W. Biederman wrote:
> >> Rich Felker <dalias@aerifal.cx> writes:
> >>
> >> > I'm not proposing code because I'm a libc developer not a kernel
> >> > developer. I know what's needed for userspace to provide a conforming
> >> > fexecve to applications, not how to implement that on the kernel side,
> >> > although I'm trying to provide constructive ideas. The hostility is
> >> > really not necessary.
> >>
> >> Conforming to what?
> >>
> >> The open group fexecve says nothing about requiring a file descriptor
> >> passed to fexecve to have O_CLOEXEC.
> >
> > It doesn't require it but it allows it, and in multithreaded programs
> > that might run child processes (or library code that might be used in
> > such situations), O_CLOEXEC is mandatory everywhere to avoid fd leaks.
> 
> As a naive idea related to Andy's suggestion elsewhere, could you
> just have an environment convention for fexecve-ing scripts?  That
> would reduce FD leaks without any need for kernel involvement/changes.
> 
> For example, set _FEXECVED_VIA_FD=4 but don't set
> O_CLOEXEC before fexecve, and the interpreter reads then
> closes that FD.  Or just get the interpreter to spot scripts named
> "/dev/fd/%d" and read-then-close the FD that way, cf. Eric's suggestion
> at https://lkml.org/lkml/2014/10/22/652.

No. Any omission of O_CLOEXEC even momentarily is a potentially
dangerous fd leak. This is the case whenever the process is
multithreaded and it's possible that other threads might fork and
exec. Think of the case of a privileged daemon re-execing itself (e.g.
to switch to an updated version) while there are potentially other
threads spawning non-privileged processes.

Rich
