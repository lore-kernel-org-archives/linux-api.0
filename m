From: Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 2/2] mm/page_ref: add tracepoint to track down page
 reference manipulation
Date: Fri, 19 Feb 2016 10:20:54 +0900
Message-ID: <CAAmzW4O=S7YYGdtyGt181x72S=G5pxYChGKjPWXWRkjFBSFkrA@mail.gmail.com>
References: <1455505490-12376-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1455505490-12376-2-git-send-email-iamjoonsoo.kim@lge.com>
	<20160218092926.083ca007@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160218092926.083ca007@gandalf.local.home>
Sender: owner-linux-mm@kvack.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Nazarewicz <mina86@mina86.com>, Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@techsingularity.net>, Vlastimil Babka <vbabka@suse.cz>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
List-Id: linux-api@vger.kernel.org

2016-02-18 23:29 GMT+09:00 Steven Rostedt <rostedt@goodmis.org>:
> On Mon, 15 Feb 2016 12:04:50 +0900
> js1304@gmail.com wrote:
>
>
>> diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
>> index 534249c..fd6d9a5 100644
>> --- a/include/linux/page_ref.h
>> +++ b/include/linux/page_ref.h
>> @@ -1,6 +1,54 @@
>>  #include <linux/atomic.h>
>>  #include <linux/mm_types.h>
>>  #include <linux/page-flags.h>
>> +#include <linux/tracepoint-defs.h>
>> +
>> +extern struct tracepoint __tracepoint_page_ref_set;
>> +extern struct tracepoint __tracepoint_page_ref_mod;
>> +extern struct tracepoint __tracepoint_page_ref_mod_and_test;
>> +extern struct tracepoint __tracepoint_page_ref_mod_and_return;
>> +extern struct tracepoint __tracepoint_page_ref_mod_unless;
>> +extern struct tracepoint __tracepoint_page_ref_freeze;
>> +extern struct tracepoint __tracepoint_page_ref_unfreeze;
>> +
>> +#ifdef CONFIG_DEBUG_PAGE_REF
>
> Please add a comment here. Something to the effect of:

Okay!

> /*
>  * Ideally we would want to use the trace_<tracepoint>_enabled() helper
>  * functions. But due to include header file issues, that is not
>  * feasible. Instead we have to open code the static key functions.
>  *
>  * See trace_##name##_enabled(void) in include/linux/tracepoint.h
>  */
>
> I may have to work on something that lets these helpers be defined in
> headers. I have some ideas on how to do that. But for now, this
> solution is fine.

Okay.

Thanks.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
