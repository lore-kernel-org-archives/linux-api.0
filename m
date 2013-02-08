From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/3] signalfd: add ability to choose a private or shared queue
Date: Fri, 8 Feb 2013 01:35:14 +0100
Message-ID: <CAKgNAkjq3hVjYA3pVdBhyiFi1PbvXc_mOyvx_FaY67PmAifBOQ@mail.gmail.com>
References: <1358849741-9611-1-git-send-email-avagin@openvz.org>
 <1358849741-9611-3-git-send-email-avagin@openvz.org> <20130207181706.GA8780@redhat.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130207181706.GA8780-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 7, 2013 at 7:17 PM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> AOn 01/22, Andrey Vagin wrote:
>>
>> This patch is added two flags SFD_SHARED_QUEUE and SFD_PER_THREAD_QUEUE
>> SFD_SHARED_QUEUE
>
> I can't believe I am going to blame the naming ;) but these 2 do not look
> "symmetrical"....
>
> SFD_PRIVATE_QUEUE looks a little bit better to me. At least it is simpler
> to type. But I am fine either way.

At the risk of bikeshedding.... The point is that there are two
queues, the process-wide queue or the per-thread queue. "Private" does
not come into. And "Shared" is a little confusing. Adding those two
terms into the mix is just confusing: it doesn't fit with the
user-space view of signals.

I'd greatly prefer names that really say what these things are. Thus:

SFD_PROCESS_QUEUE + SFD_THREAD_QUEUE
or
SFD_PROCESS_WIDE_QUEUE + SFD_PER_THREAD_QUEUE
or
SFD_PROCESS_Q + SFD_THREAD_Q
or
[some consistent variation of the above]

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
