Return-Path: <SRS0=BrOX=5R=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D729FC43331
	for <linux-api@archiver.kernel.org>; Wed,  1 Apr 2020 11:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B25CD2078B
	for <linux-api@archiver.kernel.org>; Wed,  1 Apr 2020 11:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732218AbgDALBv (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 1 Apr 2020 07:01:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:59830 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731343AbgDALBu (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Wed, 1 Apr 2020 07:01:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D02A0AD6B;
        Wed,  1 Apr 2020 11:01:48 +0000 (UTC)
Subject: Re: [PATCH 1/3] kernel/sysctl: support setting sysctl parameters from
 kernel command line
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
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
        Christian Brauner <christian.brauner@ubuntu.com>
References: <20200330115535.3215-1-vbabka@suse.cz>
 <20200330115535.3215-2-vbabka@suse.cz>
 <20200330224422.GX11244@42.do-not-panic.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <287ac6ae-a898-3e68-c7d8-4c1d17a40db9@suse.cz>
Date:   Wed, 1 Apr 2020 13:01:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200330224422.GX11244@42.do-not-panic.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On 3/31/20 12:44 AM, Luis Chamberlain wrote:
>> +	} else if (wret != len) {
>> +		pr_err("Wrote only %ld bytes of %d writing to proc file %s to set sysctl parameter '%s=%s'",
>> +			wret, len, path, param, val);
>> +	}
>> +
>> +	err = filp_close(file, NULL);
>> +	if (err)
>> +		pr_err("Error %pe closing proc file to set sysctl parameter '%s=%s'",
>> +			ERR_PTR(err), param, val);
>> +out:
>> +	kfree(path);
>> +	return 0;
>> +}
>> +
>> +void do_sysctl_args(void)
>> +{
>> +	char *command_line;
>> +	struct vfsmount *proc_mnt = NULL;
>> +
>> +	command_line = kstrdup(saved_command_line, GFP_KERNEL);
> 
> can you use kstrndup() ? And then use kfree_const()? Yes, feel free to

I don't follow, what am I missing? Do you mean this?

size_t len = strlen(saved_command_line);
command_line = kstrndup(saved_command_line, len, GFP_KERNEL);

What would be the advantage over plain kstrdup()?
As for kfree_const(), when would command_line be .rodata? I don't see using
kstrndup() resulting in that.

> move __kstrncpy() to a generic kstrncpy().
> 
>> +	if (!command_line)
>> +		panic("%s: Failed to allocate copy of command line\n", __func__);
>> +
>> +	parse_args("Setting sysctl args", command_line,
>> +		   NULL, 0, -1, -1, &proc_mnt, process_sysctl_arg);
>> +
>> +	if (proc_mnt)
>> +		kern_unmount(proc_mnt);
>> +
>> +	kfree(command_line);
>> +}
> 
> Then, can we get this tested as part of lib/test_sysctl.c with its
> respective tools/testing/selftests/sysctl/sysctl.sh ?

Hmm so I add some sysctl to the test "module" (in fact the 'config' file says it
should be build with 'y', which would be needed anyway) and expand the test
instructions so that the test kernel boot has to include it on the command line,
and then I verify it has been set? Or do you see a better way?

Thanks,
Vlastimil

>   Luis
> 

