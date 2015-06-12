From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH net-next 1/3] bpf: introduce current->pid, tgid, uid, gid,
 comm accessors
Date: Fri, 12 Jun 2015 16:25:24 -0700
Message-ID: <CALCETrVnhCoD9=nzDpB6UvmXyGz4Th_m1fstJDyRUKzfsSaKHw@mail.gmail.com>
References: <1434145226-17892-1-git-send-email-ast@plumgrid.com>
 <1434145226-17892-2-git-send-email-ast@plumgrid.com> <CALCETrUidQ9ig-xZrAFX8_==aVbDNKU-GfeYNMsT6uHugqSydg@mail.gmail.com>
 <557B60DB.5030200@plumgrid.com> <CALCETrVCAZkoM2TsrxgeT7d+kWjLrcRt76wiPav1Fk7wz0z-3g@mail.gmail.com>
 <557B6A00.7000600@plumgrid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <557B6A00.7000600@plumgrid.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Wang Nan <wangnan0@huawei.com>, Li Zefan <lizefan@huawei.com>, Daniel Wagner <daniel.wagner@bmw-carit.de>, Daniel Borkmann <daniel@iogearbox.net>, Linux API <linux-api@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 12, 2015 at 4:23 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> On 6/12/15 3:54 PM, Andy Lutomirski wrote:
>>
>> On Fri, Jun 12, 2015 at 3:44 PM, Alexei Starovoitov <ast@plumgrid.com>
>> wrote:
>>>
>>> On 6/12/15 3:08 PM, Andy Lutomirski wrote:
>>>>
>>>>
>>>> On Fri, Jun 12, 2015 at 2:40 PM, Alexei Starovoitov <ast@plumgrid.com>
>>>> wrote:
>>>>>
>>>>>
>>>>> eBPF programs attached to kprobes need to filter based on
>>>>> current->pid, uid and other fields, so introduce helper functions:
>>>>>
>>>>> u64 bpf_get_current_pid_tgid(void)
>>>>> Return: current->tgid << 32 | current->pid
>>>>>
>>>>> u64 bpf_get_current_uid_gid(void)
>>>>> Return: current_gid << 32 | current_uid
>>>>
>>>>
>>>>
>>>> How does this work wrt namespaces,
>>>
>>>
>>>
>>> from_kuid(current_user_ns(), uid)
>>>
>>
>> Is current_user_ns() well defined in the context of an eBPF program?
>
>
> What do you mean 'well defined'?
> Semantically same as 'current'. Depending on where particular
> kprobe is placed, 'current' is either meaningful or not. Program
> author needs to know what he's doing. It's a tool.
>

It's a dangerous tool.  Also, shouldn't the returned uid match the
namespace of the task that installed the probe, not the task that's
being probed?

--Andy
