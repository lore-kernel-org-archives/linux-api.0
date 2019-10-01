From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] io_uring: use __kernel_timespec in timeout ABI
Date: Tue, 1 Oct 2019 08:09:19 -0600
Message-ID: <8d5d34da-e1f0-1ab5-461e-f3145e52c48a@kernel.dk>
References: <20190930202055.1748710-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190930202055.1748710-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, linux-api@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Stefan_B=c3=bchler?= <source@stbuehler.de>, Hannes Reinecke <hare@suse.com>, Jackie Liu <liuyun01@kylinos.cn>, Andrew Morton <akpm@linux-foundation.org>, Hristo Venev <hristo@venev.name>, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 9/30/19 2:20 PM, Arnd Bergmann wrote:
> All system calls use struct __kernel_timespec instead of the old struct
> timespec, but this one was just added with the old-style ABI. Change it
> now to enforce the use of __kernel_timespec, avoiding ABI confusion and
> the need for compat handlers on 32-bit architectures.
> 
> Any user space caller will have to use __kernel_timespec now, but this
> is unambiguous and works for any C library regardless of the time_t
> definition. A nicer way to specify the timeout would have been a less
> ambiguous 64-bit nanosecond value, but I suppose it's too late now to
> change that as this would impact both 32-bit and 64-bit users.

Thanks for catching that, Arnd. Applied.

-- 
Jens Axboe
