From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC] failure atomic writes for file systems and block devices
Date: Wed, 1 Mar 2017 13:21:41 +0200
Message-ID: <CAOQ4uxjYwP+XGdDu-HiKmiAVEFydqYj6xfQbaKULB9WWUSuX5g@mail.gmail.com>
References: <20170228145737.19016-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170228145737.19016-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, linux-api@vger.kernel.org, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 28, 2017 at 4:57 PM, Christoph Hellwig <hch@lst.de> wrote:
> Hi all,
>
> this series implements a new O_ATOMIC flag for failure atomic writes
> to files.   It is based on and tries to unify to earlier proposals,
> the first one for block devices by Chris Mason:
>
>         https://lwn.net/Articles/573092/
>
> and the second one for regular files, published by HP Research at
> Usenix FAST 2015:
>
>         https://www.usenix.org/conference/fast15/technical-sessions/presentation/verma
>
> It adds a new O_ATOMIC flag for open, which requests writes to be
> failure-atomic, that is either the whole write makes it to persistent
> storage, or none of it, even in case of power of other failures.
>
> There are two implementation various of this:  on block devices O_ATOMIC
> must be combined with O_(D)SYNC so that storage devices that can handle
> large writes atomically can simply do that without any additional work.
> This case is supported by NVMe.
>
> The second case is for file systems, where we simply write new blocks
> out of places and then remap them into the file atomically on either
> completion of an O_(D)SYNC write or when fsync is called explicitly.
>
> The semantics of the latter case are explained in detail at the Usenix
> paper above.
>
> Last but not least a new fcntl is implemented to provide information
> about I/O restrictions such as alignment requirements and the maximum
> atomic write size.
>
> The implementation is simple and clean, but I'm rather unhappy about
> the interface as it has too many failure modes to bullet proof.  For
> one old kernels ignore unknown open flags silently, so applications
> have to check the F_IOINFO fcntl before, which is a bit of a killer.
> Because of that I've also not implemented any other validity checks
> yet, as they might make thing even worse when an open on a not supported
> file system or device fails, but not on an old kernel.  Maybe we need
> a new open version that checks arguments properly first?
>

[CC += linux-api@vger.kernel.org] for that question and for the new API

> Also I'm really worried about the NVMe failure modes - devices simply
> advertise an atomic write size, with no way for the device to know
> that the host requested a given write to be atomic, and thus no
> error reporting.  This is made worse by NVMe 1.2 adding per-namespace
> atomic I/O parameters that devices can use to introduce additional
> odd alignment quirks - while there is some language in the spec
> requiring them not to weaken the per-controller guarantees it all
> looks rather weak and I'm not too confident in all implementations
> getting everything right.
>
> Last but not least this depends on a few XFS patches, so to actually
> apply / run the patches please use this git tree:
>
>     git://git.infradead.org/users/hch/vfs.git O_ATOMIC
>
> Gitweb:
>
>     http://git.infradead.org/users/hch/vfs.git/shortlog/refs/heads/O_ATOMIC
