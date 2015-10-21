From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH v8] seccomp, ptrace: add support for dumping seccomp filters
Date: Wed, 21 Oct 2015 22:18:20 +0200
Message-ID: <5627F30C.5020904@iogearbox.net>
References: <1445370612-18843-1-git-send-email-tycho.andersen@canonical.com>	<1445370612-18843-2-git-send-email-tycho.andersen@canonical.com>	<20151020202024.GA5772@redhat.com>	<20151020220814.GA3232@hopstrocity>	<20151021185146.GA27176@redhat.com>	<20151021191533.GD30729@hopstrocity> <CAGXu5jL-LMC6SLazLE0UPcffr9cD5Z0ME4ddNjJmBKTx=dXz_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jL-LMC6SLazLE0UPcffr9cD5Z0ME4ddNjJmBKTx=dXz_A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Tycho Andersen <tycho.andersen@canonical.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Alexei Starovoitov <ast@kernel.org>, Will Drewry <wad@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Pavel Emelyanov <xemul@parallels.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 10/21/2015 10:12 PM, Kees Cook wrote:
> On Wed, Oct 21, 2015 at 12:15 PM, Tycho Andersen
> <tycho.andersen@canonical.com> wrote:
>> Hi Oleg,
>>
>> On Wed, Oct 21, 2015 at 08:51:46PM +0200, Oleg Nesterov wrote:
>>> On 10/20, Tycho Andersen wrote:
>>>>
>>>> Hi Kees, Oleg,
>>>>
>>>> On Tue, Oct 20, 2015 at 10:20:24PM +0200, Oleg Nesterov wrote:
>>>>>
>>>>> No, you can't do copy_to_user() from atomic context. You need to pin this
>>>>> filter, drop the lock/irq, then copy_to_user().
>>>>
>>>> Attached is a patch which addresses this.
>>>
>>> Looks good to me, feel free to add my reviewed-by.
>>>
>>>
>>> a couple of questions, I am just curious...
>>>
>>>> +long seccomp_get_filter(struct task_struct *task, unsigned long filter_off,
>>>> +                   void __user *data)
>>>> +{
>>>> +   struct seccomp_filter *filter;
>>>> +   struct sock_fprog_kern *fprog;
>>>> +   long ret;
>>>> +   unsigned long count = 0;
>>>> +
>>>> +   if (!capable(CAP_SYS_ADMIN) ||
>>>> +       current->seccomp.mode != SECCOMP_MODE_DISABLED) {
>>>> +           return -EACCES;
>>>> +   }
>>>> +
>>>> +   spin_lock_irq(&task->sighand->siglock);
>>>> +   if (task->seccomp.mode != SECCOMP_MODE_FILTER) {
>>>> +           ret = -EINVAL;
>>>> +           goto out;
>>>> +   }
>>>> +
>>>> +   filter = task->seccomp.filter;
>>>> +   while (filter) {
>>>> +           filter = filter->prev;
>>>> +           count++;
>>>> +   }
>>>> +
>>>> +   if (filter_off >= count) {
>>>> +           ret = -ENOENT;
>>>> +           goto out;
>>>> +   }
>>>> +   count -= filter_off;
>>>> +
>>>> +   filter = task->seccomp.filter;
>>>> +   while (filter && count > 1) {
>>>> +           filter = filter->prev;
>>>> +           count--;
>>>> +   }
>>>> +
>>>> +   if (WARN_ON(count != 1)) {
>>>> +           /* The filter tree shouldn't shrink while we're using it. */
>>>> +           ret = -ENOENT;
>>>
>>> Yes. but this looks a bit confusing. If we want this WARN_ON() check
>>> because we are paranoid, then we should do
>>>
>>>        WARN_ON(count != 1 || filter);
>>
>> I guess you mean !filter here? We want filter to be non-null, because
>> we use it later.
>>
>>> And "while we're using it" look misleading, we rely on ->siglock.
>>>
>>> Plus if we could be shrinked the additional check can't help anyway,
>>> we can used the free filter. So I don't really understand this check
>>> and "filter != NULL" in the previous "while (filter && count > 1)".
>>> Nevermind...
>>
>> Just paranoia. You're right that we could get rid of WARN_ON and the
>> null check. I can send an updated patch to drop these bits if
>> necessary. Kees?
>
> I like being really paranoid when dealing with the filters. Let's keep
> the WARN_ON (with the "|| !filter" added) but maybe wrap it in
> "unlikely"?

Btw, the conditions inside the WARN_ON() macro would already resolve
to unlikely().

Best,
Daniel
