From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 2/3] perf: Userspace event
Date: Tue, 4 Nov 2014 19:40:31 +0100
Message-ID: <20141104184031.GM10501@worktop.programming.kicks-ass.net>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
 <1415060918-19954-3-git-send-email-pawel.moll@arm.com>
 <87ppd35vbk.fsf@sejong.aot.lge.com>
 <1415119331.24819.19.camel@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1415119331.24819.19.camel-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Cc: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 04, 2014 at 04:42:11PM +0000, Pawel Moll wrote:
> 
> 1. I'm wrong and the record doesn't have to be padded to make it 8 bytes
> aligned. Then I can drop the additional size field.

No, you're right, we're supposed to stay 8 byte aligned.

> 2. I could impose a limitation on the prctl API that the data size must
> be 8 bytes aligned. Bad idea in my opinion, I'd rather not.

Agreed.

> 3. The additional size (for the data part) field stays. Notice that
> PERF_SAMPLE_RAW has it as well :-)

Right, with binary data there is no other day. With \0 terminated
strings there won't be a problem, but I think we decided we wanted to
allow any binary blow.
