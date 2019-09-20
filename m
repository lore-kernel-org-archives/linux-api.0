From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: [PATCH RFC v4 1/1] random: WARN on large getrandom() waits and
 introduce getrandom2()
Date: Fri, 20 Sep 2019 19:56:46 +0200
Message-ID: <20190920175646.GA6969@pc>
References: <CAHk-=wjyH910+JRBdZf_Y9G54c1M=LBF8NKXB6vJcm9XjLnRfg@mail.gmail.com>
 <20190914122500.GA1425@darwi-home-pc>
 <008f17bc-102b-e762-a17c-e2766d48f515@gmail.com>
 <20190915052242.GG19710@mit.edu>
 <CAHk-=wgg2T=3KxrO-BY3nHJgMEyApjnO3cwbQb_0vxsn9qKN8Q@mail.gmail.com>
 <20190918211503.GA1808@darwi-home-pc>
 <20190918211713.GA2225@darwi-home-pc>
 <CAHk-=wiCqDiU7SE3FLn2W26MS_voUAuqj5XFa1V_tiGTrrW-zQ@mail.gmail.com>
 <20190920134609.GA2113@pc>
 <20190920172609.GA1832@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190920172609.GA1832@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
To: Willy Tarreau <w@1wt.eu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Lennart Poettering <mzxreary@0pointer.de>, "Theodore Y. Ts'o" <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Matthew Garrett <mjg59@srcf.ucam.org>, lkml <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, linux-man@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Sep 20, 2019 at 07:26:09PM +0200, Willy Tarreau wrote:
> Hi Ahmed,
> 
> On Fri, Sep 20, 2019 at 03:46:09PM +0200, Ahmed S. Darwish wrote:
> > Problem is, glibc is still *really* slow in adopting linux syscall
> > wrappers, so I'm not optimistic about that...
> >
> > I still see the new system call as the sanest path, even provided
> > the cost of a new syscall number..
> 
> New syscalls are always a pain to deal with in userland, because when
> they are introduced, everyone wants them long before they're available
> in glibc. So userland has to define NR_xxx for each supported arch and
> to perform the call itself.
> 
> With flags adoption is instantaneous. Just #ifndef/#define, check if
> the flag is supported and that's done. The only valid reason for a new
> syscall is when the API changes (e.g. one extra arg, a la accept4()),
> which doesn't seem to be the case here. Otherwise please by all means
> avoid this in general.
> 

I see. Thanks a lot for the explanation above :)

--
Ahmed Darwish
