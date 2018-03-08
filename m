From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH bpf-next v8 00/11] Landlock LSM: Toward unprivileged sandboxing
Date: Thu, 8 Mar 2018 23:53:52 +0000
Message-ID: <CALCETrUwkV4_65y7UjSgrq5WHOcZZ=+znKArehvhb1xEGG9HXw@mail.gmail.com>
References: <20180227004121.3633-1-mic@digikod.net> <CALCETrV3OZb70o83uOG437PubwBwaUJ6SKQucq_7g1BuBOmxzg@mail.gmail.com>
 <2e06621c-08e9-dc12-9b6e-9c09d5d8f458@digikod.net> <CALCETrWnJ7WkkfiymyahQd7YqO0KXP4mG1pRMq7fp8LG8Bwtcw@mail.gmail.com>
 <a70b41ee-78cb-52cc-152c-ac5e43b7e45c@digikod.net> <CALCETrUQYp0ta4tLgUWJ79pZVwp3WRY7cp-XaPcn1WyTc=wZyg@mail.gmail.com>
 <20180306224636.wf5z3kujtc7r5qyh@cisco> <7082be04-d6af-b853-4bb7-f331836662e2@digikod.net>
 <CALCETrXT8JUXVwDNKGVRG7=aenthDRePD+T+YiDY6cceaazDeA@mail.gmail.com> <cd811155-9e0d-283a-9291-4adfcec848e6@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cd811155-9e0d-283a-9291-4adfcec848e6@digikod.net>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Tycho Andersen <tycho@tycho.ws>, LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Will Drewry <wad@chromium>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 8, 2018 at 11:51 PM, Mickaël Salaün <mic@digikod.net> wrote:
>
> On 07/03/2018 02:21, Andy Lutomirski wrote:
>> On Tue, Mar 6, 2018 at 11:06 PM, Mickaël Salaün <mic@digikod.net> wrote:
>>>
>>> On 06/03/2018 23:46, Tycho Andersen wrote:
>>>> On Tue, Mar 06, 2018 at 10:33:17PM +0000, Andy Lutomirski wrote:
>>>>>>> Suppose I'm writing a container manager.  I want to run "mount" in the
>>>>>>> container, but I don't want to allow moun() in general and I want to
>>>>>>> emulate certain mount() actions.  I can write a filter that catches
>>>>>>> mount using seccomp and calls out to the container manager for help.
>>>>>>> This isn't theoretical -- Tycho wants *exactly* this use case to be
>>>>>>> supported.
>>>>>>
>>>>>> Well, I think this use case should be handled with something like
>>>>>> LD_PRELOAD and a helper library. FYI, I did something like this:
>>>>>> https://github.com/stemjail/stemshim
>>>>>
>>>>> I doubt that will work for containers.  Containers that use user
>>>>> namespaces and, for example, setuid programs aren't going to honor
>>>>> LD_PRELOAD.
>>>>
>>>> Or anything that calls syscalls directly, like go programs.
>>>
>>> That's why the vDSO-like approach. Enforcing an access control is not
>>> the issue here, patching a buggy userland (without patching its code) is
>>> the issue isn't it?
>>>
>>> As far as I remember, the main problem is to handle file descriptors
>>> while "emulating" the kernel behavior. This can be done with a "shim"
>>> code mapped in every processes. Chrome used something like this (in a
>>> previous sandbox mechanism) as a kind of emulation (with the current
>>> seccomp-bpf ). I think it should be doable to replace the (userland)
>>> emulation code with an IPC wrapper receiving file descriptors through
>>> UNIX socket.
>>>
>>
>> Can you explain exactly what you mean by "vDSO-like"?
>>
>> When a 64-bit program does a syscall, it just executes the SYSCALL
>> instruction.  The vDSO isn't involved at all.  32-bit programs usually
>> go through the vDSO, but not always.
>>
>> It could be possible to force-load a DSO into an entire container and
>> rig up seccomp to intercept all SYSCALLs not originating from the DSO
>> such that they merely redirect control to the DSO, but that seems
>> quite messy.
>
> vDSO is a code mapped for all processes. As you said, these processes
> may use it or not. What I was thinking about is to use the same concept,
> i.e. map a "shim" code into each processes pertaining to a particular
> hierarchy (the same way seccomp filters are inherited across processes).
> With a seccomp filter matching some syscall (e.g. mount, open), it is
> possible to jump back to the shim code thanks to SECCOMP_RET_TRAP. This
> shim code should then be able to emulate/patch what is needed, even
> faking a file opening by receiving a file descriptor through a UNIX
> socket. As did the Chrome sandbox, the seccomp filter may look at the
> calling address to allow the shim code to call syscalls without being
> catched, if needed. However, relying on SIGSYS may not fit with
> arbitrary code. Using a new SECCOMP_RET_EMULATE (?) may be used to jump
> to a specific process address, to emulate the syscall in an easier way
> than only relying on a {c,e}BPF program.
>

This could indeed be done, but I think that Tycho's approach is much
cleaner and probably faster.
