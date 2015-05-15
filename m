From: David Hildenbrand <dahi-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v4 02/12] KVM: define common KVM_GUESTDBG_USE_SW/HW_BP
 bits
Date: Fri, 15 May 2015 19:33:15 +0200
Message-ID: <20150515193315.6d3e82d2@thinkpad-w530>
References: <1431700035-23479-1-git-send-email-alex.bennee@linaro.org>
	<1431700035-23479-3-git-send-email-alex.bennee@linaro.org>
	<555613F2.9060204@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <555613F2.9060204-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: Alex =?UTF-8?B?QmVubsOpZQ==?= <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, agraf-l3A5Bk7waGM@public.gmane.org, drjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, zhichao.huang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, r65777-KZfg59tc24xl57MIdRCFDg@public.gmane.org, bp-l3A5Bk7waGM@public.gmane.org, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "supporter:S390" <linux390-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "maintainer:X86 ARCHITECTURE..." <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Gleb Natapov <gleb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bharat Bhushan <Bharat.Bhushan-KZfg59tc24xl57MIdRCFDg@public.gmane.org>, Alexey Kardashevskiy <aik@oz>
List-Id: linux-api@vger.kernel.org

> Am 15.05.2015 um 16:27 schrieb Alex Benn=C3=A9e:
> > +++ b/arch/s390/include/uapi/asm/kvm.h
> > @@ -114,8 +114,6 @@ struct kvm_fpu {
> >  	__u64 fprs[16];
> >  };
> >=20
> > -#define KVM_GUESTDBG_USE_HW_BP		0x00010000
> [...]
> > +++ b/include/uapi/linux/kvm.h
> [...]
> > +#define KVM_GUESTDBG_USE_SW_BP		(1 << 16)
> > +#define KVM_GUESTDBG_USE_HW_BP		(1 << 17)
>=20
> This is an ABI break for s390, no?
>=20
> David, do you remember why we do not use KVM_GUESTDBG_USE_SW_BP?
>=20

We never had to tell the kernel about software breakpoints as this is a=
ll
handled via 4 byte DIAG instructions until now. We don't have to turn t=
his
mechanism on. QEMU can directly insert the desired DIAG instructions an=
d gets
notified when they are about to get executed.

(But we still have 2 byte breakpoint support todo - still tbd how exact=
ly this
will be realized - could be turned on via such a mechanism)

The problem is, that these bits are arch specific, now Alex wants to un=
ify
them for all archs.

So yes, this is an ABI break for us and breaks hardware breakpoints.(I =
think
the first version of this patch didn't contain this ABI break when I ha=
d a look)

I wonder if it wouldn't make more sense to

- introduce new bits in the arch-unspecific section
- rework the existing implementers to accept both bits

Or to simply leave stuff as it is and handle it via arch specific bits.

David
