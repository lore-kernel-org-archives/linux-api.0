From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Tue, 3 Apr 2018 15:39:14 -0700
Message-ID: <CALCETrV6E+r942K+fu-ALNf-x6qOZ3o1hNKGeu7qEMvr8sMP9A@mail.gmail.com>
References: <4136.1522452584@warthog.procyon.org.uk> <alpine.LRH.2.21.1803311145180.7769@namei.org>
 <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org> <30459.1522739219@warthog.procyon.org.uk>
 <CALCETrUFOdrH5ShCCd8yguGjC2NtG8fJY7AW26HH467-02UVGA@mail.gmail.com>
 <CACdnJut31+ZtiR40nkOjm89cfUxS0EM=w-oG69PtWHbXYJQxPg@mail.gmail.com>
 <CALCETrXeVod=kNpG-M7yKAMM0-n+PMg_OakN6ecWrTPmKXgMLg@mail.gmail.com>
 <9758.1522775763@warthog.procyon.org.uk> <CALCETrWHS9p1My=j07=V=OP7v4SwQkW-kJ3JOx6EbPU8fb_XEQ@mail.gmail.com>
 <13189.1522784944@warthog.procyon.org.uk> <CALCETrX4CuHVpn38R24TCcJgCBLSbh-sOD-qcD5kYF8Zo53ZJw@mail.gmail.com>
 <9349.1522794769@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9349.1522794769@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Matthew Garrett <mjg59@google.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 3, 2018 at 3:32 PM, David Howells <dhowells@redhat.com> wrote:
> Andy Lutomirski <luto@kernel.org> wrote:
>
>> > If the user can arbitrarily modify the running kernel image, you cannot
>> > trust anything.  You cannot determine the trustworthiness of something
>> > because your basis for determining that trust can be compromised.
>>
>> I'm having a very, very hard time coming up with a scenario where I
>> can "trust" something if an attacker can get root but can't modify the
>> running kernel image but I can't "trust" something if the attacker
>> can't.
>
> Eh?  If the attacker can't what?  Did you mean to put "can" at the end of that
> rather than "can't"?  I don't see why the kernel-level trust would be
> compromised if an attacker can't get root and can't modify the running kernel
> image.

Whoops, yes.

>
> Here's a simple scenario: You boot your machine.  You have module verification
> keys in your kernel.  You have /dev/mem available for root to read/write.  A
> program running as root can modify the keys in your kernel or just disable the
> checking code entirely.  It can now insmod any module it likes.  You may as
> well not bother with signed modules.  In fact, it can modify the running
> kernel image in any way it likes, without even having to load modules.

I don't particularly disagree with any of this, but you seem to be
saying "if you've bought into the party line wrt signed modules, you
had better enable lockdown, too".  I *don't* buy into the party line
about why signed modules should be needed for Secure Boot.

> There's no point bothering with UID/GID checking either.

Give me a break.  There's a *huge* difference between a system where
only root can load unsigned modules and a system where anyone can load
unsigned modules.

>
>> > Stopping the kernel from being arbitrarily read stops any encryption keys it
>> > may be using from being retrieved.
>>
>> If I build a server that runs Panera Bread 2.0's website, and the
>> attacker exploits my machine to steal tens of millions of customer
>> records by getting the machine to talk to some database server using
>> keys that are securely stored in the kernel keyring, ...
>
> I was thinking more in terms of preventing access to the encrypted data on
> your own disk.  The key for that could be unlocked using a TPM, but the
> session key then has to be retained in RAM for performance reasons unless you
> can transfer the session key to, say, your SATA controller without it going
> through the CPU.
>
> However, if /dev/mem can be read, any root process can extract the session key
> for your disk.

Any root process can read /dev/mapper/plaintext_disk, lockdown or otherwise.

>
> But, as you suggest, they could also protect secrets used in communications.
> However, the communications themselves have to be exposed to userspace for
> userspace to be able to use them.  That is unavoidable.  The kernel keyring,
> for example, tries to restrict who can even see a key, much less use it as
> much as possible - but ptrace() exists...  You are no less vulnerable if the
> key is held in a userspace process; then the attacker can get the key and the
> data.
>
> If the kernel is locked down, the aim is to try and make sure that keys
> stashed in the kernel cannot be read, though they have to be able to be used,
> or there's no point to them.

Sure.  I have no problem with having an upstream kernel have a
lockdown feature, although I think that feature should distinguish
between reads and writes.  But I don't think the upstream kernel
should apply a patch that ties any of this to Secure Boot without a
genuine technical reason why it makes sense.
