From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Tue, 3 Apr 2018 16:26:36 -0700
Message-ID: <CA+55aFyWNok1K-Jo3TQAXGXHvFOTvuOb-Hw977B9RGjBa7prrg@mail.gmail.com>
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
 <CA+55aFzG==xr2OLK8F03RH0nkUDeP6btWqepFTuHZqkPTAOWjQ@mail.gmail.com> <CACdnJuv_=ihPut=5OvCYEphdBOn7+JrKacBbNa0n3wv_JvFMzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJuv_=ihPut=5OvCYEphdBOn7+JrKacBbNa0n3wv_JvFMzg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 3, 2018 at 4:17 PM, Matthew Garrett <mjg59@google.com> wrote:
>
> 1) Secure Boot is intended to permit the construction of a boot chain that
> only runs ring 0 code that the user considers trustworthy

No.

That may be *one* intention, for some people.

It's not an a-priori one for the actual user.

> 2) Allowing arbitrary user code to run in ring 0 without affirmative
> consent on the part of the user is therefore incompatible with the goals of
> Secure Boot

Again, that has absolutely zero relevance.

Those goals are not the *users* goals.

Be honest now. It wasn't generally users who clamored for it.

If the user actually wanted it, and is asking for it, he can enable
it. Independently of secure boot, which the user generally has little
control over.

> 3) This patchset provides a mechanism to alter the behaviour of the kernel
> such that it is significantly more difficult for arbitrary user code to run
> in ring 0 without affirmative user consent

That difficulty already exists, the new thing isn't somehow related to
that at all.

Look at our "uyou can only load modules if you're root" rules. Or the
"you can only load modules if they are signed".

See a pattern there? They don't magically enable themselves (or
disable themselves) depending on whether you booted with secure boot
or not.

Yet they are a HELL OF A LOT MORE IMPORTANT than this new patch series.

> 4) Providing a mechanism for automatically enabling this behaviour when
> running in a context that is intended to restrict access to ring 0 is a
> rational thing to do, because otherwise it is difficult to achieve the
> objective in (1)

No. See why it's *NOT* rational, as explained already several times.

Magically changing kernel behavior depending on some subtle and often
unintentional bootup behavior detail is completely idiotic.

It would be idiotic if it was that "check kernel module signatures"
check. This is no less idiotic.

Seriously, listen to your own arguments. If they don't make sense for
checking kernel module signatures, why the hell would they make sense
for something like lockdown.

THE TWO THINGS ARE ENTIRELY INDEPENDENT.

I'm done with you. You're not listening, and you're repeating bogus
arguments that make no sense.

No way in hell will I merge anything like this.

                Linus
