From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [RFC PATCH 2/3] fs: add RWF_ENCODED for writing compressed data
Date: Wed, 25 Sep 2019 11:08:32 -0400
Message-ID: <20190925150832.GA20227@mit.edu>
References: <cover.1568875700.git.osandov@fb.com>
 <230a76e65372a8fb3ec62ce167d9322e5e342810.1568875700.git.osandov@fb.com>
 <CAG48ez2GKv15Uj6Wzv0sG5v2bXyrSaCtRTw5Ok_ovja_CiO_fQ@mail.gmail.com>
 <20190924171513.GA39872@vader>
 <20190924193513.GA45540@vader>
 <CAG48ez1NQBNR1XeVQYGoopEk=g_KedUr+7jxLQTaO+V8JCeweQ@mail.gmail.com>
 <20190925071129.GB804@dread.disaster.area>
 <60c48ac5-b215-44e1-a628-6145d84a4ce3@www.fastmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <60c48ac5-b215-44e1-a628-6145d84a4ce3@www.fastmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Colin Walters <walters@verbum.org>
Cc: Dave Chinner <david@fromorbit.com>, Jann Horn <jannh@google.com>, Omar Sandoval <osandov@osandov.com>, Aleksa Sarai <cyphar@cyphar.com>, Jens Axboe <axboe@kernel.dk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Kernel Team <kernel-team@fb.com>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Sep 25, 2019 at 08:07:12AM -0400, Colin Walters wrote:
> 
> 
> On Wed, Sep 25, 2019, at 3:11 AM, Dave Chinner wrote:
> >
> > We're talking about user data read/write access here, not some
> > special security capability. Access to the data has already been
> > permission checked, so why should the format that the data is
> > supplied to the kernel in suddenly require new privilege checks?
> 
> What happens with BTRFS today if userspace provides invalid
> compressed data via this interface?  Does that show up as filesystem
> corruption later?  If the data is verified at write time, wouldn't
> that be losing most of the speed advantages of providing
> pre-compressed data?

Not necessarily, most compression algorithms are far more expensive to
compress than to decompress.

If there is a buggy decompressor, it's possible that invalid data
could result in a buffer overrun.  So that's an argument for verifying
the compressed code at write time.  OTOH, the verification could be
just as vulnerability to invalid data as the decompressor, so it
doesn't buy you that much.

> Ability for a user to cause fsck errors later would be a new thing
> that would argue for a privilege check I think.

Well, if it's only invalid data in a user file, there's no reason why
it should cause the kernel declare that the file system is corrupt; it
can just return EIO.

What fsck does is a different question, of course; it might be that
the fsck code isn't going to check compressed user data.  After all,
if all of the files on the file system are compressed, requiring fsck
to check all compressed data blocks is tantamount to requiring it to
read all of the blocks in the file system.  Much better would be some
kind of online scrub operation which validates data files while the
file system is mounted and the system can be in a serving state.

						- Ted
