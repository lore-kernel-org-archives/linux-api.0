From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH RFC v4 1/1] random: WARN on large getrandom() waits and
 introduce getrandom2()
Date: Fri, 20 Sep 2019 12:22:17 -0700
Message-ID: <CALCETrW_mw0qOR2oqYC0+T6V65c+t+Vdxk5Jb6S+sPTqN6SXfw@mail.gmail.com>
References: <008f17bc-102b-e762-a17c-e2766d48f515@gmail.com>
 <20190915052242.GG19710@mit.edu> <CAHk-=wgg2T=3KxrO-BY3nHJgMEyApjnO3cwbQb_0vxsn9qKN8Q@mail.gmail.com>
 <20190918211503.GA1808@darwi-home-pc> <20190918211713.GA2225@darwi-home-pc>
 <CAHk-=wiCqDiU7SE3FLn2W26MS_voUAuqj5XFa1V_tiGTrrW-zQ@mail.gmail.com>
 <20190920134609.GA2113@pc> <CALCETrWvE5es3i+to33y6jw=Yf0Tw6ZfV-6QWjZT5v0fo76tWw@mail.gmail.com>
 <CAHk-=wgW8rN2EVL_Rdn63V9vQO0GkZ=RQFeqqsYJM==8fujpPg@mail.gmail.com>
 <CALCETrV=4TX2a4uV5t2xOFzv+zM_jnOtMLJna8Vb7uXz6S=wSw@mail.gmail.com> <20190920181216.GA1889@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190920181216.GA1889@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
To: Willy Tarreau <w@1wt.eu>
Cc: Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Theodore Y. Ts'o" <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Matthew Garrett <mjg59@srcf.ucam.org>, lkml <linux-kernel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 20, 2019 at 11:12 AM Willy Tarreau <w@1wt.eu> wrote:
>
> Hi Andy,
>
> On Fri, Sep 20, 2019 at 10:52:30AM -0700, Andy Lutomirski wrote:
> > 2. Fix what is arguably a straight up kernel bug, not even an ABI
> > issue: when a user program is blocking in getrandom(..., 0), the
> > kernel happily sits there doing absolutely nothing and deadlocks the
> > system as a result.  This IMO isn't an ABI issue -- it's an
> > implementation problem.  How about we make getrandom() (probably
> > actually wait_for_random_bytes()) do something useful to try to seed
> > the RNG if the system is otherwise not doing IO.
>
> I thought about it as well with my old MSDOS reflexes, but here I
> doubt we can do a lot. It seems fishy to me to start to fiddle with
> various drivers from within a getrandom() syscall, we could sometimes
> even end up waiting even longer because one device is already locked,
> and when we have access there there's not much we can do without
> risking to cause some harm. On desktop systems you have a bit more
> choice than on headless systems (blink keyboard leds and time the
> interrupts, run some disk accesses when there's still a disk, get a
> copy of the last buffer of the audio input and/or output, turn on
> the microphone and/or webcam, and collect some data). Many of them
> cannot always be used. We could do some more portable stuff like scan
> and hash the totality of the RAM. But that's all quite bad and
> unreliable and at this point it's better to tell userland "here's
> what I could get for you, if you want better, do it yourself" and the
> userland can then ask the user "dear user, I really need valid entropy
> this time to generate your GPG key, please type frantically on this
> keyboard". And it will be more reliable this way in my opinion.

Perhaps userland could register a helper that takes over and does
something better?  But I think the kernel really should do something
vaguely reasonable all by itself.  If nothing else, we want the ext4
patch that provoked this whole discussion to be applied, which means
that we need to unbreak userspace somehow, and returning garbage it to
is not a good choice.

Here are some possible approaches that come to mind:

int count;
while (crng isn't inited) {
  msleep(1);
}

and modify add_timer_randomness() to at least credit a tiny bit to
crng_init_cnt.

Or we do something like intentionally triggering readahead on some
offset on the root block device.  We should definitely not trigger
*blocking* IO.

Also, I wonder if the real problem preventing the RNG from staring up
is that the crng_init_cnt threshold is too high.  We have a rather
baroque accounting system, and it seems like we can accumulate and
credit entropy for a very long time indeed without actually
considering ourselves done.

--Andy
