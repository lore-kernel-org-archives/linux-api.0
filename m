From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/9] aio: sanitize ki_list handling
Date: Thu, 22 Mar 2018 18:04:05 +0100
Message-ID: <20180322170405.GB5542@lst.de>
References: <20180321073232.13366-1-hch@lst.de> <20180321073232.13366-5-hch@lst.de> <20180322152414.GF30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180322152414.GF30522@ZenIV.linux.org.uk>
Sender: owner-linux-aio@kvack.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 22, 2018 at 03:24:14PM +0000, Al Viro wrote:
> On Wed, Mar 21, 2018 at 08:32:27AM +0100, Christoph Hellwig wrote:
> 
> > -	if (iocb->ki_list.next) {
> > +	if (!list_empty_careful(iocb->ki_list.next)) {
> 
> Umm...  Why not list_empty_careful(&iocb->ki_list)?

Yes, that makes a lot more sense.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
