From: David Howells <dhowells@redhat.com>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Tue, 03 Apr 2018 08:06:59 +0100
Message-ID: <30459.1522739219@warthog.procyon.org.uk>
References: <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org> <4136.1522452584@warthog.procyon.org.uk> <alpine.LRH.2.21.1803311145180.7769@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org>
Content-ID: <30458.1522739219.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: dhowells@redhat.com, James Morris <jmorris@namei.org>, gnomes@lxorguk.ukuu.org.uk, Linus Torvalds <torvalds@linux-foundation.org>, mjg59@google.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com, linux-man@vger.kernel.org, jlee@suse.com, linux-security-module@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@kernel.org> wrote:

> This is an attempt at a review.  I'm replying here because I can't find the
> actual relevant patch emails.

This was the latest post:

	https://lkml.org/lkml/2017/11/9/660

and they were posted multiple times before that, plus distributions, such as
Fedora, have been carrying them for a long while.

> For the rest of this review, I'm going to pretend that you actually want two
> features: "try-prevent-root-from-corrupting-the-kernel" and
> "try-to-prevent-root-from-reading-kernel-memory".

It theoretically boils down into those two, but the line is blurrier than you
think.

Further, some of the vectors that can be used to do one can potentially do the
other also and it starts getting to be a lot of extra work to distinguish the
two.

> I do *not* see why the mere act of using Secure Boot should have this
> effect.

To be able to pass secure boot mode over kexec, you have to make sure that the
kernel image doesn't get corrupted, lest someone blacklist your signing key in
the bootloader.

> In particular, UEFI Secure Boot should *not* enable
> "try-to-prevent-root-from-reading-kernel-memory", which means that, unless
> you actually implement the split, you should drop a bunch of the patches.

Yes it should.  If someone can read your kernel image, they can steal the
crypto keys you use to encrypt your filesystem.

> "Restrict /dev/{mem,kmem,port} when the kernel is locked down": this should
> probably split into one restriction for read and one for write.

Not so for /dev/port.  Read & Write here are _not_ the same as Read & Write
on, say, /dev/mem.  In fact, if /dev/mem gives you access to mmio ports, then
the same applies there.  Btw, Fedora hasn't even provided /dev/kmem for a
while.

> "bpf: Restrict kernel image access functions when the kernel is locked down":
> This patch just sucks in general.

Yes - but that's what Alexei Starovoitov specified.  bpf kind of sucks since
it gives you unrestricted access to the kernel.

> "debugfs: Restrict debugfs when the kernel is locked down": The logic is IMO
> nutty.  Why the 0444 restriction?  I see no reason that reading a 0644 file
> should be treated any differently from reading a 0444 file.

Yes.  IMO it should be locked down entirely.  However, it's been abused and
there are things in there that are apparently needed (ie. it's not
debugging-only now); unfortunately, it *also* contains files that directly map
hardware.

> "efi: Lock down the kernel if booted in secure boot mode": you have a stray
> change in fs/debugfs/inode.c in here.

Good catch, thanks.

> Also, as above, I really dislike this patch.

You dislike everything, but you didn't say so any of the times these patches
were posted...

> "lockdown: Print current->comm in restriction messages": Shouldn't this be
> folded in with whatever patch added that code in the first place?

Perhaps, but at the time I added it, I didn't want to go back and change the
existing patches again.  If I have to do so, I'll fold it in then.

David
