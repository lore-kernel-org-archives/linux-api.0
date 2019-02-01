From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 04/18] iomap: wire up the iopoll method
Date: Fri, 01 Feb 2019 08:59:52 -0800
Message-ID: <1549040392.164323.2.camel@acm.org>
References: <20190201152414.23296-1-axboe@kernel.dk>
	 <20190201152414.23296-5-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190201152414.23296-5-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com
List-Id: linux-api@vger.kernel.org

On Fri, 2019-02-01 at 08:24 -0700, Jens Axboe wrote:
+AD4 +-int iomap+AF8-dio+AF8-iopoll(struct kiocb +ACo-kiocb, bool spin)
+AD4 +-+AHs
+AD4 +-	struct request+AF8-queue +ACo-q +AD0 READ+AF8-ONCE(kiocb-+AD4-private)+ADs
+AD4 +-
+AD4 +-	if (+ACE-q)
+AD4 +-		return 0+ADs
+AD4 +-	return blk+AF8-poll(q, READ+AF8-ONCE(kiocb-+AD4-ki+AF8-cookie), spin)+ADs
+AD4 +-+AH0
+AD4 +-EXPORT+AF8-SYMBOL+AF8-GPL(iomap+AF8-dio+AF8-iopoll)+ADs

How does this interact with block device removal? My understanding is that this
function can get called after a request has completed. Which mechanism, if any,
prevents that request queue 'q' is removed after kiocb-+AD4-private has been read
and before blk+AF8-poll() is called?

Thanks,

Bart.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
