From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Tue, 29 Jan 2019 09:28:01 -0700
Message-ID: <4395ae02-54fe-d5fe-dea9-c50f7eaba3b1@kernel.dk>
References: <20190123153536.7081-1-axboe@kernel.dk>
 <20190123153536.7081-6-axboe@kernel.dk> <20190128145700.GA9795@lst.de>
 <2729ab43-b2bf-44b0-d41d-dbb495ddffbf@kernel.dk>
 <20190129063043.GC2996@lst.de>
 <CAK8P3a1x4BsFfacxOmaDXKOKmmQ2j0ypX2+mCNCbjH3E7nC4DQ@mail.gmail.com>
 <4b12d149-99f7-0b2e-0c3f-9b477ce48520@kernel.dk>
 <CAK8P3a38-FLBH0sp0vaebv29M5oDyiUkwwmVY+9_S3vSER9n5Q@mail.gmail.com>
 <9a66c000-62f3-7567-7919-31e61e28defa@kernel.dk>
 <CAK8P3a1=kho718OSdZ0zp5g3mwmsYbd5J-e58kDyq2QMBCak=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <CAK8P3a1=kho718OSdZ0zp5g3mwmsYbd5J-e58kDyq2QMBCak=Q@mail.gmail.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, linux-aio <linux-aio@kvack.org>, linux-block <linux-block@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Avi Kivity <avi@scylladb.com>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Deepa Dinamani <deepa.kernel@gmail.com>
List-Id: linux-api@vger.kernel.org

On 1/29/19 9:26 AM, Arnd Bergmann wrote:
> On Tue, Jan 29, 2019 at 5:19 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 1/29/19 9:18 AM, Arnd Bergmann wrote:
>>> On Tue, Jan 29, 2019 at 4:20 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> That's good info. I am currently using set_user_sigmask() for it.
>>>> I'd really like to avoid having to pass in a sigset_t size for the
>>>> system call, however.
>>>
>>> I really wouldn't do it, given that all other signal handling interfaces
>>> are prepared for longer signal masks. You /could/ probably extend
>>> it later with a flags bit to signify a longer mask instead of using
>>> the entire register to hold the bit length, it just seems really
>>> inconsistent with all other system calls.
>>
>> Damnit! OK, I'll keep what I currently have then.
> 
> As long as you stay within the 6-argument syscall contraints,
> the cost of passing the length is basically free, right?
> 
> Is there anything else you are worried about?

My main worry is not the extra argument, more that we're at capacity
for the system call. If we wanted to add a timeout parameter, then we'd
need to bundle them up, which sucks.

But I think we're fine, I'll go with what I have.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
