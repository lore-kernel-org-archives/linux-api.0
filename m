From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 11/11] seccomp: Add tgid and tid into seccomp_data
Date: Fri, 25 Jul 2014 10:18:05 -0700
Message-ID: <CALCETrVChObsQpL6dt-ByiCjbPrtpXAXQgy_apBY-OpGQHaPjg@mail.gmail.com>
References: <1406296033-32693-1-git-send-email-drysdale@google.com>
 <1406296033-32693-12-git-send-email-drysdale@google.com> <CALCETrVJX4+-6vkRaDj4kV_bXiYL5fj_PtO53g9fRf=i4X2Tww@mail.gmail.com>
 <CAGXu5jJZ7mhmq1BrdTP5Ww15+C2iLQKjLy1Xh0=9qZvVK5E9Cw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jJZ7mhmq1BrdTP5Ww15+C2iLQKjLy1Xh0=9qZvVK5E9Cw@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Julien Tinnes <jln@google.com>, David Drysdale <drysdale@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Paolo Bonzini <pbonzini@redhat.com>, LSM List <linux-security-module@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Paul Moore <paul@paul-moore.com>, James Morris <james.l.morris@oracle.com>, Linux API <linux-api@vger.kernel.org>, Meredydd Luff <meredydd@senatehouse.org>, Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

[cc: Eric Biederman]

On Fri, Jul 25, 2014 at 10:10 AM, Kees Cook <keescook@chromium.org> wrote:
> On Fri, Jul 25, 2014 at 8:59 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Jul 25, 2014 6:48 AM, "David Drysdale" <drysdale@google.com> wrote:
>>>
>>> Add the current thread and thread group IDs into the data
>>> available for seccomp-bpf programs to work on.  This allows
>>> installation of filters that police syscalls based on thread
>>> or process ID, e.g. tgkill(2)/kill(2)/prctl(2).
>>>
>>> Signed-off-by: David Drysdale <drysdale@google.com>
>>> ---
>>>  include/uapi/linux/seccomp.h | 10 ++++++++++
>>>  kernel/seccomp.c             |  2 ++
>>>  2 files changed, 12 insertions(+)
>>>
>>> diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
>>> index ac2dc9f72973..b88370d6f6ca 100644
>>> --- a/include/uapi/linux/seccomp.h
>>> +++ b/include/uapi/linux/seccomp.h
>>> @@ -36,12 +36,22 @@
>>>   * @instruction_pointer: at the time of the system call.
>>>   * @args: up to 6 system call arguments always stored as 64-bit values
>>>   *        regardless of the architecture.
>>> + * @tgid: thread group ID of the thread executing the BPF program.
>>> + * @tid: thread ID of the thread executing the BPF program.
>>> + * The SECCOMP_DATA_TID_PRESENT macro indicates the presence of the
>>> + * tgid and tid fields; user programs may use this macro to conditionally
>>> + * compile code against older versions of the kernel.  Note also that
>>> + * BPF programs should cope with the absence of these fields by testing
>>> + * the length of data available.
>>>   */
>>>  struct seccomp_data {
>>>         int nr;
>>>         __u32 arch;
>>>         __u64 instruction_pointer;
>>>         __u64 args[6];
>>> +       __u32 tgid;
>>> +       __u32 tid;
>>>  };
>>> +#define SECCOMP_DATA_TID_PRESENT       1
>>>
>>>  #endif /* _UAPI_LINUX_SECCOMP_H */
>>> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
>>> index 301bbc24739c..dd5146f15d6d 100644
>>> --- a/kernel/seccomp.c
>>> +++ b/kernel/seccomp.c
>>> @@ -80,6 +80,8 @@ static void populate_seccomp_data(struct seccomp_data *sd)
>>>         sd->args[4] = args[4];
>>>         sd->args[5] = args[5];
>>>         sd->instruction_pointer = KSTK_EIP(task);
>>> +       sd->tgid = task_tgid_vnr(current);
>>> +       sd->tid = task_pid_vnr(current);
>>>  }
>>
>> This is, IMO, problematic.  These should probably be relative to the
>> filter creator, not the filtered task.  This will also hurt
>> performance.
>
> Yeah, we can't change the seccomp_data structure without a lot of
> care, and tgid/tid really should be encoded in the filter. However, it
> is tricky in the forking case.
>
>>
>> What's the use case?  Can it be better achieved with a new eBPF function?
>
> Julien had been wanting something like this too (though he'd suggested
> it via prctl): limit the signal functions to "self" only. I wonder if
> adding a prctl like done for O_BENEATH could work for signal sending?
>


Can we do one better and add a flag to prevent any non-self pid
lookups?  This might actually be easy on top of the pid namespace work
(e.g. we could change the way that find_task_by_vpid works).

It's far from just being signals.  There's access_process_vm, ptrace,
all the signal functions, clock_gettime (see CPUCLOCK_PID -- yes, this
is ridiculous), and probably some others that I've forgotten about or
never noticed in the first place.

--Andy

> -Kees
>
> --
> Kees Cook
> Chrome OS Security



-- 
Andy Lutomirski
AMA Capital Management, LLC
