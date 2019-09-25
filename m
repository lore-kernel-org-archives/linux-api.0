From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 2/3] fs: add RWF_ENCODED for writing compressed data
Date: Thu, 26 Sep 2019 08:52:43 +1000
Message-ID: <20190925225243.GF804@dread.disaster.area>
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
Cc: Jann Horn <jannh@google.com>, Omar Sandoval <osandov@osandov.com>, Aleksa Sarai <cyphar@cyphar.com>, Jens Axboe <axboe@kernel.dk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Kernel Team <kernel-team@fb.com>, Andy Lutomirski <luto@kernel.org>
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
> What happens with BTRFS today if userspace provides invalid compressed
> data via this interface?

Then the filesystem returns EIO or ENODATA on read because it can't
decompress it.

User can read it back in compressed format (i.e. same way they wrote
it), try to fix it themselves.

> Does that show up as filesystem corruption later?

Nope. Just bad user data.

> If the data is verified at write time, wouldn't that be losing most of the speed advantages of providing pre-compressed data?

It's a direct IO interface. User writes garbage, then they get
garbage back. The user can still retreive the compressed data
directly, so the data is not lost....

> Ability for a user to cause fsck errors later would be a new thing
> that would argue for a privilege check I think.

fsck doesn't validate the correctness of user data - it validates
the filesystem structure is consistent. i.e. user data in unreadable
format != corrupt filesystem structure.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
