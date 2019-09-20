From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: [PATCH RFC v4 1/1] random: WARN on large getrandom() waits and
 introduce getrandom2()
Date: Fri, 20 Sep 2019 15:46:09 +0200
Message-ID: <20190920134609.GA2113@pc>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wiCqDiU7SE3FLn2W26MS_voUAuqj5XFa1V_tiGTrrW-zQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lennart Poettering <mzxreary@0pointer.de>, "Theodore Y. Ts'o" <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, lkml <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, linux-man@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi,

On Wed, Sep 18, 2019 at 04:57:58PM -0700, Linus Torvalds wrote:
> On Wed, Sep 18, 2019 at 2:17 PM Ahmed S. Darwish <darwish.07@gmail.com> wrote:
> >
> > Since Linux v3.17, getrandom(2) has been created as a new and more
> > secure interface for pseudorandom data requests.  It attempted to
> > solve three problems, as compared to /dev/urandom:
  > 
> I don't think your patch is really _wrong_, but I think it's silly to
> introduce a new system call, when we have 30 bits left in the flags of
> the old one, and the old system call checked them.
> 
> So it's much simpler and more straightforward to  just introduce a
> single new bit #2 that says "I actually know what I'm doing, and I'm
> explicitly asking for secure/insecure random data".
> 
> And then say that the existing bit #1 just means "I want to wait for entropy".
> 
> So then you end up with this:
> 
>     /*
>      * Flags for getrandom(2)
>      *
>      * GRND_NONBLOCK    Don't block and return EAGAIN instead
>      * GRND_WAIT_ENTROPY        Explicitly wait for entropy
>      * GRND_EXPLICIT    Make it clear you know what you are doing
>      */
>     #define GRND_NONBLOCK               0x0001
>     #define GRND_WAIT_ENTROPY   0x0002
>     #define GRND_EXPLICIT               0x0004
> 
>     #define GRND_SECURE (GRND_EXPLICIT | GRND_WAIT_ENTROPY)
>     #define GRND_INSECURE       (GRND_EXPLICIT | GRND_NONBLOCK)
> 
>     /* Nobody wants /dev/random behavior, nobody should use it */
>     #define GRND_RANDOM 0x0002
> 
> which is actually fairly easy to understand. So now we have three
> bits, and the values are:
> 
>  000  - ambiguous "secure or just lazy/ignorant"
>  001 - -EAGAIN or secure
>  010 - blocking /dev/random DO NOT USE
>  011 - nonblocking /dev/random DO NOT USE
>  100 - nonsense, returns -EINVAL
>  101 - /dev/urandom without warnings
>  110 - blocking secure
>  111 - -EAGAIN or secure
>

Hmmm, the point of the new syscall was **exactly** to avoid the 2^3
combinations above, and to provide developers only two, sane and easy,
options:

  - GRND2_INSECURE
  - GRND2_SECURE_UNBOUNDED_INITIAL_WAIT

You *must* pick one of these, and that's it. (!)

Then the proposed getrandom_wait(7) manpage, also mentioned in the V4
patch WARN message, would provide a big rationale, and encourage
everyone to use the new getrandom2(2) syscall instead.

But yeah, maybe we should add the extra flags to the old getrandom()
instead, and let glibc implement a getrandom_safe(3) wrapper only
with the sane options available.

Problem is, glibc is still *really* slow in adopting linux syscall
wrappers, so I'm not optimistic about that...

I still see the new system call as the sanest path, even provided
the cost of a new syscall number..

@Linus, @Ted:  Final thoughts?

> and people would be encouraged to use one of these three:
> 
>  - GRND_INSECURE
>  - GRND_SECURE
>  - GRND_SECURE | GRND_NONBLOCK
> 
> all of which actually make sense, and none of which have any
> ambiguity. And while "GRND_INSECURE | GRND_NONBLOCK" works, it's
> exactly the same as just plain GRND_INSECURE - the point is that it
> doesn't block for entropy anyway, so non-blocking makes no different.
>

[...]

> 
> There is *one* other small semantic change: The old code did
> urandom_read() which added warnings, but each warning also _reset_ the
> crng_init_cnt. Until it decided not to warn any more, at which point
> it also stops that resetting of crng_init_cnt.
> 
> And that reset of crng_init_cnt, btw, is some cray cray.
> 
> It's basically a "we used up entropy" thing, which is very
> questionable to begin with as the whole discussion has shown, but
> since it stops doing it after 10 cases, it's not even good security
> assuming the "use up entropy" case makes sense in the first place.
> 
> So I didn't copy that insanity either. And I'm wondering if removing
> it from /dev/urandom might also end up helping Ahmed's case of getting
> entropy earlier, when we don't reset the counter.
>

Yeah, noticed that, but I've learned not to change crypto or
speculative-execution code even if the changes "just look the same" at
first glance ;-)

(out of curiosity, I'll do a quick test with this CRNG entropy reset
part removed. Maybe it was indeed part of the problem..)

> But other than those two details, none of the existing semantics
> changed, we just added the three actually _sane_ cases without any
> ambiguity.
> 
> In particular, this still leaves the semantics of that nasty
> "getrandom(0)" as the same "blocking urandom" that it currently is.
> But now it's a separate case, and we can make that perhaps do the
> timeout, or at least the warning.
>

Yeah, I would propose to keep the V4-submitted "timeout then WARN"
logic. This alone will give user-space / distributions time to adapt.

For example, it was interesting that even the 0day bot had limited
entropy on boot (virtio-rng / TRUST_CPU not enabled):

    https://lkml.kernel.org/r/20190920005120.GP15734@shao2-debian

If user-space didn't get its act together, then the other extreme
measures can be implemented later (the getrandom() length test, using
jitter as a credited kernel entropy source, etc., etc.)

> And the new cases are defined to *not* warn. In particular,
> GRND_INSECURE very much does *not* warn about early urandom access
> when crng isn't ready. Because the whole point of that new mode is
> that the user knows it isn't secure.
>
> So that should make getrandom(GRND_INSECURE) palatable to the systemd
> kind of use that wanted to avoid the pointless kernel warning.
>

Yup, that's what was in the submitted V4 patch too. The caller
explicitly asked for "insecure", so they know what they're doing.

getrandom2(2) never prints any kernel message.

> And we could mark this for stable and try to get it backported so that
> it will have better coverage, and encourage people to use the new sane
> _explicit_ waiting (or not) for entropy.
>

ACK. I'll wait for an answer to the "Final thoughts?" question above,
send a V5 with CC:stable, then disappear from this thread ;-)

Thanks a lot everyone!

--
Ahmed Darwish
