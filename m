From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/3] block: require write_same and discard requests align
 to logical block size
Date: Fri, 4 Mar 2016 19:02:19 -0800
Message-ID: <CA+55aFwVUs29-GPcVBtGQ=fjZbYTJz4KFc=C7Ej+V8UKvmBBhA@mail.gmail.com>
References: <20160305005556.29738.66782.stgit@birch.djwong.org>
	<20160305005610.29738.18727.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160305005610.29738.18727.stgit@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux API <linux-api@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 4, 2016 at 4:56 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> +       bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
> +       if ((sector & bs_mask) || ((sector + nr_sects) & bs_mask))
> +               return -EINVAL;

This test may _work_, but it's kind of crazily overly complicated.

The sane test would be just "are the start and length aligned":

        if ((sector & bs_mask) || (nr_sects & bs_mask))
                return -EINVAL;

and the *smart* test is simpler still, and asks "are there invalid
bits in either the start or the length":

        if ((sector | nr_sects) & bs_mask)
                return -EINVAL:

I suspect either of these would be fine, and the compiler may even
notice that there's the smart way of doing it.

The compiler *might* even notice that the original version can be
simplified and generate sane code.

But I think that original version is not only overly complicated, it's
also actually less obvious than the simpler versions, if only because
the whole conditional is so big that you have to actively parse it.

That last shortest form is actually so simple that I think it's the
easiest to understand too - the conditional is simply so small that it
doesn't take a lot of effort to see what it does.

            Linus
