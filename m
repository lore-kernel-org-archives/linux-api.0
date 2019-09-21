From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH RFC v4 1/1] random: WARN on large getrandom() waits and introduce getrandom2()
Date: Sat, 21 Sep 2019 08:07:12 +0200
Message-ID: <87blvefai7.fsf@oldenburg2.str.redhat.com>
References: <20190912034421.GA2085@darwi-home-pc>
        <20190912082530.GA27365@mit.edu>
        <CAHk-=wjyH910+JRBdZf_Y9G54c1M=LBF8NKXB6vJcm9XjLnRfg@mail.gmail.com>
        <20190914122500.GA1425@darwi-home-pc>
        <008f17bc-102b-e762-a17c-e2766d48f515@gmail.com>
        <20190915052242.GG19710@mit.edu>
        <CAHk-=wgg2T=3KxrO-BY3nHJgMEyApjnO3cwbQb_0vxsn9qKN8Q@mail.gmail.com>
        <20190918211503.GA1808@darwi-home-pc>
        <20190918211713.GA2225@darwi-home-pc>
        <CAHk-=wiCqDiU7SE3FLn2W26MS_voUAuqj5XFa1V_tiGTrrW-zQ@mail.gmail.com>
        <20190920134609.GA2113@pc>
        <CALCETrWvE5es3i+to33y6jw=Yf0Tw6ZfV-6QWjZT5v0fo76tWw@mail.gmail.com>
        <CAHk-=wgW8rN2EVL_Rdn63V9vQO0GkZ=RQFeqqsYJM==8fujpPg@mail.gmail.com>
        <CALCETrV=4TX2a4uV5t2xOFzv+zM_jnOtMLJna8Vb7uXz6S=wSw@mail.gmail.com>
        <CAHk-=wjpTWgpo6d24pTv+ubfea_uEomX-sHjjOkdACfV-8Nmkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wjpTWgpo6d24pTv+ubfea_uEomX-sHjjOkdACfV-8Nmkg@mail.gmail.com>
        (Linus Torvalds's message of "Fri, 20 Sep 2019 11:09:53 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Theodore Y. Ts'o" <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, lkml <linux-kernel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Linus Torvalds:

> Violently agreed. And that's kind of what the GRND_EXPLICIT is really
> aiming for.
>
> However, it's worth noting that nobody should ever use GRND_EXPLICIT
> directly. That's just the name for the bit. The actual users would use
> GRND_INSECURE or GRND_SECURE.

Should we switch glibc's getentropy to GRND_EXPLICIT?  Or something
else?

I don't think we want to print a kernel warning for this function.

Thanks,
Florian
