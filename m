Return-Path: <SRS0=DXPd=5L=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D23DC43331
	for <linux-api@archiver.kernel.org>; Thu, 26 Mar 2020 12:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B69B20748
	for <linux-api@archiver.kernel.org>; Thu, 26 Mar 2020 12:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgCZMru (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 26 Mar 2020 08:47:50 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:48598 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728070AbgCZMru (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 26 Mar 2020 08:47:50 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jHRvI-0004FF-F4; Thu, 26 Mar 2020 06:47:48 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jHRvH-0005af-Mz; Thu, 26 Mar 2020 06:47:48 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-mm@kvack.org, Ivan Teterevkov <ivan.teterevkov@nutanix.com>,
        David Rientjes <rientjes@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Guilherme G . Piccoli" <gpiccoli@canonical.com>
References: <20200325120345.12946-1-vbabka@suse.cz>
        <874kuc5b5z.fsf@x220.int.ebiederm.org>
        <20200326065829.GC27965@dhcp22.suse.cz>
Date:   Thu, 26 Mar 2020 07:45:13 -0500
In-Reply-To: <20200326065829.GC27965@dhcp22.suse.cz> (Michal Hocko's message
        of "Thu, 26 Mar 2020 07:58:29 +0100")
Message-ID: <87bloj2skm.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jHRvH-0005af-Mz;;;mid=<87bloj2skm.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19UwF8u5e2QvQbuXdnuXgW+a4jTDraswv0=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [RFC v2 1/2] kernel/sysctl: support setting sysctl parameters from kernel command line
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Michal Hocko <mhocko@kernel.org> writes:

> On Wed 25-03-20 17:20:40, Eric W. Biederman wrote:
>> Vlastimil Babka <vbabka@suse.cz> writes:
> [...]
>> > +	if (strncmp(param, "sysctl.", sizeof("sysctl.") - 1))
>> > +		return 0;
>> 
>> Is there any way we can use a slash separated path.  I know
>> in practice there are not any sysctl names that don't have
>> a '.' in them but why should we artifically limit ourselves?
>
> Because this is the normal userspace interface? Why should it be any
> different from calling sysctl?
> [...]

Why should the kernel command line implement userspace whims?
I was thinking something like: "sysctl/kernel/max_lock_depth=2048"
doesn't look too bad and it makes things like reusing our
kernel internal helpers much easier.

Plus it suggest that we could do the same for sysfs files:
	"sysfs/kernel/fscaps=1"

And the code could be same for both cases except for the filesystem
prefix.

>> Further it will be faster to lookup the sysctls using the code from
>> proc_sysctl.c as it constructs an rbtree of all of the entries in
>> a directory.  The code might as well take advantage of that for large
>> directories.
>
> Sounds like a good fit for a follow up patch to me. Let's make this
> as simple as possible for the initial version. But up to Vlastimil of course.

I would argue that reusing proc_sysctl.c:lookup_entry() should make the
code simpler, and easier to reason about.

Especially given the bugs in the first version with a sysctl path.
A clean separation between separating the path from into pieces and
looking up those pieces should make the code more robust.

That plus I want to get very far away from the incorrect idea that you
can have sysctls without compiling in proc support.  That is not how
the code works, that is not how the code is tested.

It is also worth pointing out that:

	proc_mnt = kern_mount(proc_fs_type);
        for_each_sysctl_cmdline() {
        	...
		file = file_open_root(proc_mnt->mnt_root, proc_mnt, sysctl_path, O_WRONLY, 0);
		kernel_write(file, value, value_len);
        }
        kern_umount(proc_mnt);

Is not an unreasonable implementation.

There are problems with a persistent mount of proc in that it forces
userspace not to use any proc mount options.  But a temporary mount of
proc to deal with command line options is not at all unreasonable.
Plus it looks like we can have kern_write do all of the kernel/user
buffer silliness.

> [...]
>
>> Hmm.  There is a big gotcha in here and I think it should be mentioned.
>> This code only works because no one has done set_fs(KERNEL_DS).  Which
>> means this only works with strings that are kernel addresses essentially
>> by mistake.  A big fat comment documenting why it is safe to pass in
>> kernel addresses to a function that takes a "char __user*" pointer
>> would be very good.
>
> Agreed

Eric
