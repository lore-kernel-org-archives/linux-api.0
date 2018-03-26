From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH v5 bpf-next 00/10] bpf, tracing: introduce bpf raw
 tracepoints
Date: Mon, 26 Mar 2018 17:32:02 +0200
Message-ID: <ba96cda5-c4d6-4d66-0128-b7053d25fcd8@iogearbox.net>
References: <20180324023038.938665-1-ast@fb.com>
 <c8be6d52-3f86-0402-9fdc-cc98f8e3e940@iogearbox.net>
 <20180326110435.4cdd7e7d@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180326110435.4cdd7e7d@gandalf.local.home>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Alexei Starovoitov <ast@fb.com>, davem@davemloft.net, torvalds@linux-foundation.org, peterz@infradead.org, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 03/26/2018 05:04 PM, Steven Rostedt wrote:
> On Mon, 26 Mar 2018 10:28:03 +0200
> Daniel Borkmann <daniel@iogearbox.net> wrote:
> 
>>> tracepoint    base  kprobe+bpf tracepoint+bpf raw_tracepoint+bpf
>>> task_rename   1.1M   769K        947K            1.0M
>>> urandom_read  789K   697K        750K            755K  
>>
>> Applied to bpf-next, thanks Alexei!
> 
> Please wait till you have the proper acks. Some of this affects
> tracing.

Ok, I thought time up to v5 was long enough. Anyway, in case there are
objections I can still toss out the series from bpf-next tree worst case
should e.g. follow-up fixups not be appropriate.

Thanks,
Daniel
