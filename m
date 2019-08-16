From: Dmitry Safonov <0x7f454c46@gmail.com>
Subject: Re: [PATCHv6 23/36] x86/vdso: Allocate timens vdso
Date: Fri, 16 Aug 2019 23:47:24 +0100
Message-ID: <483678c7-7687-5445-f09e-e45e9460d559@gmail.com>
References: <20190815163836.2927-1-dima@arista.com>
 <20190815163836.2927-24-dima@arista.com>
 <b719199a-ed91-610b-38bc-015a0749f600@kernel.org>
 <alpine.DEB.2.21.1908162208190.1923@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1908162208190.1923@nanos.tec.linutronix.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>
Cc: Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Hi Andy, Thomas,

thank you very much for your time and the reviews, appreciate that.

On 8/16/19 9:10 PM, Thomas Gleixner wrote:
> On Fri, 16 Aug 2019, Andy Lutomirski wrote:
[..]
>> I'm unconvinced that any of this magic is wise.  I think you should make a
>> special timens vvar page that causes the normal fastpath to fail (using a
>> special vclock mode, a special seq value, or a special "last" value) and then
>> make the failure path detect that timens is in use and use the timens path.

I see. That's so clever, it haven't come on my mind.
Hmm, is that better because of the price of 5-byte NOP?
I'm a bit afraid to complicate that seq/vclock logic more..

So, what I'm driving at is would you change your mind if timens still
had boot-time dynamic patching but without introducing NOP?

We've got the point that you want to have no penalty at all for host
tasks [on RFC reply] by introducing `if` as trashing cache and branch
predictor, but I wasn't sure if NOP is also unacceptable.

At that moment we had a "plan B" with something that was half-wittedly
called "retcalls". The basic idea is that all that the timens brings
into vdso are calls clk_to_ns(), which are all placed in tails of
functions. So, if we could just memcpy() function returns in host vdso
over introduced time-ns tail calls - it would be a very same code that
lied before. There is a draft of those [1], that actually works on x86
on both mine and Andrei's machines.

Consulting with Andrei, I've decided that we better stick to
static_branchs as they are well known and have already backends for
other architectures. We probably mistakenly decided that a price of NOP
on scalar machines is negligible and would be acceptable.

Would those self-invented "retcalls" be something that could be reviewed
and potentially accepted in further iterations?

[1]
https://github.com/0x7f454c46/linux/commit/ab0eeb646f43#diff-c22e1e73e7367f371e1f12e3877ea12f

> My initial suggestion still stands. Do that at compile time. It really does
> not matter whether we have another 2 or 3 variants of vdso binaries.
> 
> Use it and be done with it. No special magic, just straight forward
> decisions to use a timens capable VDSO or not.

I believe that was something we did in version 1 of the patches set.
It doesn't sound like a rocket science to do, but it resulted in a
couple of ugly patches.

The post-attempt notes about downsides of doing it compile-time are:

1. There is additional .so for each vdso: 64-bit, ia32, x32. The same
for every architecture to-be supported. It adds rules in Makefiles. [2]
2. If we still intend to keep setns() working without exec(), function
entries on both host/namespace vdso should be aligned to each other [3].
That results in a patch to vdso2c to generate offsets [4, 5] and in
linker magic to align another vdso [6].
3. As unexpected consequence, we also need to align local functions on
vdso [7].

So, it might be all related to my lack of skills, but it seems to bring
some big amount of complexity into build process. And in my point of
view, major issue is that it would not scale easily when the day will
come and there will be a need to introduce another vdso.so. As I didn't
want to be the guy that happens to be remembered as "he wrote this
unmaintainable pile of garbage", I've taken dynamic patching approach
that is done once a boot time.

Regardless, we both with Andrei want to improve the patches set and make
it acceptable and easy to maintain in future. I hope, that our effort to
do that is visible through evolution of patches. And we're very glad
that we've constructive critics and such patient maintainers.
So, if I'm mistaken in those points about compile-time vdso(s), or you
have in mind a plan how-to avoid those, I'd appreciate and rework it to
that direction.

[2] lkml.kernel.org/r/20190206001107.16488-14-dima@arista.com
[3] lkml.kernel.org/r/20190206001107.16488-15-dima@arista.com
[4] lkml.kernel.org/r/20190206001107.16488-16-dima@arista.com
[5] lkml.kernel.org/r/20190206001107.16488-17-dima@arista.com
[6] lkml.kernel.org/r/20190206001107.16488-19-dima@arista.com
[7] lkml.kernel.org/r/20190206001107.16488-20-dima@arista.com

Thanks,
          Dmitry
