From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Thu, 5 Apr 2018 11:47:52 -0700
Message-ID: <CALCETrU_4PywXj78pzfuCYCfXxQNvi_K-KfuyZKHu-upfesdPw@mail.gmail.com>
References: <4136.1522452584@warthog.procyon.org.uk> <alpine.LRH.2.21.1803311145180.7769@namei.org>
 <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org> <30459.1522739219@warthog.procyon.org.uk>
 <CALCETrUFOdrH5ShCCd8yguGjC2NtG8fJY7AW26HH467-02UVGA@mail.gmail.com>
 <CACdnJut31+ZtiR40nkOjm89cfUxS0EM=w-oG69PtWHbXYJQxPg@mail.gmail.com>
 <CALCETrXeVod=kNpG-M7yKAMM0-n+PMg_OakN6ecWrTPmKXgMLg@mail.gmail.com>
 <CACdnJuutJeeaaB2kwma0MMd9uDDbKavoHEk4koDLe1M6gYZWXQ@mail.gmail.com>
 <CALCETrVR_EcbKv5-4AR6Zm02XHhJQQGNDeO8FGkMbYozmuDTJw@mail.gmail.com> <20180404184255.exdrtpqnxlqme7tl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180404184255.exdrtpqnxlqme7tl@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Jones <pjones@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Matthew Garrett <mjg59@google.com>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 4, 2018 at 11:42 AM, Peter Jones <pjones@redhat.com> wrote:
> On Tue, Apr 03, 2018 at 02:51:23PM -0700, Andy Lutomirski wrote:
>> On Tue, Apr 3, 2018 at 12:29 PM, Matthew Garrett <mjg59@google.com> wrote:
>> Can someone please explain why the UEFI crowd cares so much about "as
>> a bootloader"?  Once I'm able to install an OS (Linux kernel +
>> bootloader, Windows embedded doodad, OpenBSD, whatever) on your
>> machine, I can use your peripherals, read your data, write your data,
>> see your keystrokes, use your network connection, re-flash your BIOS
>> (at least as well as any OS can), run VMs, and generally own your
>> system.  Somehow you all seem fine with all of this, except that the
>> fact that I can chainload something else gives UEFI people the
>> willies.
>>
>> Can someone explain why?
>
> There's no inherent difference, in terms of the trust chain, between
> compromising it to use the machine as a toaster or to run a botnet - the
> trust chain is compromised either way.  But you're much more likely to
> notice if your desktop starts producing bread products than if it hides
> some malware and keeps on booting, and the second one is much more
> attractive to attackers anyway.
>
> The reason we talk about it as a bootloader is because of the model
> employed by malware.  I'm sure you know that one kind of malware that
> exists in the wild, a so-called "boot kit", operates by modifying a
> kernel during load (or on disk before loading) so that it has some
> malicious payload, like exfiltrating user data or allowing a way to
> install software that the kernel hides or *whatever*, and incorporating
> some way to achieve relative persistence on the system - for example
> hiding the real boot settings and loading a kernel with a different than
> normal initramfs that loads an exploit before continuing with a normal
> looking boot.

This is a fair point, but I wonder how much it matters in practice.
If I'm writing a bootkit, I can think of at least four ways to do it.

1. The easy way.  Write a malicious bootloader that modifies the
kernel image to insert malicious code.  Stock secure boot makes this
awkward because you need a signed bootloader.  It's worth noting that
a non-locked-down signed Linux kernel is actually a rather awkward way
to do this because it will add several seconds to the boot and may
show a splash screen unless you're rather careful.

2. The CPL3 way.  Write a malicious initramfs that inserts the
malicious code in PID 1 instead.  This might be easier to get working
across a variety of Linux kernels, but it's more awkward to hide well
from userspace.  Conventional secure boot (with the stock MS keys)
doesn't help at all.

3. The nasty way.  Find a known exploitable kernel or bootloader, and
use it to do your evil deeds.  This is very, very hard to protect
against with normal secure boot.

4. The VM-kit way.  Use a signed, locked down, perfectly secure kernel
and run your pwned system as a VM guest.  Secure boot doesn't help one
whit.

*All* of these variants are avoided by a real, working verified boot
approach that chains all the way down to the running system image, and
*that* solution doesn't need cpl0 and cpl3 to be separated.

So I find myself wondering whether the bootkit argument is actually
very compelling.
