From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH RFC] fs/fcntl: add fcntl F_GET_RSS
Date: Mon, 28 Oct 2019 15:55:19 +0300
Message-ID: <d7e76bee-80c3-d787-b854-91e631ab29cd@yandex-team.ru>
References: <157225848971.557.16257813537984792761.stgit@buzz>
 <87k18p6qjk.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87k18p6qjk.fsf@mid.deneb.enyo.de>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fw@deneb.enyo.de>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Roman Gushchin <guro@fb.com>
List-Id: linux-api@vger.kernel.org

On 28/10/2019 14.46, Florian Weimer wrote:
> * Konstantin Khlebnikov:
> 
>> This implements fcntl() for getting amount of resident memory in cache.
>> Kernel already maintains counter for each inode, this patch just exposes
>> it into userspace. Returned size is in kilobytes like values in procfs.
> 
> I think this needs a 32-bit compat implementation which clamps the
> returned value to INT_MAX.
> 

32-bit machine couldn't hold more than 2TB cache in one file.
Even radix tree wouldn't fit into low memory area.
