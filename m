From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v7 09/11] KVM: arm64: guest debug, HW assisted debug
 support
Date: Mon, 6 Jul 2015 11:31:14 +0200
Message-ID: <20150706093114.GB11590@cbox>
References: <1435775343-20034-1-git-send-email-alex.bennee@linaro.org>
 <1435775343-20034-10-git-send-email-alex.bennee@linaro.org>
 <20150702084847.GB3418@arm.com>
 <87pp4asm6u.fsf@linaro.org>
 <20150703092323.GA1588@arm.com>
 <87h9plrzqq.fsf@linaro.org>
 <20150706085140.GA30342@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150706085140.GA30342@arm.com>
Sender: linux-doc-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <Marc.Zyngier@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>, "agraf@suse.de" <agraf@suse.de>, "drjones@redhat.com" <drjones@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "zhichao.huang@linaro.org" <zhichao.huang@linaro.org>, "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>, "dahi@linux.vnet.ibm.com" <dahi@linux.vnet.ibm.com>, "r65777@freescale.com" <r65777@freescale.com>, "bp@suse.de" <bp@suse.de>, Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <Catalin.Marinas@arm.com>, Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>, Ingo Molnar <mingo@kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 06, 2015 at 09:51:40AM +0100, Will Deacon wrote:
> On Fri, Jul 03, 2015 at 05:07:41PM +0100, Alex Benn=E9e wrote:
> > Will Deacon <will.deacon@arm.com> writes:
> > > On Thu, Jul 02, 2015 at 02:50:33PM +0100, Alex Benn=E9e wrote:
> > >> Are you happy with this?:
> > >
> > > [...]
> > >
> > >> +/**
> > >> + * kvm_arch_dev_ioctl_check_extension
> > >> + *
> > >> + * We currently assume that the number of HW registers is unifo=
rm
> > >> + * across all CPUs (see cpuinfo_sanity_check).
> > >> + */
> > >>  int kvm_arch_dev_ioctl_check_extension(long ext)
> > >>  {
> > >>         int r;
> > >> @@ -64,6 +71,12 @@ int kvm_arch_dev_ioctl_check_extension(long e=
xt)
> > >>         case KVM_CAP_ARM_EL1_32BIT:
> > >>                 r =3D cpu_has_32bit_el1();
> > >>                 break;
> > >> +       case KVM_CAP_GUEST_DEBUG_HW_BPS:
> > >> +               r =3D hw_breakpoint_slots(TYPE_INST);
> > >> +               break;
> > >> +       case KVM_CAP_GUEST_DEBUG_HW_WPS:
> > >> +               r  =3D hw_breakpoint_slots(TYPE_DATA);
> > >> +               break;
> > >
> > > Whilst I much prefer this code, it actually adds an unwanted depe=
ndency
> > > on PERF_EVENTS that I didn't think about to start with. Sorry to =
keep
> > > messing you about -- I guess your original patch is the best thin=
g after
> > > all.
> >=20
> > Everything looks to be in hw_breakpoint.[ch] which does depend on
> > CONFIG_HAVE_HW_BREAKPOINT which depends on PERF_EVENTS to be built.
> > However the previous code depended on this behaviour as well.
>=20
> I think your original approach (of sticking stuff in the header file)=
 works
> regardless of the CONFIG option, no?
>=20
> > It would seem weird to enable guest debug using HW debug registers =
to
> > debug the guest yet not allowing the host kernel to use them? Of co=
urse
> > this is the only code they would share as all the magic of guest
> > debugging is already mostly there for dirty guest handling.
> >=20
> > I'm not familiar with Kconfig but it looks like this is all part of
> > arm64 defconfig. Are people really going to want to disable PERF_EV=
ENTS
> > but still debug their guests with HW support?
>=20
> Then it's your call. I just find the host dependency on perf a bit we=
ird
> to get guest debug working (especially as the dependency is completel=
y
> "fake" because we don't use any perf infrastructure at all).
>=20
Agreed, let's see if we can avoid this.

Thanks,
-Christoffer
