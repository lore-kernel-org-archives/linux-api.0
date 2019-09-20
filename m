From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RFC v4 1/1] random: WARN on large getrandom() waits and
 introduce getrandom2()
Date: Fri, 20 Sep 2019 13:02:50 -0700
Message-ID: <CAHk-=wic-uFGcCGX+JKFA__Xoh=BgzTpmaBJqCxfqWGcMQF0gw@mail.gmail.com>
References: <008f17bc-102b-e762-a17c-e2766d48f515@gmail.com>
 <20190915052242.GG19710@mit.edu> <CAHk-=wgg2T=3KxrO-BY3nHJgMEyApjnO3cwbQb_0vxsn9qKN8Q@mail.gmail.com>
 <20190918211503.GA1808@darwi-home-pc> <20190918211713.GA2225@darwi-home-pc>
 <CAHk-=wiCqDiU7SE3FLn2W26MS_voUAuqj5XFa1V_tiGTrrW-zQ@mail.gmail.com>
 <20190920134609.GA2113@pc> <CALCETrWvE5es3i+to33y6jw=Yf0Tw6ZfV-6QWjZT5v0fo76tWw@mail.gmail.com>
 <CAHk-=wgW8rN2EVL_Rdn63V9vQO0GkZ=RQFeqqsYJM==8fujpPg@mail.gmail.com>
 <CALCETrV=4TX2a4uV5t2xOFzv+zM_jnOtMLJna8Vb7uXz6S=wSw@mail.gmail.com>
 <20190920181216.GA1889@1wt.eu> <CALCETrW_mw0qOR2oqYC0+T6V65c+t+Vdxk5Jb6S+sPTqN6SXfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrW_mw0qOR2oqYC0+T6V65c+t+Vdxk5Jb6S+sPTqN6SXfw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Willy Tarreau <w@1wt.eu>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Theodore Y. Ts'o" <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Matthew Garrett <mjg59@srcf.ucam.org>, lkml <linux-kernel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 20, 2019 at 12:22 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> Here are some possible approaches that come to mind:
>
> int count;
> while (crng isn't inited) {
>   msleep(1);
> }
>
> and modify add_timer_randomness() to at least credit a tiny bit to
> crng_init_cnt.

I'd love that, but we don't actually call add_timer_randomness() for timers.

Yeah, the name is misleading.

What the "timer" in add_timer_randomness() means is that we look at
the timing between calls. And we may actually have (long ago) called
it for timer interrupts. But we don't any more.

The only actual users of add_timer_randomness() is
add_input_randomness() and add_disk_randomness(). And it turns out
that even disk IO doesn't really call add_disk_randomness(), so the
only _real_ user is that keyboard input thing.

Which means that unless you sit at the machine and type things in,
add_timer_randomness() _never_ gets called.

No, the real source of entropy right now is
add_interrupt_randomness(), which is called for all device interrupts.

But note the "device interrupts" part. Not the timer interrupt. That's
special, and has its own low-level architecture rules. So only the
normal IO interrupts (like disk/network/etc).

So timers right now do not add _anything_ to the randomness pool. Not
noise, not entropy.

But yes, what you can do is a jitter entropy thing, which basically
does what you suggest, except instead of "msleep(1)" it does something
like

   while (crng isn't inited) {
       sched_yield();
       do_a_round_of_memory_accesses_etc();
       add_cycle_counter_entropy();
   }

and with a lot of handwaving you'll convince a certain amount of
people that yes, the timing of the above is unpredictable enough that
the entropy you add is real.

             Linus
