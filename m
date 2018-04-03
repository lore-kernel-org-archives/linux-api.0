From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Tue, 3 Apr 2018 16:08:43 -0700
Message-ID: <CA+55aFzG==xr2OLK8F03RH0nkUDeP6btWqepFTuHZqkPTAOWjQ@mail.gmail.com>
References: <4136.1522452584@warthog.procyon.org.uk> <alpine.LRH.2.21.1803311145180.7769@namei.org>
 <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org> <30459.1522739219@warthog.procyon.org.uk>
 <CALCETrUFOdrH5ShCCd8yguGjC2NtG8fJY7AW26HH467-02UVGA@mail.gmail.com>
 <CACdnJut31+ZtiR40nkOjm89cfUxS0EM=w-oG69PtWHbXYJQxPg@mail.gmail.com>
 <CALCETrXeVod=kNpG-M7yKAMM0-n+PMg_OakN6ecWrTPmKXgMLg@mail.gmail.com>
 <9758.1522775763@warthog.procyon.org.uk> <CALCETrWHS9p1My=j07=V=OP7v4SwQkW-kJ3JOx6EbPU8fb_XEQ@mail.gmail.com>
 <13189.1522784944@warthog.procyon.org.uk> <CALCETrX4CuHVpn38R24TCcJgCBLSbh-sOD-qcD5kYF8Zo53ZJw@mail.gmail.com>
 <9349.1522794769@warthog.procyon.org.uk> <CALCETrV6E+r942K+fu-ALNf-x6qOZ3o1hNKGeu7qEMvr8sMP9A@mail.gmail.com>
 <CA+55aFxKzxdRZthzaokaGPAsWCp3a-p3aVfJSutF+9Fp9sbaVA@mail.gmail.com> <CACdnJusSfwULV-ubvgtYd8G_cTF4LnJ4DAeTCux4XRhHKVpBUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJusSfwULV-ubvgtYd8G_cTF4LnJ4DAeTCux4XRhHKVpBUw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 3, 2018 at 3:51 PM, Matthew Garrett <mjg59@google.com> wrote:
>
> Lockdown is clearly useful without Secure Boot (and I intend to deploy it
> that way for various things), but I still don't understand why you feel
> that the common case of booting a kernel from a boot chain that's widely
> trusted derives no benefit from it being harder to subvert that kernel into
> subverting that boot chain.

It has NOTHING TO DO WITH "HARDER TO SUBVERT".

THE TWO FEATURES HAVE NOTHING TO DO WITH EACH OTHER WHAT-SO-EVER.

I do not want my kernel to act differently depending on some really
esoteric detail in how it was booted. That is fundamentally wrong.

Is that really so hard to understand?

Look at it this way: maybe lockdown breaks some application because
that app does something odd. I get a report of that happening, and it
so happens that the reporter is running the same distro I am, so I try
it with his exact kernel configuration, and it works for me.

It is *entirely* non-obvious that the reporter happened to run a
distro kernel that had secure boot enabled, and I obviously do not.

See what the problem is? Tying these things magically together IS A BAD IDEA.

And when people ask you why you did it, YOU HAVE YET TO COME UP WITH A
SINGLE ACTUAL RESPONSE.

Instead, you just ask people why they care, or tell people to not enable it.

Seriously, Matthew, it's WRONG to tie things together in magic ways
when they have nothing what-so-ever to do with each other.

So no. The answer is simply "don't tie the two things together".

And dammit, if you tie them together, you had damn well have a good
reason. So far, your reasons have _literally_ been "Why not?" and
tried to make the onus be on others to explain to you why not.

That's not the right approach to begin with, Matthew.  The onus is on
*you* to explain why you tied them together, not on others to explain
to you - over and over - that they have nothing to do with each other.

This discussion is over until you give an actual honest-to-goodness
reason for why you tied the two features together. No more "Why not?"
crap.

                 Linus
