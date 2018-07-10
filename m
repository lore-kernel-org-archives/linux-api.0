From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 7/7] aio: implement io_pgetevents
Date: Tue, 10 Jul 2018 14:51:19 +0200
Message-ID: <20180710125119.GA2642@lst.de>
References: <20180502211448.18276-1-hch@lst.de> <20180704142116.GM17048@lisas.de> <20180708204359.GA19198@lst.de> <1632268.WSg4zQ7CbY@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <1632268.WSg4zQ7CbY@positron.chronox.de>
Sender: owner-linux-aio@kvack.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc: Christoph Hellwig <hch@lst.de>, Adrian Reber <adrian@lisas.de>, viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 09, 2018 at 09:21:53PM +0200, Stephan Müller wrote:
> Without such a patch, libkcapi fails to compile as well. See [1].
> 
> Apart from your suggested patch above, do you have another suggestion how make 
> the user space code compile?

The only other option would be to move the __aio_sigset delcaration
out of the uapi header, similar to what we do for pselect.  This is
also rather ugly, but I gess that's what we'll have to do.  I will
prepare a patch for it.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
