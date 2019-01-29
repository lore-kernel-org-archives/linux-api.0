From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Mon, 28 Jan 2019 17:31:59 -0700
Message-ID: <51c759f4-7ce5-182b-98e8-2c0e99ca4f9a@kernel.dk>
References: <20190128213538.13486-1-axboe@kernel.dk>
 <20190128213538.13486-6-axboe@kernel.dk>
 <CAG48ez0vDqDH4ks7q4L3F+xt-4kVQrN1yw34QwFAmwQyy27FTw@mail.gmail.com>
 <e9326a77-54c5-e2b8-d9e5-663261462597@kernel.dk>
 <CAG48ez17NW0GJVRC6dFcHZTgQifFz5og1XCUbXkHKhr6f=j74Q@mail.gmail.com>
 <c20a1250-9f3f-a286-9baf-5b71db0c128f@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <c20a1250-9f3f-a286-9baf-5b71db0c128f@kernel.dk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jann Horn <jannh@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>
List-Id: linux-api@vger.kernel.org

On 1/28/19 5:03 PM, Jens Axboe wrote:
>> But you only do that teardown on ->release, right? And ->release
>> doesn't have much to do with the process lifetime.
> 
> Yes, only on ->relase().

OK, so I reworked the files struct to just grab it, then we ensure that
doesn't go away. For mm, it's a bit more tricky. I think the best
solution here is to add a fops->flush() and check for the process
exiting its files. If it does, we quiesce the async contexts and prevent
further use of that mm. We can't just keep holding a reference to the mm
like we do with the files.

That should solve both cases.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
