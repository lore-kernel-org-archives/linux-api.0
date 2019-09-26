From: "Colin Walters" <walters@verbum.org>
Subject: Re: [RFC PATCH 2/3] add RWF_ENCODED for writing compressed data
Date: Thu, 26 Sep 2019 08:17:12 -0400
Message-ID: <4e6e03c1-b2f4-4841-99af-cbb75f33c14d@www.fastmail.com>
References: <cover.1568875700.git.osandov@fb.com>
 <230a76e65372a8fb3ec62ce167d9322e5e342810.1568875700.git.osandov@fb.com>
 <CAG48ez2GKv15Uj6Wzv0sG5v2bXyrSaCtRTw5Ok_ovja_CiO_fQ@mail.gmail.com>
 <20190924171513.GA39872@vader> <20190924193513.GA45540@vader>
 <CAG48ez1NQBNR1XeVQYGoopEk=g_KedUr+7jxLQTaO+V8JCeweQ@mail.gmail.com>
 <20190925071129.GB804@dread.disaster.area>
 <60c48ac5-b215-44e1-a628-6145d84a4ce3@www.fastmail.com>
 <FF3F534F-B40D-4D7D-956B-F1B63C4751CC@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <FF3F534F-B40D-4D7D-956B-F1B63C4751CC@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Chris Mason <clm@fb.com>
Cc: Dave Chinner <david@fromorbit.com>, Jann Horn <jannh@google.com>, Omar Sandoval <osandov@osandov.com>, Aleksa Sarai <cyphar@cyphar.com>, Jens Axboe <axboe@kernel.dk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org



On Wed, Sep 25, 2019, at 10:56 AM, Chris Mason wrote:

> The data is verified while being decompressed, but that's a fairly large 
> fuzzing surface (all of zstd, zlib, and lzo).  A lot of people will 
> correctly argue that we already have that fuzzing surface today, but I'd 
> rather not make a really easy way to stuff arbitrary bytes through the 
> kernel decompression code until all the projects involved sign off.

Right.  So maybe have this start of as a BTRFS ioctl and require
privileges?   I assume that's sufficient for what Omar wants.

(Are there actually any other popular Linux filesystems that do transparent compression anyways?)
