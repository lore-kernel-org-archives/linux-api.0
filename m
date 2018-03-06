From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH bpf-next v8 00/11] Landlock LSM: Toward unprivileged sandboxing
Date: Tue, 6 Mar 2018 22:33:17 +0000
Message-ID: <CALCETrUQYp0ta4tLgUWJ79pZVwp3WRY7cp-XaPcn1WyTc=wZyg@mail.gmail.com>
References: <20180227004121.3633-1-mic@digikod.net> <CALCETrV3OZb70o83uOG437PubwBwaUJ6SKQucq_7g1BuBOmxzg@mail.gmail.com>
 <2e06621c-08e9-dc12-9b6e-9c09d5d8f458@digikod.net> <CALCETrWnJ7WkkfiymyahQd7YqO0KXP4mG1pRMq7fp8LG8Bwtcw@mail.gmail.com>
 <a70b41ee-78cb-52cc-152c-ac5e43b7e45c@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a70b41ee-78cb-52cc-152c-ac5e43b7e45c@digikod.net>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>, Will Drewry <wad@chromium>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 6, 2018 at 10:25 PM, Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>=
 wrote:
>
>
> On 28/02/2018 00:09, Andy Lutomirski wrote:
>> On Tue, Feb 27, 2018 at 10:03 PM, Micka=C3=ABl Sala=C3=BCn <mic@digikod.=
net> wrote:
>>>
>>> On 27/02/2018 05:36, Andy Lutomirski wrote:
>>>> On Tue, Feb 27, 2018 at 12:41 AM, Micka=C3=ABl Sala=C3=BCn <mic@digiko=
d.net> wrote:
>>>>> Hi,
>>>>>
>>
>>>>>
>>>>> ## Why use the seccomp(2) syscall?
>>>>>
>>>>> Landlock use the same semantic as seccomp to apply access rule
>>>>> restrictions. It add a new layer of security for the current process
>>>>> which is inherited by its children. It makes sense to use an unique
>>>>> access-restricting syscall (that should be allowed by seccomp filters=
)
>>>>> which can only drop privileges. Moreover, a Landlock rule could come
>>>>> from outside a process (e.g.  passed through a UNIX socket). It is th=
en
>>>>> useful to differentiate the creation/load of Landlock eBPF programs v=
ia
>>>>> bpf(2), from rule enforcement via seccomp(2).
>>>>
>>>> This seems like a weak argument to me.  Sure, this is a bit different
>>>> from seccomp(), and maybe shoving it into the seccomp() multiplexer is
>>>> awkward, but surely the bpf() multiplexer is even less applicable.
>>>
>>> I think using the seccomp syscall is fine, and everyone agreed on it.
>>>
>>
>> Ah, sorry, I completely misread what you wrote.  My apologies.  You
>> can disregard most of my email.
>>
>>>
>>>>
>>>> Also, looking forward, I think you're going to want a bunch of the
>>>> stuff that's under consideration as new seccomp features.  Tycho is
>>>> working on a "user notifier" feature for seccomp where, in addition to
>>>> accepting, rejecting, or kicking to ptrace, you can send a message to
>>>> the creator of the filter and wait for a reply.  I think that Landlock
>>>> will want exactly the same feature.
>>>
>>> I don't think why this may be useful at all her. Landlock does not
>>> filter at the syscall level but handles kernel object and actions as
>>> does an LSM. That is the whole purpose of Landlock.
>>
>> Suppose I'm writing a container manager.  I want to run "mount" in the
>> container, but I don't want to allow moun() in general and I want to
>> emulate certain mount() actions.  I can write a filter that catches
>> mount using seccomp and calls out to the container manager for help.
>> This isn't theoretical -- Tycho wants *exactly* this use case to be
>> supported.
>
> Well, I think this use case should be handled with something like
> LD_PRELOAD and a helper library. FYI, I did something like this:
> https://github.com/stemjail/stemshim

I doubt that will work for containers.  Containers that use user
namespaces and, for example, setuid programs aren't going to honor
LD_PRELOAD.

>
> Otherwise, we should think about enabling a process to (dynamically)
> extend/patch the vDSO (similar to LD_PRELOAD but at the syscall level
> and works with static binaries) for a subset of processes (the same way
> seccomp filters are inherited). It may be more powerful and flexible
> than extending the kernel/seccomp to patch (buggy?) userland.

Egads!
