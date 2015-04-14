From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 02/10] KVM: define common __KVM_GUESTDBG_USE_SW/HW_BP
 values
Date: Tue, 14 Apr 2015 10:24:48 +0200
Message-ID: <20150414082448.GR6186@cbox>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-3-git-send-email-alex.bennee@linaro.org>
 <20150413115535.GM6186@cbox>
 <871tjokrnu.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <871tjokrnu.fsf@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org, jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>, Gleb Natapov <gleb@kernel.org>, Bharat Bhushan <Bharat.Bhushan@freescale.com>, Alexey Kardashevskiy <aik@ozlabs.ru>, Mihai Caraman <mihai.caraman@freescale.com>, Nadav Amit <namit@cs.technion.ac.il>, "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>, open list <linux-kernel@vger.>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 13, 2015 at 03:51:33PM +0100, Alex Benn=E9e wrote:
>=20
> Christoffer Dall <christoffer.dall@linaro.org> writes:
>=20
> > On Tue, Mar 31, 2015 at 04:08:00PM +0100, Alex Benn=E9e wrote:
> >> Currently x86, powerpc and soon arm64 use the same two architectur=
e
> >> specific bits for guest debug support for software and hardware
> >> breakpoints. This makes the shared values explicit while leaving t=
he
> >> gate open for another architecture to use some other value if they
> >> really really want to.
> >>=20
> >> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> >>=20
> >> diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/in=
clude/uapi/asm/kvm.h
> >> index ab4d473..1731569 100644
> >> --- a/arch/powerpc/include/uapi/asm/kvm.h
> >> +++ b/arch/powerpc/include/uapi/asm/kvm.h
> >> @@ -310,8 +310,8 @@ struct kvm_guest_debug_arch {
> >>   * and upper 16 bits are architecture specific. Architecture spec=
ific defines
> >>   * that ioctl is for setting hardware breakpoint or software brea=
kpoint.
> >>   */
> >> -#define KVM_GUESTDBG_USE_SW_BP		0x00010000
> >> -#define KVM_GUESTDBG_USE_HW_BP		0x00020000
> >> +#define KVM_GUESTDBG_USE_SW_BP		__KVM_GUESTDBG_USE_SW_BP
> >> +#define KVM_GUESTDBG_USE_HW_BP		__KVM_GUESTDBG_USE_HW_BP
> >> =20
> >>  /* definition of registers in kvm_run */
> >>  struct kvm_sync_regs {
> >> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/ua=
pi/asm/kvm.h
> >> index d7dcef5..1438202 100644
> >> --- a/arch/x86/include/uapi/asm/kvm.h
> >> +++ b/arch/x86/include/uapi/asm/kvm.h
> >> @@ -250,8 +250,8 @@ struct kvm_debug_exit_arch {
> >>  	__u64 dr7;
> >>  };
> >> =20
> >> -#define KVM_GUESTDBG_USE_SW_BP		0x00010000
> >> -#define KVM_GUESTDBG_USE_HW_BP		0x00020000
> >> +#define KVM_GUESTDBG_USE_SW_BP		__KVM_GUESTDBG_USE_SW_BP
> >> +#define KVM_GUESTDBG_USE_HW_BP		__KVM_GUESTDBG_USE_HW_BP
> >>  #define KVM_GUESTDBG_INJECT_DB		0x00040000
> >>  #define KVM_GUESTDBG_INJECT_BP		0x00080000
> >> =20
> >> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> >> index 5eedf84..ce2db14 100644
> >> --- a/include/uapi/linux/kvm.h
> >> +++ b/include/uapi/linux/kvm.h
> >> @@ -525,8 +525,16 @@ struct kvm_s390_irq {
> >> =20
> >>  /* for KVM_SET_GUEST_DEBUG */
> >> =20
> >> -#define KVM_GUESTDBG_ENABLE		0x00000001
> >> -#define KVM_GUESTDBG_SINGLESTEP		0x00000002
> >> +#define KVM_GUESTDBG_ENABLE		(1 << 0)
> >> +#define KVM_GUESTDBG_SINGLESTEP	(1 << 1)
> >> +
> >> +/*
> >> + * Architecture specific stuff uses the top 16 bits of the field,
> >
> > can you be more specific than 'stuff' here?  features?
> >
> >> + * however there is some shared commonality for the common cases
> >
> > I don't like this sentence; shared commonality is a pleonasm and th=
e use
> > of however makes it sounds like there's some caveat here.
>=20
> OK I can see that - after I looked it up ;-)
>=20
> > If the top 16 bits are indeed arhictecture specific, then I think t=
hey
> > should just be defined in their architecture specific headers.  Unl=
ess
> > the idea here is that there's a fixed set of of flags that architec=
tures
> > can choose to support, in which case it should simply be defined in=
 the
> > common header.
>=20
> Well an architecture might not support some features and want to use
> those bits for something else? I didn't want to force the bottom two
> of the architecture specific bits to wasted if the features don't exi=
st.
>=20
In that case I think the definition is local to each architecture and
should indeed just be duplicated.  The __ definitions complicate more
than they help as they are exported to userspace etc.  The KVM
maintainers may have a different view on this though.

-Christoffer
