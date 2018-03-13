From: Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH] bpf: whitelist syscalls for error injection
Date: Tue, 13 Mar 2018 16:49:29 -0700
Message-ID: <67172932-df1d-5585-601d-a7ce70a2c86b@fb.com>
References: <20180313231627.1247-1-hmclauchlan@fb.com>
 <20180313234509.GA4981@vader>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180313234509.GA4981@vader>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>, Howard McLauchlan <hmclauchlan@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, "David S . Miller" <davem@davemloft.net>, Thomas Garnier <thgarnie@google.com>, kernel-team@fb.com, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Josef Bacik <jbacik@fb.com>, Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org
List-Id: linux-api@vger.kernel.org



On 3/13/18 4:45 PM, Omar Sandoval wrote:
> On Tue, Mar 13, 2018 at 04:16:27PM -0700, Howard McLauchlan wrote:
>> Error injection is a useful mechanism to fail arbitrary kernel
>> functions. However, it is often hard to guarantee an error propagates
>> appropriately to user space programs. By injecting into syscalls, we can
>> return arbitrary values to user space directly; this increases
>> flexibility and robustness in testing, allowing us to test user space
>> error paths effectively.
>>
>> The following script, for example, fails calls to sys_open() from a
>> given pid:
>>
>> from bcc import BPF
>> from sys import argv
>>
>> pid = argv[1]
>>
>> prog = r"""
>>
>> int kprobe__SyS_open(struct pt_regs *ctx, const char *pathname, int flags)
>> {
>>      u32 pid = bpf_get_current_pid_tgid();
>>      if (pid == %s)
>>          bpf_override_return(ctx, -ENOENT);
>>      return 0;
>> }
>> """ % pid
>>
>> b = BPF(text = prog)
>> while 1:
>>      b.perf_buffer_poll()
>>
>> This patch whitelists all syscalls defined with SYSCALL_DEFINE for error
>> injection.
>>
>> Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
>> ---
>> based on 4.16-rc5
>>   include/linux/syscalls.h | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
>> index a78186d826d7..e8c6d63ace78 100644
>> --- a/include/linux/syscalls.h
>> +++ b/include/linux/syscalls.h
>> @@ -191,6 +191,8 @@ static inline int is_syscall_trace_event(struct trace_event_call *tp_event)
>>   
>>   #define SYSCALL_DEFINE0(sname)					\
>>   	SYSCALL_METADATA(_##sname, 0);				\
>> +	asmlinkage long sys_##sname(void);			\
>> +	ALLOW_ERROR_INJECTION(sys_##sname, ERRNO);		\
>>   	asmlinkage long sys_##sname(void)

duplication of asmlinkage in the above?

>>   
>>   #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
>> @@ -210,6 +212,7 @@ static inline int is_syscall_trace_event(struct trace_event_call *tp_event)
>>   #define __SYSCALL_DEFINEx(x, name, ...)					\
>>   	asmlinkage long sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))	\
>>   		__attribute__((alias(__stringify(SyS##name))));		\
>> +	ALLOW_ERROR_INJECTION(sys##name, ERRNO);			\
>>   	static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__));	\
>>   	asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__));	\
>>   	asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__))	\
>> -- 
>> 2.14.1
>>
> 
> Adding a few more people to Cc
> 
