From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH 0/3] Fix unsafe BPF_PROG_TEST_RUN interface
Date: Tue, 20 Nov 2018 01:34:05 +0100
Message-ID: <040aedc7-0883-86c6-3707-b54a6a9e01c2@iogearbox.net>
References: <20181116125329.3974-1-lmb@cloudflare.com>
 <CAH3MdRW1=iUm0qQdNrv9r5Orn3rZ2XBDn-qym5i_cpi7wo6PxA@mail.gmail.com>
 <CACAyw98fu_=WufBrv_7CwO4iJj3jhOu1n6b3Pr0aZxqSk8++Gw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CACAyw98fu_=WufBrv_7CwO4iJj3jhOu1n6b3Pr0aZxqSk8++Gw@mail.gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Lorenz Bauer <lmb@cloudflare.com>, ys114321@gmail.com
Cc: Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 11/19/2018 03:30 PM, Lorenz Bauer wrote:
> On Sun, 18 Nov 2018 at 06:13, Y Song <ys114321@gmail.com> wrote:
>>
>> There is a slight change of user space behavior for this patch.
>> Without this patch, the value bpf_attr.test.data_size_out is output only.
>> For example,
>>    output buffer : out_buf (user allocated size 10)
>>    data_size_out is a random value (e.g., 1),
>>
>> The actual data to copy is 5.
>>
>> In today's implementation, the kernel will copy 5 and set data_size_out is 5.
>>
>> With this patch, the kernel will copy 1 and set data_size_out is 5.
>>
>> I am not 100% sure at this time whether we CAN overload data_size_out
>> since it MAY break existing applications.
> 
> Yes, that's correct. I think that the likelihood of this is low. It would
> affect code that uses bpf_attr without zeroing it first. I had a look around,
> and I could only find code that would keep working:

Agree, it seems like this would be rather unlikely to break the old behavior
and only if some test app forgot to zero it (given data_size_out is also in
the middle and not at the end). I'd rather prefer this approach here and then
push the patch via stable than adding yet another data_size_out-like member.

I think it also makes sense to return a -ENOSPC as Yonghong suggested in order
to indicate to user space that the buffer is not sufficient. Right now this
would have no such indication to the user so it would not be possible to
distinguish whether truncation or not happened. Was thinking whether it makes
sense to indicate through a new flag member that buffer truncation happened,
but I do like -ENOSPC better.

Thanks,
Daniel
