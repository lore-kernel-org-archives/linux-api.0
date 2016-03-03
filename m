From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: generic RDMA READ/WRITE API V2
Date: Thu, 3 Mar 2016 17:09:41 +0200
Message-ID: <56D853B5.9000906@dev.mellanox.co.il>
References: <1457017443-17662-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1457017443-17662-1-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, axboe@fb.com
Cc: milosz@adfin.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


> This series contains patches that implement a first version of a gene=
ric
> API to handle RDMA READ/WRITE operations as commonly used on the targ=
et
> (or server) side for storage protocols.
>
> This has been developed for the upcoming NVMe over Fabrics target, an=
d
> extensively te=D1=95ted as part of that, although this upstream versi=
on has
> additional updates over the one we're currently using.
>
> It hides details such as the use of MRs for iWarp devices, and will a=
llow
> looking at other HCA specifics easily in the future.
>
> This series contains a conversion of the SRP target, and the git tree
> below also has a RFC conversion of the iSER target (a little hacky
> due to the signature MR support which I can't test)
>
> I also have a git tree available at:
>
> 	git://git.infradead.org/users/hch/rdma.git rdma-rw-api
>
> Gitweb:
>
> 	http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/rdma=
-rw-api
>
> These two also include the RFC iSER target conversion.

Heh... Looks like you got your cover-letters mixed up :)
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
