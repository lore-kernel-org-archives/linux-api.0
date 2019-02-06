From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 13/18] io_uring: add file set registration
Date: Wed, 6 Feb 2019 06:41:00 -0700
Message-ID: <8f124de2-d6da-d656-25e4-b4d9e58f880e@kernel.dk>
References: <20190129192702.3605-1-axboe@kernel.dk>
 <20190129192702.3605-14-axboe@kernel.dk>
 <CAG48ez2kLWUEambWesQQaeVn_u=PtjuMeDUc49yamhYspfd7Sg@mail.gmail.com>
 <20190204025612.GR2217@ZenIV.linux.org.uk>
 <785c6db4-095e-65b0-ded5-72b41af5174e@kernel.dk>
 <2b2137ed-8107-f7b6-f0ca-202dcfb87c97@kernel.dk>
 <40b27e78-9ee8-1395-feb3-a73aac87c9a7@kernel.dk>
 <20190206005638.GU2217@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190206005638.GU2217@ZenIV.linux.org.uk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jann Horn <jannh@google.com>, linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 2/5/19 5:56 PM, Al Viro wrote:
> On Tue, Feb 05, 2019 at 12:08:25PM -0700, Jens Axboe wrote:
>> Proof is in the pudding, here's the main commit introducing io_uring
>> and now wiring it up to the AF_UNIX garbage collection:
>>
>> http://git.kernel.dk/cgit/linux-block/commit/?h=io_uring&id=158e6f42b67d0abe9ee84886b96ca8c4b3d3dfd5
>>
>> How does that look?
> 
> In a word - wrong.  Some theory: garbage collector assumes that there is
> a subset of file references such that
> 	* for all files with such references there's an associated unix_sock.
> 	* all such references are stored in SCM_RIGHTS datagrams that can be
> found by the garbage collector (currently: for data-bearing AF_UNIX sockets -
> queued SCM_RIGHTS datagrams, for listeners - SCM_RIGHTS datagrams sent via
> yet-to-be-accepted connections).
> 	* there is an efficient way to count those references for given file
> (->inflight of the corresponding unix_sock).
> 	* removal of those references would render the graph acyclic.
> 	* file can _NOT_ be subject to syscalls unless there are references
> to it outside of that subset.

IOW, we cannot use fget() for registering files, and we still need fget/fput
in the fast path to retain safe use of the file. If I'm understanding you
correctly?

Just trying to ensure that I understand what you're saying here, as it seems
to refer to the file registration part, not the main patch (which did get
reworked, though).

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
