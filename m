From: Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 2/2] mm/page_ref: add tracepoint to track down page
 reference manipulation
Date: Thu, 18 Feb 2016 16:46:08 +0900
Message-ID: <CAAmzW4M3efu7T-PGtBwN=uNZ+bYpWCX+DBQK_nS149O9yyUu0w@mail.gmail.com>
References: <1455505490-12376-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1455505490-12376-2-git-send-email-iamjoonsoo.kim@lge.com>
	<20160215110741.7c0c5039@gandalf.local.home>
	<20160216004720.GA1782@js1304-P5Q-DELUXE>
	<20160215201602.350d73fa@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160215201602.350d73fa@gandalf.local.home>
Sender: owner-linux-mm@kvack.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Nazarewicz <mina86@mina86.com>, Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@techsingularity.net>, Vlastimil Babka <vbabka@suse.cz>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

2016-02-16 10:16 GMT+09:00 Steven Rostedt <rostedt@goodmis.org>:
> On Tue, 16 Feb 2016 09:47:20 +0900
> Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
>
>> > They return true when CONFIG_TRACEPOINTS is configured in and the
>> > tracepoint is enabled, and false otherwise.
>>
>> This implementation is what you proposed before. Please refer below
>> link and source.
>>
>> https://lkml.org/lkml/2015/12/9/699
>> arch/x86/include/asm/msr.h
>
> That was a year ago, how am I suppose to remember ;-)

I think you are smart enough to remember. :)
I will add it on commit description on next spin.

>>
>> There is header file dependency problem between mm.h and tracepoint.h.
>> page_ref.h should be included in mm.h and tracepoint.h cannot
>> be included in this case.
>
> Ah, OK, I forgot about that. I'll take another look at it again.
>
> A lot happened since then, that's all a fog to me.

Okay. Please let me know result of another look.

Thanks.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
