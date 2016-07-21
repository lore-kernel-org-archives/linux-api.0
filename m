From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: modules: add ro_after_init support
Date: Thu, 21 Jul 2016 19:11:39 -0400
Message-ID: <20160721231139.GA27457@packer-debian-8-amd64.digitalocean.com>
References: <1465863198-15947-1-git-send-email-jeyu@redhat.com>
 <1465863198-15947-2-git-send-email-jeyu@redhat.com>
 <8737nwdcog.fsf@rustcorp.com.au>
 <20160629212713.GB30908@packer-debian-8-amd64.digitalocean.com>
 <87wpl7b7fw.fsf@rustcorp.com.au>
 <CAGXu5j+EER6wQ8vU6RAWK8SZYGYYbX1LThL0V4tP95k3PKoStg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5j+EER6wQ8vU6RAWK8SZYGYYbX1LThL0V4tP95k3PKoStg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

+++ Kees Cook [21/07/16 16:03 -0700]:
>On Wed, Jun 29, 2016 at 9:56 PM, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org> wrote:
>> Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
>>> +++ Rusty Russell [29/06/16 10:38 +0930]:
>>>>Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
>>>>> Add ro_after_init support for modules by adding a new page-aligned section
>>>>> in the module layout (after rodata) for ro_after_init data and enabling RO
>>>>> protection for that section after module init runs.
>>>>>
>>>>> Signed-off-by: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>>
>>>>I would prefer a "bool after_init" flag to module_enable_ro().  It's
>>>>more explicit.
>>>
>>> Sure thing, I was just initially worried about the
>>> module_{enable,disable}_ro() asymmetry. :)
>>
>> Yes, but I think compile-time-analyzable behaviour beats
>> runtime-analyzable behaviour for clarity.
>>
>>>>Exposing the flags via uapi looks like a wart, but it's kind of a
>>>>feature, since we don't *unset* it in any section; userspace may want to
>>>>know about it.
>>>
>>> Hm, I'm still unsure about this. I'm starting to think it might be a
>>> bit overkill to expose SHF_RO_AFTER_INIT through uapi (although that
>>> is where all the other SHF_* flags are defined) SHF_RO_AFTER_INIT
>>> would technically be used only internally in the kernel (i.e. module
>>> loader), and it'd also be considered a non-standard flag, using a bit
>>> from SHF_MASKOS (OS-specific range). What do you think?
>>
>> Some arch *could* use it by setting the flag in a section in their
>> module I think; we don't stop them.  Since the other flags are there,
>> I'd leave it.
>>
>> We don't expose the flags via sysfs, though, so that's the only
>> exposure.
>
>What's the state of this series? I'd love it if the functionality
>could land for v4.8...
>

Hi Kees,

Sorry for the delay! Have been busier than usual lately. I'll be able
to get v2 out tomorrow.

Thanks!
Jessica
