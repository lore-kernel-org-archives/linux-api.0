From: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: utimensat EACCES vs. EPERM in 4.8+
Date: Mon, 16 Jan 2017 23:50:43 -0500
Message-ID: <432649da-a5d6-e448-e72e-76b68db16bb9@redhat.com>
References: <18a5b416-ad6a-e679-d993-af7ffa0dcc10@redhat.com>
 <CAOssrKfb1-C8c=9bAPiairh+Lyf=w28r+RjSXTLQcQZ-=eWMRA@mail.gmail.com>
 <CAKgNAkjTkBMY0wrj3wsH39YF=bHp=8mbYrXkSPzn0X4ezfso1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkjTkBMY0wrj3wsH39YF=bHp=8mbYrXkSPzn0X4ezfso1w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jan Stancek <jstancek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, guaneryu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, ltp-cunTk1MwBs91InPhgRC9rw@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 01/16/2017 07:04 PM, Michael Kerrisk (man-pages) wrote:
> [CC += linux-api + Dave Chinner]

> Summary of the above list: there's a nontrivial risk that something in
> userspace got broken. (And just because we didn't hear about it yet
> doesn't mean it didn't happen; sometimes these reports only arrive
> many months or even years later.)
> 
> So, (1) I'm struggling to see the rationale for this change (I don't
> think "consistency" is enough) and (2) if "consistency" is the
> argument then (because the set of system calls in [1] are more
> frequently used than those in [2]), there's a reasonable argument that
> the change should have gone the other way: changing all IS_IMMUTABLE
> cases to fail with EACCES.
> 
> Summary: I think there's an argument for reverting the kernel patch.

Completely agree.

Even if you go ahead with these changes, they really should go through
some kind of distro verification [1]. If I even contemplated such a change
in glibc I'd run it through 4-6 months of Fedora Rawhide builds just to
see what breaks before putting it out in a real release (and we do this
frequently for thread-related changes).

-- 
Cheers,
Carlos.

[1] "Usage of Fedora Rawhide" https://fedoraproject.org/wiki/Glibc
