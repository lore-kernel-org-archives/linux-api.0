From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 10/12] KVM: arm64: guest debug, HW assisted debug support
Date: Thu, 25 Jun 2015 11:42:25 +0100
Message-ID: <87k2usxe5q.fsf@linaro.org>
References: <1434716630-18260-1-git-send-email-alex.bennee@linaro.org> <1434716630-18260-11-git-send-email-alex.bennee@linaro.org> <20150624202216.GE22785@cbox> <87mvzoxpg6.fsf@linaro.org> <20150625074934.GB28244@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20150625074934.GB28244@cbox>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, agraf-l3A5Bk7waGM@public.gmane.org, drjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, zhichao.huang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, dahi-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, r65777-KZfg59tc24xl57MIdRCFDg@public.gmane.org, bp-l3A5Bk7waGM@public.gmane.org, Gleb Natapov <gleb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:

> On Thu, Jun 25, 2015 at 07:38:33AM +0100, Alex Benn=C3=A9e wrote:
>>=20
>> Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:
>>=20
>> > On Fri, Jun 19, 2015 at 01:23:48PM +0100, Alex Benn=C3=A9e wrote:
>> >> This adds support for userspace to control the HW debug registers=
 for
>> >> guest debug. In the debug ioctl we copy the IMPDEF defined number=
 of
<snip>
>> >>  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
>> >>  {
>> >> -	if (vcpu->guest_debug)
>> >> +	if (vcpu->guest_debug) {
>> >>  		restore_guest_debug_regs(vcpu);
>> >> +
>> >> +		/*
>> >> +		 * If we were using HW debug we need to restore the
>> >> +		 * debug_ptr to the guest debug state.
>> >> +		 */
>> >> +		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW)
>> >> +			vcpu->arch.debug_ptr =3D &vcpu->arch.vcpu_debug_state;
>> >
>> > I still think this would be more cleanly done in the setup_debug
>> > function, but ok:
>>=20
>> I don't follow, setup_debug is called before we enter KVM. It's pret=
ty
>> light when no debugging is being done so this ensure we leave state =
how
>> we would like it when we stop debugging.
>>=20
>> I can move it to an else leg in setup if you really want.
>>=20
> I just feel like whenever you enter the guest you setup the state you
> want for your guest and then when reading the code you never have to
> worry about "did I set the pointer back correctly last time it exited=
",
> but thinking about your response, I guess that's an extra store on ea=
ch
> world-switch, so theoretically that may be a bit more overhead (on to=
p
> of the hundreds other stores and spinlocks we take and stuff).

The setup/clear() calls are tightly paired around the KVM_RUN ioctl cod=
e
without any obvious exit points.

Are there any cases you can escape the ioctl code flow? I notice irq's
are re-enabled so I guess a suitably determined irq function could
change the return address or mess around with guest_debug.

> If you prefer, leave it like this, but consider adding a
> BUG_ON(!guest_debugging && debug_ptr !=3D &vcpu->arch.vcpu_debug_stat=
e) in
> the setup function...

The clear_debug() code would end up being a fairly sparse piece of code
without it ;-)

> I'm probably being paranoid.

A little paranoia goes a long way in kernel mode ;-)

>
> -Christoffer

--=20
Alex Benn=C3=A9e
