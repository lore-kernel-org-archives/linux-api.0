From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Mon, 2 Apr 2018 17:37:14 -0700
Message-ID: <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org>
References: <4136.1522452584@warthog.procyon.org.uk>
 <alpine.LRH.2.21.1803311145180.7769@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.21.1803311145180.7769@namei.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>
Cc: gnomes@lxorguk.ukuu.org.uk, Linus Torvalds <torvalds@linux-foundation.org>, mjg59@google.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com, linux-man@vger.kernel.org, jlee@suse.com, linux-security-module@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On 03/30/2018 05:46 PM, James Morris wrote:
> On Sat, 31 Mar 2018, David Howells wrote:
> 
>> Date: Thu, 26 Oct 2017 17:37:38 +0100
>>
>> Hi James,
>>
>> Can you pull this patchset into security/next please?  It has been in
>> linux-next since the beginning of March.
>>
>> It adds kernel lockdown support for EFI secure boot.
> 
> Applied to
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git
> next-lockdown and next-testing
> 
> Are there any known coverage gaps now?
> 
> 
> 

This is an attempt at a review.  I'm replying here because I can't find 
the actual relevant patch emails.

Cover letter:

 > Here's a set of patches to institute a "locked-down mode" in the
 > kernel and to trigger that mode if the kernel is booted in 
secure-boot > mode or through the command line.

I think this is seriously problematic in that it's not well defined.  It 
sounds like "locked-down mode" means "make me feel good about 
something".  For the rest of this review, I'm going to pretend that you 
actually want two features: 
"try-prevent-root-from-corrupting-the-kernel" and 
"try-to-prevent-root-from-reading-kernel-memory".

Also, there should be a justification that allows normal people (i.e. 
those who are not involved in the UEFI signing process) to understand 
*why* this should have anything to do with UEFI.  I can very easily see 
why it would make sense for a UEFI authenticated variable to tell the 
kernel to enable one or both of these modes or for there to be an 
authenticated mechanism for the bootloader to tell the kernel to enable 
it.  I do *not* see why the mere act of using Secure Boot should have 
this effect.

In particular, UEFI Secure Boot should *not* enable 
"try-to-prevent-root-from-reading-kernel-memory", which means that, 
unless you actually implement the split, you should drop a bunch of the 
patches.

In fact, I think the kernel should try to get away from the idea that 
UEFI Secure Boot should imply annoying restrictions.  It's really 
annoying and it's never been clear to me that it has a benefit.

"Restrict /dev/{mem,kmem,port} when the kernel is locked down": this 
should probably split into one restriction for read and one for write.

"Lock down /proc/kcore": should only apply to 
"try-to-prevent-root-from-reading-kernel-memory"

"Lock down kprobes": ditto

"bpf: Restrict kernel image access functions when the kernel is locked 
down": This patch just sucks in general.  At the very least, it should 
only apply to "bpf: Restrict kernel image access functions when the 
kernel is locked down".  But you should probably just force all eBPF 
users through the unprivileged path when locked down instead, since eBPF 
is really quite useful even with the stricter verification mode.

"Lock down perf": how about preventing using perf on the kernel when 
"try-to-prevent-root-from-reading-kernel-memory" is set and not 
restricting it otherwise?

"debugfs: Restrict debugfs when the kernel is locked down": The logic is 
IMO nutty.  Why the 0444 restriction?  I see no reason that reading a 
0644 file should be treated any differently from reading a 0444 file. 
Regardless, I think you should prevent writing or reading depending on 
lockdown mode and add an API so that individual debugfs files can 
override this.

"efi: Lock down the kernel if booted in secure boot mode": you have a 
stray change in fs/debugfs/inode.c in here.  Also, as above, I really 
dislike this patch.

"lockdown: Print current->comm in restriction messages": Shouldn't this 
be folded in with whatever patch added that code in the first place?
