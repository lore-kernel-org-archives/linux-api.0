From: Chris Mason <clm@fb.com>
Subject: Re: [RFC PATCH 2/3] add RWF_ENCODED for writing compressed data
Date: Wed, 25 Sep 2019 14:56:15 +0000
Message-ID: <FF3F534F-B40D-4D7D-956B-F1B63C4751CC@fb.com>
References: <cover.1568875700.git.osandov@fb.com>
 <230a76e65372a8fb3ec62ce167d9322e5e342810.1568875700.git.osandov@fb.com>
 <CAG48ez2GKv15Uj6Wzv0sG5v2bXyrSaCtRTw5Ok_ovja_CiO_fQ@mail.gmail.com>
 <20190924171513.GA39872@vader> <20190924193513.GA45540@vader>
 <CAG48ez1NQBNR1XeVQYGoopEk=g_KedUr+7jxLQTaO+V8JCeweQ@mail.gmail.com>
 <20190925071129.GB804@dread.disaster.area>
 <60c48ac5-b215-44e1-a628-6145d84a4ce3@www.fastmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <60c48ac5-b215-44e1-a628-6145d84a4ce3@www.fastmail.com>
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
To: Colin Walters <walters@verbum.org>
Cc: Dave Chinner <david@fromorbit.com>, Jann Horn <jannh@google.com>, Omar Sandoval <osandov@osandov.com>, Aleksa Sarai <cyphar@cyphar.com>, Jens Axboe <axboe@kernel.dk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On 25 Sep 2019, at 8:07, Colin Walters wrote:

> On Wed, Sep 25, 2019, at 3:11 AM, Dave Chinner wrote:
>>
>> We're talking about user data read/write access here, not some
>> special security capability. Access to the data has already been
>> permission checked, so why should the format that the data is
>> supplied to the kernel in suddenly require new privilege checks?
>
> What happens with BTRFS today if userspace provides invalid compressed=20
> data via this interface?  Does that show up as filesystem corruption=20
> later?  If the data is verified at write time, wouldn't that be losing=20
> most of the speed advantages of providing pre-compressed data?

The data is verified while being decompressed, but that's a fairly large=20
fuzzing surface (all of zstd, zlib, and lzo).  A lot of people will=20
correctly argue that we already have that fuzzing surface today, but I'd=20
rather not make a really easy way to stuff arbitrary bytes through the=20
kernel decompression code until all the projects involved sign off.

-chris
