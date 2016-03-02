From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v5.1 0/2] create BLKZEROOUT ioctl that invalidates page cache
Date: Tue, 01 Mar 2016 20:09:32 -0800
Message-ID: <20160302040932.16685.62789.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, hch@infradead.org, akpm@linux-foundation.org, torvalds@linux-foundation.org, darrick.wong@oracle.com
Cc: martin.petersen@oracle.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, shane.seymour@hpe.com, bfields@fieldses.org, linux-fsdevel@vger.kernel.org, jlayton@poochiereds.net
List-Id: linux-api@vger.kernel.org

Hi,

This is (yet another) repost of the patch series that fixes the
existing BLKZEROOUT ioctl to invalidate the page cache if the zeroing
command to the underlying device succeeds.  This patch is against
4.5-rc6 and hasn't changed much in months.

The new BLKZEROOUT ioctl has the same semantics as the old one, but it
invalidates the page cache to prevent surprising results, just like
how dio writes invalidate page cache.

I've incorporated all the feedback I've received into these patches,
but haven't heard yea or nay or anything at all from the maintainer.
Will someone please pick this up for 4.6?

Comments and questions are, as always, welcome.

--D
