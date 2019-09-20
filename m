From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RFC v4 1/1] random: WARN on large getrandom() waits and
 introduce getrandom2()
Date: Fri, 20 Sep 2019 11:09:53 -0700
Message-ID: <CAHk-=wjpTWgpo6d24pTv+ubfea_uEomX-sHjjOkdACfV-8Nmkg@mail.gmail.com>
References: <20190912034421.GA2085@darwi-home-pc> <20190912082530.GA27365@mit.edu>
 <CAHk-=wjyH910+JRBdZf_Y9G54c1M=LBF8NKXB6vJcm9XjLnRfg@mail.gmail.com>
 <20190914122500.GA1425@darwi-home-pc> <008f17bc-102b-e762-a17c-e2766d48f515@gmail.com>
 <20190915052242.GG19710@mit.edu> <CAHk-=wgg2T=3KxrO-BY3nHJgMEyApjnO3cwbQb_0vxsn9qKN8Q@mail.gmail.com>
 <20190918211503.GA1808@darwi-home-pc> <20190918211713.GA2225@darwi-home-pc>
 <CAHk-=wiCqDiU7SE3FLn2W26MS_voUAuqj5XFa1V_tiGTrrW-zQ@mail.gmail.com>
 <20190920134609.GA2113@pc> <CALCETrWvE5es3i+to33y6jw=Yf0Tw6ZfV-6QWjZT5v0fo76tWw@mail.gmail.com>
 <CAHk-=wgW8rN2EVL_Rdn63V9vQO0GkZ=RQFeqqsYJM==8fujpPg@mail.gmail.com> <CALCETrV=4TX2a4uV5t2xOFzv+zM_jnOtMLJna8Vb7uXz6S=wSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrV=4TX2a4uV5t2xOFzv+zM_jnOtMLJna8Vb7uXz6S=wSw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Theodore Y. Ts'o" <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, lkml <linux-kernel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 20, 2019 at 10:52 AM Andy Lutomirski <luto@kernel.org> wrote:
>
> IMO, from the beginning, we should have done this:
>
> GRND_INSECURE: insecure.  always works.
>
> GRND_SECURE_BLOCKING: does exactly what it says.
>
> 0: -EINVAL.

Violently agreed. And that's kind of what the GRND_EXPLICIT is really
aiming for.

However, it's worth noting that nobody should ever use GRND_EXPLICIT
directly. That's just the name for the bit. The actual users would use
GRND_INSECURE or GRND_SECURE.

And yes, maybe it's worth making the name be GRND_SECURE_BLOCKING just
to make people see what the big deal is.

In the meantime, we need that new bit just to be able to create the
new semantics eventually. With a warning to nudge people in the right
direction.

We may never be able to return -EINVAL, but we can add the pr_notice()
to discourage people from using it.

And yes, we'll have to block - at least for a time - to get some
entropy. But at some point we either start making entropy up, or we
say "0 means jitter-entropy for ten seconds".

That will _work_, but it will also make the security-people nervous,
which is just one more hint that they should move to
GRND_SECURE[_BLOCKING].

> getrandom(..., GRND_EXPLICIT): just fscking give me a number.  it
> seems to work and it shuts up the warning
>
> And we're back to square one.

Actually, you didn't read the GRND_INSECURE patch, did you.

getrandom(GRND_EXPLICIT) on its own returns -EINVAL.

Because yes, I thought about it, and yes, I agree that it's the same
as the old 0.

So GRND_EXPLICIT is a bit that basically means "I am explicit about
what behavior I want". But part of that is that you need to _state_
the behavior too.

So:

 - GRND_INSECURE is (GRND_EXPLICIT | GRND_NONBLOCK)

   As in "I explicitly ask you not to just not ever block": urandom

 - GRND_SECURE_BLOCKING is (GRND_EXPLICIT | GRND_RANDOM)

   As in "I explicitly ask you for those secure random numbers"

 - GRND_SECURE_NONBLOCKING is (GRND_EXPLICIT | GRND_RANDOM | GRND_NONBLOCK)

   As in "I want explicitly secure random numbers, but return -EAGAIN
if that would block".

Which are the three sane behaviors (that last one is useful for the "I
can try to generate entropy if you don't have any" case. I'm not sure
anybody will do it, but it definitely conceptually makes sense).

And I agree that your naming is better.

I had it as just "GRND_SECURE" for the blocking version, and
"GRND_SECURE | GRND_NONBLOCK" for the "secure but return EAGAIN if you
would need to block for entropy" version.

But explicitly stating the blockingness in the name makes it clearer
to the people who just want GRND_INSECURE, and makes them realize that
they don't want the blocking version.

             Linus
