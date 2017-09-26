From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 1/1] audit: Record fanotify access control decisions
Date: Tue, 26 Sep 2017 07:10:24 +0300
Message-ID: <CAOQ4uxi0Zta1VMhWXCfb-ygTwyTEHCAwXHm2K4oQahyez1mdkA@mail.gmail.com>
References: <3856419.lGSJdPn8Ye@x2> <CAOQ4uxizzR=1wMCVMtwSWJzMpopHBK=9GtKnsz-5LP_bsELMgA@mail.gmail.com>
 <2007095.3atlGr9L8Y@x2>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <2007095.3atlGr9L8Y@x2>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Steve Grubb <sgrubb@redhat.com>
Cc: fsdevel <linux-fsdevel@vger.kernel.org>, Linux Audit <linux-audit@redhat.com>, linux-api@vger.kernel.org, Jan Kara <jack@suse.cz>, Paul Moore <pmoore@redhat.com>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 25, 2017 at 11:37 PM, Steve Grubb <sgrubb@redhat.com> wrote:
> On Monday, September 25, 2017 2:49:19 PM EDT Amir Goldstein wrote:
...
>> >
>> > +       if (flags & FAN_ENABLE_AUDIT) {
>> > +               fd = -EPERM;
>> > +               if (!capable(CAP_AUDIT_WRITE))
>> > +                       goto out_destroy_group;
>> > +               group->audit_enabled = 1;
>> > +       }
>> > +
>>
>> App should not be able to enable audit if audit is not configured in kernel.
>> So there should be code that returns EINVAL for flag FAN_ENABLE_AUDIT if
>> CONFIG_AUDITSYSCALL is not defined.
>> Same deal as flag FAN_ALL_PERM_EVENTS and kernel config
>> CONFIG_FANOTIFY_ACCESS_PERMISSIONS in fanotify_mark().
>> Perhaps it is better not to extend FAN_ALL_INIT_FLAGS and explicitly
>> test (flags & ~(FAN_ALL_INIT_FLAGS | FAN_ENABLE_AUDIT)) in fanotify_init()
>> under ifdef, as done in fanotify_mark()?
>
> OK. How about this, I do the (flags & ~(FAN_ALL_INIT_FLAGS |
> FAN_ENABLE_AUDIT)) with an ifdef. This will cause -EINVAL if FAN_ENABLE_AUDIT
> is attempted and CONFIG_AUDITSYSCALL is not defined. So, the code initially
> discussed above for audit_enabled would not need to have an #else. I can
> surround the "if" block with a CONFIG_AUDITSYSCALL so that it compiles out if
> audit is not being used. This will cause audit_enabled to always be false when
> audit is not compiled in.
>

Sure. only there is no need for wrapping the if block with ifdef as the flag
FAN_ENABLE_AUDIT is already not possible due to the first check, so by
rule of "use bare minimum ifdefs" there is no need for the second ifdef.

Amir.
