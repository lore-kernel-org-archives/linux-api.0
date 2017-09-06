From: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/1] audit: Record fanotify access control decisions
Date: Wed, 6 Sep 2017 14:11:48 +0300
Message-ID: <CAOQ4uxjvbUnvZycF+t6=L_zK-hWsXL9VaFnXDV6muLOwBEqWew@mail.gmail.com>
References: <1970763.eSnnJ2BxMO@x2> <20170906091822.GB27916@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170906091822.GB27916-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Steve Grubb <sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Audit <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Sep 6, 2017 at 12:18 PM, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> wrote:
> On Tue 05-09-17 14:32:07, Steve Grubb wrote:
>> The fanotify interface allows user space daemons to make access
>>  control decisions. Under common criteria requirements, we need to
>>  optionally record decisions based on policy. This patch adds a bit mask,
>>  FAN_AUDIT, that a user space daemon can 'or' into the response decision
>>  which will tell the kernel that it made a decision and record it.
>
> [Since this is API change, added linux-api to CC, also added Amir since he
> works with fanotify]
>
> Hum, probably I'm missing something here but why an application responding
> to fanotify event should need to know about audit? Or is it that for CC
> requirements you have to implement some deamon which will arbitrate access
> using fanotify and you need to have decisions logged using kernel audit
> interface?
>
> And another design question: If you need all responses by some daemon
> logged, wouldn't it be more logical to make FAN_AUDIT a property of
> fanotify instance (i.e., a flag to fanotify_init(2))? Or maybe a property
> of fanotify mark (i.e., a flag to fanotify_mark(2))?
>

Even if the use case is auditing blocklisted files, the change of ABI on the
response fd should be opt-in by a new flag to fanotify_init(), something like
FAN_CAN_AUDIT.

In other words, your new daemon that responds with FAN_AUDIT must
fail to start when running on an old kernel that doesn't support the FAN_AUDIT
response, unless it knows how to fall back and call fanotify_init()
again without
FAN_CAN_AUDIT and then not respond with FAN_AUDIT.

Other than that, I agree with Jan that setting FAN_AUDIT by default for
all permission responses at fanotify_init() and maybe fanotify_mark()
sounds useful.
IMO, it makes most sense in proximity to defining the notification class, e.g.:
fanotify_init(FAN_CLASS_CONTENT|FAN_PERM_AUDIT, 0);

Amir.
