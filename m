From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 07/30] aio: add delayed cancel support
Date: Wed, 28 Mar 2018 17:35:26 +0100
Message-ID: <20180328163526.GV30522@ZenIV.linux.org.uk>
References: <20180328072926.17131-1-hch@lst.de>
 <20180328072926.17131-8-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180328072926.17131-8-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 28, 2018 at 09:29:03AM +0200, Christoph Hellwig wrote:
>  static void aio_fsync_work(struct work_struct *work)
>  {
>  	struct fsync_iocb *req = container_of(work, struct fsync_iocb, work);
> +	struct aio_kiocb *iocb = container_of(req, struct aio_kiocb, fsync);
> +	struct file *file = req->file;
>  	int ret;
>  
>  	ret = vfs_fsync(req->file, req->datasync);
> -	fput(req->file);
> -	aio_complete(container_of(req, struct aio_kiocb, fsync), ret, 0);
> +	if (aio_complete(iocb, ret, 0, 0))
> +		fput(file);

IDGI.
	1) can aio_complete() ever return false here?
	2) do we ever have aio_kiocb that would not have an associated
struct file * that needs to be dropped on successful aio_complete()?  AFAICS,
rw, fsync and poll variants all have one, and I'm not sure what kind of
async IO *could* be done without an opened file.
