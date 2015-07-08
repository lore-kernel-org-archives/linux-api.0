From: Marcin Niesluchowski <m.niesluchow@samsung.com>
Subject: Re: [RFC 0/8] Additional kmsg devices
Date: Wed, 08 Jul 2015 10:30:03 +0200
Message-ID: <559CDF8B.2090000@samsung.com>
References: <1435920595-30879-1-git-send-email-m.niesluchow@samsung.com>
 <CAFLxGvxvaePEyCpLrB1cjNn4bvnCwt-_HE3zcT-6diMYNOraBw@mail.gmail.com>
 <5596A58F.7090208@samsung.com> <5596A80D.5040109@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-reply-to: <5596A80D.5040109@nod.at>
Sender: linux-doc-owner@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.cz>, Tejun Heo <tj@kernel.org>, Kay Sievers <kay@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
List-Id: linux-api@vger.kernel.org

On 07/03/2015 05:19 PM, Richard Weinberger wrote:
> Am 03.07.2015 um 17:09 schrieb Marcin Niesluchowski:
>>> Why can't you just make sure that your target has a working
>>> syslogd/rsyslogd/journald/whatever?
>>> All can be done perfectly fine in userspace.
>> * Message credibility: Lets imagine simple service which collects logs via unix sockets. There is no reliable way of identifying logging process. getsockopt() with SO_PEERCRED
>> option would give pid form cred structure, but according to manual it may not be of actual logging process:
>>    "The returned credentials are those that were in effect at the time of the call to connect(2) or socketpair(2)."
>>        - select(7)
> This interface can be improved. Should be easy.

What kind of improvement do you have in mind?

>> * Early userspace tool: Helpful especially for embeded systems.
> This is what we do already. In early user space spawn your logger as early as possible.
> "embedded Linux is special" is not an excuse btw. ;)

I would say "embedded Linux is real use case"instead of "special". What 
I meant that it does only require one ioctl and no additional resources 
are needed.

>> * Reliability: Userspace service may be killed due to out of memory (OOM). This is kernel cyclic buffer, which size can be specified differently according to situation.
> This is what we have /proc/<pid>/oom_adj and /proc/<pid>/oom_score_adj for.

You are right, but additional resources and complexity is required.

>> * Possibility of using it with pstore: This code could be extended to log additional buffers to persistent storage same way main (kmsg) log buffer is.
> pstorefs and friends?

pstore filesystem is used to access already stored kernel data (e.g. 
kmsg buffer). But does not provide mechanism of storing userspace memory.

>> * Use case of attaching file descriptor to stdout/stderr: Especially in early userspace.
> You can redirect these also in userspace.

True for that, but as I said in my first argument there is no 
possibility of logging process identification in case of sockets.


>> * Performance: Those services mentioned by You are weeker solutions in that case. Especially systemd-journald is much too heavy soulution.
> Do you have numbers? I agree systemd-journald is heavy wight. But it is by far not the only logging daemon we have...

I compared write operations on kmsg buffervia write/read operations on 
socketon SOCK_STREAM socket and sendmsg/recv on SOCK_DGRAM socket. 
Compared toSOCK_STREAM socket it was about 39% slowerbut compared 
toSOCK_DGRAM socket it was about 326% faster.syslogfor example uses 
SOCK_DGRAM sockets.In all cases there were 2^20 (1048576) write/sendmsg 
operations of 2^8 (256) bytes.

Best Regards,
Marcin Niesluchowski
