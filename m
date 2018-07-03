From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [REGRESSION] "Locked" and "Pss" in /proc/*/smaps are the same
Date: Tue, 3 Jul 2018 09:45:59 +0200
Message-ID: <f19dd0ba-7fe7-57d9-6872-aa6498f75d42@suse.cz>
References: <69eb77f7-c8cc-fdee-b44f-ad7e522b8467@gmail.com>
 <ebf6c7fb-fec3-6a26-544f-710ed193c154@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ebf6c7fb-fec3-6a26-544f-710ed193c154@suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Lindroth <thomas.lindroth@gmail.com>, dancol@google.com, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
List-Id: linux-api@vger.kernel.org

On 07/03/2018 09:36 AM, Vlastimil Babka wrote:
> On 07/01/2018 08:31 PM, Thomas Lindroth wrote:
>> While looking around in /proc on my v4.14.52 system I noticed that
>> all processes got a lot of "Locked" memory in /proc/*/smaps. A lot
>> more memory than a regular user can usually lock with mlock().
>>
>> commit 493b0e9d945fa9dfe96be93ae41b4ca4b6fdb317 (v4.14-rc1) seems
>> to have changed the behavior of "Locked".

Oops, I forgot, thanks for the nice report :)

Vlastimil
