From: George Dunlap <George.Dunlap-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH 1/2] xen: Implement ioctl to restrict privcmd
 to a specific domain
Date: Thu, 31 Jul 2014 13:49:10 -0400
Message-ID: <CAFLBxZYnaeEGTbuU5QoKJOU62Ck9p_B53bjAd46Z7uVgOxXH8g@mail.gmail.com>
References: <E1XCqEY-0005zn-RQ@lists.xen.org>
	<1406814787.10395.2.camel@kazak.uk.xensource.com>
	<E1XCr4p-0007Nh-Qu@lists.xen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E1XCr4p-0007Nh-Qu-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Cc: Ian Campbell <Ian.Campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Frediano Ziglio <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, xen-devel <xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 31, 2014 at 10:11 AM, David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org> wrote:
> On 31/07/14 14:53, Ian Campbell wrote:
>> On Thu, 2014-07-31 at 14:16 +0100, Frediano Ziglio wrote:
>>
>>>  include/xen/interface/domctl.h     | 1090 ++++++++++++++++++++++++++++++++++++
>>
>> domctl is an stable toolstack only hypervisor interface, so the kernel
>> cannot use it because it would then break.
>
> Ok.  I guess we'll have to resurrect the idea to do something with XSM.

What kind of thing did you have in mind for XSM?

In general it seems like allowing a vcpu to switch into an XSM label
(not sure I've got the terminology right here) when it context
switches into a particular process might be the most flexible way for
that to work.

But would that actually be easier than implementing stub domains?

 -George
