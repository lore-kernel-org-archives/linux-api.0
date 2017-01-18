From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: utimensat EACCES vs. EPERM in 4.8+
Date: Wed, 18 Jan 2017 21:23:19 +1300
Message-ID: <cb15e28d-8c5e-e3d7-441a-9165c4e57133@gmail.com>
References: <18a5b416-ad6a-e679-d993-af7ffa0dcc10@redhat.com>
 <CAOssrKfb1-C8c=9bAPiairh+Lyf=w28r+RjSXTLQcQZ-=eWMRA@mail.gmail.com>
 <CAKgNAkjTkBMY0wrj3wsH39YF=bHp=8mbYrXkSPzn0X4ezfso1w@mail.gmail.com>
 <280513509.810300.1484639500985.JavaMail.zimbra@redhat.com>
 <20170117075702.GB10417@rei.lan>
 <CAOssrKd32K-e5794m9KOjrMm_E3VZ7P-bvZW2P8UpGFTOgi8JQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOssrKd32K-e5794m9KOjrMm_E3VZ7P-bvZW2P8UpGFTOgi8JQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Jan Stancek <jstancek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, guaneryu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ltp-cunTk1MwBs91InPhgRC9rw@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Miklos,

On 01/17/2017 10:39 PM, Miklos Szeredi wrote:
> On Tue, Jan 17, 2017 at 8:57 AM, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org> wrote:
>> Hi!
>>>> Jan, thanks for spotting this.
>>>
>>> Credit goes to Cyril. As for LTP-20170116 (released yesterday) we went
>>> with current documented behavior - few failures are expected on 4.8+.
>>
>> Actually credit goes to SUSE QAM that caught the change on kernel
>> update :-).
> 
> And while this makes for a nice discussion, it is almost completely
> irrelevant in real life, since the only thing broken by this change
> will be test suites (in other words immutable files are rare as hen's
> teeth).

While I agree that the chances of breakage may be quite small (though
I certainly won't be so bold as to assert that only test suites
will get broken), your comment misses the important metapoint:
changes like this should not just be getting waved through the gate
without some analysis along the lines of what I did. "Consistency"
and an (incorrect) assertion that "In most cases, EPERM is returned
on immutable inode" just don't cut it, when it comes to making
changes of this sort.

> If you find that this change actually breaks something other than a
> test suite, then yes, please lets revert it.  

No. That is not a strategy. I already said it, but I'll say it again:
sometimes these reports only arrive many months or even years later.
And then we can end up with fiascoes such as F_SETOWN/F_SETOWN_EX.
(Essentially: F_SETOWN got subtly changed, and by the time people
realized the breakage had occurred it was *years* late. Too late to
revert... So, then we got F_SETOWN_EX to allow us what F_SETOWN
used to do. See fcntl(2).)

> Otherwise there's not
> much point (distros can revert it for themselves if they want be
> paranoid).

Also not a strategy; distros don't want to carry such junk
patches.

All of this said, I still don't know whether reverting the patch
is warranted...

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
