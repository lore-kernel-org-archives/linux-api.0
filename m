From: Marcin Niesluchowski <m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC 0/8] Additional kmsg devices
Date: Fri, 03 Jul 2015 17:09:03 +0200
Message-ID: <5596A58F.7090208@samsung.com>
References: <1435920595-30879-1-git-send-email-m.niesluchow@samsung.com>
 <CAFLxGvxvaePEyCpLrB1cjNn4bvnCwt-_HE3zcT-6diMYNOraBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <CAFLxGvxvaePEyCpLrB1cjNn4bvnCwt-_HE3zcT-6diMYNOraBw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 07/03/2015 01:21 PM, Richard Weinberger wrote:
> On Fri, Jul 3, 2015 at 12:49 PM, Marcin Niesluchowski
> <m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> wrote:
>> Dear All,
>>
>> This series of patches extends kmsg interface with ability to dynamicaly
>> create (and destroy) kmsg-like devices which can be used by user space
>> for logging. Logging to kernel has number of benefits, including but not
>> limited to - always available, requiring no userspace, automatically
>> rotating and low overhead.
>>
>> User-space logging to kernel cyclic buffers was already successfully used
>> in android logger concept but it had certain flaws that this commits try
>> to address:
>> * drops hardcoded number of devices and static paths in favor for dynamic
>>    configuration by ioctl interface in userspace
>> * extends existing driver instead of creating completely new one
> So, now we start moving syslogd into kernel land because userspace is
> too broken to provide
> decent logging?
>
> I can understand the systemd is using kmsg if no other logging service
> is available
> but I really don't think we should encourage other programs to do so.
>
> Why can't you just make sure that your target has a working
> syslogd/rsyslogd/journald/whatever?
> All can be done perfectly fine in userspace.
* Message credibility: Lets imagine simple service which collects logs 
via unix sockets. There is no reliable way of identifying logging 
process. getsockopt() with SO_PEERCRED option would give pid form cred 
structure, but according to manual it may not be of actual logging process:
   "The returned credentials are those that were in effect at the time 
of the call to connect(2) or socketpair(2)."
       - select(7)

* Early userspace tool: Helpful especially for embeded systems.

* Reliability: Userspace service may be killed due to out of memory 
(OOM). This is kernel cyclic buffer, which size can be specified 
differently according to situation.

* Possibility of using it with pstore: This code could be extended to 
log additional buffers to persistent storage same way main (kmsg) log 
buffer is.

* Use case of attaching file descriptor to stdout/stderr: Especially in 
early userspace.

* Performance: Those services mentioned by You are weeker solutions in 
that case. Especially systemd-journald is much too heavy soulution.

-- 

Best Regards,
Marcin Niesluchowski
