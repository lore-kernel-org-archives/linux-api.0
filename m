From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCHSET v11] io_uring IO interface
Date: Fri, 01 Feb 2019 14:52:31 -0800
Message-ID: <1549061551.164323.17.camel@acm.org>
References: <20190201152414.23296-1-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190201152414.23296-1-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com
List-Id: linux-api@vger.kernel.org

On Fri, 2019-02-01 at 08:23 -0700, Jens Axboe wrote:
+AD4 Here's v11 of the io+AF8-uring project. Main fixes in this release is a
+AD4 rework of how we grab the ctx-+AD4-uring+AF8-lock, never using trylock for it in
+AD4 a user visible way. Outside of that, fixes around locking for the polled
+AD4 list when we hit -EAGAIN conditions on IO submit. This fixes list
+AD4 corruption issues with polling that some users have reported.
+AD4 
+AD4 As far as I'm concerned, this project is ready to get staged for 5.1.
+AD4 Please do review carefully so we can fix any minor nits that might still
+AD4 exist.
+AD4 
+AD4 The liburing git repo has a full set of man pages for this, though they
+AD4 could probably still use a bit of polish. I'd also like to see a
+AD4 io+AF8-uring(7) man page to describe the overall design of the project,
+AD4 expect that in the not-so-distant future. You can clone that here:
+AD4 
+AD4 git://git.kernel.dk/liburing
+AD4 
+AD4 Patches are against 5.0-rc4, and can also be found in my io+AF8-uring branch
+AD4 here:
+AD4 
+AD4 git://git.kernel.dk/linux-block io+AF8-uring
+AD4 
+AD4 Changes since v10:
+AD4 - Rework uring+AF8-lock locking
+AD4 - Ensure that async contexts lock when fiddling with polled lists
+AD4 - Minor tweak to io+AF8-iopoll+AF8-check() continue looping condition
+AD4 - Fold +AF8AXw-io+AF8-uring+AF8-enter() into io+AF8-uring+AF8-enter()

Hi Jens,

Which goal(s) do you want to realize with this new API? Is the goal perhaps
to reduce the overhead of submitting I/O and receiving I/O completions?
If so, where can I find a comparison of the performance of this API with
libaio and synchronous I/O?

Thanks,

Bart.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
