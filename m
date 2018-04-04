From: David Howells <dhowells@redhat.com>
Subject: Re: An actual suggestion (Re: [GIT PULL] Kernel lockdown for secure boot)
Date: Wed, 04 Apr 2018 17:17:24 +0100
Message-ID: <1119.1522858644@warthog.procyon.org.uk>
References: <CALCETrUVQLDC6_VEvuAbdCOuGrmcxohqTB6P8eyNojm9AryNkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUVQLDC6_VEvuAbdCOuGrmcxohqTB6P8eyNojm9AryNkg@mail.gmail.com>
Content-ID: <1118.1522858644.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: dhowells@redhat.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, Matthew Garrett <mjg59@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@kernel.org> wrote:

> Since this thread has devolved horribly, I'm going to propose a solution.
> 
> 1. Split the "lockdown" state into three levels:  (please don't
> bikeshed about the names right now.)
> 
> LOCKDOWN_NONE: normal behavior
> 
> LOCKDOWN_PROTECT_INTEGREITY: kernel tries to keep root from writing to
> kernel memory
> 
> LOCKDOWN_PROTECT_INTEGRITY_AND_SECRECY: kernel tries to keep root from
> reading or writing kernel memory.

In theory, it's good idea, but in practice it's not as easy to implement as I
think you think.

Let me list here the things that currently get restricted by lockdown:

 (1) Manipulation of devices to access the kernel image:

	- Ioports & ioperm
	- /dev/ports
	- /dev/mem
	- PCI Bar
	- Some debugfs files
	- pcmcia_cis
	- Driver hardware parameters
	  - ISA drivers
	  - TIOCSSERIAL
	  - SCSI EATA driver
	- testmmiotrace
	- firmware

 (2) Direct kernel memory modification:

	- /dev/mem
	- /dev/kmem
	- bpf
	- kprobes

 (3) Direct kernel memory reading:

	- /dev/mem
	- /dev/kmem
	- /dev/kcore
	- bpf
	- kprobes
	- perf

 (4) Indirect kernel access:

	- Modules
	- MSRs
	- Suspend to disk
	- ACPI (custom_method, RSDP, table override, error injection)

 (5) Kexec.

Note that /dev/mem can be used to access MMIO devices (I'm not sure about
/dev/kmem, though).  Even reads through /dev/mem can do this.  I'm not sure
whether that's sufficient to actually affect a modification, though.

Debugfs is particularly icky.  It contains at least a couple of thousand
files, a few of which provide direct access to hardware, some of which change
driver behaviour and some of which just give information.  Auditing that pile
isn't something I really want to have to do.  I'd rather just turn the whole
lot off, but got persuaded otherwise by people who have been using it to
provide mechanisms that programs rely on - hence the only allow files that
have 0444 (and even that is iffy as some of these files have side effects and
write ops anyway).

> 2. The kexec protocol gets a new flag min_lockdown_level.  A kexeced
> kernel will boot with at least that lockdown level regardless of its
> configuration.  kexec sets min_lockdown_level to the running kernels'
> lockdown_level.  Some future API could allow kexec with a higher
> min_lockdown_level.  An even fancier future API could allow a
> LOCKDOWN_PROTECT_INTEGRITY_AND_SECRECY kernel to kexec with
> min_lockdown_level == LOCKDOWN_PROTECT_INTEGRITY if there's some
> mechanism that guarantees that memory gets zeroed in the process.

Note that on x86 we already have an allocated flag for passing the secure boot
flag from kexec/bootloader to the kernel being booted, and what you're
proposing ought to be redundant.  See boot_params::secure_boot.

> 3. All the bpf and tracing stuf, etc, gets changed so it only takes
> effect when LOCKDOWN_PROTECT_INTEGRITY_AND_SECRECY is set.

Uh, no.  bpf, for example, can be used to modify kernel memory.  I think only
the following are safe from being able to talk directly to devices:

	/dev/kmem (O_RDONLY only)
	/dev/kcore
	perf
	some debugfs files

> This removes a giant annoyance on distro kernels that are likely to want to
> enable LOCKDOWN_PROTECT_INTEGRITY.

*shrug* Distros have been running with the full set for a while.  I haven't
seen many complaints.

> If you load a key into the kernel, and you want to keep that key safe, you
> can enable LOCKDOWN_PROTECT_INTEGRITY_AND_SECRECY at that time.  After all,
> if root is compromised before that, root can just remember a copu of the key
> in user memory or email it to someone.

If your key needs to be truly protected, it should never be seen unencrypted
in userspace, rather it should be decrypted in the TPM and then retained in
kernel memory only.

> ...
> 6. There's a way to *decrease* the lockdown level below the configured
> value.  (This ability itself may be gated by a config option.)
> Choices include a UEFI protected variable,

By turning secure boot off, maybe?

> an authenticated flag passed by the bootloader,

Authenticated how?  How do you stop the running system from passing this to
the bootloader next time it is run?  I guess you're thinking of a bootloader
"command" that can only be passed by someone sat at a keyboard and never read
from the config file.

> and even just some special flag in the boot handoff protocol.

We already have that with secure boot.

> It would be really quite useful for a user to be able to ask their
> bootloader to reduce the lockdown level for the purpose of a particular boot
> for debugging.

This I shall grant you - but you have to be able to prevent an attacker inside
the system from making use of it.  There's a SysRq provided to drop out of
lockdown mode - in theory only usable if you're sat at a wired keyboard
connected to the computer.

> 7. kexec does not attempt to think about "secure boot" at all.
> They're totally separate.

Except that they're not.  The boot_params flag must be set to something by
kexec on x86 for transfer along the chain.  However, we can leave secure boot
out for now - that can be treated as a separate issue.

Note that whether you like it or not, distribution kernels already work this
way and propagate the boot_params flag over kexec.

> What do you all think?  I think that this checks basically all the
> boxes, is a lot more user friendly than the current patchset or what
> distros do, and actually makes some sense from a security perspective.

You haven't really defined well what's allowed in _INTEGRITY mode verses
_SECRECY mode.

I'm currently in the throes of modifying my patchset to make it more inline
with what Linus mandates: dropping the enablement from secure boot; dropping
the propagation of the flag over kexec; providing a config option to make it
mandatory.  There is already a command line option to trigger it.

David
