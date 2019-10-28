From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH RFC] fs/fcntl: add fcntl F_GET_RSS
Date: Mon, 28 Oct 2019 14:20:51 +0300
Message-ID: <33978ec2-ac27-1b8b-ba33-3bd2c66aa016@yandex-team.ru>
References: <157225848971.557.16257813537984792761.stgit@buzz>
 <20191028111034.GS2963@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191028111034.GS2963@bombadil.infradead.org>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Roman Gushchin <guro@fb.com>
List-Id: linux-api@vger.kernel.org

On 28/10/2019 14.10, Matthew Wilcox wrote:
> On Mon, Oct 28, 2019 at 01:28:09PM +0300, Konstantin Khlebnikov wrote:
>> +	if (dax_mapping(mapping))
>> +		pages = READ_ONCE(mapping->nrexceptional);
>> +	else
>> +		pages = READ_ONCE(mapping->nrpages);
> 
> I'm not sure this is the right calculation for DAX files.  We haven't
> allocated any memory for DAX; we're just accessing storage directly.
> The entries in the page caache are just translation from file offset to
> physical address.
> 

Yep, makes sense. If RSS declared as memory usage then this chunk must do
pages = READ_ONCE(mapping->nrpages) unconditionally and report 0 for DAX.
