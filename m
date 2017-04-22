From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v3 2/2] modules:capabilities: add a per-task modules
 autoload restriction
Date: Fri, 21 Apr 2017 17:13:21 -0700
Message-ID: <ee72344c-ca19-5e46-9d7d-efd90e50230a@schaufler-ca.com>
References: <1492640420-27345-1-git-send-email-tixxdz@gmail.com>
 <1492640420-27345-3-git-send-email-tixxdz@gmail.com>
 <CALCETrXFp-apnfRPg9qx6E7g3KDU8DanBW1pMUnA1zShrB5xKg@mail.gmail.com>
 <CAGXu5jJ5dm8yJJ34tEyOP78OxUr2awXmNhm6RaVP8jE4q+L5Ng@mail.gmail.com>
 <CALCETrUueOx1tqj+Ru93KGpy2HHR-A_GQ6DrAppiomkPTtX7Lw@mail.gmail.com>
 <CAGXu5jJBp6VHvDP9182hJgvzS2sBUbUFpmZZ+196K2FcEHUxzw@mail.gmail.com>
 <CALCETrVZ2KH4s2uGW2J3zUQ8RNsrq=N7pJP=YDqd=+cp6fJW=g@mail.gmail.com>
 <5f07b121-62e1-b9a8-4faa-f6630b24ff48@schaufler-ca.com>
 <CALCETrW+cOe4SUA+KSuuC8x9KHH-on4BjaGukrfbkR5DizU5dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-hardening-return-7478-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CALCETrW+cOe4SUA+KSuuC8x9KHH-on4BjaGukrfbkR5DizU5dg@mail.gmail.com>
To: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Djalal Harouni <tixxdz@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, James Morris <james.l.morris@oracle.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Arnaldo Carvalho de Melo <acme@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Ingo Molnar <mingo@kernel.org>, belakhdar abdeldjalil <zendyani@gmail.com>, Peter Zijlstra <peterz@infradea>
List-Id: linux-api@vger.kernel.org

On 4/21/2017 5:00 PM, Andy Lutomirski wrote:
> On Fri, Apr 21, 2017 at 4:52 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>> On 4/21/2017 4:28 PM, Andy Lutomirski wrote:
>>> On Fri, Apr 21, 2017 at 4:19 PM, Kees Cook <keescook@chromium.org> wrote:
>>>> On Wed, Apr 19, 2017 at 7:41 PM, Andy Lutomirski <luto@kernel.org> wrote:
>>>>> On Wed, Apr 19, 2017 at 4:43 PM, Kees Cook <keescook@chromium.org> wrote:
>>>>>> On Wed, Apr 19, 2017 at 4:15 PM, Andy Lutomirski <luto@kernel.org> wrote:
>>>>>>> On Wed, Apr 19, 2017 at 3:20 PM, Djalal Harouni <tixxdz@gmail.com> wrote:
>>>>>>>> +/* Sets task's modules_autoload */
>>>>>>>> +static inline int task_set_modules_autoload(struct task_struct *task,
>>>>>>>> +                                           unsigned long value)
>>>>>>>> +{
>>>>>>>> +       if (value > MODULES_AUTOLOAD_DISABLED)
>>>>>>>> +               return -EINVAL;
>>>>>>>> +       else if (task->modules_autoload > value)
>>>>>>>> +               return -EPERM;
>>>>>>>> +       else if (task->modules_autoload < value)
>>>>>>>> +               task->modules_autoload = value;
>>>>>>>> +
>>>>>>>> +       return 0;
>>>>>>>> +}
>>>>>>> This needs to be more locked down.  Otherwise someone could set this
>>>>>>> and then run a setuid program.  Admittedly, it would be quite odd if
>>>>>>> this particular thing causes a problem, but the issue exists
>>>>>>> nonetheless.
>>>>>> Eeeh, I don't agree this needs to be changed. APIs provided by modules
>>>>>> are different than the existing privilege-manipulation syscalls this
>>>>>> concern stems from. Applications are already forced to deal with
>>>>>> things being missing like this in the face of it simply not being
>>>>>> built into the kernel.
>>>>>>
>>>>>> Having to hide this behind nnp seems like it'd reduce its utility...
>>>>>>
>>>>> I think that adding an inherited boolean to task_struct that can be
>>>>> set by unprivileged tasks and passed to privileged tasks is a terrible
>>>>> precedent.  Ideally someone would try to find all the existing things
>>>>> like this and kill them off.
>>>> (Tristate, not boolean, but yeah.)
>>>>
>>>> I see two others besides seccomp and nnp:
>>>>
>>>> PR_MCE_KILL
>>> Well, that's interesting.  That should presumably be reset on setuid
>>> exec or something.
>>>
>>>> PR_SET_THP_DISABLE
>>> Um.  At least that's just a performance issue.
>>>
>>>> I really don't think this needs nnp protection.
>>>>
>>>>> I agree that I don't see how one would exploit this particular
>>>>> feature, but I still think I dislike the approach.  This is a slippery
>>>>> slope to adding a boolean for perf_event_open(), unshare(), etc, and
>>>>> we should solve these for real rather than half-arsing them IMO.
>>>> I disagree (obviously); this would be protecting the entire module
>>>> autoload attack surface. That's hardly a specific control, and it's a
>>>> demonstrably needed flag.
>>>>
>>> The list is just going to get longer.  We should probably have controls for:
>>>
>>>  - Use of perf.  Unclear how fine grained they should be.
>>>
>>>  - Creation of new user namespaces.  Possibly also use of things like
>>> iptables without global privilege.
>>>
>>>  - Ability to look up tasks owned by different uids (or maybe other
>>> tasks *at all*) by pid/tid.  Conceptually, this is easy.  The API is
>>> the only hard part, I think.
>>>
>>>  - Ability to bind ports, maybe?
>> One of my longer term (i.e. after stacking) projects
>> is to create sensible access control on ports. Why shouldn't
>> they have owners and mode bits (or ACLs, if you prefer)
>> or real names. I kind of think we should be able to eliminate
>> the need for dbus without resorting to kdbus.
> My implicit_rights concept gives any type of access control you can
> use on inodes because they *are* inodes.  So you get ACLs, etc.
>
> Brief summary for those who didn't read my old email: We add a new
> kind of filesystem object called a "right".  It's a special kind of
> socket inode that can't be bound or connected but is instead created
> by a new syscall.  It has a name, so "port:1234" might be a name of a
> right.
>
> To use an implicit right, you do whatever syscall you would do
> normally.  The kernel looks for a right object at
> /dev/implicit_rights/<name>.  If that object exists, is a right of the
> correct type (i.e. the right's name matches <name>) and you have
> execute access, you win.  Otherwise you lose.
>
> To avoid breaking existing distros, for things like modules_autoload,
> you would set a sysctl
> /proc/sys/kernel/required_implicit_rights/modules_autoload=1.  With
> that set, to autoload a module without CAP_SYS_MODULE, you need the
> /dev/implicit_rights/modules_autoload.

Sounds good.

>> So I don't like the idea of treating that as a special case.
>> I'd rather see ports controlled properly. (Of course, the
>> SELinux crowd will point out they have this handled, but I
>> remain unconvinced of the overall solution)
> Agreed.  But I think we should address all of these things together.

What I don't want is to have to buy into a hundred things I
don't want in order to get the one thing I do. A General mechanism
is dandy, but I don't want to have to write a gazillion policy
lines for features I don't want in order to get a simple control.
The problem with SELinux is not the effort required to protect
what you care about, it's the effort required to do everything else.
