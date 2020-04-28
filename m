Return-Path: <SRS0=IXk3=6M=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F252DC83000
	for <linux-api@archiver.kernel.org>; Tue, 28 Apr 2020 08:09:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D77E3206B9
	for <linux-api@archiver.kernel.org>; Tue, 28 Apr 2020 08:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgD1IJl (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 28 Apr 2020 04:09:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:50810 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726377AbgD1IJl (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Tue, 28 Apr 2020 04:09:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DF892AD0E;
        Tue, 28 Apr 2020 08:09:37 +0000 (UTC)
Subject: Re: [PATCH v3 1/5] kernel/sysctl: support setting sysctl parameters
 from kernel command line
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-mm@kvack.org, Ivan Teterevkov <ivan.teterevkov@nutanix.com>,
        Michal Hocko <mhocko@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        "Guilherme G . Piccoli" <gpiccoli@canonical.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Michal Hocko <mhocko@suse.com>
References: <20200427180433.7029-1-vbabka@suse.cz>
 <20200427180433.7029-2-vbabka@suse.cz>
 <20200427113331.f0c1e8e7cee98644260448d3@linux-foundation.org>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <d7d01e9e-6b6d-47ce-c750-cd7296e30613@suse.cz>
Date:   Tue, 28 Apr 2020 10:09:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427113331.f0c1e8e7cee98644260448d3@linux-foundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On 4/27/20 8:33 PM, Andrew Morton wrote:
> On Mon, 27 Apr 2020 20:04:29 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:
> 
>> ...
>>  
>> +	sysctl.*=	[KNL]
>> +			Set a sysctl parameter, right before loading the init
>> +			process, as if the value was written to the respective
>> +			/proc/sys/... file. Both '.' and '/' are recognized as
>> +			separators. Unrecognized parameters and invalid values
>> +			are reported in the kernel log. Sysctls registered
>> +			later by a loaded module cannot be set this way.
>> +			Example: sysctl.vm.swappiness=40
> 
> Why support "."?  I think only supporting "/" is perfectly adequate and
> simplifies documentation.  It aligns the command-line syntax with the
> rest of the sysctl documentation.  I'm not seeing the need to provide
> two ways of doing the same thing?

AFAIK the "." is traditional, and "/" is a newer artefact of moving from the 
binary syscall form to procfs based form. So by "command-line syntax" you mean 
echo and cat, not sysctl tool? Because "man sysctl" says:

variable
	The name of a key to read from.  An example is kernel.ostype.  The '/' 
separator is also accepted in place of a '.'.

So I'm not strongly against supporting only / but I expect most people are used 
to the . and it will take them two attempts to pass the sysctl boot parameter 
correctly if they don't use it regularly - first trying . form, wonder why it 
doesn't work, then read the doc and realize it's not supported?

Vlastimil
