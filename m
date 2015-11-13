From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Fri, 13 Nov 2015 08:47:20 -0700
Message-ID: <56460608.2070107@kernel.dk>
References: <20151110051526.GA2217@birch.djwong.org>
 <DDB9C85B850785449757F9914A034FCB444D1676@G9W0766.americas.hpqcorp.net>
 <20151111061435.GA32272@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151111061435.GA32272-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Seymour, Shane M" <shane.seymour-ZPxbGqLxI0U@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/10/2015 11:14 PM, Darrick J. Wong wrote:
> On Wed, Nov 11, 2015 at 05:30:07AM +0000, Seymour, Shane M wrote:
>> A quick question about this part of the patch:
>>
>>> +	uint64_t end = start + len - 1;
>>
>>> +	if (end >= i_size_read(bdev->bd_inode))
>>   		return -EINVAL;
>>
>>> +	/* Invalidate the page cache, including dirty pages */
>>> +	mapping = bdev->bd_inode->i_mapping;
>>> +	truncate_inode_pages_range(mapping, start, end);
>>
>> blk_ioctl_zeroout accepts unsigned values for start and end (uint64_t) but
>> loff_t types are turned from i_size_read() and passed as the 2nd and 3rd
>> values to truncate_inode_pages_range() and loff_t is a signed value. It
>> should be possible to pass in some values would overflow the calculation of
>> end causing the test on the value of end and the result of i_size_read to
>> pass but then end up passing a large unsigned value for in start that would
>> be implicitly converted to signed in truncate_inode_pages_range. I was
>> wondering if you'd tested passing in data that would cause sign conversion
>> issues when passed into truncate_inode_pages_range (does it handle it
>> gracefully?) or should this code:
>>
>> 	if (start & 511)
>>   		return -EINVAL;
>>   	if (len & 511)
>>   		return -EINVAL;
>>
>> be something more like this (for better sanity checking of your arguments)
>> which will ensure that you don't have implicit conversion issues from
>> unsigned to signed and ensure that the result of adding them together won't
>> either:
>>
>> 	if ((start & 511) || (start > (uint64_t)LLONG_MAX))
>>   		return -EINVAL;
>>   	if ((len & 511) ) || (len > (uint64_t)LLONG_MAX))
>>   		return -EINVAL;
>> 	if (end > (uint64_t)LLONG_MAX)
>> 		return -EINVAL;
>>
>> My apologies in advance if I've made a mistake when looking at this and my
>> concerns about unsigned values being implicitly converted to signed are
>> unfounded (I would have hoped for compiler warnings about any implicit
>> conversions though).
>
> I don't have a device large enough to test for signedness errors, since passing
> huge values for start and len never make it past the i_size_read check.
> However, I do see that I forgot to check the padding values, so I'll update
> that.

modprobe null_blk nr_devices=1 gb=512000

will get you a /dev/nullb0 that is 500TB. Adjust 'gb' at will. Or use 
loop with a big ass sparse file.

-- 
Jens Axboe
