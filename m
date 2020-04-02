Return-Path: <SRS0=TDPh=5S=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F5CC2D0F3
	for <linux-api@archiver.kernel.org>; Thu,  2 Apr 2020 16:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA3002063A
	for <linux-api@archiver.kernel.org>; Thu,  2 Apr 2020 16:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585843489;
	bh=EKykHnOpSi5xLEA7dlACnsP3Lzvy10/+gJuuJcWsBs0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=mcGfI0GakzsM9ZrA2hsux7OJZroddaJc4lmPOjlV+mSP4FcD7A2OgRXrsXyi4G4hA
	 JD/05ragIYmpW+/+i9OpQ/efsslquawiWPbMGz86UKQ+ogFxku3TTz03g2gC4RVPVN
	 0r2FBxyY9lP8AKKiCqbVQdgUr6oCadHwgN0RwfAc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389366AbgDBQEr (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 2 Apr 2020 12:04:47 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:47017 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389294AbgDBQEq (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 2 Apr 2020 12:04:46 -0400
Received: by mail-pl1-f194.google.com with SMTP id s23so1481437plq.13;
        Thu, 02 Apr 2020 09:04:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VAdtQeZG1W5hggzwlZjx1TjdJy3EIjRqPxs+2mgheWo=;
        b=sfK4WWiBpAmW2Ks9DTW6QP5BnmO5agP2xRTD4tGzeTK9RILAnE0WCnDgnmBrbCscpc
         1JKqOwfaACWBAvPtJfDNxg+qOUmXez/Heef1ZWHLc28Y0VTd8OibwraOjIF8mzpqszup
         Kbvhv3950Clh7Ipk7b3QrPSJWYMRpMoXDlBRctFuzVecyK999rQTdb1B3359GJSSyk8x
         jwMNj34ryyAdE0IMt0OiS7OfnGxlz/COJfBsrAUbTVC7BETl2MCJIWvKZZBOFnqwV3Ao
         peG4uxZZos+MrJgaURDxKDYPUE4U7RDbYwHPHj2a4RskJB/kW/PPMCjTNuiNgZzTN7hY
         ib6Q==
X-Gm-Message-State: AGi0PublgH1SUV/Dc/KN2VYHFSX0166eB9qLio6TR3/gXlkLl+tnC+Ym
        K6zbpGiUkUFYq4g3i2tswRA=
X-Google-Smtp-Source: APiQypLGf0t35D4GpzRZlLXnQ+AE2f8f9vge/ycWTZ41fuOR44A9Ncby4ouXoBP9j0rzBrPD0Ueoxg==
X-Received: by 2002:a17:90a:bb88:: with SMTP id v8mr4688532pjr.54.1585843485016;
        Thu, 02 Apr 2020 09:04:45 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id f9sm2907508pgj.2.2020.04.02.09.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 09:04:43 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id D687F40254; Thu,  2 Apr 2020 16:04:42 +0000 (UTC)
Date:   Thu, 2 Apr 2020 16:04:42 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Vlastimil Babka <vbabka@suse.cz>
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
Subject: Re: [PATCH 1/3] kernel/sysctl: support setting sysctl parameters
 from kernel command line
Message-ID: <20200402160442.GA11244@42.do-not-panic.com>
References: <20200330115535.3215-1-vbabka@suse.cz>
 <20200330115535.3215-2-vbabka@suse.cz>
 <20200330224422.GX11244@42.do-not-panic.com>
 <287ac6ae-a898-3e68-c7d8-4c1d17a40db9@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <287ac6ae-a898-3e68-c7d8-4c1d17a40db9@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Wed, Apr 01, 2020 at 01:01:47PM +0200, Vlastimil Babka wrote:
> On 3/31/20 12:44 AM, Luis Chamberlain wrote:
> >> +	} else if (wret != len) {
> >> +		pr_err("Wrote only %ld bytes of %d writing to proc file %s to set sysctl parameter '%s=%s'",
> >> +			wret, len, path, param, val);
> >> +	}
> >> +
> >> +	err = filp_close(file, NULL);
> >> +	if (err)
> >> +		pr_err("Error %pe closing proc file to set sysctl parameter '%s=%s'",
> >> +			ERR_PTR(err), param, val);
> >> +out:
> >> +	kfree(path);
> >> +	return 0;
> >> +}
> >> +
> >> +void do_sysctl_args(void)
> >> +{
> >> +	char *command_line;
> >> +	struct vfsmount *proc_mnt = NULL;
> >> +
> >> +	command_line = kstrdup(saved_command_line, GFP_KERNEL);
> > 
> > can you use kstrndup() ? And then use kfree_const()? Yes, feel free to
> 
> I don't follow, what am I missing? Do you mean this?
> 
> size_t len = strlen(saved_command_line);
> command_line = kstrndup(saved_command_line, len, GFP_KERNEL);
> 
> What would be the advantage over plain kstrdup()?
> As for kfree_const(), when would command_line be .rodata? I don't see using
> kstrndup() resulting in that.

The const nature of using kstrdup() comes with using const for your
purpose. ie:

const char *const_command_line = saved_command_line;

The point of a kstrncpy() then is to ensure force a const throughout
your use if you know you don't need modifications.

> > move __kstrncpy() to a generic kstrncpy().
> > 
> >> +	if (!command_line)
> >> +		panic("%s: Failed to allocate copy of command line\n", __func__);
> >> +
> >> +	parse_args("Setting sysctl args", command_line,
> >> +		   NULL, 0, -1, -1, &proc_mnt, process_sysctl_arg);
> >> +
> >> +	if (proc_mnt)
> >> +		kern_unmount(proc_mnt);
> >> +
> >> +	kfree(command_line);
> >> +}
> > 
> > Then, can we get this tested as part of lib/test_sysctl.c with its
> > respective tools/testing/selftests/sysctl/sysctl.sh ?
> 
> Hmm so I add some sysctl to the test "module" (in fact the 'config' file says it
> should be build with 'y', which would be needed anyway) and expand the test
> instructions so that the test kernel boot has to include it on the command line,
> and then I verify it has been set? Or do you see a better way?

We don't necessarily have a way to test the use boot params today.
That reveals an are which we should eventually put some focus on
in the future. In the meantime we have to deal with what we have.

So let's think about this:

You are adding a new cmdline sysctl boot param, and also a wrapper
for those old boot bootparams to also work using both new sysctl
path and old path. Testing just these both should suffice.

How about this:

For testing the new feature you are adding, can you extend the default
boot params *always* if a new CONFIG_TEST_SYSCTL_CMDLINE is set? Then
upon boot we can verify the proc handlers for these new boot params got
kicked, and likewise some other proc handlers which also can be used
from the cmdline are *not* set. For this later set, we already have
a series of test syctls you can use. In fact, you can use the existing
syctls for both cases already I believe, its just a matter of adding
this new CONFIG_TEST_SYSCTL_CMDLINE which would extend the cmdline,
and these tests would take place *first* on the script.

That would test both cases with one kernel.

You could then also add a bogus new sysctl which also expands to a silly
raw boot param to test the wrapper you are providing. That would be the
only new test syctl you would need to add.

If you can think of a way to *break* your new functionality and ensure
it doesn't break the kernel, even better.

  Luis
