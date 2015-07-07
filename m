From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [RFC 0/8] Additional kmsg devices
Date: Tue, 07 Jul 2015 19:10:56 +0200
Message-ID: <559C0820.3060805@samsung.com>
References: <1435920595-30879-1-git-send-email-m.niesluchow@samsung.com>
 <CAFLxGvxvaePEyCpLrB1cjNn4bvnCwt-_HE3zcT-6diMYNOraBw@mail.gmail.com>
 <5596A58F.7090208@samsung.com> <20150707131124.GI32664@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-reply-to: <20150707131124.GI32664@pathway.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
To: Petr Mladek <pmladek@suse.com>, Marcin Niesluchowski <m.niesluchow@samsung.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Kay Sievers <kay@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Kyungmin Park <kmpark@infradead.org>
List-Id: linux-api@vger.kernel.org

On 2015-07-07 15:11, Petr Mladek wrote:
> On Fri 2015-07-03 17:09:03, Marcin Niesluchowski wrote:
>> On 07/03/2015 01:21 PM, Richard Weinberger wrote:
>>> On Fri, Jul 3, 2015 at 12:49 PM, Marcin Niesluchowski
>>> <m.niesluchow@samsung.com> wrote:
>>>> Dear All,
>>>>
>>>> This series of patches extends kmsg interface with ability to dynamicaly
>>>> create (and destroy) kmsg-like devices which can be used by user space
>>>> for logging. Logging to kernel has number of benefits, including but not
>>>> limited to - always available, requiring no userspace, automatically
>>>> rotating and low overhead.
>>>>
>>>> User-space logging to kernel cyclic buffers was already successfully used
>>>> in android logger concept but it had certain flaws that this commits try
>>>> to address:
>>>> * drops hardcoded number of devices and static paths in favor for dynamic
>>>>   configuration by ioctl interface in userspace
>>>> * extends existing driver instead of creating completely new one
>>> So, now we start moving syslogd into kernel land because userspace is
>>> too broken to provide
>>> decent logging?
>>>
>>> I can understand the systemd is using kmsg if no other logging service
>>> is available
>>> but I really don't think we should encourage other programs to do so.
>>>
>>> Why can't you just make sure that your target has a working
>>> syslogd/rsyslogd/journald/whatever?
>>> All can be done perfectly fine in userspace.
>> * Message credibility: Lets imagine simple service which collects
>> logs via unix sockets. There is no reliable way of identifying
>> logging process. getsockopt() with SO_PEERCRED option would give pid
>> form cred structure, but according to manual it may not be of actual
>> logging process:
>>   "The returned credentials are those that were in effect at the
>> time of the call to connect(2) or socketpair(2)."
>>       - select(7)
>>
>> * Early userspace tool: Helpful especially for embeded systems.
>>
>> * Reliability: Userspace service may be killed due to out of memory
>> (OOM). This is kernel cyclic buffer, which size can be specified
>> differently according to situation.
> But then many services will fight for the space in the kernel ring
> buffer.

Yes.   Please note however that problems you describe are also valid for
/dev/kmsg today.

User space has used (one) writeable kmsg for some time already - which
has caused number of interesting problems caused by the fact that
messages from different domains (kernel, userspace) are written to one
place (ie. systemd "debug" problem).  One of the goals is to avoid this
particular problem and let userspace create, destroy and user their own
buffers at will.

> We will need a mechanism to guarantee a space for each service.

We preserve semantics of kmsg, so I don't see why we would need to give
any more guarantees that what was provided there.

> We will need priorities to throttle various services various ways. 

Appropriate buffer size will throttle messages automatically -  I don't
think we need anything more than that.  See also below.

> It will be easier to lost messages. 

Ability to lose messages is one of the goals -  if we exceed buffer size
and there are no one actively reading buffers this is what we want to
happen.

Say we have one buffer where debug messages go - we are not at all
interested in the content and are very happy to lose these... unless in
the case of crash, where we will have all of it dumped to persistent
storage by pstore (this is when content might be interesting and helpful).

This is just one of many possible scenarios.

> It might be harder to get the important messages on the console when
> the system is going down.

Messages from additional buffers are not intended to be written to console.

> It will be harder to handle continuous lines.

I don't see how it would be different from what we have today.

> I am not sure that we want to go this way.

This is why this thread has RFC tag anyway :^)


Thanks

-- 
Karol Lewandowski, Samsung R&D Institute Poland

