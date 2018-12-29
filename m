From: Dominique Martinet <asmadeus@codewreck.org>
Subject: Re: [Qemu-devel] d_off field in struct dirent and 32-on-64 emulation
Date: Sat, 29 Dec 2018 03:37:21 +0100
Message-ID: <20181229023721.GA9291@nautica>
References: <87bm56vqg4.fsf@mid.deneb.enyo.de>
 <CAFEAcA92m4vhzjJ+B=mP_o6Wfhx1XSKo3uWxah3osh=u5UXFuw@mail.gmail.com>
 <9C6A7D45-CF53-4C61-B5DD-12CA0D419972@dilger.ca>
 <CAFEAcA9W+JK7_TrtTnL1P2ES1knNPJX9wcUvhfLwxLq9augq1w@mail.gmail.com>
 <20181229021157.GG5864@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181229021157.GG5864@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Peter Maydell <peter.maydell@linaro.org>, Andreas Dilger <adilger@dilger.ca>, Florian Weimer <fw@deneb.enyo.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, lucho@ionkov.net, libc-alpha@sourceware.org, Arnd Bergmann <arnd@arndb.de>, ericvh@gmail.com, hpa@zytor.com, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, QEMU Developers <qemu-devel@nongnu.org>, rminnich@sandia.gov, v9fs-developer@lists.sourceforge.net
List-Id: linux-api@vger.kernel.org

Theodore Y. Ts'o wrote on Fri, Dec 28, 2018:
> > The problem is that there is no 32-bit API in some cases
> > (unless I have misunderstood the kernel code) -- not all
> > host architectures implement compat syscalls or allow them
> > to be called from 64-bit processes or implement all the older
> > syscall variants that had smaller offets. If there was a guaranteed
> > "this syscall always exists and always gives me 32-bit offsets"
> > we could use it.
> 
> Are there going to be cases where a process or a thread will sometimes
> want the 64-bit interface, and sometimes want the 32-bit interface?
> Or is it always going to be one or the other?  I wonder if we could
> simply add a new flag to the process personality(2) flags.

That would likely work for qemu user, but the qemu system+9p case is
going to be more painful..
More precisely, the 9p protocol does not plan for anything other than
64bit offset so if the vfs needs to hand out a 32bit offset we'll need
to make a correspondance table between the 32bit offsets we hand off and
the 64bit ones to use; unless some flag can be passed at lopen to tell
the server to always hand out 32bit offsets for this directory... And if
we do that then 9p servers will need a way to use both APIs in parallel
for both types of directories.

(Although I'd rather not have to do either in the first place, keeping
track of all used offsets just in case seems like a waste even if we
only do it for processes in 32bit mode, and a new flag would be a
protocol change with 9p not being designed to catter for subtle protocol
changes so would be rather painful to roll out)


No bright idea here, sorry.
-- 
Dominique Martinet | Asmadeus
