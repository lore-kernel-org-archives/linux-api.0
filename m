From: Peter Maydell <peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/7] KVM: arm64: guest debug, add support for single-step
Date: Sun, 30 Nov 2014 10:20:19 +0000
Message-ID: <CAFEAcA882aVrnkKFVMaLA0NzkN9OGHJTQseo_w5UFkmBfTDnTQ@mail.gmail.com>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
 <1416931805-23223-6-git-send-email-alex.bennee@linaro.org>
 <CAFEAcA-cjM9yUXi6tc79UP0fBKAagtFKQgV3iAjz5DWr9yxZUQ@mail.gmail.com> <20141130101056.GB484@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141130101056.GB484@cbox>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, kvm-devel <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, arm-mail-list <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Alexander Graf <agraf-l3A5Bk7waGM@public.gmane.org>, "J. Kiszka" <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, David Hildenbrand <dahi-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Bharat Bhushan <r65777-KZfg59tc24xl57MIdRCFDg@public.gmane.org>, bp-l3A5Bk7waGM@public.gmane.org, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gleb Natapov <gleb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 30 November 2014 at 10:10, Christoffer Dall
<christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> In any case, I think it was related to how userspace observes the state
> of the CPU, because when you do the MMIO operation emulation in
> userspace, currently if you observe the PC though GET_ONE_REG, you'll
> see a PC pointing to the next instruction, not the one you're emulating
> which is strange.

Also if we ever add support for userspace to say "this MMIO should
fault" then we definitely need the PC-advance to happen afterwards,
not before.

> Not sure what the relation to a guest single-stepping itself was.

I think it just came up in the course of that discussion, because
single-step handling also needs to perform an action (clear PSTATE.SS)
as part of the "advance over this insn" operation. But I think that
you're right that doing the advance before dropping out to userspace
is no worse for singlestep than it is for any other case.

-- PMM
