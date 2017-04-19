From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 2/8] nowait aio: Introduce RWF_NOWAIT
Date: Wed, 19 Apr 2017 05:30:24 -0500
Message-ID: <2d816e3e-3625-7ebd-8550-68a7cc9c1a2e@suse.de>
References: <20170414120257.8932-1-rgoldwyn@suse.de>
 <20170414120257.8932-3-rgoldwyn@suse.de>
 <20170419063930.GB20053@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170419063930.GB20053-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-IBi9RG/b67k@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 04/19/2017 01:39 AM, Christoph Hellwig wrote:
> 
>> @@ -1593,6 +1593,11 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
>>  	}
>>  
>>  	req->common.ki_flags |= iocb_rw_flags(iocb->aio_rw_flags);
>> +	if ((req->common.ki_flags & IOCB_NOWAIT) &&
>> +	    !(req->common.ki_flags & IOCB_DIRECT)) {
>> +			ret = -EINVAL;
>> +			goto out_put_req;
>> +		}
> 
> Wrong indentation.  Also I think this should be EOPNOTSUPP here.
> 

Do we plan to add support for nowait in buffered I/O in the future? It
is just too complicated. EINVAL suits best in this case.

-- 
Goldwyn
