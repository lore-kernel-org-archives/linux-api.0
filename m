From: David Howells <dhowells@redhat.com>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Wed, 04 Apr 2018 00:39:05 +0100
Message-ID: <10718.1522798745@warthog.procyon.org.uk>
References: <CA+55aFxKzxdRZthzaokaGPAsWCp3a-p3aVfJSutF+9Fp9sbaVA@mail.gmail.com> <4136.1522452584@warthog.procyon.org.uk> <alpine.LRH.2.21.1803311145180.7769@namei.org> <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org> <30459.1522739219@warthog.procyon.org.uk> <CALCETrUFOdrH5ShCCd8yguGjC2NtG8fJY7AW26HH467-02UVGA@mail.gmail.com> <CACdnJut31+ZtiR40nkOjm89cfUxS0EM=w-oG69PtWHbXYJQxPg@mail.gmail.com> <CALCETrXeVod=kNpG-M7yKAMM0-n+PMg_OakN6ecWrTPmKXgMLg@mail.gmail.com> <9758.1522775763@warthog.procyon.org.uk> <CALCETrWHS9p1My=j07=V=OP7v4SwQkW-kJ3JOx6EbPU8fb_XEQ@mail.gmail.com> <13189.1522784944@warthog.procyon.org.uk> <CALCETrX4CuHVpn38R24TCcJgCBLSbh-sOD-qcD5kYF8Zo53ZJw@mail.gmail.com> <9349.1522794769@warthog.procyon.org.uk> <CALCETrV6E+r942K+fu-ALNf-x6qOZ3o1hNKGeu7qEMvr8sMP9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxKzxdRZthzaokaGPAsWCp3a-p3aVfJSutF+9Fp9sbaVA@mail.gmail.com>
Content-ID: <10717.1522798745.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Andy Lutomirski <luto@kernel.org>, Matthew Garrett <mjg59@google.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> The same thing is true of some lockdown patch. Maybe it's a good thing
> in general. But whether it's a good thing is _entirely_ independent of
> any secure boot issue. I can see using secure boot without it, but I
> can very much also see using lockdown without secure boot.
> 
> The two things are simply entirely orthogonal. They have _zero_
> overlap. I'm not seeing why they'd be linked at all in any way.

I'm not sure I agree.  Here's my reasoning:

 (1) Lockdown mode really needs to activated during kernel boot, before
     userspace has a chance to run, otherwise there's a window of opportunity
     in which the kernel *isn't* locked down.

 (2) If the kernel isn't booted in secure boot mode, then there's the
     opportunity to tamper before the kernel even starts booting.

 (3) There doesn't seem any point in booting in secure boot mode if you don't
     protect the running kernel image against tampering.  What does it mean to
     be in "secure boot mode" in that case?  If the kernel can be tampered
     with, it would seem to be, by definition, insecure.

 (4) You can't validly promise the next OS you kexec that *it* is started in
     secure boot mode if you don't stop your image from being tampered with.
     Note that this doesn't prevent a compromised kernel from lying to the
     next OS.

 (5) Tampering with a running kernel can be achieved in a variety of ways:
     loading of arbitrary modules, loading of modified firmware, direct access
     to devices that can effect DMA, writing to /dev/mem, ...

 (6) We need to be able to load modules and firmware, but these can be signed,
     hashed or measured so we have some idea of their provenance - but signing
     can be worked around if, say, /dev/mem is writable.

 (7) If you told the BIOS[*] that you want to be in secure boot mode, then the
     kernel should honour that and try to prevent tampering with the image.

 (8) Turning lockdown mode on if the kernel is booted in secure boot seems to
     be the way to achieve this.

 (9) BIOS vendors can blacklist any of the components - say the SHIM - to
     prevent an insecure kernel from being used to compromise and kexec
     another OS.

Note that I've provided a kernel command line parameter that will turn
lockdown mode on arbitrarily - but that can be turned off by editing the
parameters in grub.cfg, say.

David

[*] Yeah, I know, this is an x86-centric view.
