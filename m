From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH v6 2/5] fs: Convert kiocb rw_hint from enum to u16
Date: Tue, 22 May 2018 11:24:35 -0500
Message-ID: <084d253c-52ab-7b23-521c-28602c56153b@suse.de>
References: <20180522150737.9893-1-adam.manzanares@wdc.com>
 <20180522150737.9893-3-adam.manzanares@wdc.com>
 <11fb2ee5-8352-2d35-3154-68637d99b096@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <11fb2ee5-8352-2d35-3154-68637d99b096@kernel.dk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, adam.manzanares@wdc.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, bcrl@kvack.org
Cc: tglx@linutronix.de, mingo@kernel.org, pombredanne@nexb.com, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, bigeasy@linutronix.de, jack@suse.cz, darrick.wong@oracle.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org, hch@infradread.org, jmoyer@redhat.com
List-Id: linux-api@vger.kernel.org



On 05/22/2018 10:32 AM, Jens Axboe wrote:
> On 5/22/18 9:07 AM, adam.manzanares@wdc.com wrote:
>> From: Adam Manzanares <adam.manzanares@wdc.com>
>>
>> In order to avoid kiocb bloat for per command iopriority support, rw_hint
>> is converted from enum to a u16. Added a guard around ki_hint assignment.
>>
>> Signed-off-by: Adam Manzanares <adam.manzanares@wdc.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> ---
>>  include/linux/fs.h | 13 +++++++++++--
>>  1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 7f07977bdfd7..50de40dbbb85 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -284,6 +284,8 @@ enum rw_hint {
>>  	WRITE_LIFE_EXTREME	= RWH_WRITE_LIFE_EXTREME,
>>  };
>>  
>> +#define MAX_KI_HINT		((1 << 16) - 1) /* ki_hint type is u16 */
> 
> Instead of having to do this and now rely on those now being synced,
> how about something like the below.
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 760d8da1b6c7..070438d0b62d 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -299,7 +299,7 @@ struct kiocb {
>  	void (*ki_complete)(struct kiocb *iocb, long ret, long ret2);
>  	void			*private;
>  	int			ki_flags;
> -	enum rw_hint		ki_hint;
> +	u16			ki_hint;
>  } __randomize_layout;
>  
>  static inline bool is_sync_kiocb(struct kiocb *kiocb)
> @@ -1927,12 +1927,22 @@ static inline enum rw_hint file_write_hint(struct file *file)
>  
>  static inline int iocb_flags(struct file *file);
>  
> +static inline u16 ki_hint_validate(enum rw_hint hint)
> +{
> +	typeof(((struct kiocb *)0)->ki_hint) max_hint = -1;

This looks complex to me. Would force a reader to lookback at what
datatype ki_hint is. I'd prefer to declare it as u16 max_hint = -1, or
even the previous #define MAX_KI_HINT format is easier to read. Just a
program reading style you are comfortable with though.


-- 
Goldwyn

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
