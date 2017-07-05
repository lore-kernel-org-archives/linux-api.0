From: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Wed, 5 Jul 2017 08:16:33 -0700
Message-ID: <a462fb3b-a6d4-e969-b301-b404981de224@roeck-us.net>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info>
 <20170703123025.7479702e@gandalf.local.home>
 <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
 <20170705084528.67499f8c@gandalf.local.home>
 <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
 <20170705092757.63dc2328@gandalf.local.home>
 <20170705140607.GA30187@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170705140607.GA30187-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 07/05/2017 07:06 AM, Greg KH wrote:
> On Wed, Jul 05, 2017 at 09:27:57AM -0400, Steven Rostedt wrote:
>> Your "b" above is what I would like to push. But who's going to enforce
>> this? With 10,000 changes per release, and a lot of them are fixes, the
>> best we can do is the honor system. Start shaming people that don't
>> have a regression test along with a Fixes tag (but we don't want people
>> to fix bugs without adding that tag either). There is a fine line one
>> must walk between getting people to change their approaches to bugs and
>> regression tests, and pissing them off where they start doing the
>> opposite of what would be best for the community.
> 
> I would bet, for the huge majority of our fixes, they are fixes for
> specific hardware, or workarounds for specific hardware issues.  Now
> writing tests for those is not an impossible task (look at what the i915
> developers have), but it is very very hard overall, especially if the
> base infrastructure isn't there to do it.
> 
> For specific examples, here's the shortlog for fixes that went into
> drivers/usb/host/ for 4.12 after 4.12-rc1 came out.  Do you know of a
> way to write a test for these types of things?
> 	usb: xhci: ASMedia ASM1042A chipset need shorts TX quirk
> 	usb: xhci: Fix USB 3.1 supported protocol parsing
> 	usb: host: xhci-plat: propagate return value of platform_get_irq()
> 	xhci: Fix command ring stop regression in 4.11
> 	xhci: remove GFP_DMA flag from allocation
> 	USB: xhci: fix lock-inversion problem
> 	usb: host: xhci-ring: don't need to clear interrupt pending for MSI enabled hcd
> 	usb: host: xhci-mem: allocate zeroed Scratchpad Buffer
> 	xhci: apply PME_STUCK_QUIRK and MISSING_CAS quirk for Denverton
> 	usb: xhci: trace URB before giving it back instead of after
> 	USB: host: xhci: use max-port define
> 	USB: ehci-platform: fix companion-device leak
> 	usb: r8a66597-hcd: select a different endpoint on timeout
> 	usb: r8a66597-hcd: decrease timeout
> 
> And look at the commits with the "Fixes:" tag in it, I do, I read every
> one of them.  See if writing a test for the majority of them would even
> be possible...
> 
> I don't mean to poo-poo the idea, but please realize that around 75% of
> the kernel is hardware/arch support, so that means that 75% of the
> changes/fixes deal with hardware things (yes, change is in direct
> correlation to size of the codebase in the tree, strange but true).
> 

The reproducers for several of the usb fixes I submitted recently took hours of
stress test to reproduce the underlying problems. I have one more to fix which
takes days to reproduce, if at all (I have seen that problem only two or three
times during weeks of stress test). Due to the nature of the problems, reproducing
them heavily depended on the underlying hardware. None of the reproducers can
guarantee that the problem is fixed; they are intended to show the problem,
not that it is fixed. This happens a lot with race conditions - in many cases
it is impossible to prove that the problem is fixed; one can only prove that
it still exists.

Echoing what you said, I have no idea how it would even be possible to write
unit tests to verify if the problems I fixed are really fixed.

Several of the fixes I have submitted are based on single-instance error logs with
no reproducer. Many others are compile time fixes or fix problems found with code
inspection (manual or automatic).

If we start shaming people for not providing unit tests, all we'll accomplish is
that people will stop providing bug fixes.

Guenter
