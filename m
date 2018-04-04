From: Andy Lutomirski <luto@kernel.org>
Subject: An actual suggestion (Re: [GIT PULL] Kernel lockdown for secure boot)
Date: Wed, 4 Apr 2018 07:49:12 -0700
Message-ID: <CALCETrUVQLDC6_VEvuAbdCOuGrmcxohqTB6P8eyNojm9AryNkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>, Matthew Garrett <mjg59@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Since this thread has devolved horribly, I'm going to propose a solution.

1. Split the "lockdown" state into three levels:  (please don't
bikeshed about the names right now.)

LOCKDOWN_NONE: normal behavior

LOCKDOWN_PROTECT_INTEGREITY: kernel tries to keep root from writing to
kernel memory

LOCKDOWN_PROTECT_INTEGRITY_AND_SECRECY: kernel tries to keep root from
reading or writing kernel memory.

2. The kexec protocol gets a new flag min_lockdown_level.  A kexeced
kernel will boot with at least that lockdown level regardless of its
configuration.  kexec sets min_lockdown_level to the running kernels'
lockdown_level.  Some future API could allow kexec with a higher
min_lockdown_level.  An even fancier future API could allow a
LOCKDOWN_PROTECT_INTEGRITY_AND_SECRECY kernel to kexec with
min_lockdown_level == LOCKDOWN_PROTECT_INTEGRITY if there's some
mechanism that guarantees that memory gets zeroed in the process.

3. All the bpf and tracing stuf, etc, gets changed so it only takes
effect when LOCKDOWN_PROTECT_INTEGRITY_AND_SECRECY is set.  This
removes a giant annoyance on distro kernels that are likely to want to
enable LOCKDOWN_PROTECT_INTEGRITY.  If you load a key into the kernel,
and you want to keep that key safe, you can enable
LOCKDOWN_PROTECT_INTEGRITY_AND_SECRECY at that time.  After all, if
root is compromised before that, root can just remember a copu of the
key in user memory or email it to someone.

4. There's a kernel config option for the default lockdown level.
This operates completely independently of secure boot.

5. There's a command line option to increase the lockdown level above
the default level.  No particular authentication is needed for this
option to work.

6. There's a way to *decrease* the lockdown level below the configured
value.  (This ability itself may be gated by a config option.)
Choices include a UEFI protected variable, an authenticated flag
passed by the bootloader, and even just some special flag in the boot
handoff protocol.  It would be really quite useful for a user to be
able to ask their bootloader to reduce the lockdown level for the
purpose of a particular boot for debugging.  I read the docs on
mokutil --disable-validation, and it's quite messy.  Let's have a way
to do this that is mostly independent of the particular firmware in
use.

I can imagine a grub option that decreases lockdown level along with a
rule that grub will *not* load that option from its config, for
example.

7. kexec does not attempt to think about "secure boot" at all.
They're totally separate.

What do you all think?  I think that this checks basically all the
boxes, is a lot more user friendly than the current patchset or what
distros do, and actually makes some sense from a security perspective.

--Andy
