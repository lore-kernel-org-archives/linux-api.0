From: Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: utimensat EACCES vs. EPERM in 4.8+
Date: Tue, 17 Jan 2017 10:39:37 +0100
Message-ID: <CAOssrKd32K-e5794m9KOjrMm_E3VZ7P-bvZW2P8UpGFTOgi8JQ@mail.gmail.com>
References: <18a5b416-ad6a-e679-d993-af7ffa0dcc10@redhat.com>
 <CAOssrKfb1-C8c=9bAPiairh+Lyf=w28r+RjSXTLQcQZ-=eWMRA@mail.gmail.com>
 <CAKgNAkjTkBMY0wrj3wsH39YF=bHp=8mbYrXkSPzn0X4ezfso1w@mail.gmail.com>
 <280513509.810300.1484639500985.JavaMail.zimbra@redhat.com> <20170117075702.GB10417@rei.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170117075702.GB10417-2UyX9mZUyMU@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
Cc: Jan Stancek <jstancek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, mtk manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, guaneryu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ltp-cunTk1MwBs91InPhgRC9rw@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 17, 2017 at 8:57 AM, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org> wrote:
> Hi!
>> > Jan, thanks for spotting this.
>>
>> Credit goes to Cyril. As for LTP-20170116 (released yesterday) we went
>> with current documented behavior - few failures are expected on 4.8+.
>
> Actually credit goes to SUSE QAM that caught the change on kernel
> update :-).

And while this makes for a nice discussion, it is almost completely
irrelevant in real life, since the only thing broken by this change
will be test suites (in other words immutable files are rare as hen's
teeth).

If you find that this change actually breaks something other than a
test suite, then yes, please lets revert it.  Otherwise there's not
much point (distros can revert it for themselves if they want be
paranoid).

Thanks,
Miklos
