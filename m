From: Matthew Garrett <mjg59@google.com>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Wed, 04 Apr 2018 04:30:18 +0000
Message-ID: <CACdnJutuBaE3RaDx0KM5vDF9Sinrp=3tG9csrS-H3eU-J7-Utw@mail.gmail.com>
References: <4136.1522452584@warthog.procyon.org.uk> <alpine.LRH.2.21.1803311145180.7769@namei.org>
 <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org> <30459.1522739219@warthog.procyon.org.uk>
 <CALCETrUFOdrH5ShCCd8yguGjC2NtG8fJY7AW26HH467-02UVGA@mail.gmail.com>
 <CACdnJut31+ZtiR40nkOjm89cfUxS0EM=w-oG69PtWHbXYJQxPg@mail.gmail.com>
 <CALCETrXeVod=kNpG-M7yKAMM0-n+PMg_OakN6ecWrTPmKXgMLg@mail.gmail.com>
 <9758.1522775763@warthog.procyon.org.uk> <CALCETrWHS9p1My=j07=V=OP7v4SwQkW-kJ3JOx6EbPU8fb_XEQ@mail.gmail.com>
 <13189.1522784944@warthog.procyon.org.uk> <CALCETrX4CuHVpn38R24TCcJgCBLSbh-sOD-qcD5kYF8Zo53ZJw@mail.gmail.com>
 <9349.1522794769@warthog.procyon.org.uk> <CALCETrV6E+r942K+fu-ALNf-x6qOZ3o1hNKGeu7qEMvr8sMP9A@mail.gmail.com>
 <CA+55aFxKzxdRZthzaokaGPAsWCp3a-p3aVfJSutF+9Fp9sbaVA@mail.gmail.com>
 <CACdnJusSfwULV-ubvgtYd8G_cTF4LnJ4DAeTCux4XRhHKVpBUw@mail.gmail.com>
 <CA+55aFzG==xr2OLK8F03RH0nkUDeP6btWqepFTuHZqkPTAOWjQ@mail.gmail.com>
 <CACdnJuv_=ihPut=5OvCYEphdBOn7+JrKacBbNa0n3wv_JvFMzg@mail.gmail.com>
 <CA+55aFyWNok1K-Jo3TQAXGXHvFOTvuOb-Hw977B9RGjBa7prrg@mail.gmail.com>
 <CACdnJutZFKX+izBxRYbyxefT5KrKhVV0XsymU=vBhywd+TOE3A@mail.gmail.com>
 <CA+55aFwVUmjZ+Swe9xUdDOEE+EOoaU3dh7BcrH74BOLCi8y_Kw@mail.gmail.com>
 <CACdnJuvqQQ+hidokY5GA7g-yrAs5-358it0cs+m_d4RFDMuB_w@mail.gmail.com>
 <CA+55aFwJBGCr-anrdV9N63fUH4V_QJqgr0_fJyHhH=fuqGAoog@mail.gmail.com>
 <CACdnJuvFqXGLsAv1Km3MmdssHBfuH5-C_vG3A4eq4Yuj0HhFBA@mail.gmail.com>
 <CA+55aFzYbpRAdma0PvqE+9ygySuKzNKByqOzzMufBoovXVnfPw@mail.gmail.com>
 <CACdnJuv-VpdhjEe1cMysdHb6Oy67jQqg-_TVHbUrOfH9GmCVvg@mail.gmail.com>
 <CA+55aFwvuoSHhKnn82VnDndZ6oXMJgwHF604gZ=h3ehHyC600A@mail.gmail.com>
 <CA+55aFzJ2sQR13T+20MKEJ5co-f3Ev8rRxQkRCWVaeDSUU3yhQ@mail.gmail.com>
 <CACdnJuti5Riqoi1sesqPALYHq9LT87o4MFj-0Y5BZqqzJ5579g@mail.gmail.com>
 <CA+55aFwhi=gz3HLoGST9--n1_kLJNP6jsf8GSesSFxTDCdPdtQ@mail.gmail.com>
 <CACdnJuuek-sS3esmomNOkjBMV_6VPL2NFCzRd+UGxbZrMe=4nw@mail.gmail.com> <CA+55aFxgrh5eeG9MRSEsJtyL5yTe0TehZ=BS2josGJaLxoMMBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxgrh5eeG9MRSEsJtyL5yTe0TehZ=BS2josGJaLxoMMBQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: luto@kernel.org, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, jmorris@namei.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jforbes@redhat.com, linux-man@vger.kernel.org, jlee@suse.com, LSM List <linux-security-module@vger.kernel.org>, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 3, 2018 at 6:43 PM Linus Torvalds
<torvalds@linux-foundation.org>
wrote:

> On Tue, Apr 3, 2018 at 6:13 PM, Matthew Garrett <mjg59@google.com> wrote:
> >
> > There are four cases:

> No.

> Matthew., stop with the agenda already.

> This shit is what I'm talking about:

> > Verified Boot off, lockdown on: Perception of security improvement
that's
> > trivially circumvented (and so bad)

> You're doing some serious value judgement that is simply bogus.

> If lockdown actually helps avoid CPL0 execution attacks, then it helps
> even if secure more is off.

Bear in mind that I'm talking about defaults here - in more constrained
configurations the answers may change. But the kernel has no way of knowing
whether it's in one of those configurations, and as a result there's an
argument for not overpromising on the security that you're providing users.
If a user has a configuration where you're able to verify that userspace
has some degree of protection (eg, disk encryption keys are in the TPM and
won't unseal if someone's switched out the kernel) then it's reasonable for
userland (or a kernel command line option) to enable the functionality.

What I'm afraid of is this turning into a "security" feature that ends up
being circumvented in most scenarios where it's currently deployed - eg,
module signatures are mostly worthless in the non-lockdown case because you
can just grab the sig_enforce symbol address and then kexec a preamble that
flips it back to N regardless of the kernel config. This is the sort of
thing that's not obvious to most users, and it potentially causes them to
make worse security decisions as a result. The goal for this part of the
patchset isn't to cover every single conceivable case, it's to provide
reasonable defaults in a way that makes life easier for distributions.

> Or think of virtual machines - which people often use on purpose for
> security things. Again, they very much are _not_ going to have secure
> boot, but it's not necessarily even possible to "replace the kernel
> and reboot" at all, because the kernel came from outside the virtual
> machine entirely, and rebooting might just kill the VM rather than
> restart anything.

And where you have a trustworthy external thing providing your kernel,
yeah, that's also an argument - and having a kernel command line argument
that enables it in this case also seems entirely reasonable.

> This is what I mean by having an agenda.  We all know you are a big
> proponent of secure boot. But it seems to cloud your arguments, by
> turning your assumptions and your agenda into an "argument" that is
> simply not even TRUE.

I'm making this argument from the perspective of "What should the kernel do
when it has no additional information". Having the kernel automatically
enable lockdown without the user being aware of which guarantees their
environment is providing risks giving users the impression of security that
they may not have - in that case it makes more sense to have the user make
an explicit decision to enable it.

> See what I'm unhappy about?

> > Verified Boot on, lockdown off: Perception of security improvement
that's
> > trivially circumvented (and so bad), status quo in mainline kernels

> I think this is entirely false too. Again, the "trivial circumvention"
> shows a bias and agenda that isn't really all that true.

> > Of these four options, only two make sense.

> No.

> You say that, because you have that bias and that agenda.

Ok. Only two make sense *in the absence of additional information about
local configuration*. Distributions have to make reasonable choices here,
and where a configuration choice decreases functionality and provides what
may only be a marginal increase in security it's not a good configuration
choice to make by default.

> That said, wouldn't it be equally good to just make the whole thing be
> a protected EFI variable instead? Once you have physical access to the
> EFI shell (to turn off secure boot) you have access to that too.

That's pretty much exactly what mokutil does, without you needing to find a
copy of the UEFI shell to install first. If you think there's a strong
enough need for it, we could definitely add an additional variable that
allowed you to disable lockdown without disabling signature validation.
