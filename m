From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Fri, 12 May 2017 01:07:41 -0700
Message-ID: <20170512080741.GA32228@infradead.org>
References: <20170428153213.137279-1-thgarnie@google.com>
 <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com>
 <20170508124621.GA20705@kroah.com>
 <20170509064522.anusoikaalvlux3w@gmail.com>
 <20170509085659.GA32555@infradead.org>
 <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
 <20170512070012.7dysuhbkcas7ibaj@gmail.com>
 <20170512071549.GP390@ZenIV.linux.org.uk>
 <20170512073521.GA7091@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20170512073521.GA7091@infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mark Rutland <mark.rutland@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Greg KH <greg@kroah.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-s390 <linux-s390@vger.kernel.org>, Richard Weinberger <richard@nod.at>, the arch/x86 maintainers <x86@kernel.org>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Christoph Hellwig <hch@infradead.org>, Christian Borntraeger <borntraeger@de.ibm.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Catalin Marinas <catalin.marinas@arm.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>Rik van Riel <ri>
List-Id: linux-api@vger.kernel.org

On Fri, May 12, 2017 at 12:35:21AM -0700, Christoph Hellwig wrote:
> On Fri, May 12, 2017 at 08:15:49AM +0100, Al Viro wrote:
> > And converting everything to ->read_iter()/->write_iter() means an insane
> > amount of code churn, not to mention coping with random bogosities in
> > semantics.  ->read() and ->write() are going to stay around, pretty
> > much indefinitely.
> 
> But I don't think kernel users of them have to.  I've been digging
> through the calllers and will send an analysis to the list in a bit.

Ok, here is the cleaned up list.  The targets for in-kernel I/O
are basically regular files on normal fs, block devices, pipes
and sockets, with a few narrow exceptions and a few unclear cases.

I've added a few maintainers to Cc to clarify, and the list is below:

When looking at kernel_read/kernel_readv/kernel_write/__kernel_write
instances, or vfs_read/vfs_readv/vfs_write/vfs_writev inststances with
set_fs tricks most of them simply require a regular file on a "real"
fs or a block device, pipe, socket:

 - various binary loaders: need to be regular files (+ on a "real" fs)
 - nandsim: expect a regular file or maybe a block device
 - code: expects a regular file
 - ecryptfs: expects a regular file
 - splice: can be a regular file or device file
 - security/keys: regular file
 - cachefiles: needs to be a regular file
 - coredump: usually a regular file, but possibly a pipe
 - acct: regular file
 - target: regular file
 - nfsd: regular file
 - lustre: regular file
 - f_mass_storage: regular file, or maybe block device
 - autofs: pipe
 - btrfs: regular file / pipe / socket
 - ima: regular file on specific file systems

Then there are a few interesting ones with specific targets:

 - sysctl: regular file on procfs
 - mconsole: procfs as far as I can tell.  Might be able to further
   narrow it down?
 - ashmem: regular file on shmem

The nommu mmap code needs to read everything that wants to support
a MAP_PRIVATE mmap, but as far as a I can tell: do a) address limits
not matter for nommu, and b) I have no f***cking idea why it doesn't
use readpage(s) to start with like the MMU code.

And a few that I can't figure:

 - cx25821: no idea what this opens, need to confirm with the maintainers
   (on Cc)
 - 9p: not clear.  looks like it might be sockets/pipes
 
 Last but not least we have a driver that's a complete mess:

 - series2002: /dev/tty* (drivers is in staging and needs to be rewritten
   using the proper in-kernel APIs anyway)
