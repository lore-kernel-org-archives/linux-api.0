From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v3 2/3] fs: Convert kiocb rw_hint from enum to u16
Date: Wed, 9 May 2018 09:34:32 -0400
Message-ID: <20180509133432.GD28388@thunk.org>
References: <20180508174202.2537-1-adam.manzanares@wdc.com>
 <20180508174202.2537-3-adam.manzanares@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180508174202.2537-3-adam.manzanares@wdc.com>
Sender: owner-linux-aio@kvack.org
To: adam.manzanares@wdc.com
Cc: viro@zeniv.linux.org.uk, bcrl@kvack.org, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, May 08, 2018 at 10:42:01AM -0700, adam.manzanares@wdc.com wrote:
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 760d8da1b6c7..7a90ce387e00 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -284,6 +284,8 @@ enum rw_hint {
>  	WRITE_LIFE_EXTREME	= RWH_WRITE_LIFE_EXTREME,
>  };
>  
> +#define MAX_KI_HINT		((1 << 16) - 1) /* ki_hint type is u16 */
> +

Do we really think there will be *ever* be a need for more than 16 I/O
priority levels?  I would much rather use the low four bits of KI_HINT
for the priority level, and reserve the rest of the 16 bits in KI_HINT
for some future use.  (For example, we might want to use some number
of bits for a stream ID.)

					- Ted

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
