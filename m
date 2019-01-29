From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Tue, 29 Jan 2019 08:54:49 -0700
Message-ID: <41d1cd0c-8a0b-73a8-32a2-c5ef31425fae@kernel.dk>
References: <20190128213538.13486-1-axboe@kernel.dk>
 <20190128213538.13486-6-axboe@kernel.dk>
 <87tvhrpsqg.fsf@oldenburg2.str.redhat.com>
 <74fd3127-75f1-3a48-d3cb-a8f6c9bd0b74@kernel.dk>
 <CAG48ez0PPWP7GU5kinzejN1B3invrcxCZT2fkpnHxMK2F0pj6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <CAG48ez0PPWP7GU5kinzejN1B3invrcxCZT2fkpnHxMK2F0pj6A@mail.gmail.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jann Horn <jannh@google.com>
Cc: Florian Weimer <fweimer@redhat.com>, linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>
List-Id: linux-api@vger.kernel.org

On 1/29/19 8:38 AM, Jann Horn wrote:
> On Tue, Jan 29, 2019 at 2:35 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 1/29/19 5:12 AM, Florian Weimer wrote:
>>> * Jens Axboe:
>>>
>>>> +#define IORING_MAX_ENTRIES  4096
>>>
>>> Where does this constant come from?  Should it really be exposed to
>>> userspace?
>>
>> Seems pretty handy for the application to know what the limit is?
> 
> The running kernel version might be different from the kernel version
> whose headers the userspace code was compiled with. So if this is a
> limit that might change at some point in the future, and you think
> userspace wants to know the limit, some other API might be better.

Probably best to just kill it, we'll error in io_uring_register() if
it's exceeded anyway.


-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
