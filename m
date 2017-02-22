From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v3 0/4] Improved seccomp logging
Date: Wed, 22 Feb 2017 10:46:30 -0800
Message-ID: <CAGXu5jLtLgYmDJDfGA2EtfB7Fqze-SP768ezq=fgWZ=X-ObW3w@mail.gmail.com>
References: <1487043928-5982-1-git-send-email-tyhicks@canonical.com>
 <CALCETrXbPQg2V_=3OqZRXbzOf7zGJ8V_RZ5YQ5CHtEEkA0n5HQ@mail.gmail.com> <CAGXu5j+muyh2bwtMXDHuUHsDV9ZyEY-hMHrJjVuX2vC20MVSZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5j+muyh2bwtMXDHuUHsDV9ZyEY-hMHrJjVuX2vC20MVSZw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Crispin <john-Pj+rj9U5foFAfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 16, 2017 at 3:29 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> On Wed, Feb 15, 2017 at 7:24 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>> On Mon, Feb 13, 2017 at 7:45 PM, Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
>>> This patch set is the third revision of the following two previously
>>> submitted patch sets:
>>>
>>> v1: http://lkml.kernel.org/r/1483375990-14948-1-git-send-email-tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org
>>> v1: http://lkml.kernel.org/r/1483377999-15019-2-git-send-email-tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org
>>>
>>> v2: http://lkml.kernel.org/r/1486100262-32391-1-git-send-email-tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org
>>>
>>> The patch set aims to address some known deficiencies in seccomp's current
>>> logging capabilities:
>>>
>>>   1. Inability to log all filter actions.
>>>   2. Inability to selectively enable filtering; e.g. devs want noisy logging,
>>>      users want relative quiet.
>>>   3. Consistent behavior with audit enabled and disabled.
>>>   4. Inability to easily develop a filter due to the lack of a
>>>      permissive/complain mode.
>>
>> I think I dislike this, but I think my dislikes may be fixable with
>> minor changes.
>>
>> What I dislike is that this mixes app-specific built-in configuration
>> (seccomp) with global privileged stuff (audit).  The result is a
>> potentially difficult to use situation in which you need to modify an
>> app to make it loggable (using RET_LOG) and then fiddle with
>> privileged config (auditctl, etc) to actually see the logs.
>
> You make a good point about RET_LOG vs log_max_action. I think making
> RET_LOG the default value would work for 99% of the cases.

Actually, I take this back: making "log" the default means that
everything else gets logged too, include "expected" return values like
errno, trap, etc. I think that would be extremely noisy as a default
(for upstream or Ubuntu).

Perhaps RET_LOG should unconditionally log? Or maybe the logged
actions should be a bit field instead of a single value? Then the
default could be "RET_KILL and RET_LOG", but an admin could switch it
to just RET_KILL, or even nothing at all? Hmmm...

-Kees

-- 
Kees Cook
Pixel Security
