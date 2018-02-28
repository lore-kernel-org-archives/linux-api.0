From: Pavel Emelyanov <xemul@virtuozzo.com>
Subject: Re: [PATCH v5 0/4] vm: add a syscall to map a process memory into a
 pipe
Date: Wed, 28 Feb 2018 10:12:55 +0300
Message-ID: <627ac4f8-a52d-0582-0c9e-e70ea667fa7e@virtuozzo.com>
References: <1515479453-14672-1-git-send-email-rppt@linux.vnet.ibm.com>
 <20180220164406.3ec34509376f16841dc66e34@linux-foundation.org>
 <3122ec5a-7f73-f6b4-33ea-8c10ef32e5b0@virtuozzo.com>
 <20180227021818.GA31386@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180227021818.GA31386@altlinux.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, criu@openvz.org, gdb@sourceware.org, devel@lists.open-mpi.org, rr-dev@mozilla.org, Arnd Bergmann <arnd@arndb.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Josh Triplett <josh@joshtriplett.org>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Andrei Vagin <avagin@openvz.org>
List-Id: linux-api@vger.kernel.org

On 02/27/2018 05:18 AM, Dmitry V. Levin wrote:
> On Mon, Feb 26, 2018 at 12:02:25PM +0300, Pavel Emelyanov wrote:
>> On 02/21/2018 03:44 AM, Andrew Morton wrote:
>>> On Tue,  9 Jan 2018 08:30:49 +0200 Mike Rapoport <rppt@linux.vnet.ibm.com> wrote:
>>>
>>>> This patches introduces new process_vmsplice system call that combines
>>>> functionality of process_vm_read and vmsplice.
>>>
>>> All seems fairly strightforward.  The big question is: do we know that
>>> people will actually use this, and get sufficient value from it to
>>> justify its addition?
>>
>> Yes, that's what bothers us a lot too :) I've tried to start with finding out if anyone 
>> used the sys_read/write_process_vm() calls, but failed :( Does anybody know how popular
>> these syscalls are?
> 
> Well, process_vm_readv itself is quite popular, it's used by debuggers nowadays,
> see e.g.
> $ strace -qq -esignal=none -eprocess_vm_readv strace -qq -o/dev/null cat /dev/null

I see. Well, yes, this use-case will not benefit much from remote splice. How about more
interactive debug by, say, gdb? It may attach, then splice all the memory, then analyze
the victim code/data w/o copying it to its address space?

-- Pavel
