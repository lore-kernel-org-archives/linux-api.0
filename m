From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 13/19] net: split out functions related to registering
 inflight socket files
Date: Fri, 8 Feb 2019 12:51:46 -0700
Message-ID: <234470b5-ab86-a526-84bd-1b81254c3c14@kernel.dk>
References: <20190208173423.27014-1-axboe@kernel.dk>
 <20190208173423.27014-14-axboe@kernel.dk>
 <20190208.114909.2274258441884310233.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190208.114909.2274258441884310233.davem@davemloft.net>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk, netdev@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 2/8/19 12:49 PM, David Miller wrote:
> From: Jens Axboe <axboe@kernel.dk>
> Date: Fri,  8 Feb 2019 10:34:17 -0700
> 
>> We need this functionality for the io_uring file registration, but
>> we cannot rely on it since CONFIG_UNIX can be modular. Move the helpers
>> to a separate file, that's always builtin to the kernel if CONFIG_UNIX is
>> m/y.
>>
>> No functional changes in this patch, just moving code around.
>>
>> Cc: netdev@vger.kernel.org
>> Cc: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> No objections on my end, feel free to merge this in with your series.
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Great, thanks Dave! I'll add your ack.

-- 
Jens Axboe
