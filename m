From: joeyli <jlee@suse.com>
Subject: Re: An actual suggestion (Re: [GIT PULL] Kernel lockdown for secure
 boot)
Date: Thu, 5 Apr 2018 09:45:21 +0800
Message-ID: <20180405014521.GA7362@linux-l9pv.suse>
References: <CALCETrUVQLDC6_VEvuAbdCOuGrmcxohqTB6P8eyNojm9AryNkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUVQLDC6_VEvuAbdCOuGrmcxohqTB6P8eyNojm9AryNkg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, Matthew Garrett <mjg59@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Andy,

On Wed, Apr 04, 2018 at 07:49:12AM -0700, Andy Lutomirski wrote:
> Since this thread has devolved horribly, I'm going to propose a solution.
...
> 6. There's a way to *decrease* the lockdown level below the configured
> value.  (This ability itself may be gated by a config option.)
> Choices include a UEFI protected variable, an authenticated flag
> passed by the bootloader, and even just some special flag in the boot
> handoff protocol.  It would be really quite useful for a user to be
> able to ask their bootloader to reduce the lockdown level for the
> purpose of a particular boot for debugging.  I read the docs on

The "mokutil --disable-validation" done a similar bahvior as above.
Just it lets kernel to ignore the secure boot. 

> mokutil --disable-validation, and it's quite messy.  Let's have a way
> to do this that is mostly independent of the particular firmware in
> use.
>

Why the disabl-validation is messy?   
The mokutil is shim specific but not dependent on particular firmware. 
 
> I can imagine a grub option that decreases lockdown level along with a
> rule that grub will *not* load that option from its config, for
> example.
>

The root can modify the grub config to decrease lockdown level in next
boot without physcial accessing. The mokutil's interactive UI is used
to deal with user to confirm the physcial accessing.

Thanks
Joey Lee
