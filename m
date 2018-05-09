From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 2/3] fs: Convert kiocb rw_hint from enum to u16
Date: Wed, 9 May 2018 08:23:00 -0600
Message-ID: <0aad993b-448c-3586-cfc0-f2e50b1dda28@kernel.dk>
References: <20180508174202.2537-1-adam.manzanares@wdc.com>
 <20180508174202.2537-3-adam.manzanares@wdc.com>
 <20180509133432.GD28388@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180509133432.GD28388@thunk.org>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>, adam.manzanares@wdc.com, viro@zeniv.linux.org.uk, bcrl@kvack.org, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 5/9/18 7:34 AM, Theodore Y. Ts'o wrote:
> On Tue, May 08, 2018 at 10:42:01AM -0700, adam.manzanares@wdc.com wrote:
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 760d8da1b6c7..7a90ce387e00 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -284,6 +284,8 @@ enum rw_hint {
>>  	WRITE_LIFE_EXTREME	= RWH_WRITE_LIFE_EXTREME,
>>  };
>>  
>> +#define MAX_KI_HINT		((1 << 16) - 1) /* ki_hint type is u16 */
>> +
> 
> Do we really think there will be *ever* be a need for more than 16 I/O
> priority levels?  I would much rather use the low four bits of KI_HINT
> for the priority level, and reserve the rest of the 16 bits in KI_HINT
> for some future use.  (For example, we might want to use some number
> of bits for a stream ID.)

Streams is essentially the only thing ki_hint is currently used for,
with the write life time hints mapping to a stream. The idea for the
user side API was to have other things than just write life time hints.

Since Adam wants to do priorities, he'd either need to pack into the
existing ki_hint, or do this patch does, which is make it smaller and
add a new member. I think the latter is cleaner.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
