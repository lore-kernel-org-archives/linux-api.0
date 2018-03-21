From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 6/9] aio: delete iocbs from the active_reqs list in
 kiocb_cancel
Date: Wed, 21 Mar 2018 10:17:25 +0100
Message-ID: <20180321091725.GN14085@kroah.com>
References: <20180321073232.13366-1-hch@lst.de>
 <20180321073232.13366-7-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180321073232.13366-7-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 21, 2018 at 08:32:29AM +0100, Christoph Hellwig wrote:
> One we cancel an iocb there is no reason to keep it on the active_reqs
> list, given that the list is only used to look for cancelation candidates.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Jeff Moyer <jmoyer@redhat.com>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
