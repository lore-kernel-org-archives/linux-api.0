From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RFC v4 1/1] random: WARN on large getrandom() waits and
 introduce getrandom2()
Date: Fri, 20 Sep 2019 09:29:51 -0700
Message-ID: <CAHk-=wgW8rN2EVL_Rdn63V9vQO0GkZ=RQFeqqsYJM==8fujpPg@mail.gmail.com>
References: <20190912034421.GA2085@darwi-home-pc> <20190912082530.GA27365@mit.edu>
 <CAHk-=wjyH910+JRBdZf_Y9G54c1M=LBF8NKXB6vJcm9XjLnRfg@mail.gmail.com>
 <20190914122500.GA1425@darwi-home-pc> <008f17bc-102b-e762-a17c-e2766d48f515@gmail.com>
 <20190915052242.GG19710@mit.edu> <CAHk-=wgg2T=3KxrO-BY3nHJgMEyApjnO3cwbQb_0vxsn9qKN8Q@mail.gmail.com>
 <20190918211503.GA1808@darwi-home-pc> <20190918211713.GA2225@darwi-home-pc>
 <CAHk-=wiCqDiU7SE3FLn2W26MS_voUAuqj5XFa1V_tiGTrrW-zQ@mail.gmail.com>
 <20190920134609.GA2113@pc> <CALCETrWvE5es3i+to33y6jw=Yf0Tw6ZfV-6QWjZT5v0fo76tWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWvE5es3i+to33y6jw=Yf0Tw6ZfV-6QWjZT5v0fo76tWw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Theodore Y. Ts'o" <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, lkml <linux-kernel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 20, 2019 at 7:34 AM Andy Lutomirski <luto@kernel.org> wrote:
>
> What is this GRND_EXPLICIT thing?

Your own email gives the explanation:

> Linus, I disagree that blocking while waiting for randomness is an
> error.  Sometimes you want to generate a key

That's *exactly* why GRND_EXPLICIT needs to be done regardless.

The keyword there is "Sometimes".

But people currently use "getrandom(0)" when they DO NOT want a key,
they just want some miscellaneous random numbers for some totally
non-security-related reason.

And that will continue. Exactly because the people who do not want a
key by definition aren't thinking about it very hard.

So the interface was very much mis-designed from the get-go. It was
designed purely for key people, even though generating keys is by no
means the most common reason for wanting a block of "random" numbers.

So GRND_EXPLICIT is there very much to make sure people who want true
secure keys will say so, and five years from now we will not have the
confusion between "Oh, I wasn't thinking about bootup". Because at a
minimum, in the near future getrandom(0) will warn about the
ambiguity. Or it will use some questionable jitter entropy that some
real key users will look at sideways and go "I don't want that".

This is an ABI design issue. The old ABI was fundamentally misdesigned
and actively encouraged the current situation of mixing secure and
insecure callers for that getrandom(0).

And it's entirely orthogonal to _any_ actual technical change we will
do (like removing the old GRND_RANDOM behavior entirely, which is
insane for other reasons and nobody ever wanted or likely used).

            Linus
