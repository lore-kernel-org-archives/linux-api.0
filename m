From: Matthew Garrett <mjg59@google.com>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Tue, 03 Apr 2018 23:09:27 +0000
Message-ID: <CACdnJuvfsZN_8yATpR+Zas69Yz0trZONACqV07A7-Ua0O5j3Kg@mail.gmail.com>
References: <4136.1522452584@warthog.procyon.org.uk> <alpine.LRH.2.21.1803311145180.7769@namei.org>
 <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org> <30459.1522739219@warthog.procyon.org.uk>
 <CALCETrUFOdrH5ShCCd8yguGjC2NtG8fJY7AW26HH467-02UVGA@mail.gmail.com>
 <CACdnJut31+ZtiR40nkOjm89cfUxS0EM=w-oG69PtWHbXYJQxPg@mail.gmail.com>
 <CALCETrXeVod=kNpG-M7yKAMM0-n+PMg_OakN6ecWrTPmKXgMLg@mail.gmail.com>
 <9758.1522775763@warthog.procyon.org.uk> <CALCETrWHS9p1My=j07=V=OP7v4SwQkW-kJ3JOx6EbPU8fb_XEQ@mail.gmail.com>
 <13189.1522784944@warthog.procyon.org.uk> <CALCETrX4CuHVpn38R24TCcJgCBLSbh-sOD-qcD5kYF8Zo53ZJw@mail.gmail.com>
 <9349.1522794769@warthog.procyon.org.uk> <CALCETrV6E+r942K+fu-ALNf-x6qOZ3o1hNKGeu7qEMvr8sMP9A@mail.gmail.com>
 <CA+55aFxKzxdRZthzaokaGPAsWCp3a-p3aVfJSutF+9Fp9sbaVA@mail.gmail.com>
 <CACdnJusSfwULV-ubvgtYd8G_cTF4LnJ4DAeTCux4XRhHKVpBUw@mail.gmail.com> <CALCETrXC-mL07YvGrvqaUQrbv+3fv2G9rGuQoMohaxG=QUQn2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXC-mL07YvGrvqaUQrbv+3fv2G9rGuQoMohaxG=QUQn2g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: luto@kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, jmorris@namei.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jforbes@redhat.com, linux-man@vger.kernel.org, jlee@suse.com, LSM List <linux-security-module@vger.kernel.org>, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 3, 2018 at 3:53 PM Andy Lutomirski <luto@kernel.org> wrote:
> On Tue, Apr 3, 2018 at 3:51 PM, Matthew Garrett <mjg59@google.com> wrote:
> > Lockdown is clearly useful without Secure Boot (and I intend to deploy
it
> > that way for various things), but I still don't understand why you feel
> > that the common case of booting a kernel from a boot chain that's widely
> > trusted derives no benefit from it being harder to subvert that kernel
into
> > subverting that boot chain. For cases where you're self-signing and feel
> > happy about that, you just set CONFIG_LOCK_DOWN_IN_EFI_SECURE_BOOT to n
and
> > everyone's happy?

> I would like to see distros that want Secure Boot to annoy users by
> enabling Lockdown be honest about the fact that it's an annoyance and
> adds very little value by having to carry a patch that was rejected by
> the upstream kernel.

I disagree with the assertion that it adds very little value, but if you
want to reject a technically useful patch for political reasons then I'm
well beyond the point of caring.
