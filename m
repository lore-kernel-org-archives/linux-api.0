From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] io_uring: add support for barrier fsync
Date: Tue, 9 Apr 2019 12:23:34 -0600
Message-ID: <5f8d9644-9e8f-c9d2-611e-4b144c62539c@kernel.dk>
References: <7c7276e4-8ffa-495a-6abf-926a58ee899e@kernel.dk>
 <20190409181742.GA24925@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190409181742.GA24925@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 4/9/19 12:17 PM, Christoph Hellwig wrote:
> On Tue, Apr 09, 2019 at 10:27:43AM -0600, Jens Axboe wrote:
>> It's a quite common use case to issue a bunch of writes, then an fsync
>> or fdatasync when they complete. Since io_uring doesn't guarantee any
>> type of ordering, the application must track issued writes and wait
>> with the fsync issue until they have completed.
>>
>> Add an IORING_FSYNC_BARRIER flag that helps with this so the application
>> doesn't have to do this manually. If this flag is set for the fsync
>> request, we won't issue it until pending IO has already completed.
> 
> I think we need a much more detailed explanation of the semantics,
> preferably in man page format.
> 
> Barrier at least in Linux traditionally means all previously submitted
> requests have finished and no new ones are started until the
> barrier request finishes, which is very heavy handed.  Is that what
> this is supposed to do?  If not what are the exact guarantees vs
> ordering and or barrier semantics?

The patch description isn't that great, and maybe the naming isn't that
intuitive either. The way it's implemented, the fsync will NOT be issued
until previously issued IOs have completed. That means both reads and
writes, since there's no way to wait for just one.  In terms of
semantics, any previously submitted writes will have completed before
this fsync is issued. The barrier fsync has no ordering wrt future
writes, no ordering is implied there. Hence:

W1, W2, W3, FSYNC_W_BARRIER, W4, W5

W1..3 will have been completed by the hardware side before we start
FSYNC_W_BARRIER. We don't wait with issuing W4..5 until after the fsync
completes, no ordering is provided there.

-- 
Jens Axboe
