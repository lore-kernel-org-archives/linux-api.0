From: David Howells <dhowells@redhat.com>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Wed, 04 Apr 2018 00:12:59 +0100
Message-ID: <10232.1522797179@warthog.procyon.org.uk>
References: <CALCETrV6E+r942K+fu-ALNf-x6qOZ3o1hNKGeu7qEMvr8sMP9A@mail.gmail.com> <4136.1522452584@warthog.procyon.org.uk> <alpine.LRH.2.21.1803311145180.7769@namei.org> <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org> <30459.1522739219@warthog.procyon.org.uk> <CALCETrUFOdrH5ShCCd8yguGjC2NtG8fJY7AW26HH467-02UVGA@mail.gmail.com> <CACdnJut31+ZtiR40nkOjm89cfUxS0EM=w-oG69PtWHbXYJQxPg@mail.gmail.com> <CALCETrXeVod=kNpG-M7yKAMM0-n+PMg_OakN6ecWrTPmKXgMLg@mail.gmail.com> <9758.1522775763@warthog.procyon.org.uk> <CALCETrWHS9p1My=j07=V=OP7v4SwQkW-kJ3JOx6EbPU8fb_XEQ@mail.gmail.com> <13189.1522784944@warthog.procyon.org.uk> <CALCETrX4CuHVpn38R24TCcJgCBLSbh-sOD-qcD5kYF8Zo53ZJw@mail.gmail.com> <9349.1522794769@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrV6E+r942K+fu-ALNf-x6qOZ3o1hNKGeu7qEMvr8sMP9A@mail.gmail.com>
Content-ID: <10231.1522797179.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: dhowells@redhat.com, Matthew Garrett <mjg59@google.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@kernel.org> wrote:

> I'm having a very, very hard time coming up with a scenario where I
> can "trust" something if an attacker can get root but can't modify the
> running kernel image but I can't "trust" something if the attacker
> can [modify the running kernel image].

(I think the above is what you meant)

Let's go at this a different way.  How do you decide you can trust something
in this context?  You compare it to something.  Signing it, keeping a hash
whitelist, IMA - these are all ways of comparing something.  Do you agree with
that?

However, the comparison can be subverted if the running kernel image (I might
be better saying running kernel state here since I'm not talking about the
source bzImage file) can be modified arbitrarily by userspace, either by
modifying the data against which the comparison is made - e.g. the public key
set or the hash list - or by modifying the code that makes the comparison.

/dev/mem, direct access to DMA, bpf, etc. all provide ways of modifying the
kernel image arbitrarily, which leads me to this:

> I *don't* buy into the party line about why signed modules should be needed
> for Secure Boot.

Modules are just another way of modifying the kernel image.  If I can just
create an arbitrary module and load it, then I can modify the kernel image
from within the module.

Locking down modules by signing, hashing or IMA practically prevents the
loading of arbitrarily constructed modules and only permits modules from a set
that the provider of the modules somewhat trusts.

What use is secure boot if processes run as root can subvert your kernel?

> > There's no point bothering with UID/GID checking either.
> 
> Give me a break.  There's a *huge* difference between a system where
> only root can load unsigned modules and a system where anyone can load
> unsigned modules.

I don't think we've ever advocated letting just anyone load a module.

But my point is that if you can modify the running kernel, you can nullify all
security checks, including UID/GID checks.

> > However, if /dev/mem can be read, any root process can extract the session
> > key for your disk.
> 
> Any root process can read /dev/mapper/plaintext_disk, lockdown or otherwise.

True - for now - and they can also access the mounted filesystem.  But if they
get their hands on your powered-off computer, no, they can't.

> But I don't think the upstream kernel should apply a patch that ties any of
> this to Secure Boot without a genuine technical reason why it makes sense.

Because unless you turn lockdown on during kernel boot, there exists a window
of opportunity where the kernel isn't locked down and can be accessed, thereby
obviating the fact that you started in Secure Boot mode.

David
