From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Thu, 8 Mar 2018 15:07:01 -0800
Message-ID: <d83869b4-260e-179d-d469-83b8d8068399@fb.com>
References: <20180306013457.1955486-1-ast@kernel.org>
 <20180308012353.GO14069@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180308012353.GO14069@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, Alexei Starovoitov <ast@kernel.org>
Cc: davem@davemloft.net, daniel@iogearbox.net, torvalds@linux-foundation.org, gregkh@linuxfoundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org, Jessica Yu <jeyu@kernel.org>, Kees Cook <keescook@chromium.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Jiri Kosina <jikos@kernel.org>
List-Id: linux-api@vger.kernel.org

On 3/7/18 5:23 PM, Luis R. Rodriguez wrote:
>
> request_module() has its own world though too. How often in your proof of
> concept is request_module() called? How many times do you envision it being
> called?

once.

>> +static int run_umh(struct file *file)
>> +{
>> +	struct subprocess_info *sub_info = call_usermodehelper_setup_file(file);
>> +
>> +	if (!sub_info)
>> +		return -ENOMEM;
>> +	return call_usermodehelper_exec(sub_info, UMH_WAIT_EXEC);
>> +}
>
> run_umh() calls the program and waits. Note that while we are running a UMH we
> can't suspend. What if they take forever, who is hosing them down with an
> equivalent:
>
> 	schedule();
> 	try_to_freeze();
>
> Say they are buggy and never return, will they stall suspend, have you tried?
>
> call_usermodehelper_exec() uses helper_lock() which in turn is used for
> umh's accounting for number of running umh's. One of the sad obscure uses
> for this is to deal with suspend/resume. Refer to __usermodehelper* calls
> on kernel/power/process.c
>
> Note how you use UMH_WAIT_EXEC too, so this is all synchronous.

looks like you misread this code and the rest of your concerns
with suspend/resume are not applicable any more.

#define UMH_NO_WAIT     0       /* don't wait at all */
#define UMH_WAIT_EXEC   1       /* wait for the exec, but not the process */
#define UMH_WAIT_PROC   2       /* wait for the process to complete */
#define UMH_KILLABLE    4       /* wait for EXEC/PROC killable */

bpftiler.ko is started once and runs non-stop from there on.
Unless it crashes, but it's a different discussion.

>> +	if (info->hdr->e_type == ET_EXEC) {
>> +#ifdef CONFIG_MODULE_SIG
>> +		if (!info->sig_ok) {
>> +			pr_notice_once("umh %s verification failed: signature and/or required key missing - tainting kernel\n",
>> +				       info->file->f_path.dentry->d_name.name);
>> +			add_taint(TAINT_UNSIGNED_MODULE, LOCKDEP_STILL_OK);
>> +		}
>> +#endif
>
> So I guess this check is done *after* run_umh() then, what about the enforce mode,
> don't we want to reject loading at all in any circumstance?

already answered this twice in the thread.
