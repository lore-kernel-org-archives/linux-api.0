From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [RFC PATCH v2 0/5] fs: interface for directly reading/writing
 compressed data
Date: Mon, 21 Oct 2019 12:04:18 -0700
Message-ID: <20191021190418.GC81648@vader>
References: <cover.1571164762.git.osandov@fb.com>
 <c7e8f93596fee7bb818dc0edf29f484036be1abb.1571164851.git.osandov@fb.com>
 <cover.1571164762.git.osandov@fb.com>
 <20191020230501.GA8080@dread.disaster.area>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191020230501.GA8080@dread.disaster.area>
Sender: linux-btrfs-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, Jann Horn <jannh@google.com>, linux-api@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org

On Mon, Oct 21, 2019 at 10:05:01AM +1100, Dave Chinner wrote:
> On Tue, Oct 15, 2019 at 11:42:38AM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > Hello,
> > 
> > This series adds an API for reading compressed data on a filesystem
> > without decompressing it as well as support for writing compressed data
> > directly to the filesystem. It is based on my previous series which
> > added a Btrfs-specific ioctl [1], but it is now an extension to
> > preadv2()/pwritev2() as suggested by Dave Chinner [2]. I've included a
> > man page patch describing the API in detail. Test cases and examples
> > programs are available [3].
> > 
> > The use case that I have in mind is Btrfs send/receive: currently, when
> > sending data from one compressed filesystem to another, the sending side
> > decompresses the data and the receiving side recompresses it before
> > writing it out. This is wasteful and can be avoided if we can just send
> > and write compressed extents. The send part will be implemented in a
> > separate series, as this API can stand alone.
> > 
> > Patches 1 and 2 add the VFS support. Patch 3 is a Btrfs prep patch.
> > Patch 4 implements encoded reads for Btrfs, and patch 5 implements
> > encoded writes.
> > 
> > Changes from v1 [4]:
> > 
> > - Encoded reads are now also implemented.
> > - The encoded_iov structure now includes metadata for referring to a
> >   subset of decoded data. This is required to handle certain cases where
> >   a compressed extent is truncated, hole punched, or otherwise sliced up
> >   and Btrfs chooses to reflect this in metadata instead of decompressing
> >   the whole extent and rewriting the pieces. We call these "bookend
> >   extents" in Btrfs, but any filesystem supporting transparent encoding
> >   is likely to have a similar concept.
> 
> Where's the in-kernel documentation for this API? You're encoding a
> specific set of behaviours into the user API, so this needs a whole
> heap of documentation in the generic code to describe how it works
> so that other filesystems implementing have a well defined guideline
> to what they need to support.

The man-page I sent is quite detailed, but sure, I can add the relevant
information to the generic code, as well.

> Also, I don't see any test code for this -

It's in the cover letter: https://github.com/osandov/xfstests/tree/rwf-encoded

I haven't sent those patches up because it's tedious to rework and
resend them for each little tweak we make to the API.

> can you please add
> support for RWF_ENCODED to xfs_io and write a suite of unit tests
> for fstests that exercise the user API fully?

Reading requires filesystem-specific decoding, and I wasn't sure if that
would be a good fit for xfs_io. Alternatively, it could dump the raw
buffer to stdout, but whatever interprets it also needs the metadata, so
there'd need to be some sort of protocol between xfs_io and whatever
interprets it. I added a btrfs_read_encoded program in my xfstests
branch above instead. It should be easy enough to move the encoded_write
test program to xfs_io pwrite, though.

> Given our history of
> screwing up new user APIs, this absolutely should not be merged
> until there is a full set of generic unit tests written and reviewed
> for it and support has been added to fsstress, fsx, and other test
> utilities to fuzz and stress the implementation as part of normal
> day-to-day filesystem development...

Sure thing, I'll add support to those tools once the API isn't in flux
so much.
