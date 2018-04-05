From: Matthew Garrett <mjg59@google.com>
Subject: Re: An actual suggestion (Re: [GIT PULL] Kernel lockdown for secure boot)
Date: Thu, 05 Apr 2018 00:22:02 +0000
Message-ID: <CACdnJusC7pvGhaRZBHAQqxc8MLHBeFUdZAddUO5DG2kFZMktMA@mail.gmail.com>
References: <CALCETrUVQLDC6_VEvuAbdCOuGrmcxohqTB6P8eyNojm9AryNkg@mail.gmail.com>
 <1119.1522858644@warthog.procyon.org.uk> <alpine.LRH.2.21.1804050918330.21060@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.21.1804050918330.21060@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jmorris@namei.org
Cc: David Howells <dhowells@redhat.com>, luto@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jforbes@redhat.com, linux-man@vger.kernel.org, jlee@suse.com, LSM List <linux-security-module@vger.kernel.org>, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 4, 2018 at 4:25 PM James Morris <jmorris@namei.org> wrote:
> It's surely reasonable to allow an already secure-booted system to be
> debugged without needing to be rebooted.

alt-sysrq-x from a physical console will do that.
