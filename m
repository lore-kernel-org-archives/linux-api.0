From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Tue, 3 Apr 2018 16:55:47 -0700
Message-ID: <CA+55aFwVUmjZ+Swe9xUdDOEE+EOoaU3dh7BcrH74BOLCi8y_Kw@mail.gmail.com>
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
 <CA+55aFyWNok1K-Jo3TQAXGXHvFOTvuOb-Hw977B9RGjBa7prrg@mail.gmail.com> <CACdnJutZFKX+izBxRYbyxefT5KrKhVV0XsymU=vBhywd+TOE3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJutZFKX+izBxRYbyxefT5KrKhVV0XsymU=vBhywd+TOE3A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 3, 2018 at 4:45 PM, Matthew Garrett <mjg59@google.com> wrote:
>> Be honest now. It wasn't generally users who clamored for it.
>
> If you ask a user whether they want a system that lets an attacker replace
> their kernel or one that doesn't, what do you think their answer is likely
> to be?

Goddamnit.

We both know what the answer will be.

And it will have *nothing* to do with secure boot.

So *you* be honest now.

Because you clearly aren't.

Seriously. Go ask that question to a random person:

 "Do you want a system that lets an attacker replace their kernel or
one that doesn't?"

and don't ask anything else.

Do you really think they'll answer "no, I don't want an attacker to
replace my kernel, but only if I booted with secure boot"?

Honestly, now.

> Again, what is your proposed mechanism for ensuring that off the shelf
> systems can be configured in a way that makes this possible?

If you think lockdown is a good idea, and you enabled it, then IT IS ENABLED.

No idiotic "secure boot or not" garbage.

Because secure boot or not isn't *relevant*.

Christ, we already have things like

 - CONFIG_STRICT_KERNEL_RWX

 - CONFIG_STRICT_DEVMEM

 - CONFIG_HARDENED_USERCOPY

 - CONFIG_MODULE_SIG_ALL (and friends)

and absolutely *NONE* of them depend on whether the kernel was booted
with secure boot or not.

And I claim that it would be completely idiotic and broken if they did.

And - not entirely unrelated - I claim that it is COMPLETELY IDIOTIC
AND BROKEN to make some new "lockdown" option depend on it.

Comprende?

Really. Your arguments make no sense. They are all fundamentally
broken for the simple reason that all your "but secure boot implies
XYZ" are pure and utter bullshit, because all your arguments are valid
whether secure boot happened or not.

See? Secure boot has *NOTHING* do to with anything.  It has nothing to
do with loading only signed kernel modules. It has nothing to do with
your lockdown patches.

Either lockdown is good or not. It's that simple. But the goodness has
nothing to do with secure boot.

              Linus
