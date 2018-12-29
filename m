From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [Qemu-devel] d_off field in struct dirent and 32-on-64 emulation
Date: Fri, 28 Dec 2018 21:11:57 -0500
Message-ID: <20181229021157.GG5864@mit.edu>
References: <87bm56vqg4.fsf@mid.deneb.enyo.de>
 <CAFEAcA92m4vhzjJ+B=mP_o6Wfhx1XSKo3uWxah3osh=u5UXFuw@mail.gmail.com>
 <9C6A7D45-CF53-4C61-B5DD-12CA0D419972@dilger.ca>
 <CAFEAcA9W+JK7_TrtTnL1P2ES1knNPJX9wcUvhfLwxLq9augq1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <libc-alpha-return-98858-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <CAFEAcA9W+JK7_TrtTnL1P2ES1knNPJX9wcUvhfLwxLq9augq1w@mail.gmail.com>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Andreas Dilger <adilger@dilger.ca>, Florian Weimer <fw@deneb.enyo.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, lucho@ionkov.net, libc-alpha@sourceware.org, Arnd Bergmann <arnd@arndb.de>, ericvh@gmail.com, hpa@zytor.com, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, QEMU Developers <qemu-devel@nongnu.org>, rminnich@sandia.gov, v9fs-developer@lists.sourceforge.net
List-Id: linux-api@vger.kernel.org

On Fri, Dec 28, 2018 at 11:18:18AM +0000, Peter Maydell wrote:
> In general inodes and offsets start from 0 and work up --
> so almost all of the time they don't actually overflow.
> The problem with ext4 directory hash "offsets" is that they
> overflow all the time and immediately, so instead of "works
> unless you have a weird edge case" like all the other filesystems,h
> it's "never works".

Actually, XFS uses the inode number to encode the location of the
inode (it doesn't have a fixed inode table, so it's effectively the
block number shifted left by 3 or 4 bits, with the low bits indicating
the slot in the 4k block).  It has a hack to provide backwards
compatibility for 32-bit API's, but there is a similar, "oh, we're on
a non-paleolithic CPU, let's use the full 64-bits" sort of logic that
ext4 has.

> The problem is that there is no 32-bit API in some cases
> (unless I have misunderstood the kernel code) -- not all
> host architectures implement compat syscalls or allow them
> to be called from 64-bit processes or implement all the older
> syscall variants that had smaller offets. If there was a guaranteed
> "this syscall always exists and always gives me 32-bit offsets"
> we could use it.

Are there going to be cases where a process or a thread will sometimes
want the 64-bit interface, and sometimes want the 32-bit interface?
Or is it always going to be one or the other?  I wonder if we could
simply add a new flag to the process personality(2) flags.

> Yes, that has been suggested, but it seemed a bit dubious
> to bake in knowledge of ext4's internal implementation details.
> Can we rely on this as an ABI promise that will always work
> for all versions of all file systems going forwards?

Yeah, that seems dubious because I'm pretty sure there are other file
systems that may have their own 32/64-bit quirks.

						- Ted
