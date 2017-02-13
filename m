From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v4 2/2] procfs/tasks: add a simple per-task procfs
 hidepid= field
Date: Mon, 13 Feb 2017 11:15:03 -0800
Message-ID: <CAGXu5jKJYYkStLM6YhcB_NxfGqx=kVQ-d8QWB2GCBHAksx31MQ@mail.gmail.com>
References: <1484572984-13388-1-git-send-email-djalal@gmail.com>
 <1484572984-13388-3-git-send-email-djalal@gmail.com> <CAEiveUfDvSoW9Hy2Y_uxU2YQ+vR8OvXMqRhxAANTGG7QaQbJeg@mail.gmail.com>
 <CALCETrWEGLhEHO_6sTXreVyWFVsEeYmZSrLNNXx-ma5gd+nTQQ@mail.gmail.com>
 <CAEiveUcrSKS9PHAMpiDRChHHK5QDTPh6G63a0p3iXyYP8Wa27w@mail.gmail.com>
 <CALCETrWn-DpyR5JCGG0H2_yFxU3UHPHZHByXMc5uAxHgQDtnjA@mail.gmail.com>
 <CAGXu5jKz5vo3NwKb_JmNyWDCP0izK=sxTL6Dx_KmYX=1NK+icA@mail.gmail.com> <CALCETrWNY9Ea=3dKksFJjizoH5eZbVOFWFnWoJrCRwP0R1QWHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWNY9Ea=3dKksFJjizoH5eZbVOFWFnWoJrCRwP0R1QWHg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org" <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Lafcadio Wluiki <wluikil-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 13, 2017 at 11:01 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Fri, Feb 10, 2017 at 3:44 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>> On Wed, Jan 18, 2017 at 3:35 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>> On Wed, Jan 18, 2017 at 2:50 PM, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>> Andy I don't follow here, no_new_privs is never cleared right ? I
>>>> can't see the corresponding clear bit code for it.
>>>
>>> I believe that unsharing userns clears no_new_privs.
>>
>> Seriously? That's kind of ... weird. I mean, I guess you're
>> priv-confined in a way, but that seems fragile.
>>
>
> I appear to have made this up.  Either I genuinely pulled it out of
> thin air or it was discussed and not done.
>
> $ setpriv --nnp unshare -Ur cat /proc/self/status |grep NoNewPrivs
> NoNewPrivs:    1
>
> If it were to be done, it ought to be quite safe except for possible LSM issues.

Okay, cool. Thanks. (Also, where does "setpriv" live? I must need a
new set of util-linux or something?)

-Kees

-- 
Kees Cook
Pixel Security
