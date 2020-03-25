Return-Path: <SRS0=7VMH=5K=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2FC8C43331
	for <linux-api@archiver.kernel.org>; Wed, 25 Mar 2020 22:23:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C589E2070A
	for <linux-api@archiver.kernel.org>; Wed, 25 Mar 2020 22:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgCYWXX (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 25 Mar 2020 18:23:23 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56712 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbgCYWXX (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 25 Mar 2020 18:23:23 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jHEQi-0003tz-7y; Wed, 25 Mar 2020 16:23:20 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jHEQb-0001V5-Q7; Wed, 25 Mar 2020 16:23:19 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-mm@kvack.org, Ivan Teterevkov <ivan.teterevkov@nutanix.com>,
        Michal Hocko <mhocko@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Guilherme G . Piccoli" <gpiccoli@canonical.com>
References: <20200325120345.12946-1-vbabka@suse.cz>
Date:   Wed, 25 Mar 2020 17:20:40 -0500
In-Reply-To: <20200325120345.12946-1-vbabka@suse.cz> (Vlastimil Babka's
        message of "Wed, 25 Mar 2020 13:03:44 +0100")
Message-ID: <874kuc5b5z.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jHEQb-0001V5-Q7;;;mid=<874kuc5b5z.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18WnfbSyMGxO0OSg+4AxGGHmbYXnSGukgI=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [RFC v2 1/2] kernel/sysctl: support setting sysctl parameters from kernel command line
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Vlastimil Babka <vbabka@suse.cz> writes:

> A recently proposed patch to add vm_swappiness command line parameter in
> addition to existing sysctl [1] made me wonder why we don't have a general
> support for passing sysctl parameters via command line. Googling found only
> somebody else wondering the same [2], but I haven't found any prior discussion
> with reasons why not to do this.
>
> Settings the vm_swappiness issue aside (the underlying issue might be solved in
> a different way), quick search of kernel-parameters.txt shows there are already
> some that exist as both sysctl and kernel parameter - hung_task_panic,
> nmi_watchdog, numa_zonelist_order, traceoff_on_warning. A general mechanism
> would remove the need to add more of those one-offs and might be handy in
> situations where configuration by e.g. /etc/sysctl.d/ is impractical.
> Also after 61a47c1ad3a4 ("sysctl: Remove the sysctl system call") the only way
> to set sysctl is via procfs, so this would eventually allow small systems to be
> built without CONFIG_PROC_SYSCTL and still be able to change sysctl parameters.
>
> Hence, this patch adds a new parse_args() pass that looks for parameters
> prefixed by 'sysctl.' and searches for them in the sysctl ctl_tables. When
> found, the respective proc handler is invoked. The search is just a naive
> linear one, to avoid using the whole procfs layer. It should be acceptable,
> as the cost depends on number of sysctl. parameters passed.
>
> The main limitation of avoiding the procfs layer is however that sysctls
> dynamically registered by register_sysctl_table() or register_sysctl_paths()
> cannot currently be set by this method.
>
> The processing is hooked right before the init process is loaded, as some
> handlers might be more complicated than simple setters and might need some
> subsystems to be initialized. At the moment the init process can be started and
> eventually execute a process writing to /proc/sys/ then it should be also fine
> to do that from the kernel.
>
> [1] https://lore.kernel.org/linux-doc/BL0PR02MB560167492CA4094C91589930E9FC0@BL0PR02MB5601.namprd02.prod.outlook.com/
> [2] https://unix.stackexchange.com/questions/558802/how-to-set-sysctl-using-kernel-command-line-parameter
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
> v2: - handle any nesting level of parameter name
>  - add Documentation/admin-guide/kernel-parameters.txt blurb
>  - alias support for legacy one-off parameters, with first conversion (patch 2)
>  - still no support for dynamically registed sysctls
>
>  .../admin-guide/kernel-parameters.txt         |  9 +++
>  include/linux/sysctl.h                        |  1 +
>  init/main.c                                   | 21 +++++++
>  kernel/sysctl.c                               | 62 +++++++++++++++++++
>  4 files changed, 93 insertions(+)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index c07815d230bc..5076e288f93f 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -4793,6 +4793,15 @@
>  
>  	switches=	[HW,M68k]
>  
> +	sysctl.*=	[KNL]
> +			Set a sysctl parameter right before loading the init
> +			process, as if the value was written to the respective
> +			/proc/sys/... file. Currently a subset of sysctl
> +			parameters is supported that is not registered
> +			dynamically. Unrecognized parameters and invalid values
> +			are reported in the kernel log.
> +			Example: sysctl.vm.swappiness=40
> +
>  	sysfs.deprecated=0|1 [KNL]
>  			Enable/disable old style sysfs layout for old udev
>  			on older distributions. When this option is enabled
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index 02fa84493f23..62ae963a5c0c 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -206,6 +206,7 @@ struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
>  void unregister_sysctl_table(struct ctl_table_header * table);
>  
>  extern int sysctl_init(void);
> +int process_sysctl_arg(char *param, char *val, const char *unused, void *arg);
>  
>  extern struct ctl_table sysctl_mount_point[];
>  
> diff --git a/init/main.c b/init/main.c
> index ee4947af823f..74a094c6b8b9 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -1345,6 +1345,25 @@ void __weak free_initmem(void)
>  	free_initmem_default(POISON_FREE_INITMEM);
>  }
>  
> +static void do_sysctl_args(void)
> +{
> +#ifdef CONFIG_SYSCTL
> +	size_t len = strlen(saved_command_line) + 1;
> +	char *command_line;
> +
> +	command_line = kzalloc(len, GFP_KERNEL);
> +	if (!command_line)
> +		panic("%s: Failed to allocate %zu bytes\n", __func__, len);
> +
> +	strcpy(command_line, saved_command_line);
> +
> +	parse_args("Setting sysctl args", command_line,
> +		   NULL, 0, -1, -1, NULL, process_sysctl_arg);
> +
> +	kfree(command_line);
> +#endif
> +}
> +
>  static int __ref kernel_init(void *unused)
>  {
>  	int ret;
> @@ -1367,6 +1386,8 @@ static int __ref kernel_init(void *unused)
>  
>  	rcu_end_inkernel_boot();
>  
> +	do_sysctl_args();
> +
>  	if (ramdisk_execute_command) {
>  		ret = run_init_process(ramdisk_execute_command);
>  		if (!ret)
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index ad5b88a53c5a..18c7f5606d55 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1980,6 +1980,68 @@ int __init sysctl_init(void)
>  	return 0;
>  }
>  
> +/* Set sysctl value passed on kernel command line. */
> +int process_sysctl_arg(char *param, char *val,
> +			       const char *unused, void *arg)
> +{
> +	size_t count;
> +	char *remaining;
> +	int err;
> +	loff_t ppos = 0;
> +	struct ctl_table *ctl, *found = NULL;
> +
> +	if (strncmp(param, "sysctl.", sizeof("sysctl.") - 1))
> +		return 0;

Is there any way we can use a slash separated path.  I know
in practice there are not any sysctl names that don't have
a '.' in them but why should we artifically limit ourselves?

I guess as long as we don't mind not being able to set sysctls
that have a '.' in them it doesn't matter.

> +
> +	param += sizeof("sysctl.") - 1;
> +
> +	remaining = param;
> +	ctl = &sysctl_base_table[0];
> +
> +	while(ctl->procname != 0) {
              ^^^^^^^^^^^^^^^^^^

Please either test "while(ctl->procname)" or
"while(ctl->procname != NULL)" testing against 0 makes it look like
procname is an integer.  The style in the kernel is to test against
NULL, to make it clear when something is a pointer.

> +		int len = strlen(ctl->procname);

You should have done "strchr(remaining)" and figured out if there is
another '.' and only compared up to that dot.  Probably skipping this
entry entirely if the two lengths don't match.

> +		if (strncmp(remaining, ctl->procname, len)) {
> +			ctl++;
> +			continue;
> +		}
> +		if (ctl->child) {
> +			if (remaining[len] == '.') {
> +				remaining += len + 1;
> +				ctl = ctl->child;
> +				continue;
> +			}
> +		} else {
> +			if (remaining[len] == '\0') {
> +				found = ctl;
> +				break;
> +			}
> +		}
> +		ctl++;

There should be exactly one match for a name a table.
If you get here the code should break, not continue on.

> +	}
> +
> +	if (!found) {
> +		pr_warn("Unknown sysctl param '%s' on command line", param);
> +		return 0;
> +	}
> +
> +	if (!(found->mode & 0200)) {
> +		pr_warn("Cannot set sysctl '%s=%s' from command line - not writable",
> +			param, val);
> +		return 0;
> +	}
> +
> +	count = strlen(val);
> +	err = found->proc_handler(found, 1, val, &count, &ppos);
> +
> +	if (err)
> +		pr_warn("Error %d setting sysctl '%s=%s' from command line",
> +			err, param, val);
> +
> +	pr_debug("Set sysctl '%s=%s' from command line", param, val);
> +
> +	return 0;
> +}

You really should be able to have this code live in
fs/proc/proc_sysctl.c and utilize lookup_entry.

That should give you the ability to lookup any sysctl.  If
kernel/sysctl.c is compiled into the kernel proc_sysctl.c is compiled
into the kernel.  Systems that don't select CONFIG_PROC_SYSCTL won't
have any sysctl tables installed at all so they do not make sense to
consider or design for.

Further it will be faster to lookup the sysctls using the code from
proc_sysctl.c as it constructs an rbtree of all of the entries in
a directory.  The code might as well take advantage of that for large
directories.

Arguably the main sysctl tables in kernel/sysctl.c should be split up so
that things are more localized and there is less global state exported
throughout the kernel.  I certainly don't want to discourage anyone from
doing that just so their sysctl can be used on the command line.


Hmm.  There is a big gotcha in here and I think it should be mentioned.
This code only works because no one has done set_fs(KERNEL_DS).  Which
means this only works with strings that are kernel addresses essentially
by mistake.  A big fat comment documenting why it is safe to pass in
kernel addresses to a function that takes a "char __user*" pointer
would be very good.

Eric
