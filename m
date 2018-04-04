From: James Morris <jmorris@namei.org>
Subject: Re: An actual suggestion (Re: [GIT PULL] Kernel lockdown for secure
 boot)
Date: Thu, 5 Apr 2018 09:25:19 +1000 (AEST)
Message-ID: <alpine.LRH.2.21.1804050918330.21060@namei.org>
References: <CALCETrUVQLDC6_VEvuAbdCOuGrmcxohqTB6P8eyNojm9AryNkg@mail.gmail.com> <1119.1522858644@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1119.1522858644@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, Matthew Garrett <mjg59@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, 4 Apr 2018, David Howells wrote:

> > 6. There's a way to *decrease* the lockdown level below the configured
> > value.  (This ability itself may be gated by a config option.)
> > Choices include a UEFI protected variable,
> 
> By turning secure boot off, maybe?

It's surely reasonable to allow an already secure-booted system to be 
debugged without needing to be rebooted.



- James
-- 
James Morris
<jmorris@namei.org>
