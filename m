From: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Subject: Re: [PATCH v3 05/11] x86/tracing: fix compat syscall handling
Date: Thu, 13 Oct 2016 08:32:38 +0200
Message-ID: <413d180f-2620-7471-8fa9-f576e3a457b2@imgtec.com>
References: <1476182576-15247-1-git-send-email-marcin.nowakowski@imgtec.com>
 <1476182576-15247-6-git-send-email-marcin.nowakowski@imgtec.com>
 <alpine.DEB.2.20.1610121552220.8572@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1610121552220.8572@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luto@amacapital.net, rostedt@goodmis.org, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On 12.10.2016 15:53, Thomas Gleixner wrote:
> On Tue, 11 Oct 2016, Marcin Nowakowski wrote:
>> -/*
>> - * Because ia32 syscalls do not map to x86_64 syscall numbers
>> - * this screws up the trace output when tracing a ia32 task.
>> - * Instead of reporting bogus syscalls, just do not trace them.
>> - *
>> - * If the user really wants these, then they should use the
>> - * raw syscall tracepoints with filtering.
>
> Why aren't you moving this information to the new place? It's valuable.

Well - much of this information is no longer true as with these fixes 
tracing can work properly, but I can keep a note clarifying that the 
numbers are mapped differently and why arch_syscall_addr() needs the 
sort of handling it does.

Marcin
