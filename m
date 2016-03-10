From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Thu, 10 Mar 2016 20:28:35 +0530
Message-ID: <56E18B9B.5070503@gmail.com>
References: <20160302040947.16685.42926.stgit@birch.djwong.org>
 <CA+55aFx_NPn0VYk=+Ad5S_r=D6J1xFmWmf7JzQ7RmkwKmdkYOg@mail.gmail.com>
 <20160302225601.GB21890@birch.djwong.org>
 <CA+55aFyNPnjJ-Nsu3bMr+HuLQnkj1B8FMddNnXW7HJqxdUzJmQ@mail.gmail.com>
 <yq1bn6v8mqg.fsf@sermon.lab.mkp.net> <20160303180924.GA4116@infradead.org>
 <yq1vb5375oh.fsf@sermon.lab.mkp.net> <20160303223952.GE24012@thunk.org>
 <20160303231050.GU29057@dastard>
 <CAC6JEv-HeAoRxSmVghGvbX7G92yH00k-5F-48qEW13vAB1Q99g@mail.gmail.com>
 <20160309230819.GB3949@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160309230819.GB3949@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Gregory Farnum <greg@gregs42.com>, Dave Chinner <david@fromorbit.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Eric Sandeen <esandeen@redhat.com>
List-Id: linux-api@vger.kernel.org

On 03/10/2016 04:38 AM, Theodore Ts'o wrote:
> On Wed, Mar 09, 2016 at 02:20:31PM -0800, Gregory Farnum wrote:
>> I really am sensitive to the security concerns, just know that if it's
>> a permanent blocker you're essentially blocking out a growing category
>> of disk users (who run on an awfully large number of disks!).
> Or they just have to use kernels with out-of-tree patches installed.  :-P
>
> If you want to consider how many disks Google has that are using this
> patch, I probably could have appealed to Linus and asked him to accept
> the patch if I forced the issue.  The only reason why I didn't was
> that people like Ric Wheeler threatened to have distro-specific
> patches to disable the feature, and at the end of the day, I didn't
> care that much.  After all, if it makes it harder for large scale
> cloud companies besides Google to create more efficient userspace
> cluster file systems, it's not like I was keeping the patch a secret.
>
> So ultimately, if the Ceph developers want to make a case to Red Hat
> management that this is important, great.  If not, it's not that hard
> for those people who need the patch and who are running large cloud
> infrastructures to simply apply the out-of-tree patch if they need it.
>
> Cheers,
>
>     	     	     	 	      		  - Ted
>

What was objectionable at the time this patch was raised years back (not just to 
me, but to pretty much every fs developer at LSF/MM that year) centered on the 
concern that this would be viewed as a "performance" mode and we get pressure to 
support this for non-priveleged users. It gives any user effectively the ability 
to read the block device content for previously allocated data without restriction.

At the time, I also don't recall seeing the patch posted on upstream lists for 
debate or justification.

As we discussed a few weeks back, I don't object to having support for doing 
this in carefully controlled ways for things like user space file systems. In 
effect, the problem of preventing other people's data being handed over to the 
end user is taken on by that layer of code. I suspect that fits the use case at 
google and Ceph both.

Regards,

Ric



