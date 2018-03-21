From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 9/9] aio: implement IOCB_CMD_FSYNC and IOCB_CMD_FDSYNC
Date: Wed, 21 Mar 2018 10:30:49 +0100
Message-ID: <20180321093049.GA7285@lst.de>
References: <20180321073232.13366-1-hch@lst.de> <20180321073232.13366-10-hch@lst.de> <20180321092713.GR14085@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180321092713.GR14085@kroah.com>
Sender: owner-linux-aio@kvack.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 21, 2018 at 10:27:13AM +0100, Greg KH wrote:
> I hate the "bool" arguments to functions as you always need to go back
> and look them up.  A "wrapper" of "aio_fsync_datasync()" and
> "aio_fsync_nodatasync()" around this maybe?

This is how the fsync API works.  Wrappers really don't help anything,
although flags would certainly be nicer.  Next time I need to touch
->fsync for one reason or another that is high on the todo list.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
