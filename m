From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Tue, 3 Apr 2018 12:01:01 -0700
Message-ID: <CALCETrW=Tjd2K9Ka0y_9es3XWiWHpKySDBwCq9vG=pbgkd2nFQ@mail.gmail.com>
References: <4136.1522452584@warthog.procyon.org.uk> <alpine.LRH.2.21.1803311145180.7769@namei.org>
 <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org> <30459.1522739219@warthog.procyon.org.uk>
 <CALCETrUFOdrH5ShCCd8yguGjC2NtG8fJY7AW26HH467-02UVGA@mail.gmail.com>
 <CACdnJut31+ZtiR40nkOjm89cfUxS0EM=w-oG69PtWHbXYJQxPg@mail.gmail.com>
 <CALCETrXeVod=kNpG-M7yKAMM0-n+PMg_OakN6ecWrTPmKXgMLg@mail.gmail.com> <CAGXu5j+CyVXEvsMarJjBwaNh7poVZtmit5PGmQM9rKKqZPqVXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+CyVXEvsMarJjBwaNh7poVZtmit5PGmQM9rKKqZPqVXg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>, Matthew Garrett <mjg59@google.com>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 3, 2018 at 11:45 AM, Kees Cook <keescook@chromium.org> wrote:
> On Tue, Apr 3, 2018 at 9:45 AM, Andy Lutomirski <luto@kernel.org> wrote:
>> On Tue, Apr 3, 2018 at 9:29 AM, Matthew Garrett <mjg59@google.com> wrote:
>>> On Tue, Apr 3, 2018 at 8:11 AM Andy Lutomirski <luto@kernel.org> wrote:
>>>> Can you explain that much more clearly?  I'm asking why booting via
>>>> UEFI Secure Boot should enable lockdown, and I don't see what this has
>>>> to do with kexec.  And "someone blacklist[ing] your key in the
>>>> bootloader" sounds like a political issue, not a technical issue.
>>>
>>> A kernel that allows users arbitrary access to ring 0 is just an
>>> overfeatured bootloader. Why would you want secure boot in that case?
>>
>> To get a chain of trust.  I can provision a system with some public
>> keys, stored in UEFI authenticated variables, such that the system
>> will only boot a signed image.  That signed image, can, in turn, load
>> a signed (or hashed or otherwise verfified) kernel and a verified
>> initramfs.  The initramfs can run a full system from a verified (using
>> dm-verity or similar) filesystem, for example.  Now it's very hard to
>> persistently attack this system.  Chromium OS does something very much
>> like this, except that it doesn't use UEFI as far as I know.  So does
>> iOS, and so do some Android versions.
>
> Correct, Chrome OS does not use UEFI, and we still want this patch
> series, as it plugs all the known "intentional" escalation paths from
> uid-0 to ring-0. Happily, that means all the politics around the UEFI
> and Secure Boot case can be ignored, because those issues are specific
> to Secure Boot, not the lockdown series. (They are _related_, sure,
> but lockdown isn't only about Secure Boot -- it's just that SB is one
> of the widely deployed implementations of this kind of
> trust-chain-booting-thing. Chrome OS and Android's Verified Boot do
> similar things and have the same expectations about the uid-0/ring-0
> separation.)
>
> The goal for that bright line on Chrome OS and Android is to stop
> attack persistence. We want to know that a reboot onto a new kernel
> and OS image will actually result in getting the desired system state,
> and that any attack on persistent system data (even for things running
> with full root privileges) can't result in using kernel interfaces to
> gain kernel control. This isn't expected to be _perfect_, since
> nothing is. But it creates a place to work from. The idea that uid-0
> is NOT ring-0 is still relatively new, so the existing designs in the
> kernel aren't well suited to building that distinction. I view this
> series as a solid first step to getting there, though.
>

But wouldn't Chrome OS possibly want to lock down kernel memory write
vectors but not read vectors?  After all, debugging is useful even on
Chrome OS.

--Andy
