From: Christoph Hellwig <hch@lst.de>
Subject: generic RDMA READ/WRITE API V2
Date: Thu,  3 Mar 2016 16:03:57 +0100
Message-ID: <1457017443-17662-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk, axboe@fb.com
Cc: milosz@adfin.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This series contains patches that implement a first version of a generi=
c
API to handle RDMA READ/WRITE operations as commonly used on the target
(or server) side for storage protocols.

This has been developed for the upcoming NVMe over Fabrics target, and
extensively te=D1=95ted as part of that, although this upstream version=
 has
additional updates over the one we're currently using.

It hides details such as the use of MRs for iWarp devices, and will all=
ow
looking at other HCA specifics easily in the future.

This series contains a conversion of the SRP target, and the git tree
below also has a RFC conversion of the iSER target (a little hacky
due to the signature MR support which I can't test)

I also have a git tree available at:

	git://git.infradead.org/users/hch/rdma.git rdma-rw-api

Gitweb:

	http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/rdma-r=
w-api

These two also include the RFC iSER target conversion.

Chances since V2:
 - fold the list_del in mr_pool_get into the right patch
 - clamp the max FR page size length
 - minor srpt style fix
 - spelling fixes

Changes since V1:
 - fixed offset handling in ib_sg_to_pages
 - uses proper SG iterators to handle larger than PAGE_SIZE segments
 - adjusted parameters for some functions to reduce size of the context
 - SRP target support

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
