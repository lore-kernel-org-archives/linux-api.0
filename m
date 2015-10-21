From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v8] seccomp, ptrace: add support for dumping seccomp filters
Date: Wed, 21 Oct 2015 13:12:17 -0700
Message-ID: <CAGXu5jL-LMC6SLazLE0UPcffr9cD5Z0ME4ddNjJmBKTx=dXz_A@mail.gmail.com>
References: <1445370612-18843-1-git-send-email-tycho.andersen@canonical.com>
	<1445370612-18843-2-git-send-email-tycho.andersen@canonical.com>
	<20151020202024.GA5772@redhat.com>
	<20151020220814.GA3232@hopstrocity>
	<20151021185146.GA27176@redhat.com>
	<20151021191533.GD30729@hopstrocity>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151021191533.GD30729@hopstrocity>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 21, 2015 at 12:15 PM, Tycho Andersen
<tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> Hi Oleg,
>
> On Wed, Oct 21, 2015 at 08:51:46PM +0200, Oleg Nesterov wrote:
>> On 10/20, Tycho Andersen wrote:
>> >
>> > Hi Kees, Oleg,
>> >
>> > On Tue, Oct 20, 2015 at 10:20:24PM +0200, Oleg Nesterov wrote:
>> > >
>> > > No, you can't do copy_to_user() from atomic context. You need to pin this
>> > > filter, drop the lock/irq, then copy_to_user().
>> >
>> > Attached is a patch which addresses this.
>>
>> Looks good to me, feel free to add my reviewed-by.
>>
>>
>> a couple of questions, I am just curious...
>>
>> > +long seccomp_get_filter(struct task_struct *task, unsigned long filter_off,
>> > +                   void __user *data)
>> > +{
>> > +   struct seccomp_filter *filter;
>> > +   struct sock_fprog_kern *fprog;
>> > +   long ret;
>> > +   unsigned long count = 0;
>> > +
>> > +   if (!capable(CAP_SYS_ADMIN) ||
>> > +       current->seccomp.mode != SECCOMP_MODE_DISABLED) {
>> > +           return -EACCES;
>> > +   }
>> > +
>> > +   spin_lock_irq(&task->sighand->siglock);
>> > +   if (task->seccomp.mode != SECCOMP_MODE_FILTER) {
>> > +           ret = -EINVAL;
>> > +           goto out;
>> > +   }
>> > +
>> > +   filter = task->seccomp.filter;
>> > +   while (filter) {
>> > +           filter = filter->prev;
>> > +           count++;
>> > +   }
>> > +
>> > +   if (filter_off >= count) {
>> > +           ret = -ENOENT;
>> > +           goto out;
>> > +   }
>> > +   count -= filter_off;
>> > +
>> > +   filter = task->seccomp.filter;
>> > +   while (filter && count > 1) {
>> > +           filter = filter->prev;
>> > +           count--;
>> > +   }
>> > +
>> > +   if (WARN_ON(count != 1)) {
>> > +           /* The filter tree shouldn't shrink while we're using it. */
>> > +           ret = -ENOENT;
>>
>> Yes. but this looks a bit confusing. If we want this WARN_ON() check
>> because we are paranoid, then we should do
>>
>>       WARN_ON(count != 1 || filter);
>
> I guess you mean !filter here? We want filter to be non-null, because
> we use it later.
>
>> And "while we're using it" look misleading, we rely on ->siglock.
>>
>> Plus if we could be shrinked the additional check can't help anyway,
>> we can used the free filter. So I don't really understand this check
>> and "filter != NULL" in the previous "while (filter && count > 1)".
>> Nevermind...
>
> Just paranoia. You're right that we could get rid of WARN_ON and the
> null check. I can send an updated patch to drop these bits if
> necessary. Kees?

I like being really paranoid when dealing with the filters. Let's keep
the WARN_ON (with the "|| !filter" added) but maybe wrap it in
"unlikely"?

>> The question is:
>>
>> > +   fprog = filter->prog->orig_prog;
>> > +   if (!fprog) {
>>
>> So is it possible or not? I didn't see the previous changes which
>> added "bool save" to seccomp_attach_filter() so I simply can't know.
>
> Currently, no, it's not. Every struct seccomp_filter is created via a
> classic filter,
>
>> Now,
>>
>> > +           /* This must be a new non-cBPF filter, since we save every
>> > +            * every cBPF filter's orig_prog above when
>> > +            * CONFIG_CHECKPOINT_RESTORE is enabled.
>> > +            */
>> > +           ret = -EMEDIUMTYPE;
>>
>> If this is possible, then probably we should simply change both
>> "while (filter)" loops above to skip a filter if orig_prog == NULL
>> and remove the -EMEDIUMTYPE code ?
>>
>> Or what? Probably "a new non-cBPF filter" answers my question,
>> but I do not know what this cBPF/non-cBPF actually means ;)
>>
>> In short. Who can attach a filter without "save => true" ?
>
> There are two kinds of BPF programs, a "classic" instruction set, and
> an "extended" one (which has more features, like maps, that seccomp
> probably wants to use someday). Right now, the kernel only supports
> adding filters via the classic interface, which saves the orig_prog
> and then converts it into the "extended" instruction set for internal
> use in the kernel. This ptrace command just dumps the classic
> programs.
>
> In the future, if there exists a seccomp interface to add extended BPF
> programs directly, they won't have an orig_prog, which will trigger
> this error. We don't want to skip these filters because userspace has
> no way to know that there is a filter there it couldn't dump. Instead,
> we give EMEDIUMTYPE, so userspace knows to use whatever dumping
> mechanism exists for this new filter type.

These tests are for future-proofing, and I think we should keep.

-Kees

>
> Tycho



-- 
Kees Cook
Chrome OS Security
