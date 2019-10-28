From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH RFC] fs/fcntl: add fcntl F_GET_RSS
Date: Mon, 28 Oct 2019 15:49:44 +0300
Message-ID: <03f36def-746e-063b-7c42-91244eec87bd@yandex-team.ru>
References: <157225848971.557.16257813537984792761.stgit@buzz>
 <CAHk-=wiCDPd1ivoU5BJBMSt5cmKnX0XFWiinfegyknfoipif0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wiCDPd1ivoU5BJBMSt5cmKnX0XFWiinfegyknfoipif0g@mail.gmail.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>
List-Id: linux-api@vger.kernel.org

On 28/10/2019 15.27, Linus Torvalds wrote:
> On Mon, Oct 28, 2019 at 11:28 AM Konstantin Khlebnikov
> <khlebnikov@yandex-team.ru> wrote:
>>
>> This implements fcntl() for getting amount of resident memory in cache.
>> Kernel already maintains counter for each inode, this patch just exposes
>> it into userspace. Returned size is in kilobytes like values in procfs.
> 
> This doesn't actually explain why anybody would want it, and what the
> usage scenario is.
> 

This really helps to plot memory usage distribution. Right now file cache
have only total counters. Collecting statistics via mincore as implemented
in page-types tool isn't efficient and very racy.

Usage scenario is the same as finding top memory usage among processes.
But among files which are not always mapped anywhere.

For example if somebody writes\reads logs too intensive this file cache
could bloat and push more important data out out memory.

Also little bit of introspection wouldn't hurt.
Using this I've found unneeded pages beyond i_size.

>               Linus
> 
