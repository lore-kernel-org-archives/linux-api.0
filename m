From: Peter Jones <pjones@redhat.com>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Wed, 4 Apr 2018 14:42:56 -0400
Message-ID: <20180404184255.exdrtpqnxlqme7tl@redhat.com>
References: <4136.1522452584@warthog.procyon.org.uk>
 <alpine.LRH.2.21.1803311145180.7769@namei.org>
 <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org>
 <30459.1522739219@warthog.procyon.org.uk>
 <CALCETrUFOdrH5ShCCd8yguGjC2NtG8fJY7AW26HH467-02UVGA@mail.gmail.com>
 <CACdnJut31+ZtiR40nkOjm89cfUxS0EM=w-oG69PtWHbXYJQxPg@mail.gmail.com>
 <CALCETrXeVod=kNpG-M7yKAMM0-n+PMg_OakN6ecWrTPmKXgMLg@mail.gmail.com>
 <CACdnJuutJeeaaB2kwma0MMd9uDDbKavoHEk4koDLe1M6gYZWXQ@mail.gmail.com>
 <CALCETrVR_EcbKv5-4AR6Zm02XHhJQQGNDeO8FGkMbYozmuDTJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVR_EcbKv5-4AR6Zm02XHhJQQGNDeO8FGkMbYozmuDTJw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Matthew Garrett <mjg59@google.com>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 03, 2018 at 02:51:23PM -0700, Andy Lutomirski wrote:
> On Tue, Apr 3, 2018 at 12:29 PM, Matthew Garrett <mjg59@google.com> wrote:
> > On Tue, Apr 3, 2018 at 9:46 AM Andy Lutomirski <luto@kernel.org> wrote:
> >> On Tue, Apr 3, 2018 at 9:29 AM, Matthew Garrett <mjg59@google.com> wrote:
> >> > A kernel that allows users arbitrary access to ring 0 is just an
> >> > overfeatured bootloader. Why would you want secure boot in that case?
> >
> >> To get a chain of trust.  I can provision a system with some public
> >> keys, stored in UEFI authenticated variables, such that the system
> >> will only boot a signed image.  That signed image, can, in turn, load
> >> a signed (or hashed or otherwise verfified) kernel and a verified
> >> initramfs.  The initramfs can run a full system from a verified (using
> >> dm-verity or similar) filesystem, for example.  Now it's very hard to
> >> persistently attack this system.  Chromium OS does something very much
> >> like this, except that it doesn't use UEFI as far as I know.  So does
> >> iOS, and so do some Android versions.  None of this requires lockdown,
> >> or even a separation between usermode and kernelmode, to work
> >> correctly.  One could even do this on an MMU-less system if one really
> >> cared to.  More usefully, someone probably has done this using a
> >> unikernel.
> >
> > That's only viable if you're the only person with the ability to sign stuff
> > for your machine - the moment there are generic distributions that your
> > machine trusts, an attacker can use one as a bootloader to compromise your
> > trust chain.
> 
> 
> If you removed "as a bootloader", then I agree with that sentence.
> 
> Can someone please explain why the UEFI crowd cares so much about "as
> a bootloader"?  Once I'm able to install an OS (Linux kernel +
> bootloader, Windows embedded doodad, OpenBSD, whatever) on your
> machine, I can use your peripherals, read your data, write your data,
> see your keystrokes, use your network connection, re-flash your BIOS
> (at least as well as any OS can), run VMs, and generally own your
> system.  Somehow you all seem fine with all of this, except that the
> fact that I can chainload something else gives UEFI people the
> willies.
> 
> Can someone explain why?

There's no inherent difference, in terms of the trust chain, between
compromising it to use the machine as a toaster or to run a botnet - the
trust chain is compromised either way.  But you're much more likely to
notice if your desktop starts producing bread products than if it hides
some malware and keeps on booting, and the second one is much more
attractive to attackers anyway.

The reason we talk about it as a bootloader is because of the model
employed by malware.  I'm sure you know that one kind of malware that
exists in the wild, a so-called "boot kit", operates by modifying a
kernel during load (or on disk before loading) so that it has some
malicious payload, like exfiltrating user data or allowing a way to
install software that the kernel hides or *whatever*, and incorporating
some way to achieve relative persistence on the system - for example
hiding the real boot settings and loading a kernel with a different than
normal initramfs that loads an exploit before continuing with a normal
looking boot.

As Kees has pointed out, the lockdown portion of this is about
separating uid-0 from ring-0.  There are a lot of reasons to want to do
that, of course.  But the reason Secure Boot exists, and ultimately the
reason we started trying to do this, is so you can't build the
persistence mechanism for a boot kit by using a trusted kernel to
springboard into a modified one, even if it's the same kernel just
modified before kexec.  If you can do that, you can use that to build
the persistence mechanism in a boot kit.

That is to say, as a result of the way malware has been written, our way
of thinking about it is often that it's a way to build a boot loader for
a malicious kernel, so that's how we wind up talking about it.  Are we
concerned with malware stealing your data?  Yes, but Secure Boot is only
indirectly about that.  It's primarily about denying the malware easy
mechanisms to build a persistence mechanism.  The uid-0 != ring-0 aspect
is useful independent of Secure Boot, but Secure Boot without it falls
way short of accomplishing its goal.

--
  Peter
