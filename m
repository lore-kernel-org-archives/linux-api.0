From: David Howells <dhowells@redhat.com>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Tue, 03 Apr 2018 23:32:49 +0100
Message-ID: <9349.1522794769@warthog.procyon.org.uk>
References: <CALCETrX4CuHVpn38R24TCcJgCBLSbh-sOD-qcD5kYF8Zo53ZJw@mail.gmail.com> <4136.1522452584@warthog.procyon.org.uk> <alpine.LRH.2.21.1803311145180.7769@namei.org> <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org> <30459.1522739219@warthog.procyon.org.uk> <CALCETrUFOdrH5ShCCd8yguGjC2NtG8fJY7AW26HH467-02UVGA@mail.gmail.com> <CACdnJut31+ZtiR40nkOjm89cfUxS0EM=w-oG69PtWHbXYJQxPg@mail.gmail.com> <CALCETrXeVod=kNpG-M7yKAMM0-n+PMg_OakN6ecWrTPmKXgMLg@mail.gmail.com> <9758.1522775763@warthog.procyon.org.uk> <CALCETrWHS9p1My=j07=V=OP7v4SwQkW-kJ3JOx6EbPU8fb_XEQ@mail.gmail.com> <13189.1522784944@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrX4CuHVpn38R24TCcJgCBLSbh-sOD-qcD5kYF8Zo53ZJw@mail.gmail.com>
Content-ID: <8614.1522794399.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: dhowells@redhat.com, Matthew Garrett <mjg59@google.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@kernel.org> wrote:

> > If the user can arbitrarily modify the running kernel image, you cannot
> > trust anything.  You cannot determine the trustworthiness of something
> > because your basis for determining that trust can be compromised.
> 
> I'm having a very, very hard time coming up with a scenario where I
> can "trust" something if an attacker can get root but can't modify the
> running kernel image but I can't "trust" something if the attacker
> can't.

Eh?  If the attacker can't what?  Did you mean to put "can" at the end of that
rather than "can't"?  I don't see why the kernel-level trust would be
compromised if an attacker can't get root and can't modify the running kernel
image.

Here's a simple scenario: You boot your machine.  You have module verification
keys in your kernel.  You have /dev/mem available for root to read/write.  A
program running as root can modify the keys in your kernel or just disable the
checking code entirely.  It can now insmod any module it likes.  You may as
well not bother with signed modules.  In fact, it can modify the running
kernel image in any way it likes, without even having to load modules.
There's no point bothering with UID/GID checking either.

> > Stopping the kernel from being arbitrarily read stops any encryption keys it
> > may be using from being retrieved.
> 
> If I build a server that runs Panera Bread 2.0's website, and the
> attacker exploits my machine to steal tens of millions of customer
> records by getting the machine to talk to some database server using
> keys that are securely stored in the kernel keyring, ...

I was thinking more in terms of preventing access to the encrypted data on
your own disk.  The key for that could be unlocked using a TPM, but the
session key then has to be retained in RAM for performance reasons unless you
can transfer the session key to, say, your SATA controller without it going
through the CPU.

However, if /dev/mem can be read, any root process can extract the session key
for your disk.

But, as you suggest, they could also protect secrets used in communications.
However, the communications themselves have to be exposed to userspace for
userspace to be able to use them.  That is unavoidable.  The kernel keyring,
for example, tries to restrict who can even see a key, much less use it as
much as possible - but ptrace() exists...  You are no less vulnerable if the
key is held in a userspace process; then the attacker can get the key and the
data.

If the kernel is locked down, the aim is to try and make sure that keys
stashed in the kernel cannot be read, though they have to be able to be used,
or there's no point to them.

David
