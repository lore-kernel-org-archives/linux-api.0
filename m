From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2] fs: Add aio iopriority support for block_dev
Date: Thu, 3 May 2018 16:53:19 -0600
Message-ID: <b74a5202-7078-88e8-6b30-7cad0c123703@kernel.dk>
References: <20180503182114.2797-1-adam.manzanares@wdc.com>
 <20180503183353.GC1562@bombadil.infradead.org>
 <47e0a519-37b4-f5e7-0616-8659d11c2b69@wdc.com>
 <18300bdb-a12f-0b6c-1317-6db3e4391d57@kernel.dk>
 <20180503224308.GA30823@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180503224308.GA30823@bombadil.infradead.org>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Adam Manzanares <Adam.Manzanares@wdc.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "bcrl@kvack.org" <bcrl@kvack.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 5/3/18 4:43 PM, Matthew Wilcox wrote:
> On Thu, May 03, 2018 at 02:24:58PM -0600, Jens Axboe wrote:
>> On 5/3/18 2:15 PM, Adam Manzanares wrote:
>>> On 5/3/18 11:33 AM, Matthew Wilcox wrote:
>>>> Or we could just make ki_hint a u8 or u16 ... seems unlikely we'll need
>>>> 32 bits of ki_hint.  (currently defined values are 1-5)
>>>
>>> I like the approach of using a u16 for the ki_hint. I'll update and 
>>> resubmit.
>>
>> It's intended to be a mask. If you do shrink it for now, then we need some
>> guard code to ensure it can always carry what it needs to.
> 
> ummm ...
> 
> enum rw_hint {
>         WRITE_LIFE_NOT_SET      = 0,
>         WRITE_LIFE_NONE         = RWH_WRITE_LIFE_NONE,
>         WRITE_LIFE_SHORT        = RWH_WRITE_LIFE_SHORT,
> ...
> 
>                 .ki_hint = file_write_hint(filp),
> 
> static inline enum rw_hint file_write_hint(struct file *file)
> 
> #define RWF_WRITE_LIFE_NOT_SET  0
> #define RWH_WRITE_LIFE_NONE     1
> #define RWH_WRITE_LIFE_SHORT    2
> #define RWH_WRITE_LIFE_MEDIUM   3
> #define RWH_WRITE_LIFE_LONG     4
> #define RWH_WRITE_LIFE_EXTREME  5
> 
> It doesn't look like it's being used as a mask.

Right, currently it only supports the life time hint. I'm saying the
intent is, for when it's being expanded to cover other hints, is to
split up the value into maskable sections.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
