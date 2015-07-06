From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v7 09/11] KVM: arm64: guest debug, HW assisted debug support
Date: Mon, 06 Jul 2015 10:02:46 +0100
Message-ID: <87vbdxacax.fsf@linaro.org>
References: <1435775343-20034-1-git-send-email-alex.bennee@linaro.org> <1435775343-20034-10-git-send-email-alex.bennee@linaro.org> <20150702084847.GB3418@arm.com> <87pp4asm6u.fsf@linaro.org> <20150703092323.GA1588@arm.com> <87h9plrzqq.fsf@linaro.org> <20150706085140.GA30342@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20150706085140.GA30342@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>, "agraf@suse.de" <agraf@suse.de>, "drjones@redhat.com" <drjones@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "zhichao.huang@linaro.org" <zhichao.huang@linaro.org>, "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>, "dahi@linux.vnet.ibm.com" <dahi@linux.vnet.ibm.com>, "r65777@freescale.com" <r65777@freescale.com>, "bp@suse.de" <bp@suse.de>, Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <Catalin.Marinas@arm.com>, Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>, Ingo Molnar <mingo@kernel.o>
List-Id: linux-api@vger.kernel.org


Will Deacon <will.deacon@arm.com> writes:

> On Fri, Jul 03, 2015 at 05:07:41PM +0100, Alex Benn=C3=A9e wrote:
>> Will Deacon <will.deacon@arm.com> writes:
>> > On Thu, Jul 02, 2015 at 02:50:33PM +0100, Alex Benn=C3=A9e wrote:
>> >> Are you happy with this?:
>> >
>> > [...]
>> >
>> >> +/**
>> >> + * kvm_arch_dev_ioctl_check_extension
>> >> + *
>> >> + * We currently assume that the number of HW registers is unifor=
m
>> >> + * across all CPUs (see cpuinfo_sanity_check).
>> >> + */
>> >>  int kvm_arch_dev_ioctl_check_extension(long ext)
>> >>  {
>> >>         int r;
>> >> @@ -64,6 +71,12 @@ int kvm_arch_dev_ioctl_check_extension(long ex=
t)
>> >>         case KVM_CAP_ARM_EL1_32BIT:
>> >>                 r =3D cpu_has_32bit_el1();
>> >>                 break;
>> >> +       case KVM_CAP_GUEST_DEBUG_HW_BPS:
>> >> +               r =3D hw_breakpoint_slots(TYPE_INST);
>> >> +               break;
>> >> +       case KVM_CAP_GUEST_DEBUG_HW_WPS:
>> >> +               r  =3D hw_breakpoint_slots(TYPE_DATA);
>> >> +               break;
>> >
>> > Whilst I much prefer this code, it actually adds an unwanted depen=
dency
>> > on PERF_EVENTS that I didn't think about to start with. Sorry to k=
eep
>> > messing you about -- I guess your original patch is the best thing=
 after
>> > all.
>>=20
>> Everything looks to be in hw_breakpoint.[ch] which does depend on
>> CONFIG_HAVE_HW_BREAKPOINT which depends on PERF_EVENTS to be built.
>> However the previous code depended on this behaviour as well.
>
> I think your original approach (of sticking stuff in the header file)=
 works
> regardless of the CONFIG option, no?

Ahh yeah I reverted that to an extern due to random compile breakage:

http://storage.kernelci.org/alex/v4.1-12-gd38574dba3ec/arm64-allmodconf=
ig/build.log

I'll see if I can fix that up.

>> It would seem weird to enable guest debug using HW debug registers t=
o
>> debug the guest yet not allowing the host kernel to use them? Of cou=
rse
>> this is the only code they would share as all the magic of guest
>> debugging is already mostly there for dirty guest handling.
>>=20
>> I'm not familiar with Kconfig but it looks like this is all part of
>> arm64 defconfig. Are people really going to want to disable PERF_EVE=
NTS
>> but still debug their guests with HW support?
>
> Then it's your call. I just find the host dependency on perf a bit we=
ird
> to get guest debug working (especially as the dependency is completel=
y
> "fake" because we don't use any perf infrastructure at all).
>
> Will

--=20
Alex Benn=C3=A9e
