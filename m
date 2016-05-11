From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] mmap.2: clarify MAP_LOCKED semantic
Date: Wed, 11 May 2016 13:18:05 +0200
Message-ID: <573314ED.4090704@infradead.org>
References: <1431527892-2996-1-git-send-email-miso@dhcp22.suse.cz>
 <1431527892-2996-2-git-send-email-miso@dhcp22.suse.cz>
 <57331275.9000805@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <57331275.9000805@infradead.org>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <miso@dhcp22.suse.cz>, Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>
List-Id: linux-api@vger.kernel.org



On 05/11/2016 01:07 PM, Peter Zijlstra wrote:
> On 05/13/2015 04:38 PM, Michal Hocko wrote:
>>
>> This patch makes the semantic of MAP_LOCKED explicit and suggest using
>> mmap + mlock as the only way to guarantee no later major page faults.
>>
>
> URGH, this really blows chunks. It basically means MAP_LOCKED is 
> pointless cruft and we might as well remove it.
>
> Why not fix it proper?

OK; after having been pointed at this discussion, it seems I reacted rather
too hasty in that I didn't read all the previous threads.

 From that it appears fixing this proper is indeed rather hard, and we 
should
indeed consider MAP_LOCKED broken. At which point I would've worded the
manpage update stronger, but alas.

Sorry for the noise.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
