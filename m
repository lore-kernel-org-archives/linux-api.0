From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Wed, 4 Apr 2018 07:35:20 -0700
Message-ID: <CALCETrUaKOG1q43W=UBPue5TAL61zzwzgr8QeH3Yh6KsMUA2aQ@mail.gmail.com>
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
 <CACdnJuv_=ihPut=5OvCYEphdBOn7+JrKacBbNa0n3wv_JvFMzg@mail.gmail.com>
 <CA+55aFyWNok1K-Jo3TQAXGXHvFOTvuOb-Hw977B9RGjBa7prrg@mail.gmail.com>
 <CACdnJutZFKX+izBxRYbyxefT5KrKhVV0XsymU=vBhywd+TOE3A@mail.gmail.com>
 <CA+55aFwVUmjZ+Swe9xUdDOEE+EOoaU3dh7BcrH74BOLCi8y_Kw@mail.gmail.com>
 <CACdnJuvqQQ+hidokY5GA7g-yrAs5-358it0cs+m_d4RFDMuB_w@mail.gmail.com>
 <CA+55aFwJBGCr-anrdV9N63fUH4V_QJqgr0_fJyHhH=fuqGAoog@mail.gmail.com>
 <CAG48ez1MRsDGoea5MwGTXK6R0LJy9u0mX-1VrSSskwnV98kEjQ@mail.gmail.com>
 <CALCETrXZWU1MC8LbLCg7VTVHMqKpXh51amnTjKePRCJ31jRiwg@mail.gmail.com> <20736.1522829117@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20736.1522829117@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Matthew Garrett <mjg59@google.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

I've reordered your email to make my email more coherent.

> On Apr 4, 2018, at 1:05 AM, David Howells <dhowells@redhat.com> wrote:
>

>
> What we *have* said is that *if* we want to pass the secure boot state across
> kexec, then we have to make sure that:
>

What do you even mean "pass the secure boot state across kexec"?  All
I can come up with is that you want a kexeced Linux kernel to also be
passed a flag saying "I was secure booted" and to enable or disable
lockdown accordingly.  Let's consider the cases:

1. First kernel is verified (secure boot or otherwise) and locked
down.  Certainly that lock down needs to enforce that the next kernel
in the chain is locked down, otherwise lockdown gets defeated.

2. First kernel is not verified but is locked down.  It still needs to
enforce that the next kernel is verified and locked down, otherwise
lockdown gets defeated.

3. First kernel is verified but not locked down.  There's very little
point in trying to force the next kernel to be locked down.

4. First kernel is neither verified nor locked down.  There's still no
point in trying to force the next kernel to be locked down.

Isn't the right solution to have a flag saying "force lockdown" that
kexec can pass to the child kernel?  A locked down parent kernel would
refuse to load an unsigned child kernel and would always set that
flag.

> Andy Lutomirski <luto@kernel.org> wrote:
>
>> As far as I can tell, what's really going on here is that there's a
>> significant contingent here that wants to prevent Linux from
>> chainloading something that isn't Linux.
>
> You have completely the wrong end of the stick.  No one has said that or even
> implied that.  You are alleging dishonesty on our part.

I'm alleging that the idea that Linux seems some particular policy to
avoid being blacklisted keeps being brought up as a justification for
these patches.  And, in fact, you bring it up again right here:

>
> And if someone tampers with the aim of breaking, say, Windows, then someone,
> e.g.  Microsoft, might blacklist the shim.

In other words, if you chainload an intentionally corrupted copy of
Windows, you get blacklisted?  This sounds awfully like what I said
upthread.  Is this actually a real concern?  Greg seems quite
convinced that it isn't.
