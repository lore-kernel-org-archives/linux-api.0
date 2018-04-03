From: Matthew Garrett <mjg59@google.com>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Tue, 03 Apr 2018 21:37:28 +0000
Message-ID: <CACdnJuvfDugkqZeW-0Y=vH-Gr+SpnnH7boRD5WygMff+rYXMug@mail.gmail.com>
References: <4136.1522452584@warthog.procyon.org.uk> <alpine.LRH.2.21.1803311145180.7769@namei.org>
 <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org> <30459.1522739219@warthog.procyon.org.uk>
 <CALCETrUFOdrH5ShCCd8yguGjC2NtG8fJY7AW26HH467-02UVGA@mail.gmail.com>
 <CACdnJut31+ZtiR40nkOjm89cfUxS0EM=w-oG69PtWHbXYJQxPg@mail.gmail.com>
 <CA+55aFy5EPxAyqyGGaYUUyakuLbjXHiseWCkz-oNdo=Y-878tg@mail.gmail.com>
 <CACdnJuuXOP5T-BRAwMvc7XF8S49wyvp4ZYgcU=EZkaGNgPAQig@mail.gmail.com>
 <CA+55aFzGFZT68ih446DeQbB69Fyk_wT6b7PGq0iz-gctUGQq_A@mail.gmail.com>
 <CACdnJuvheCbuvTLyDWMQWcUytc4EvuSUaEKywfEX8Kp6qYL9dg@mail.gmail.com> <20180403212102.GL30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180403212102.GL30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, luto@kernel.org, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, jmorris@namei.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jforbes@redhat.com, linux-man@vger.kernel.org, jlee@suse.com, LSM List <linux-security-module@vger.kernel.org>, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 3, 2018 at 2:21 PM Al Viro <viro@zeniv.linux.org.uk> wrote:

> On Tue, Apr 03, 2018 at 09:08:54PM +0000, Matthew Garrett wrote:
> > If you don't want Secure Boot, turn it off. If you want Secure Boot,
use a
> > kernel that behaves in a way that actually increases your security.

> That assumes you *can* turn that shit off.  On the hardware where
manufacturer
> has installed firmware that doesn't allow that SB is a misfeature that has
> to be worked around.  Making that harder might improve the value of SB to
> said manufacturers, but what's the benefit for everybody else?

This is why Shim has support for its own key database, as well as allowing
you to disable further signature validation. If the hardware supports third
party code at all, you can just use Shim to sidestep any unreasonable
restrictions the vendor has imposed.

(This doesn't help with systems that don't support third party code at all,
but this patchset does nothing to make that worse - that hardware wouldn't
boot your own kernel before this patchset, and it won't afterwards either)
