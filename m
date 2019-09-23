From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH RFC v4 1/1] random: WARN on large getrandom() waits and
 introduce getrandom2()
Date: Mon, 23 Sep 2019 11:33:21 -0700
Message-ID: <CALCETrWM9opVj+BBrHnnTakTLunW_fB9RM+VSNpNSkR9drDjMw@mail.gmail.com>
References: <20190912034421.GA2085@darwi-home-pc> <20190912082530.GA27365@mit.edu>
 <CAHk-=wjyH910+JRBdZf_Y9G54c1M=LBF8NKXB6vJcm9XjLnRfg@mail.gmail.com>
 <20190914122500.GA1425@darwi-home-pc> <008f17bc-102b-e762-a17c-e2766d48f515@gmail.com>
 <20190915052242.GG19710@mit.edu> <CAHk-=wgg2T=3KxrO-BY3nHJgMEyApjnO3cwbQb_0vxsn9qKN8Q@mail.gmail.com>
 <20190918211503.GA1808@darwi-home-pc> <20190918211713.GA2225@darwi-home-pc>
 <CAHk-=wiCqDiU7SE3FLn2W26MS_voUAuqj5XFa1V_tiGTrrW-zQ@mail.gmail.com>
 <20190920134609.GA2113@pc> <CALCETrWvE5es3i+to33y6jw=Yf0Tw6ZfV-6QWjZT5v0fo76tWw@mail.gmail.com>
 <CAHk-=wgW8rN2EVL_Rdn63V9vQO0GkZ=RQFeqqsYJM==8fujpPg@mail.gmail.com>
 <CALCETrV=4TX2a4uV5t2xOFzv+zM_jnOtMLJna8Vb7uXz6S=wSw@mail.gmail.com>
 <CAHk-=wjpTWgpo6d24pTv+ubfea_uEomX-sHjjOkdACfV-8Nmkg@mail.gmail.com> <87blvefai7.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87blvefai7.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Theodore Y. Ts'o" <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, lkml <linux-kernel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 20, 2019 at 11:07 PM Florian Weimer <fweimer@redhat.com> wrote:
>
> * Linus Torvalds:
>
> > Violently agreed. And that's kind of what the GRND_EXPLICIT is really
> > aiming for.
> >
> > However, it's worth noting that nobody should ever use GRND_EXPLICIT
> > directly. That's just the name for the bit. The actual users would use
> > GRND_INSECURE or GRND_SECURE.
>
> Should we switch glibc's getentropy to GRND_EXPLICIT?  Or something
> else?
>
> I don't think we want to print a kernel warning for this function.
>

Contemplating this question, I think the answer is that we should just
not introduce GRND_EXPLICIT or anything like it.  glibc is going to
have to do *something*, and getentropy() is unlikely to just go away.
The explicitly documented semantics are that it blocks if the RNG
isn't seeded.

Similarly, FreeBSD has getrandom():

https://www.freebsd.org/cgi/man.cgi?query=getrandom&sektion=2&manpath=freebsd-release-ports

and if we make getrandom(..., 0) warn, then we have a situation where
the *correct* (if regrettable) way to use the function on FreeBSD
causes a warning on Linux.

Let's just add GRND_INSECURE, make the blocking mode work better, and,
if we're feeling a bit more adventurous, add GRND_SECURE_BLOCKING as a
better replacement for 0, convince FreeBSD to add it too, and then
worry about deprecating 0 once we at least get some agreement from the
FreeBSD camp.
