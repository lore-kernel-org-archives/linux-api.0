From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v4 00/16] fs-verity: read-only file-based
 authenticity protection
Date: Thu, 6 Jun 2019 12:43:44 -0700
Message-ID: <20190606194343.GA84833@gmail.com>
References: <20190606155205.2872-1-ebiggers@kernel.org>
 <CAHk-=wgSzRzoro8ATO5xb6OFxN1A0fjUCQSAHfGuEPbEu+zWvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <CAHk-=wgSzRzoro8ATO5xb6OFxN1A0fjUCQSAHfGuEPbEu+zWvA@mail.gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Y . Ts'o" <tytso@mit.edu>, "Darrick J . Wong" <darrick.wong@oracle.com>, Linux API <linux-api@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, linux-integrity@vger.kernel.org, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Victor Hsieh <victorhsieh@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 06, 2019 at 10:21:12AM -0700, Linus Torvalds wrote:
> On Thu, Jun 6, 2019 at 8:54 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > This is a redesigned version of the fs-verity patchset, implementing
> > Ted's suggestion to build the Merkle tree in the kernel
> > (https://lore.kernel.org/linux-fsdevel/20190207031101.GA7387@mit.edu/).
> > This greatly simplifies the UAPI, since the verity metadata no longer
> > needs to be transferred to the kernel.
> 
> Interfaces look sane to me. My only real concern is whether it would
> make sense to make the FS_IOC_ENABLE_VERITY ioctl be something that
> could be done incrementally, since the way it is done now it looks
> like any random user could create a big file and then do the
> FS_IOC_ENABLE_VERITY to make the kernel do a _very_ expensive
> operation.
> 
> Yes, I see the
> 
> +               if (fatal_signal_pending(current))
> +                       return -EINTR;
> +               cond_resched();
> 
> in there, so it's not like it's some entirely unkillable thing, and
> maybe we don't care as a result. But maybe the ioctl interface could
> be fundamentally restartable?
> 
> If that was already considered and people just went "too complex", never mind.
> 
>                Linus

Making it incremental would be complex.  We could make FS_IOC_ENABLE_VERITY
write checkpoints periodically, and make it resume from the checkpoint if
present.  But then we'd have to worry about sync'ing the Merkle tree before
writing each checkpoint, and storing the Merkle tree parameters in each
checkpoint so that if the second call to FS_IOC_ENABLE_VERITY is made with
different parameters it knows to delete everything and restart from scratch.

Or we could make it explicit in the UAPI, where userspace calls ioctls to build
blocks 0 through 9999, then 10000 through 19999, etc.  But that would make the
UAPI much more complex, and the kernel would need to do lots of extra validation
of the parameters passed in.  This approach would also not be crash-safe unless
userspace did its own checkpointing, whereas the all-or-nothing API naturally
avoids inconsistent states.

And either way of making it incremental, the "partial Merkle tree" would also
become a valid on-disk state.  Conceptually that adds a lot of complexity, and
probably people would want fsck to support removing all the partial trees,
similar to how e2fsck supports optimizing directories and extent trees.

So in the end, it's not something I decided to add.

- Eric
