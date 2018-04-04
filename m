From: Matthew Garrett <mjg59@google.com>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Wed, 04 Apr 2018 16:26:43 +0000
Message-ID: <CACdnJuuXgpnkMw8oacgadJQL5nE897cw3-RZBqV7df+19NuiMQ@mail.gmail.com>
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
 <CACdnJuuek-sS3esmomNOkjBMV_6VPL2NFCzRd+UGxbZrMe=4nw@mail.gmail.com> <CANA3KFXyUH4cEJVTH-yoTwqAnZ+-9h-uboYTzO642Uo78H_wqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CANA3KFXyUH4cEJVTH-yoTwqAnZ+-9h-uboYTzO642Uo78H_wqg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: oiaohm@gmail.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>, luto@kernel.org, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, jmorris@namei.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jforbes@redhat.com, linux-man@vger.kernel.org, jlee@suse.com, LSM List <linux-security-module@vger.kernel.org>, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 3, 2018 at 11:56 PM Peter Dolding <oiaohm@gmail.com> wrote:
> On Wed, Apr 4, 2018 at 11:13 AM, Matthew Garrett <mjg59@google.com> wrote:

> > There are four cases:
> >
> > Verified Boot off, lockdown off: Status quo in distro and mainline
kernels
> > Verified Boot off, lockdown on: Perception of security improvement
that's
> > trivially circumvented (and so bad)
> > Verified Boot on, lockdown off: Perception of security improvement
that's
> > trivially circumvented (and so bad), status quo in mainline kernels
> > Verified Boot on, lockdown on: Security improvement, status quo in
distro
> > kernels
> >
> > Of these four options, only two make sense. The most common
implementation
> > of Verified Boot on x86 platforms is UEFI Secure Boot,

> Stop right there.   Verified boot does not have to be UEFI secureboot.
>    You could be using a uboot verified boot or
> https://www.coreboot.org/git-docs/Intel/vboot.html  google vboot.
> Neither of these provide flags to kernel to say they have been
> performed.

They can be modified to set the appropriate bit in the bootparams - the
reason we can't do that in the UEFI case is that Linux can be built as a
UEFI binary that the firmware execute directly, and so the firmware has no
way to set that flag.

> Now Verified Boot on, lockdown off.   Insanely this can be required in
> diagnostic on some embedded platform because EFI secureboot does not
> have a off switch.    These are platforms where they don't boot if
> they don't have a PK and KEK set installed.  Yes some of these is jtag
> the PK and KEK set in.

> The fact that this Verified Boot on, lockdown off causes trouble
> points to a clear problem.   User owns the hardware they should have
> the right to defeat secureboot if they wish to.

Which is why Shim allows you to disable validation if you prove physical
user presence.
