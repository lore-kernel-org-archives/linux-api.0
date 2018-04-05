From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Thu, 5 Apr 2018 15:58:25 +0100
Message-ID: <20180405155825.588b2775@alans-desktop>
References: <4136.1522452584@warthog.procyon.org.uk>
        <9349.1522794769@warthog.procyon.org.uk>
        <CALCETrV6E+r942K+fu-ALNf-x6qOZ3o1hNKGeu7qEMvr8sMP9A@mail.gmail.com>
        <CA+55aFxKzxdRZthzaokaGPAsWCp3a-p3aVfJSutF+9Fp9sbaVA@mail.gmail.com>
        <CACdnJusSfwULV-ubvgtYd8G_cTF4LnJ4DAeTCux4XRhHKVpBUw@mail.gmail.com>
        <CA+55aFzG==xr2OLK8F03RH0nkUDeP6btWqepFTuHZqkPTAOWjQ@mail.gmail.com>
        <CACdnJuv_=ihPut=5OvCYEphdBOn7+JrKacBbNa0n3wv_JvFMzg@mail.gmail.com>
        <CA+55aFyWNok1K-Jo3TQAXGXHvFOTvuOb-Hw977B9RGjBa7prrg@mail.gmail.com>
        <CA+55aFx9u-O81MwSq8zpb+MKaWYjYvtEcFu1NLP1_s63ED6_3Q@mail.gmail.com>
        <CACdnJutkO9dgz=HZpPRR9PZC=+cHh97dRUiGB+D3gruZr6U9Kg@mail.gmail.com>
        <CA+55aFxZN_p_cU94z7QN8=HnPanRrpRHH7UUkOBaFDSjfrivnQ@mail.gmail.com>
        <CACdnJutOAPTmPm6dmHiw4+8rj=M7B1SiCkPaRZLmi9-CCuRyNg@mail.gmail.com>
        <CA+55aFzH6doC2F1xBitPRwTZtbiCO_mX+QVcJ8HQCdsdD3Vmpg@mail.gmail.com>
        <CACdnJuvuf13VrHfBadvXvVLUQoqjdbwqmnsRHamfDN_O4Ve+kA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJuvuf13VrHfBadvXvVLUQoqjdbwqmnsRHamfDN_O4Ve+kA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, luto@kernel.org, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, jmorris@namei.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jforbes@redhat.com, linux-man@vger.kernel.org, jlee@suse.com, LSM List <linux-security-module@vger.kernel.org>, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, 04 Apr 2018 00:12:04 +0000
Matthew Garrett <mjg59@google.com> wrote:

> On Tue, Apr 3, 2018 at 5:08 PM Linus Torvalds
> <torvalds@linux-foundation.org>
> wrote:
> > Still better than telling them to disable/enable secure boot, which
> > they may or may not even be able to to.  
> 
> Users who can boot a non-vendor Linux distribution on their platform can
> disable Secure Boot 100% of the time.

So can anyone else, or ignore it. Vendors of all OS's have released
enough buggy but signed kernel images over the past years that rummaging
around in the archive will find you a wide choice of signed boot images
that'll then let you do wtf you like including chaining some other target.

It was IMHO broken by design, it's always been broken by design and the
horse left the stable several years ago. Key revocation is hard, nobody
ever gets it right.

Thus "secure" boot is irrelevant to all of this

The most useful application of this kind of hardening is against remote
attacks. I don't care too much that someone local can attack my machine.
They can also steal it, ask me nicely with a baseball bat to remember the
password and so on.

If my box boots a random unsigned image that has these kinds of hardening
enabled then by the time it's on a network it's much much trickier to
attack. Yes you might be able to update the boot and reboot - but if I've
got that far I can insert an ancient buggy signed kernel image from a
vendor and chain through that anyway.

Real men boot security sensitive servers off a write protected SD card. If
your enterprise vendor doesn't supply a write protect for the boot
partition then maybe you should ask them why they don't 8)

In some ways the real application for this stuff is embedded. Whatever
the boot process most embedded devices benefit from that kind of lock
down.

Alan
