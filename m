From: Daniel Gruss <daniel@gruss.cc>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Mon, 7 Jan 2019 14:29:03 +0100
Message-ID: <3b6525a6-4d8b-b5f4-67cd-0e230eb2691e@gruss.cc>
References: <20190107043227.GA3325@nautica>
 <151b4ac8-5cfc-ed30-db30-e4d67a324c4b@suse.cz>
 <20190107110827.GA15249@nautica>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190107110827.GA15249@nautica>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dominique Martinet <asmadeus@codewreck.org>, Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Jiri Kosina <jikos@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 1/7/19 12:08 PM, Dominique Martinet wrote:
>> That's my bigger concern here. In [1] there's described a remote attack
>> (on webserver) using the page fault timing differences for present/not
>> present page cache pages. Noisy but works, and I expect locally it to be
>> much less noisy. Yet the countermeasures section only mentions
>> restricting mincore() as if it was sufficient (and also how to make
>> evictions harder, but that's secondary IMHO).
> 
> I'd suggest making clock rougher for non-root users but javascript tried
> that and it wasn't enough... :)
> Honestly won't be of much help there, good luck?

Restricting mincore() is sufficient to fix the hardware-agnostic part.
If the attack is not hardware-agnostic anymore, an attacker could also
just use a hardware cache attack, which has a higher temporal and
spatial resolution, so there's no reason why the attacker would use page
cache attacks instead then.


Cheers,
Daniel
