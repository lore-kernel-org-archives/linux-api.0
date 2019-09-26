From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: [PATCH RFC v4 1/1] random: WARN on large getrandom() waits and
 introduce getrandom2()
Date: Thu, 26 Sep 2019 23:11:50 +0200
Message-ID: <20190926211150.GA1085@darwi-home-pc>
References: <20190918211503.GA1808@darwi-home-pc>
 <20190918211713.GA2225@darwi-home-pc>
 <CAHk-=wiCqDiU7SE3FLn2W26MS_voUAuqj5XFa1V_tiGTrrW-zQ@mail.gmail.com>
 <20190920134609.GA2113@pc>
 <CALCETrWvE5es3i+to33y6jw=Yf0Tw6ZfV-6QWjZT5v0fo76tWw@mail.gmail.com>
 <CAHk-=wgW8rN2EVL_Rdn63V9vQO0GkZ=RQFeqqsYJM==8fujpPg@mail.gmail.com>
 <CALCETrV=4TX2a4uV5t2xOFzv+zM_jnOtMLJna8Vb7uXz6S=wSw@mail.gmail.com>
 <CAHk-=wjpTWgpo6d24pTv+ubfea_uEomX-sHjjOkdACfV-8Nmkg@mail.gmail.com>
 <87blvefai7.fsf@oldenburg2.str.redhat.com>
 <CALCETrWM9opVj+BBrHnnTakTLunW_fB9RM+VSNpNSkR9drDjMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWM9opVj+BBrHnnTakTLunW_fB9RM+VSNpNSkR9drDjMw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Florian Weimer <fweimer@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Lennart Poettering <mzxreary@0pointer.de>, "Theodore Y. Ts'o" <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, lkml <linux-kernel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 23, 2019 at 11:33:21AM -0700, Andy Lutomirski wrote:
> On Fri, Sep 20, 2019 at 11:07 PM Florian Weimer <fweimer@redhat.com> wrote:
> >
> > * Linus Torvalds:
> >
> > > Violently agreed. And that's kind of what the GRND_EXPLICIT is really
> > > aiming for.
> > >
> > > However, it's worth noting that nobody should ever use GRND_EXPLICIT
> > > directly. That's just the name for the bit. The actual users would use
> > > GRND_INSECURE or GRND_SECURE.
> >
> > Should we switch glibc's getentropy to GRND_EXPLICIT?  Or something
> > else?
> >
> > I don't think we want to print a kernel warning for this function.
> >
> 
> Contemplating this question, I think the answer is that we should just
> not introduce GRND_EXPLICIT or anything like it.  glibc is going to
> have to do *something*, and getentropy() is unlikely to just go away.
> The explicitly documented semantics are that it blocks if the RNG
> isn't seeded.
> 
> Similarly, FreeBSD has getrandom():
> 
> https://www.freebsd.org/cgi/man.cgi?query=getrandom&sektion=2&manpath=freebsd-release-ports
> 
> and if we make getrandom(..., 0) warn, then we have a situation where
> the *correct* (if regrettable) way to use the function on FreeBSD
> causes a warning on Linux.
> 
> Let's just add GRND_INSECURE, make the blocking mode work better, and,
> if we're feeling a bit more adventurous, add GRND_SECURE_BLOCKING as a
> better replacement for 0, ...

This is what's now done in the just-submitted V5, except the "make the
blocking mode work better" part:

    https://lkml.kernel.org/r/20190926204217.GA1366@pc

It's a very conservative patch so far IMHO (minus the loud warning).

Thanks,
--
Ahmed Darwish
