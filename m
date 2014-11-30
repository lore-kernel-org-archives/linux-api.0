From: Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/7] KVM: arm64: guest debug, add support for single-step
Date: Sun, 30 Nov 2014 11:10:56 +0100
Message-ID: <20141130101056.GB484@cbox>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
 <1416931805-23223-6-git-send-email-alex.bennee@linaro.org>
 <CAFEAcA-cjM9yUXi6tc79UP0fBKAagtFKQgV3iAjz5DWr9yxZUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA-cjM9yUXi6tc79UP0fBKAagtFKQgV3iAjz5DWr9yxZUQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Maydell <peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, kvm-devel <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, arm-mail-list <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Alexander Graf <agraf-l3A5Bk7waGM@public.gmane.org>, "J. Kiszka" <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, David Hildenbrand <dahi-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Bharat Bhushan <r65777-KZfg59tc24xl57MIdRCFDg@public.gmane.org>, bp-l3A5Bk7waGM@public.gmane.org, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gleb Natapov <gleb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 26, 2014 at 07:27:06PM +0000, Peter Maydell wrote:
> On 25 November 2014 at 16:10, Alex Benn=E9e <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> =
wrote:
> > This adds support for single-stepping the guest. As userspace can a=
nd
> > will manipulate guest registers before restarting any tweaking of t=
he
> > registers has to occur just before control is passed back to the gu=
est.
> > Furthermore while guest debugging is in effect we need to squash th=
e
> > ability of the guest to single-step itself as we have no easy way o=
f
> > re-entering the guest after the exception has been delivered to the
> > hypervisor.
>=20
> A corner case I don't think this patch handles: if the debugger
> tries to single step an insn which is emulated by the
> hypervisor (because it's a load/store which is trapped and
> handled as emulated mmio in userspace) then we won't
> correctly update the single-step state machine (and so we'll end
> up incorrectly stopping after the following insn rather than
> before, I think).
>=20
> You should be able to achieve this effect by simply always clearing
> the guest's PSTATE.SS when you advance the PC to skip the emulated
> instruction (cf the comment in the pseudocode SSAdvance() function).
>=20
> I think we should also be doing this PC advance on return from
> userspace's handling of the mmio rather than before we drop back
> to userspace as we do now, but I can't remember why I think that.
> Christoffer, I don't suppose you recall, do you? I think it was
> you I had this conversation with on IRC a month or so back...
>=20
I don't remember clearly, no.  Was it not during lunch at LCU we had
this conversation?

In any case, I think it was related to how userspace observes the state
of the CPU, because when you do the MMIO operation emulation in
userspace, currently if you observe the PC though GET_ONE_REG, you'll
see a PC pointing to the next instruction, not the one you're emulating
which is strange.

Not sure what the relation to a guest single-stepping itself was.

-Christoffer
