Return-Path: <SRS0=RkrY=C2=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78DBCC43461
	for <linux-api@archiver.kernel.org>; Thu, 17 Sep 2020 15:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CAB5206B5
	for <linux-api@archiver.kernel.org>; Thu, 17 Sep 2020 15:51:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="BFLuqVFA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbgIQPv3 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 17 Sep 2020 11:51:29 -0400
Received: from linux.microsoft.com ([13.77.154.182]:55182 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727959AbgIQPvA (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 17 Sep 2020 11:51:00 -0400
Received: from [192.168.254.38] (unknown [47.187.206.220])
        by linux.microsoft.com (Postfix) with ESMTPSA id B4CB020B7178;
        Thu, 17 Sep 2020 08:36:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B4CB020B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1600356964;
        bh=QO+LfG0Faopxheg2cutvYRBT+pPhms6wveYLa1LgL+U=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=BFLuqVFA/BDQQm7DZtjpCvIA39dAw9ux6L9xLBXRs6zIIXnRN+iAbXLuSLqhrzA+k
         BG7bFfSeOzurlviYcp2xoC7KmQR6uPkch48sGL+8ZSgMbTtNqSk+vcT3F4zKwn48wg
         Rw5oLxGtZN7S6/Kam+IanR5OdBOQIIId/5GCFEoU=
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
To:     Florian Weimer <fw@deneb.enyo.de>
Cc:     kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, oleg@redhat.com,
        x86@kernel.org, libffi-discuss@sourceware.org
References: <20200916150826.5990-1-madvenka@linux.microsoft.com>
 <87v9gdz01h.fsf@mid.deneb.enyo.de>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <96ea02df-4154-5888-1669-f3beeed60b33@linux.microsoft.com>
Date:   Thu, 17 Sep 2020 10:36:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87v9gdz01h.fsf@mid.deneb.enyo.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org



On 9/16/20 8:04 PM, Florian Weimer wrote:
> * madvenka:
> 
>> Examples of trampolines
>> =======================
>>
>> libffi (A Portable Foreign Function Interface Library):
>>
>> libffi allows a user to define functions with an arbitrary list of
>> arguments and return value through a feature called "Closures".
>> Closures use trampolines to jump to ABI handlers that handle calling
>> conventions and call a target function. libffi is used by a lot
>> of different applications. To name a few:
>>
>> 	- Python
>> 	- Java
>> 	- Javascript
>> 	- Ruby FFI
>> 	- Lisp
>> 	- Objective C
> 
> libffi does not actually need this.  It currently collocates
> trampolines and the data they need on the same page, but that's
> actually unecessary.  It's possible to avoid doing this just by
> changing libffi, without any kernel changes.
> 
> I think this has already been done for the iOS port.
> 

The trampoline table that has been implemented for the iOS port (MACH)
is based on PC-relative data referencing. That is, the code and data
are placed in adjacent pages so that the code can access the data using
an address relative to the current PC.

This is an ISA feature that is not supported on all architectures.

Now, if it is a performance feature, we can include some architectures
and exclude others. But this is a security feature. IMO, we cannot
exclude any architecture even if it is a legacy one as long as Linux
is running on the architecture. So, we need a solution that does
not assume any specific ISA feature.

>> The code for trampoline X in the trampoline table is:
>>
>> 	load	&code_table[X], code_reg
>> 	load	(code_reg), code_reg
>> 	load	&data_table[X], data_reg
>> 	load	(data_reg), data_reg
>> 	jump	code_reg
>>
>> The addresses &code_table[X] and &data_table[X] are baked into the
>> trampoline code. So, PC-relative data references are not needed. The user
>> can modify code_table[X] and data_table[X] dynamically.
> 
> You can put this code into the libffi shared object and map it from
> there, just like the rest of the libffi code.  To get more
> trampolines, you can map the page containing the trampolines multiple
> times, each instance preceded by a separate data page with the control
> information.
> 

If you put the code in the libffi shared object, how do you pass data to
the code at runtime? If the code we are talking about is a function, then
there is an ABI defined way to pass data to the function. But if the
code we are talking about is some arbitrary code such as a trampoline,
there is no ABI defined way to pass data to it except in a couple of
platforms such as HP PA-RISC that have support for function descriptors
in the ABI itself.

As mentioned before, if the ISA supports PC-relative data references
(e.g., X86 64-bit platforms support RIP-relative data references)
then we can pass data to that code by placing the code and data in
adjacent pages. So, you can implement the trampoline table for X64.
i386 does not support it.


> I think the previous patch submission has also resulted in several
> comments along those lines, so I'm not sure why you are reposting
> this.

IIRC, I have answered all of those comments by mentioning the point
that we need to support all architectures without requiring special
ISA features. Taking the kernel's help in this is one solution.


> 
>> libffi
>> ======
>>
>> I have implemented my solution for libffi and provided the changes for
>> X86 and ARM, 32-bit and 64-bit. Here is the reference patch:
>>
>> http://linux.microsoft.com/~madvenka/libffi/libffi.v2.txt
> 
> The URL does not appear to work, I get a 403 error.

I apologize for that. That site is supposed to be accessible publicly.
I will contact the administrator and get this resolved.

Sorry for the annoyance.

> 
>> If the trampfd patchset gets accepted, I will send the libffi changes
>> to the maintainers for a review. BTW, I have also successfully executed
>> the libffi self tests.
> 
> I have not seen your libffi changes, but I expect that the complexity
> is about the same as a userspace-only solution.
> 
> 

I agree. The complexity is about the same. But the support is for all
architectures. Once the common code is in place, the changes for each
architecture are trivial.

Madhavan

> Cc:ing libffi upstream for awareness.  The start of the thread is
> here:
> 
> <https://lore.kernel.org/linux-api/20200916150826.5990-1-madvenka@linux.microsoft.com/>
> 
