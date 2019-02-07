From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 13/18] io_uring: add file set registration
Date: Thu, 7 Feb 2019 16:51:30 +0000
Message-ID: <20190207165130.GF2217@ZenIV.linux.org.uk>
References: <20190204025612.GR2217@ZenIV.linux.org.uk>
 <785c6db4-095e-65b0-ded5-72b41af5174e@kernel.dk>
 <2b2137ed-8107-f7b6-f0ca-202dcfb87c97@kernel.dk>
 <40b27e78-9ee8-1395-feb3-a73aac87c9a7@kernel.dk>
 <0d2e5085-32ff-e86e-d628-6000071fd132@kernel.dk>
 <20190206010104.GV2217@ZenIV.linux.org.uk>
 <608c1102-5818-e38c-cfc7-b1cec5a1ecb4@kernel.dk>
 <20190207040547.GX2217@ZenIV.linux.org.uk>
 <51f167c6-aacc-dd5b-4481-7168c6f8b413@kernel.dk>
 <20190207163047.GE2217@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20190207163047.GE2217@ZenIV.linux.org.uk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Jann Horn <jannh@google.com>, linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Feb 07, 2019 at 04:30:47PM +0000, Al Viro wrote:
> Well, yes - once you receive it, you obviously have no references
> sitting in SCM_RIGHTS anymore.
> 
> Get rid of recv_fd() there (along with fork(), while we are at it - what's
> it for?) and just do send_fd + these 3 close (or just exit, for that matter).

If you pardon a bad ASCII graphics,

ring_fd            sv[0]             sv[1]                 (descriptors)
   |                |                  |
   V                V                  V
[io_uring]        [socket1]          [socket2]             (struct file)
 ^ |               ^  |                ^  |
 | |               |  |                |  |
 | \_______________/__|________________/  |                (after registering)
 |                    |                   |
 |                    V                   V
 |                 [unix_sock1]<---->[unix_sock2]          (struct unix_sock)
 |                                        |
 |                                        V
 \----------------------------------[SCM_RIGHTS]           (queue contents)

References from io_uring to other two struct file are added when you
register these suckers.  Reference from SCM_RIGHTS appears when you
do send_fd().  Now, each file has two references to it.  And
if you close all 3 descriptors (either explicitly, or by exiting)
you will be left with this graph:

[io_uring]------------\-------------------\
 ^                    |                   |
 |                    V                   V
 |                [socket1]          [socket2]
 |                    |                   |
 |                    V                   V
 |                 [unix_sock1]<---->[unix_sock2]
 |                                        |
 |                                        V
 \----------------------------------[SCM_RIGHTS]

All struct file still have references, so they are all still alive,
->release() isn't called on any of them.  And the entire thing
is obviously unreachable from the rest of data structures.

Of course recvmsg() would've removed the loop.  The point is, with
that situation you *can't* get it called - you'd need to reach
socket2 to do that and you can't do that anymore.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
