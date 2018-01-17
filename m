From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 32/32] aio: implement io_pgetevents
Date: Wed, 17 Jan 2018 04:27:21 +0000
Message-ID: <20180117042721.GT13338@ZenIV.linux.org.uk>
References: <20180110155853.32348-1-hch@lst.de>
 <20180110155853.32348-33-hch@lst.de>
 <x49k1wmdcxn.fsf@segfault.boston.devel.redhat.com>
 <20180115085310.GB32532@lst.de>
 <20180116120433.GA14579@lst.de>
 <x493735b9l7.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <x493735b9l7.fsf@segfault.boston.devel.redhat.com>
Sender: owner-linux-aio@kvack.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Jan 16, 2018 at 07:41:24PM -0500, Jeff Moyer wrote:
>  	if (sigmask) {
> -		if (copy_from_user(&ksigmask, sigmask, sizeof(ksigmask)))
> +		if (!access_ok(VERIFY_READ, sigmask,
> +			       sizeof(void *) + sizeof(size_t)) ||
> +		    __get_user(up, (sigset_t __user * __user *)sigmask) ||
> +		    __get_user(sigsetsize,
> +			       (size_t __user *)(sigmask + sizeof(void *))))
>  			return -EFAULT;

How about copy_from_user() on a struct?  Making eyes bleed is fun, but
people tend to get annoyed when you do it to them...

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
