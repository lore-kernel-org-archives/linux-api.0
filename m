From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [RFC PATCH 2/3] fs: add RWF_ENCODED for writing compressed data
Date: Tue, 24 Sep 2019 10:15:13 -0700
Message-ID: <20190924171513.GA39872@vader>
References: <cover.1568875700.git.osandov@fb.com>
 <230a76e65372a8fb3ec62ce167d9322e5e342810.1568875700.git.osandov@fb.com>
 <CAG48ez2GKv15Uj6Wzv0sG5v2bXyrSaCtRTw5Ok_ovja_CiO_fQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez2GKv15Uj6Wzv0sG5v2bXyrSaCtRTw5Ok_ovja_CiO_fQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Linux API <linux-api@vger.kernel.org>, Kernel Team <kernel-team@fb.com>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 19, 2019 at 05:44:12PM +0200, Jann Horn wrote:
> On Thu, Sep 19, 2019 at 8:54 AM Omar Sandoval <osandov@osandov.com> wrote:
> > Btrfs can transparently compress data written by the user. However, we'd
> > like to add an interface to write pre-compressed data directly to the
> > filesystem. This adds support for so-called "encoded writes" via
> > pwritev2().
> >
> > A new RWF_ENCODED flags indicates that a write is "encoded". If this
> > flag is set, iov[0].iov_base points to a struct encoded_iov which
> > contains metadata about the write: namely, the compression algorithm and
> > the unencoded (i.e., decompressed) length of the extent. iov[0].iov_len
> > must be set to sizeof(struct encoded_iov), which can be used to extend
> > the interface in the future. The remaining iovecs contain the encoded
> > extent.
> >
> > A similar interface for reading encoded data can be added to preadv2()
> > in the future.
> >
> > Filesystems must indicate that they support encoded writes by setting
> > FMODE_ENCODED_IO in ->file_open().
> [...]
> > +int import_encoded_write(struct kiocb *iocb, struct encoded_iov *encoded,
> > +                        struct iov_iter *from)
> > +{
> > +       if (iov_iter_single_seg_count(from) != sizeof(*encoded))
> > +               return -EINVAL;
> > +       if (copy_from_iter(encoded, sizeof(*encoded), from) != sizeof(*encoded))
> > +               return -EFAULT;
> > +       if (encoded->compression == ENCODED_IOV_COMPRESSION_NONE &&
> > +           encoded->encryption == ENCODED_IOV_ENCRYPTION_NONE) {
> > +               iocb->ki_flags &= ~IOCB_ENCODED;
> > +               return 0;
> > +       }
> > +       if (encoded->compression > ENCODED_IOV_COMPRESSION_TYPES ||
> > +           encoded->encryption > ENCODED_IOV_ENCRYPTION_TYPES)
> > +               return -EINVAL;
> > +       if (!capable(CAP_SYS_ADMIN))
> > +               return -EPERM;
> 
> How does this capable() check interact with io_uring? Without having
> looked at this in detail, I suspect that when an encoded write is
> requested through io_uring, the capable() check might be executed on
> something like a workqueue worker thread, which is probably running
> with a full capability set.

I discussed this more with Jens. You're right, per-IO permission checks
aren't going to work. In fully-polled mode, we never get an opportunity
to check capabilities in right context. So, this will probably require a
new open flag.
