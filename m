From: Matthew Garrett <mjg59@google.com>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Tue, 03 Apr 2018 21:32:50 +0000
Message-ID: <CACdnJutFiGDymC1dAdCSQB2aHYKqdRfXBsyvLN6quwg6CzcWmA@mail.gmail.com>
References: <4136.1522452584@warthog.procyon.org.uk> <alpine.LRH.2.21.1803311145180.7769@namei.org>
 <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org> <30459.1522739219@warthog.procyon.org.uk>
 <CALCETrUFOdrH5ShCCd8yguGjC2NtG8fJY7AW26HH467-02UVGA@mail.gmail.com>
 <CACdnJut31+ZtiR40nkOjm89cfUxS0EM=w-oG69PtWHbXYJQxPg@mail.gmail.com>
 <CA+55aFy5EPxAyqyGGaYUUyakuLbjXHiseWCkz-oNdo=Y-878tg@mail.gmail.com>
 <CACdnJuuXOP5T-BRAwMvc7XF8S49wyvp4ZYgcU=EZkaGNgPAQig@mail.gmail.com>
 <CA+55aFzGFZT68ih446DeQbB69Fyk_wT6b7PGq0iz-gctUGQq_A@mail.gmail.com>
 <CACdnJuvheCbuvTLyDWMQWcUytc4EvuSUaEKywfEX8Kp6qYL9dg@mail.gmail.com> <CA+55aFy4ZVaar3sf7bSVYtU5sRkv18x9W8HMEwF9O9beQK4wbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFy4ZVaar3sf7bSVYtU5sRkv18x9W8HMEwF9O9beQK4wbw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: luto@kernel.org, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, jmorris@namei.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jforbes@redhat.com, linux-man@vger.kernel.org, jlee@suse.com, LSM List <linux-security-module@vger.kernel.org>, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 3, 2018 at 2:26 PM Linus Torvalds
<torvalds@linux-foundation.org>
wrote:

> On Tue, Apr 3, 2018 at 2:08 PM, Matthew Garrett <mjg59@google.com> wrote:
> >
> > Secure Boot ensures that the firmware will only load signed
bootloaders. If
> > a signed bootloader loads a kernel that's effectively an unsigned
> > bootloader, there's no point in using Secure Boot

> Bullshit.

> I may want to know that I'm running *my* kernel, but once that is the
> case, I trust it.

If you don't believe that your self-signed kernel is going to be a threat
against your security model then great! Don't turn this on when you build
it. But if you built a kernel that didn't have this lockdown functionality
and got it signed with, say, Red Hat's signing keys, anyone could take Red
Hat's bootloader chain and that kernel and subvert the Secure Boot chain on
any machine that trusts the third party signing key (ie, basically all of
them)

> Yes, on x86 hardware at least at some point MS actually had the rule
> that it has to be something you can turn off. That rule is apparently
> not true on ARM, though.

Correct - there's no requirement that it be something you can disable on
ARM, but since Microsoft won't sign any third-party code for ARM anyway it
makes no difference to this discussion.

> If you want lockdown, fine, enable it. But what the F*CK does that
> have to do with whether you had secure boot or not?

Because a kernel signed with a generally trusted key that doesn't implement
any lockdown functionality is effectively a bootloader that will load
unsigned material on most machines on the market, which reduces the
security of users running those machines with Secure Boot enabled.
