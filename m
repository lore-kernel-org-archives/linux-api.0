From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCHv4 RESEND 0/3] syscalls,x86: Add execveat() system call
Date: Sat, 25 Oct 2014 23:22:21 +0200
Message-ID: <20141025212220.GA24664@amd>
References: <1401975635-6162-1-git-send-email-drysdale@google.com>
 <CALCETrVraoD+r4zxBoGd+BV5P275AXcRV_R00SSr8fjQzRHnUg@mail.gmail.com>
 <20141019202034.GH7996@ZenIV.linux.org.uk>
 <CALCETrVZUW2iPtfFJtGnWd2RsYLwjGRGYuujrVqcOsO5oBB8Cg@mail.gmail.com>
 <20141019212921.GI7996@ZenIV.linux.org.uk>
 <CALCETrVTiO6YKRYAAe-eBgQvpUqrtE0=KrKJj2T_XJ9iSRDtmA@mail.gmail.com>
 <20141019224251.GJ7996@ZenIV.linux.org.uk>
 <CALCETrW1bWcRZxJcKS0tdCxy++Y=ndoxeh5HuZrLMLHnk+i5NA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrW1bWcRZxJcKS0tdCxy++Y=ndoxeh5HuZrLMLHnk+i5NA@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Drysdale <drysdale@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Meredydd Luff <meredydd@senatehouse.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi!

> >> Oh, you mean that #!/usr/bin/make -f would turn into /usr/bin/make
> >> /dev/fd/3?  That could be interesting, although I can imagine it
> >> breaking things, especially if /dev/fd/3 isn't set up like that, e.g.
> >> early in boot.
> >
> > Sigh...  What I mean is that fexecve(fd, ...) would have to put _something_
> > into argv when it execs the interpreter of #! file.  Simply because the
> > interpreter (which can be anything whatsoever) has no fscking idea what
> > to do with some descriptor it has before execve().  Hell, it doesn't have
> > any idea *which* descriptor had it been.
> >
> > You need to put some pathname that would yield your script upon open(2).
> > If you bothered to read those patches, you'd see that they do supply
> > one, generating it with d_path().  Which isn't particulary reliable.
> >
> > I'm not sure there's any point putting any of that in the kernel - if
> > you *do* have that pathname, you can just pass it.
> 
> Hmm.
> 
> This issue certainly makes fexecve or execveat less attractive, at
> least in cases where d_path won't work.
> 
> On the other hand, if you want to run a static binary on a cloexec fd
> (or, for that matter, a dynamic binary if you trust the interpreter to
> close the extra copy of the fd it gets) in a namespace or chroot where
> the binary is invisible, then you need kernel help.
> 
> It's too bad that script interpreters don't have a mechanism to open
> their scripts by fd.

Every interpretter depends on /dev/zero... so what about having
/dev/script_im_running? Standard character device, contains whatever
script it should contain...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
