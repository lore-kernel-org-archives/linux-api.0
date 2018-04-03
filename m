From: Kees Cook <keescook@chromium.org>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Mon, 2 Apr 2018 17:59:10 -0700
Message-ID: <CAGXu5j+UWQWDacMvvRCke3xUOb7uTkxn=WaHzG4kJTKWh-6tAA@mail.gmail.com>
References: <4136.1522452584@warthog.procyon.org.uk> <alpine.LRH.2.21.1803311145180.7769@namei.org>
 <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Matthew Garrett <mjg59@google.com>, Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 2, 2018 at 5:37 PM, Andy Lutomirski <luto@kernel.org> wrote:
> On 03/30/2018 05:46 PM, James Morris wrote:
>>
>> On Sat, 31 Mar 2018, David Howells wrote:
>>
>>> Date: Thu, 26 Oct 2017 17:37:38 +0100
>>>
>>> Hi James,
>>>
>>> Can you pull this patchset into security/next please?  It has been in
>>> linux-next since the beginning of March.
>>>
>>> It adds kernel lockdown support for EFI secure boot.
>>
>>
>> Applied to
>> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git
>> next-lockdown and next-testing
>>
>> Are there any known coverage gaps now?
>>
>>
>>
>
> This is an attempt at a review.  I'm replying here because I can't find the
> actual relevant patch emails.
>
> Cover letter:
>
>> Here's a set of patches to institute a "locked-down mode" in the
>> kernel and to trigger that mode if the kernel is booted in secure-boot >
>> mode or through the command line.
>
> I think this is seriously problematic in that it's not well defined.  It
> sounds like "locked-down mode" means "make me feel good about something".

Naming of this feature has been multi-year bikeshedding, so if we
could just leave the name, that'd be nice.

> For the rest of this review, I'm going to pretend that you actually want two
> features: "try-prevent-root-from-corrupting-the-kernel" and
> "try-to-prevent-root-from-reading-kernel-memory".

That is how I view it, yes. It's about creating a bright line between
uid-0 and ring-0. The most powerful of these distinctions was made
long ago with signed modules. It hasn't been enough, though, since
there have been many ways for uid-0 to read or write kernel memory. My
expectation for this was to reasonably fill all the remaining gaps.

> Also, there should be a justification that allows normal people (i.e. those
> who are not involved in the UEFI signing process) to understand *why* this
> should have anything to do with UEFI.  I can very easily see why it would
> make sense for a UEFI authenticated variable to tell the kernel to enable
> one or both of these modes or for there to be an authenticated mechanism for
> the bootloader to tell the kernel to enable it.  I do *not* see why the mere
> act of using Secure Boot should have this effect.
>
> In particular, UEFI Secure Boot should *not* enable
> "try-to-prevent-root-from-reading-kernel-memory", which means that, unless
> you actually implement the split, you should drop a bunch of the patches.
>
> In fact, I think the kernel should try to get away from the idea that UEFI
> Secure Boot should imply annoying restrictions.  It's really annoying and
> it's never been clear to me that it has a benefit.

FWIW, I've never been a fan of this being UEFI-centric: more than
Secure Boot needs this. For example, Chrome OS's static root of trust
and boot firmware isn't UEFI, but it wants this feature enabled.
Chrome OS would set it on the command line, since the command line is
part of the signed boot image along with the kernel, etc.

> "Restrict /dev/{mem,kmem,port} when the kernel is locked down": this should
> probably split into one restriction for read and one for write.

I think splitting read and write is only useful if there is a use-case
for only blocking one of them. I struggle to imagine allowing write
and blocking read, so really it's the case of wanting to allow read
and disallow write. Is there actually a use-case for this? In all the
"locked down" cases I've seen, both are desired.

-Kees

-- 
Kees Cook
Pixel Security
