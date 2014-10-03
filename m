From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RFC] introduce ioctl to completely invalidate page cache
Date: Fri, 03 Oct 2014 08:28:24 -0600
Message-ID: <542EB288.5000209@kernel.dk>
References: <1412266184-23776-1-git-send-email-thanos.makatos@citrix.com> <542DAEAC.8010203@kernel.dk> <2368A3FCF9F7214298E53C823B0A48EC0423DFE3@AMSPEX01CL02.citrite.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <2368A3FCF9F7214298E53C823B0A48EC0423DFE3@AMSPEX01CL02.citrite.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Thanos Makatos <thanos.makatos@citrix.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "jlayton@poochiereds.net" <jlayton@poochiereds.net>, "bfields@fieldses.org" <bfields@fieldses.org>, "jack@suse.cz" <jack@suse.cz>
List-Id: linux-api@vger.kernel.org

On 2014-10-03 03:25, Thanos Makatos wrote:
>>> -		fsync_bdev(bdev);
>>> -		invalidate_bdev(bdev);
>>> +		flush_buffer_cache(bdev);
>>> +		if (BLKFLSBUF2 == cmd)
>>> +			return invalidate_inode_pages2(
>>> +					bdev->bd_inode->i_mapping);
>>>   		return 0;
>>
>> We're currently ignoring the buffer cache sync and invalidation (which is odd),
>> but at least being consistent would be good.
>>
>> Might also need a filemap_write_and_wait() to sync before invalidation.
>
> (I've got zero knowledge in this area, so excuse my ignorance!)
>
> Does filemap_write_and_wait() writes back modified, memory-mapped pages? If so,
> isn't there a race condition? Or have I got it completely wrong?

There's no race to be concerned of for this ioctl. Any page dirtied 
before you make the call will be synced, any page dirtied after may not. 
This is no different than what would happen on the buffer cache side in 
the current ioctl.

-- 
Jens Axboe

