From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: modules: add ro_after_init support
Date: Thu, 30 Jun 2016 14:26:51 +0930
Message-ID: <87wpl7b7fw.fsf@rustcorp.com.au>
References: <1465863198-15947-1-git-send-email-jeyu@redhat.com> <1465863198-15947-2-git-send-email-jeyu@redhat.com> <8737nwdcog.fsf@rustcorp.com.au> <20160629212713.GB30908@packer-debian-8-amd64.digitalocean.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160629212713.GB30908@packer-debian-8-amd64.digitalocean.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Kees Cook <keescook@google.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Jessica Yu <jeyu@redhat.com> writes:
> +++ Rusty Russell [29/06/16 10:38 +0930]:
>>Jessica Yu <jeyu@redhat.com> writes:
>>> Add ro_after_init support for modules by adding a new page-aligned section
>>> in the module layout (after rodata) for ro_after_init data and enabling RO
>>> protection for that section after module init runs.
>>>
>>> Signed-off-by: Jessica Yu <jeyu@redhat.com>
>>
>>I would prefer a "bool after_init" flag to module_enable_ro().  It's
>>more explicit.
>
> Sure thing, I was just initially worried about the
> module_{enable,disable}_ro() asymmetry. :)

Yes, but I think compile-time-analyzable behaviour beats
runtime-analyzable behaviour for clarity.

>>Exposing the flags via uapi looks like a wart, but it's kind of a
>>feature, since we don't *unset* it in any section; userspace may want to
>>know about it.
>
> Hm, I'm still unsure about this. I'm starting to think it might be a
> bit overkill to expose SHF_RO_AFTER_INIT through uapi (although that
> is where all the other SHF_* flags are defined) SHF_RO_AFTER_INIT
> would technically be used only internally in the kernel (i.e. module
> loader), and it'd also be considered a non-standard flag, using a bit
> from SHF_MASKOS (OS-specific range). What do you think?

Some arch *could* use it by setting the flag in a section in their
module I think; we don't stop them.  Since the other flags are there,
I'd leave it.

We don't expose the flags via sysfs, though, so that's the only
exposure.

Thanks!
Rusty.
