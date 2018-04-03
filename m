From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Tue, 3 Apr 2018 22:21:02 +0100
Message-ID: <20180403212102.GL30522@ZenIV.linux.org.uk>
References: <4136.1522452584@warthog.procyon.org.uk>
 <alpine.LRH.2.21.1803311145180.7769@namei.org>
 <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org>
 <30459.1522739219@warthog.procyon.org.uk>
 <CALCETrUFOdrH5ShCCd8yguGjC2NtG8fJY7AW26HH467-02UVGA@mail.gmail.com>
 <CACdnJut31+ZtiR40nkOjm89cfUxS0EM=w-oG69PtWHbXYJQxPg@mail.gmail.com>
 <CA+55aFy5EPxAyqyGGaYUUyakuLbjXHiseWCkz-oNdo=Y-878tg@mail.gmail.com>
 <CACdnJuuXOP5T-BRAwMvc7XF8S49wyvp4ZYgcU=EZkaGNgPAQig@mail.gmail.com>
 <CA+55aFzGFZT68ih446DeQbB69Fyk_wT6b7PGq0iz-gctUGQq_A@mail.gmail.com>
 <CACdnJuvheCbuvTLyDWMQWcUytc4EvuSUaEKywfEX8Kp6qYL9dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACdnJuvheCbuvTLyDWMQWcUytc4EvuSUaEKywfEX8Kp6qYL9dg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, luto@kernel.org, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, jmorris@namei.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jforbes@redhat.com, linux-man@vger.kernel.org, jlee@suse.com, LSM List <linux-security-module@vger.kernel.org>, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 03, 2018 at 09:08:54PM +0000, Matthew Garrett wrote:

> > The fact is, some hardware pushes secure boot pretty hard. That has
> > *nothing* to do with some "lockdown" mode.
> 
> Secure Boot ensures that the firmware will only load signed bootloaders. If
> a signed bootloader loads a kernel that's effectively an unsigned
> bootloader, there's no point in using Secure Boot - you should just turn it
> off instead, because it's not giving you any meaningful security. Andy's
> example gives a scenario where by constraining your *userland* sufficiently
> you can get close to having the same guarantees, but that involves you
> having a read-only filesystem and takes you even further away from having a
> general purpose computer.
> 
> If you don't want Secure Boot, turn it off. If you want Secure Boot, use a
> kernel that behaves in a way that actually increases your security.

That assumes you *can* turn that shit off.  On the hardware where manufacturer
has installed firmware that doesn't allow that SB is a misfeature that has
to be worked around.  Making that harder might improve the value of SB to
said manufacturers, but what's the benefit for everybody else?
