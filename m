From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v3 2/2] modules:capabilities: add a per-task modules
 autoload restriction
Date: Fri, 21 Apr 2017 16:51:29 -0700
Message-ID: <CALCETrXzZwz4a9uhQfdHb4L2afApTvVLPwVx640vvV-fzbCR0w@mail.gmail.com>
References: <1492640420-27345-1-git-send-email-tixxdz@gmail.com>
 <1492640420-27345-3-git-send-email-tixxdz@gmail.com> <CALCETrXFp-apnfRPg9qx6E7g3KDU8DanBW1pMUnA1zShrB5xKg@mail.gmail.com>
 <CAGXu5jJ5dm8yJJ34tEyOP78OxUr2awXmNhm6RaVP8jE4q+L5Ng@mail.gmail.com>
 <CALCETrUueOx1tqj+Ru93KGpy2HHR-A_GQ6DrAppiomkPTtX7Lw@mail.gmail.com>
 <CAGXu5jJBp6VHvDP9182hJgvzS2sBUbUFpmZZ+196K2FcEHUxzw@mail.gmail.com>
 <CALCETrVZ2KH4s2uGW2J3zUQ8RNsrq=N7pJP=YDqd=+cp6fJW=g@mail.gmail.com> <CAGXu5jJTdL7To2JsQUXyg6B7Xbb0kow6sXH-L+teVi88=gm7MQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jJTdL7To2JsQUXyg6B7Xbb0kow6sXH-L+teVi88=gm7MQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Arnaldo Carvalho de Melo <acme@>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 21, 2017 at 4:40 PM, Kees Cook <keescook@chromium.org> wrote:
> On Fri, Apr 21, 2017 at 4:28 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Fri, Apr 21, 2017 at 4:19 PM, Kees Cook <keescook@chromium.org> wrote:
>>> On Wed, Apr 19, 2017 at 7:41 PM, Andy Lutomirski <luto@kernel.org> wrote:
>>>> On Wed, Apr 19, 2017 at 4:43 PM, Kees Cook <keescook@chromium.org> wrote:
>>>>> On Wed, Apr 19, 2017 at 4:15 PM, Andy Lutomirski <luto@kernel.org> wrote:
>>>>>> On Wed, Apr 19, 2017 at 3:20 PM, Djalal Harouni <tixxdz@gmail.com> wrote:
>>>>>>> +/* Sets task's modules_autoload */
>>>>>>> +static inline int task_set_modules_autoload(struct task_struct *task,
>>>>>>> +                                           unsigned long value)
>>>>>>> +{
>>>>>>> +       if (value > MODULES_AUTOLOAD_DISABLED)
>>>>>>> +               return -EINVAL;
>>>>>>> +       else if (task->modules_autoload > value)
>>>>>>> +               return -EPERM;
>>>>>>> +       else if (task->modules_autoload < value)
>>>>>>> +               task->modules_autoload = value;
>>>>>>> +
>>>>>>> +       return 0;
>>>>>>> +}
>>>>>>
>>>>>> This needs to be more locked down.  Otherwise someone could set this
>>>>>> and then run a setuid program.  Admittedly, it would be quite odd if
>>>>>> this particular thing causes a problem, but the issue exists
>>>>>> nonetheless.
>>>>>
>>>>> Eeeh, I don't agree this needs to be changed. APIs provided by modules
>>>>> are different than the existing privilege-manipulation syscalls this
>>>>> concern stems from. Applications are already forced to deal with
>>>>> things being missing like this in the face of it simply not being
>>>>> built into the kernel.
>>>>>
>>>>> Having to hide this behind nnp seems like it'd reduce its utility...
>>>>>
>>>>
>>>> I think that adding an inherited boolean to task_struct that can be
>>>> set by unprivileged tasks and passed to privileged tasks is a terrible
>>>> precedent.  Ideally someone would try to find all the existing things
>>>> like this and kill them off.
>>>
>>> (Tristate, not boolean, but yeah.)
>>>
>>> I see two others besides seccomp and nnp:
>>>
>>> PR_MCE_KILL
>>
>> Well, that's interesting.  That should presumably be reset on setuid
>> exec or something.
>>
>>> PR_SET_THP_DISABLE
>>
>> Um.  At least that's just a performance issue.
>>
>>>
>>> I really don't think this needs nnp protection.
>>>
>>>> I agree that I don't see how one would exploit this particular
>>>> feature, but I still think I dislike the approach.  This is a slippery
>>>> slope to adding a boolean for perf_event_open(), unshare(), etc, and
>>>> we should solve these for real rather than half-arsing them IMO.
>>>
>>> I disagree (obviously); this would be protecting the entire module
>>> autoload attack surface. That's hardly a specific control, and it's a
>>> demonstrably needed flag.
>>>
>>
>> The list is just going to get longer.  We should probably have controls for:
>>
>>  - Use of perf.  Unclear how fine grained they should be.
>
> This can already be "given up" by a process by using seccomp. The
> system-wide setting is what's missing here, and that's a whole other
> thread already even though basically every distro has implemented the
> = 3 sysctl knob level.

But it can't be done the way Linus wants it, and I don't blame him for
complaining.

>
>>  - Creation of new user namespaces.  Possibly also use of things like
>> iptables without global privilege.
>
> This is another one that can be controlled by seccomp. The system-wide
> setting already exists in /proc/sys/user/max_user_namespaces.

Awkwardly, though.

>
>>  - Ability to look up tasks owned by different uids (or maybe other
>> tasks *at all*) by pid/tid.  Conceptually, this is easy.  The API is
>> the only hard part, I think.
>
> The attack surface here is relatively small compared to the other examples.
>
>>  - Ability to bind ports, maybe?
>
> seccomp and maybe a sysctl? I'd have to look at that more carefully,
> but again, this isn't a comparable attack-surface/confinement issue.
>
>> My point is that all of these need some way to handle configuration
>> and inheritance, and I don't think that a bunch of per-task prctls is
>> the right way.  As just an example, saying that interactive users can
>> autoload modules but other users can't, or that certain systemd
>> services can, etc, might be nice.  Linus already complained that he
>> (i.e. user "torvalds" or whatever) should be able to profile the
>> kernel but that other uids should not be able to.
>>
>> I personally like my implicit_rights idea, and it might be interesting
>> to prototype it.
>
> I don't like blocking a needed feature behind a large super-feature
> that doesn't exist yet. We'd be able to refactor this code into using
> such a thing in the future, so I'd prefer to move ahead with this
> since it would stop actual exploits.

I don't think the super-feature is so hard, and I think we should not
add the per-task thing the way it's done in this patch.  Let's not add
per-task things where the best argument for their security is "not
sure how it would be exploited".

Anyway, I think the sysctl is really the important bit.  The per-task
setting is icing on the cake IMO.  One upon a time autoload was more
important, but these days modaliases are supposed to do most of the
work.  I bet that modern distros don't need unprivileged autoload at
all.

--Andy
