From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Wed, 10 May 2017 03:45:24 +0100
Message-ID: <20170510024524.GB390@ZenIV.linux.org.uk>
References: <20170428153213.137279-1-thgarnie@google.com>
 <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com>
 <20170508124621.GA20705@kroah.com>
 <20170509064522.anusoikaalvlux3w@gmail.com>
 <20170509085659.GA32555@infradead.org>
 <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
 <20170509130250.GA11381@infradead.org>
 <20170509160322.GA15902@infradead.org>
 <20170510021118.GA390@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170510021118.GA390@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@kernel.org>, Greg KH <greg@kroah.com>, Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Rik
List-Id: linux-api@vger.kernel.org

On Wed, May 10, 2017 at 03:11:18AM +0100, Al Viro wrote:
> On Tue, May 09, 2017 at 09:03:22AM -0700, Christoph Hellwig wrote:
> > On Tue, May 09, 2017 at 06:02:50AM -0700, Christoph Hellwig wrote:
> > > On Tue, May 09, 2017 at 06:00:01AM -0700, Andy Lutomirski wrote:
> > > > fs/splice.c has some, ahem, interesting uses that have been the source
> > > > of nasty exploits in the past.  Converting them to use iov_iter
> > > > properly would be really, really nice.  Christoph, I don't suppose
> > > > you'd like to do that?
> > > 
> > > I can take care of all the fs code including this one.
> 
> Oh?
> 
> > I spent the afternoon hacking up where I'd like this to head.  It's
> > completely untested as of now:
> > 
> > 	http://git.infradead.org/users/hch/vfs.git/shortlog/refs/heads/setfs-elimination
> 
> And just what happens to driver that has no ->read_iter()?  Unless I'm
> seriously misreading that, NAK with extreme prejudice.

FWIW, some parts of that queue are obviously sane; it's the conversions of
kernel_write() and friends to ->read_iter/->write_iter() that are non-starters.
That stuff is used in too many situations; we can't guarantee that all of
them will be for files that have those.

As for default_file_splice_read(), I seriously suspect that with your change
we could as well just make it return -EINVAL and be done with that; places
that have ->read_iter() tend to have explicit ->splice_read() and it looks
like the ones that do not should simply use generic_file_read_iter().
I hadn't checked that, but there's not a lot of those:

arch/s390/hypfs/inode.c:437:    .read_iter      = hypfs_read_iter,
drivers/char/mem.c:798: .read_iter      = read_iter_null,
drivers/char/mem.c:813: .read_iter      = read_iter_zero,
drivers/char/mem.c:824: .read_iter      = read_iter_zero,
drivers/char/raw.c:286: .read_iter      = blkdev_read_iter,
drivers/net/tap.c:1134: .read_iter      = tap_read_iter,
drivers/net/tun.c:2423: .read_iter  = tun_chr_read_iter,
drivers/usb/gadget/function/f_fs.c:1255:        .read_iter =    ffs_epfile_read_iter,
drivers/usb/gadget/legacy/inode.c:703:  .read_iter =    ep_read_iter,
drivers/vhost/net.c:1252:       .read_iter      = vhost_net_chr_read_iter,
fs/9p/vfs_file.c:641:   .read_iter = generic_file_read_iter,
fs/9p/vfs_file.c:652:   .read_iter = generic_file_read_iter,
fs/9p/vfs_file.c:664:   .read_iter = v9fs_file_read_iter,
fs/9p/vfs_file.c:675:   .read_iter = v9fs_file_read_iter,
fs/9p/vfs_file.c:687:   .read_iter = v9fs_mmap_file_read_iter,
fs/9p/vfs_file.c:698:   .read_iter = v9fs_mmap_file_read_iter,
fs/fuse/cuse.c:180:     .read_iter              = cuse_read_iter,
fs/fuse/file.c:3015:    .read_iter      = fuse_direct_read_iter,
fs/hugetlbfs/inode.c:980:       .read_iter              = hugetlbfs_read_iter,
fs/ncpfs/file.c:248:    .read_iter      = ncp_file_read_iter,
fs/orangefs/file.c:742: .read_iter      = orangefs_file_read_iter,
fs/pipe.c:1011: .read_iter      = pipe_read,
sound/core/pcm_native.c:3696:           .read_iter =            snd_pcm_readv,

is the full list and I'm fairly certain that most of them will work with
generic_file_splice_read() just fine.  drivers/char definitely will, so
will ncpfs/orangefs/hugetlbfs/most of 9p ones (two of the latter might
need some care in p9_client_read(), but that should be doable easily enough).
pipe is irrelevant (->splice_read() won't be called for those).  fuse ones
should be doable, but that might take a bit more infrastructure work in
lib/iov_iter.c.  vhost, gadgetfs, tun/tap - no idea at the moment.
