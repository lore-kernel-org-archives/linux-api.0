From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: add iostat counters for flush requests
Date: Thu, 21 Nov 2019 09:07:26 -0700
Message-ID: <f542739c-7d43-1ea3-5235-c7809bb59f62@kernel.dk>
References: <157433282607.7928.5202409984272248322.stgit@buzz>
 <ff971ff6-9a10-c3f1-107d-4f7d378e8755@kernel.dk>
 <20191121160430.GJ6211@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191121160430.GJ6211@magnolia>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
List-Id: linux-api@vger.kernel.org

On 11/21/19 9:04 AM, Darrick J. Wong wrote:
> On Thu, Nov 21, 2019 at 08:56:14AM -0700, Jens Axboe wrote:
>> On 11/21/19 3:40 AM, Konstantin Khlebnikov wrote:
>>> Requests that triggers flushing volatile writeback cache to disk (barriers)
>>> have significant effect to overall performance.
>>>
>>> Block layer has sophisticated engine for combining several flush requests
>>> into one. But there is no statistics for actual flushes executed by disk.
>>> Requests which trigger flushes usually are barriers - zero-size writes.
>>>
>>> This patch adds two iostat counters into /sys/class/block/$dev/stat and
>>> /proc/diskstats - count of completed flush requests and their total time.
>>
>> This makes sense to me, and the "recent" discard addition already proved
>> that we're fine extending with more fields. Unless folks object, I'd be
>> happy to queue this up for 5.5.
> 
> Looks like a good addition to /me... :)

That's all the encouragement I needed, added :-)

-- 
Jens Axboe
