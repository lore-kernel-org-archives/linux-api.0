From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] seccomp.2: document seccomp syscall
Date: Sun, 02 Nov 2014 17:37:06 +0100
Message-ID: <54565DB2.4040700@gmail.com>
References: <1411685267-27949-1-git-send-email-keescook@chromium.org>	<1411685267-27949-2-git-send-email-keescook@chromium.org>	<CALCETrVaYjrq0xBDouu9ZQ3Hm65Dmt2Uih4zscCGcDC+M89+qg@mail.gmail.com> <CAGXu5jJEn5QZPrVa4UjuT34PVuadhXqSb_d=o3W04QvZq-fMNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jJEn5QZPrVa4UjuT34PVuadhXqSb_d=o3W04QvZq-fMNw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 09/26/2014 07:55 AM, Kees Cook wrote:
> On Thu, Sep 25, 2014 at 6:29 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>> On Thu, Sep 25, 2014 at 3:47 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>>> +.SH VERSIONS
>>> +This system call first appeared in Linux 3.16.
>>> +.\" FIXME Add glibc version
>>
>> 3.17?  (And remove FIXME?)
>>
>> Otherwise I like it.
> 
> Ooops, yes: 3.17. Michael do you want me to resend with that
> corrected, or do you want to handle fixing that from this version?

No need. I've fixed that.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
