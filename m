From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2] fs: Add aio iopriority support for block_dev
Date: Thu, 3 May 2018 15:20:26 -0600
Message-ID: <9e3ba3eb-9c41-3b5d-dc12-f9ef573ab53f@kernel.dk>
References: <20180503182114.2797-1-adam.manzanares@wdc.com>
 <20180503183353.GC1562@bombadil.infradead.org>
 <47e0a519-37b4-f5e7-0616-8659d11c2b69@wdc.com>
 <18300bdb-a12f-0b6c-1317-6db3e4391d57@kernel.dk>
 <e81c74fd-a4a2-80e0-476c-6ff35f158abf@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e81c74fd-a4a2-80e0-476c-6ff35f158abf@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Adam Manzanares <Adam.Manzanares@wdc.com>, Matthew Wilcox <willy@infradead.org>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "bcrl@kvack.org" <bcrl@kvack.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 5/3/18 2:58 PM, Adam Manzanares wrote:
> 
> 
> On 5/3/18 1:24 PM, Jens Axboe wrote:
>> On 5/3/18 2:15 PM, Adam Manzanares wrote:
>>>
>>>
>>> On 5/3/18 11:33 AM, Matthew Wilcox wrote:
>>>> On Thu, May 03, 2018 at 11:21:14AM -0700, adam.manzanares@wdc.com wrote:
>>>>> If we want to avoid bloating struct kiocb, I suggest we turn the private field
>>>>> into a union of the private and ki_ioprio field. It seems like the users of
>>>>> the private field all use it at a point where we can yank the priority from
>>>>> the kiocb before the private field is used. Comments and suggestions welcome.
>>>>
>>>> Or we could just make ki_hint a u8 or u16 ... seems unlikely we'll need
>>>> 32 bits of ki_hint.  (currently defined values are 1-5)
>>>
>>> I like the approach of using a u16 for the ki_hint. I'll update and
>>> resubmit.
>>
>> It's intended to be a mask. If you do shrink it for now, then we need some
>> guard code to ensure it can always carry what it needs to.
>>
> 
> Got it, I'll add the guard to rw_hint_valid along with a comment about 
> being limited by the size of ki_hint in case we get to a situation where 
> 16 bits is not enough.

Other way around - the API should not be limited by the fact that some
smaller type was chosen for an internal structure. Hence the guard/check
should not be in rw_hint_valid, but rather around where you assign
ki_hint. If/when we do extend the read/write hints, then we'll
potentially need to bump ki_hint to accommodate it.

-- 
Jens Axboe
