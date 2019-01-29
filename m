From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Tue, 29 Jan 2019 07:45:48 +0100
Message-ID: <20190129064548.GA3280@lst.de>
References: <20190123153536.7081-1-axboe@kernel.dk> <20190123153536.7081-6-axboe@kernel.dk> <20190128145700.GA9795@lst.de> <CALCETrV30uN2qOUEf+kNGWdphBtps7K3rEk8_8+VAwdtPomRkQ@mail.gmail.com> <dab3fa32-3887-3264-9fe1-bc3b7abc58b3@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <dab3fa32-3887-3264-9fe1-bc3b7abc58b3@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Andy Lutomirski <luto@kernel.org>, Christoph Hellwig <hch@lst.de>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-aio@kvack.org, linux-block@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Avi Kivity <avi@scylladb.com>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 28, 2019 at 06:20:08PM -0700, Jens Axboe wrote:
> Sure, that would be straight forward. Is there a strong reason to do
> so outside of "that would be nice"? It's not like it's a huge amount
> of code.

And it would be really painful for userspace.  Because now you
can't pass struct iovec through from a higher level, but will instead
of to copy the iovec to a different type in the submission path.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
