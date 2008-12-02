From: "Michael Kerrisk" <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [PATCH] getrusage: fill ru_maxrss value
Date: Tue, 2 Dec 2008 11:50:45 -0500
Message-ID: <cfd18e0f0812020850v90b2e03me7dd43cf314a409@mail.gmail.com>
References: <20081202131802.5252b96d@psychotron.englab.brq.redhat.com>
	 <20081202160507.GA14524@redhat.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081202160507.GA14524-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jiri Pirko <jpirko-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Dec 2, 2008 at 11:05 AM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 12/02, Jiri Pirko wrote:
>>
>> Based on the patch previously posted by Frank Mayhar:
>> http://kerneltrap.org/mailarchive/linux-kernel/2007/9/20/264772
>>
>> Changed to do not panic and to set the value properly. Also made some
>> modifications as Oleg suggested. maxrss value is set to pages as "time"
>> application converts it co KBs.
>>
>> This patch enables "time" application to show maxresident value
>> correctly.
>
> I believe the changelog could be a bit more descriptive ;)
> And I think the patch needs more CCs. (Hugh and Michael cc'ed).

Thanks Oleg.

Jiri: linux-api@ should also be CCed on API changes; see
Documentation/SubmitChecklist and
http://thread.gmane.org/gmane.linux.ltp/5658

> What about exec? Should we preserve signal_struct->maxrss, or should
> we reset it? I don't know what is the right behaviour, but imho it
> should be consistent with task_mem()/xacct_add_tsk(). And since
> bprm_mm_init() does not copy ->hiwater_xxx, perhaps we should reset.
> Or we should change the exec_mmap() path to preserve ->hiwater_xxx,
> I dunno.
>
>> Note that even without this patch applied there is a race between two
>> parallel update_hiwater_rss() callers.
>>
>> [...snip...]
>> @@ -1051,6 +1051,8 @@ NORET_TYPE void do_exit(long code)
>>       if (tsk->mm) {
>>               update_hiwater_rss(tsk->mm);
>>               update_hiwater_vm(tsk->mm);
>> +
>> +             tsk->signal->maxrss = tsk->mm->hiwater_rss;
>
> Yes. But still it is not good the patch adds new racy calls
> (k_getrusage() too). And in fact I think this code in do_exit()
> should die, and we can update signal->maxrss in exit_mm().
>
> Unless I missed something, the "if (tsk->mm) {}" code in
> do_exit() is not needed because xacct_add_tsk() is not right
> anyway. What we imho need is get_mm_hiwater_xxx(), can be
> also used by task_mm().
>
> I'll send the patch a bit later, then we can tweak this patch.
>
> Do you agree?
>
> (just in case, I don't mean that mm/ uses update_hiwater_xxx()
>  "safely", afaics try_to_unmap can race with unmap_region
>  for example, but still).
>
> Oleg.
>
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
