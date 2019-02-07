From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Thu, 7 Feb 2019 13:15:09 -0700
Message-ID: <20190207201508.GA31594@localhost.localdomain>
References: <20190207195552.22770-1-axboe@kernel.dk>
 <20190207195552.22770-6-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20190207195552.22770-6-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On Thu, Feb 07, 2019 at 12:55:39PM -0700, Jens Axboe wrote:
> IO submissions use the io_uring_sqe data structure, and completions
> are generated in the form of io_uring_sqe data structures. 
                                        ^^^

Completions use _cqe, right?

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
