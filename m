From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Fri, 11 Mar 2016 10:12:13 +0530
Message-ID: <56E24CA5.3030702@redhat.com>
References: <20160302040947.16685.42926.stgit@birch.djwong.org>
 <CA+55aFx_NPn0VYk=+Ad5S_r=D6J1xFmWmf7JzQ7RmkwKmdkYOg@mail.gmail.com>
 <20160302225601.GB21890@birch.djwong.org>
 <CA+55aFyNPnjJ-Nsu3bMr+HuLQnkj1B8FMddNnXW7HJqxdUzJmQ@mail.gmail.com>
 <yq1bn6v8mqg.fsf@sermon.lab.mkp.net> <20160303180924.GA4116@infradead.org>
 <yq1vb5375oh.fsf@sermon.lab.mkp.net> <20160303223952.GE24012@thunk.org>
 <20160303231050.GU29057@dastard>
 <CAC6JEv-HeAoRxSmVghGvbX7G92yH00k-5F-48qEW13vAB1Q99g@mail.gmail.com>
 <20160309230819.GB3949@thunk.org> <56E18B9B.5070503@gmail.com>
 <CA+55aFyw1nN4ze3-AGGE27evOZuXnkJC9C-W5QRUR=zKHqObGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyw1nN4ze3-AGGE27evOZuXnkJC9C-W5QRUR=zKHqObGg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Gregory Farnum <greg@gregs42.com>, Dave Chinner <david@fromorbit.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Eric Sandeen <esandeen@redhat.com>
List-Id: linux-api@vger.kernel.org

On 03/11/2016 12:03 AM, Linus Torvalds wrote:
> On Thu, Mar 10, 2016 at 6:58 AM, Ric Wheeler <ricwheeler@gmail.com> wrote:
>> What was objectionable at the time this patch was raised years back (not
>> just to me, but to pretty much every fs developer at LSF/MM that year)
>> centered on the concern that this would be viewed as a "performance" mode
>> and we get pressure to support this for non-priveleged users. It gives any
>> user effectively the ability to read the block device content for previously
>> allocated data without restriction.
> The sane way to do it would be to just check permissions of the
> underlying block device.
>
> That way, people can just set the permissions for that to whatever
> they want. If google right now uses some magical group for this, they
> could make the underlying block device be writable for that group.
>
> We can do the security check at the filesystem level, because we have
> sb->s_bdev->bd_inode, and if you have read and write permissions to
> that inode, you might as well have permission to create a unsafe hole.
>
> That doesn't sound very hacky to me.
>
>                 Linus

I agree that this sounds quite reasonable.

Ric
