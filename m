From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
Date: Fri, 2 Jun 2017 12:25:25 -0700
Message-ID: <CAGXu5jLuqApE_yLNwHDZYfE7ujM2hVSr1dd_WHPfREPUiEwE-Q@mail.gmail.com>
References: <20170531005633.484a2e14@alans-desktop> <CAGXu5j+pqD1082fYDS_dvDB2QNvt9wSz+C7vAhGpMXcJWxoDkw@mail.gmail.com>
 <20170601140812.583cf0a5@alans-desktop> <CAGXu5jLefv=T3mCYryqh2pYjYonFsTQZSLsHqLK75CKvSmgb-w@mail.gmail.com>
 <20170601222432.6f593538@lxorguk.ukuu.org.uk> <2d0ad49c-886e-1caf-771a-d251957f614c@nmatt.com>
 <20170602153647.GA2688@mail.hallyn.com> <a3c1b792-a426-90e1-e37b-9f9a8d4d192a@nmatt.com>
 <20170602165732.GA3614@mail.hallyn.com> <3027e4fa-5dc2-a52f-8699-9974cb4d4b6b@nmatt.com>
 <20170602181822.GA5125@mail.hallyn.com> <1de2da93-01f5-1e26-ba4e-7c28fd9859f4@nmatt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1de2da93-01f5-1e26-ba4e-7c28fd9859f4-YiBOUZGZpYMAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Brown <matt-YiBOUZGZpYMAvxtiuMwx3w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Boris Lukashev <blukashev-JNja4Z15B3SvB/ACxS1yDA@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org" <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 2, 2017 at 12:22 PM, Matt Brown <matt-YiBOUZGZpYMAvxtiuMwx3w@public.gmane.org> wrote:
> On 6/2/17 2:18 PM, Serge E. Hallyn wrote:
>> Quoting Matt Brown (matt-YiBOUZGZpYMAvxtiuMwx3w@public.gmane.org):
>>> On 6/2/17 12:57 PM, Serge E. Hallyn wrote:
>>>> I'm not quite sure what you're asking for here.  Let me offer a precise
>>>> strawman design.  I'm sure there are problems with it, it's just a starting
>>>> point.
>>>>
>>>> system-wide whitelist (for now 'may_push_chars') is full by default.
>>>>
>>>
>>> So is may_push_chars just an alias for TIOCSTI? Or are there some
>>> potential whitelist members that would map to multiple ioctls?
>>
>> <shrug>  I'm seeing it as only TIOCSTI right now.
>>
>>>> By default, nothing changes - you can use those on your own tty, need
>>>> CAP_SYS_ADMIN against init_user_ns otherwise.
>>>>
>>>> Introduce a new CAP_TTY_PRIVILEGED.
>>>>
>>>
>>> I'm fine with this.
>>>
>>>> When may_push_chars is removed from the whitelist, you lose the ability
>>>> to use TIOCSTI on a tty - even your own - if you do not have CAP_TTY_PRIVILEGED
>>>> against the tty's user_ns.
>>>>
>>>
>>> How do you propose storing/updating the whitelist? sysctl?
>>>
>>> If it is a sysctl, would each whitelist member have a sysctl?
>>> e.g.: kernel.ioctlwhitelist.may_push_chars = 1
>>>
>>> Overall, I'm fine with this idea.
>>
>> That sounds reasonable.  Or a securityfs file - I guess not everyone
>> has securityfs, but if it were to become part of YAMA then that would
>> work.
>>
>
> Yama doesn't depend on securityfs does it?
>
> What do other people think? Should this be an addition to YAMA or its
> own thing?
>
> Alan Cox: what do you think of the above ioctl whitelisting scheme?

It's easy to stack LSMs, so since Yama is ptrace-focused, perhaps make
a separate one for TTY hardening?

-Kees

-- 
Kees Cook
Pixel Security
