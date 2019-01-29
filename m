From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Tue, 29 Jan 2019 09:06:42 -0700
Message-ID: <076acc85-b71d-c65f-e729-53e347626a1d@kernel.dk>
References: <20190128213538.13486-1-axboe@kernel.dk>
 <20190128213538.13486-6-axboe@kernel.dk>
 <CAG48ez1qxZLfJzK95kjh0RiQ6kvZLbQhr6Dr0EjBNQB6Fr7NXQ@mail.gmail.com>
 <CAG48ez1Ms+NPTXPj_UiQyv=2aMaMR3akCdp5SdDL3x7x7gd_ig@mail.gmail.com>
 <b5902860-30a9-3dc9-b513-3d892afdc51b@kernel.dk>
 <CAG48ez0sNBjgW7ynpNC+sir-_AuccY1sKguiD+VAXvL9-j4iag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <CAG48ez0sNBjgW7ynpNC+sir-_AuccY1sKguiD+VAXvL9-j4iag@mail.gmail.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jann Horn <jannh@google.com>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>
List-Id: linux-api@vger.kernel.org

On 1/29/19 8:56 AM, Jann Horn wrote:
> On Tue, Jan 29, 2019 at 4:46 AM Jens Axboe <axboe@kernel.dk> wrote:
>> On 1/28/19 7:21 PM, Jann Horn wrote:
>>> Please create a local copy of the request before parsing it to keep
>>> the data from changing under you. Additionally, it might make sense to
>>> annotate every pointer to shared memory with a comment, or something
>>> like that, to ensure that anyone looking at the code can immediately
>>> see for which pointers special caution is required on access.
>>
>> I took a look at the viability of NOT having to local copy the data, and
>> I don't think it's too bad. Local copy has a noticeable impact on the
>> performance, hence I'd really (REALLY) like to avoid it.
>>
>> Here's something on top of the current git branch. I think I even went a
>> bit too far in some areas, but it should hopefully catch the cases where
>> we might end up double evaluating the parts of the sqe that we depend
>> on. For most of the sqe reading we don't really care too much. For
>> instance, the sqe->user_data. If the app changes this field, then it
>> just gets whatever passed back in cqe->user_data. That's not a kernel
>> issue.
>>
>> For cases like addr/len etc validation, it should be sound. I'll double
>> check this in the morning as well, and obviously would need to be folded
>> in along the way.
>>
>> I'd appreciate your opinion on this part, if you see any major issues
>> with it, or if I missed something.
> 
> The io_sqe_needs_user() checks still look racy. If that helper sees a
> IORING_OP_READ_FIXED, but then __io_submit_sqe() sees a
> IORING_OP_READV - especially if this happens in io_sq_wq_submit_work()
> -, I think you could potentially end up in places like
> io_import_iovec() without having done the set_fs(USER_DS) and
> use_mm(), causing the access to potentially occur with KERNEL_DS and a
> lazy mm.

Indeed, for that case I think we should just copy the sqe. It's in the
async offload context anyway, so a copy won't really change anything
in terms of performance. And since the gap is so large between the two
problematic spots, it'd be trickier to fix.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
