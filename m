From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [RFC PATCH 2/3] add RWF_ENCODED for writing compressed data
Date: Thu, 26 Sep 2019 10:46:09 -0700
Message-ID: <20190926174609.GA18238@vader>
References: <cover.1568875700.git.osandov@fb.com>
 <230a76e65372a8fb3ec62ce167d9322e5e342810.1568875700.git.osandov@fb.com>
 <CAG48ez2GKv15Uj6Wzv0sG5v2bXyrSaCtRTw5Ok_ovja_CiO_fQ@mail.gmail.com>
 <20190924171513.GA39872@vader>
 <20190924193513.GA45540@vader>
 <CAG48ez1NQBNR1XeVQYGoopEk=g_KedUr+7jxLQTaO+V8JCeweQ@mail.gmail.com>
 <20190925071129.GB804@dread.disaster.area>
 <60c48ac5-b215-44e1-a628-6145d84a4ce3@www.fastmail.com>
 <FF3F534F-B40D-4D7D-956B-F1B63C4751CC@fb.com>
 <4e6e03c1-b2f4-4841-99af-cbb75f33c14d@www.fastmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4e6e03c1-b2f4-4841-99af-cbb75f33c14d@www.fastmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Colin Walters <walters@verbum.org>
Cc: Chris Mason <clm@fb.com>, Dave Chinner <david@fromorbit.com>, Jann Horn <jannh@google.com>, Aleksa Sarai <cyphar@cyphar.com>, Jens Axboe <axboe@kernel.dk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 26, 2019 at 08:17:12AM -0400, Colin Walters wrote:
> 
> 
> On Wed, Sep 25, 2019, at 10:56 AM, Chris Mason wrote:
> 
> > The data is verified while being decompressed, but that's a fairly large 
> > fuzzing surface (all of zstd, zlib, and lzo).  A lot of people will 
> > correctly argue that we already have that fuzzing surface today, but I'd 
> > rather not make a really easy way to stuff arbitrary bytes through the 
> > kernel decompression code until all the projects involved sign off.
> 
> Right.  So maybe have this start of as a BTRFS ioctl and require
> privileges?   I assume that's sufficient for what Omar wants.

That was the first version of this series, but Dave requested that I
make it generic [1].

> (Are there actually any other popular Linux filesystems that do transparent compression anyways?)

A scan over the kernel tree shows that a few other filesystems do
compression:

- jffs2
- pstore (if you can call that a filesystem)
- ubifs
- cramfs (read-only)
- erofs (read-only)
- squashfs (read-only)

None of the "mainstream" general-purpose filesystems have support, but
that was also the case for reflink/dedupe before XFS added support.

1: https://lore.kernel.org/linux-fsdevel/20190905021012.GL7777@dread.disaster.area/
