From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Mon, 5 Mar 2018 19:02:12 -0800
Message-ID: <eaaac6df-6deb-46e7-3020-83a97221d1f8@fb.com>
References: <20180306013457.1955486-1-ast@kernel.org>
 <67abc3a2-80c9-7223-37c2-e15bbecdcd00@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <67abc3a2-80c9-7223-37c2-e15bbecdcd00@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>, Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc: daniel@iogearbox.net, torvalds@linux-foundation.org, gregkh@linuxfoundation.org, mcgrof@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 3/5/18 6:13 PM, Randy Dunlap wrote:
> Hi,
>
> On 03/05/2018 05:34 PM, Alexei Starovoitov wrote:
>
>> diff --git a/kernel/module.c b/kernel/module.c
>> index ad2d420024f6..6cfa35795741 100644
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>
>> @@ -3669,6 +3683,17 @@ static int load_module(struct load_info *info, const char __user *uargs,
>>  	if (err)
>>  		goto free_copy;
>>
>> +	if (info->hdr->e_type == ET_EXEC) {
>> +#ifdef CONFIG_MODULE_SIG
>> +		if (!info->sig_ok) {
>> +			pr_notice_once("umh %s verification failed: signature and/or required key missing - tainting kernel\n",
>
> That's not a very friendly message to tell a user.  "umh" eh?

umh is an abbreviation known to kernel newbies:
https://kernelnewbies.org/KernelProjects/usermode-helper-enhancements

The rest of the message is copy paste of existing one.

>> +				       info->file->f_path.dentry->d_name.name);
>> +			add_taint(TAINT_UNSIGNED_MODULE, LOCKDEP_STILL_OK);
>> +		}
>
> And since the signature failed, why is it being loaded at all?

because this is how regular kernel modules deal with it.
sig_enforce is handled earlier.

> Is this in the "--force" load path?

--force forces modver and modmagic. These things don't apply here.
