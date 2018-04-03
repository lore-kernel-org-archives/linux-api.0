From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Tue, 3 Apr 2018 08:11:07 -0700
Message-ID: <CALCETrUFOdrH5ShCCd8yguGjC2NtG8fJY7AW26HH467-02UVGA@mail.gmail.com>
References: <4136.1522452584@warthog.procyon.org.uk> <alpine.LRH.2.21.1803311145180.7769@namei.org>
 <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org> <30459.1522739219@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <30459.1522739219@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Andy Lutomirski <luto@kernel.org>, James Morris <jmorris@namei.org>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Matthew Garrett <mjg59@google.com>, Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

[re-added cc's, I think.  Sorry, I think I failed to use the gmane
gateway correctly there.]

On Tue, Apr 3, 2018 at 12:06 AM, David Howells <dhowells@redhat.com> wrote:
> Andy Lutomirski <luto@kernel.org> wrote:
>
>> This is an attempt at a review.  I'm replying here because I can't find the
>> actual relevant patch emails.
>
> This was the latest post:
>
>         https://lkml.org/lkml/2017/11/9/660
>
> and they were posted multiple times before that, plus distributions, such as
> Fedora, have been carrying them for a long while.
>
>> For the rest of this review, I'm going to pretend that you actually want two
>> features: "try-prevent-root-from-corrupting-the-kernel" and
>> "try-to-prevent-root-from-reading-kernel-memory".
>
> It theoretically boils down into those two, but the line is blurrier than you
> think.
>
> Further, some of the vectors that can be used to do one can potentially do the
> other also and it starts getting to be a lot of extra work to distinguish the
> two.
>
>> I do *not* see why the mere act of using Secure Boot should have this
>> effect.
>
> To be able to pass secure boot mode over kexec, you have to make sure that the
> kernel image doesn't get corrupted, lest someone blacklist your signing key in
> the bootloader.

Can you explain that much more clearly?  I'm asking why booting via
UEFI Secure Boot should enable lockdown, and I don't see what this has
to do with kexec.  And "someone blacklist[ing] your key in the
bootloader" sounds like a political issue, not a technical issue.

What is the actual purpose of these patches?

>
>> In particular, UEFI Secure Boot should *not* enable
>> "try-to-prevent-root-from-reading-kernel-memory", which means that, unless
>> you actually implement the split, you should drop a bunch of the patches.
>
> Yes it should.  If someone can read your kernel image, they can steal the
> crypto keys you use to encrypt your filesystem.

Can you please explain the actual attack that is avoided by doing this?

Suppose I'm a bad guy attacking someone's laptop.  If I just have
normal uid!=0 access, then these patches have no effect.  Instead,
we're talking about an attacker who is somehow able to become global
root and bypass all LSM restrictions but has not gained kernel code
execution.  It is indeed the case that your patches make it harder to
simply read the dm-crypt encryption key out of main memory.  But root
can attack the disk encryption in many other ways.  They can
persistently compromise the machine by adding services or user
accounts or intentionally misconfiguring something.  They can directly
read the entire contents of the disk.  They can modify the initrd so
that the next time the machine reboots and the user types the
password, the attacker gets the key (unless the TPM is involved, but
getting *that* right on a standard distro is difficult or impossible).

And I'm not even sure why an attacker who manages to become root wants
your disk encryption key.  That key is worth nothing unless the
attacker makes its attack persistent, but, if the attacker can install
a persistent user-level backdoor, then they can read the cleartext off
your disk just as easily as they can read the ciphertext.

>
>> "Restrict /dev/{mem,kmem,port} when the kernel is locked down": this should
>> probably split into one restriction for read and one for write.
>
> Not so for /dev/port.  Read & Write here are _not_ the same as Read & Write
> on, say, /dev/mem.  In fact, if /dev/mem gives you access to mmio ports, then
> the same applies there.  Btw, Fedora hasn't even provided /dev/kmem for a
> while.

Then split /dev/mem and turn off /dev/port for all locked-down modes.

>
>> "bpf: Restrict kernel image access functions when the kernel is locked down":
>> This patch just sucks in general.
>
> Yes - but that's what Alexei Starovoitov specified.  bpf kind of sucks since
> it gives you unrestricted access to the kernel.

bpf, in certain contexts, gives you unrestricted access to *reading*
kernel memory.  bpf should, under no circumstances, let you write to
the kernel unless you're using fault injection or similar.

I'm surprised that Alexei acked this patch.  If something like XDP or
bpfilter starts becoming widely used, this patch will require a lot of
reworking to avoid breaking standard distros.
