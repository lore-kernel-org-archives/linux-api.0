From: Trond Myklebust <trond.myklebust@primarydata.com>
Subject: Re: [PATCH v5 8/9] vfs: Add vfs_copy_file_range() support for
 pagecache copies
Date: Mon, 12 Oct 2015 23:36:31 -0400
Message-ID: <CAHQdGtQoV0g1p2FYC1vFtFwh=jNq5n+AYOxAuSORVfbfhRY1Hg@mail.gmail.com>
References: <1443634014-3026-1-git-send-email-Anna.Schumaker@Netapp.com>
	<1443634014-3026-9-git-send-email-Anna.Schumaker@Netapp.com>
	<20151011142203.GA31867@infradead.org>
	<20151012231749.GC11398@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20151012231749.GC11398@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Anna Schumaker <Anna.Schumaker@netapp.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux API Mailing List <linux-api@vger.kernel.org>, Zach Brown <zab@zabbo.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Chris Mason <clm@fb.com>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, William Andros Adamson <andros@netapp.com>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 12, 2015 at 7:17 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Sun, Oct 11, 2015 at 07:22:03AM -0700, Christoph Hellwig wrote:
>> On Wed, Sep 30, 2015 at 01:26:52PM -0400, Anna Schumaker wrote:
>> > This allows us to have an in-kernel copy mechanism that avoids frequent
>> > switches between kernel and user space.  This is especially useful so
>> > NFSD can support server-side copies.
>> >
>> > I make pagecache copies configurable by adding three new (exclusive)
>> > flags:
>> > - COPY_FR_REFLINK tells vfs_copy_file_range() to only create a reflink.
>> > - COPY_FR_COPY does a full data copy, but may be filesystem accelerated.
>> > - COPY_FR_DEDUP creates a reflink, but only if the contents of both
>> >   ranges are identical.
>>
>> All but FR_COPY really should be a separate system call.  Clones (an
>> dedup as a special case of clones) are really a separate beast from file
>> copies.
>>
>> If I want to clone a file I either want it clone fully or fail, not copy
>> a certain amount.  That means that a) we need to return an error not
>> short "write", and b) locking impementations are important - we need to
>> prevent other applications from racing with our clone even if it is
>> large, while to get these semantics for the possible short returning
>> file copy will require a proper userland locking protocol. Last but not
>> least file copies need to be interruptible while clones should be not.
>> All this is already important for local file systems and even more
>> important for NFS exporting.
>>
>> So I'd suggest to drop this patch and just let your syscall handle
>> actualy copies with all their horrors.  We can go with Peng's patches
>> to generalize the btrfs ioctls for clones for now which is what everyone
>> already uses anyway, and then add a separate sys_file_clone later.
>
> Hm.  Peng's patches only generalize the CLONE and CLONE_RANGE ioctls from
> btrfs, however they don't port over the (vastly different) EXTENT_SAME ioctl.
>
> What does everyone think about generalizing EXTENT_SAME?  The interface enables
> one to ask the kernel to dedupe multiple file ranges in a single call.  That's
> more complex than what I was proposing with COPY_FR_DEDUP(E), but I'm assuming
> that the extra complexity buys us the ability to ... multi-dedupe at the same
> time, with locks held on the source file?

How is this supposed to be implemented on something like NFS without
protocol changes?

Trond
