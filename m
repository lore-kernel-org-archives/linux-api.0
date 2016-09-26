From: Kyle Huey <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v5 6/6] x86/arch_prctl Add ARCH_[GET|SET]_CPUID
Date: Mon, 26 Sep 2016 12:56:04 -0700
Message-ID: <CAP045AqpW09v3HgZN8cxhdegMpDC3dU504K-QuGXmSZS=jJKNw@mail.gmail.com>
References: <20160921185824.18980-1-khuey@kylehuey.com> <20160921185824.18980-7-khuey@kylehuey.com>
 <CALCETrW96hcsSp-YZgNqH_EzTfUyG9yStyp+0nQmpE0o3o__wA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrW96hcsSp-YZgNqH_EzTfUyG9yStyp+0nQmpE0o3o__wA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Robert O'Callahan <robert-7ok7fSEJICeEi8DpZVb4nw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Dmitry Safonov <dsafonov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Rafael J . Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Srinivas Pandruvada <srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, user
List-Id: linux-api@vger.kernel.org

On Thu, Sep 22, 2016 at 3:22 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Wed, Sep 21, 2016 at 11:58 AM, Kyle Huey <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org> wrote:
>> Intel supports faulting on the CPUID instruction beginning with Ivy Bridge.
>> When enabled, the processor will fault on attempts to execute the CPUID
>> instruction with CPL>0. Exposing this feature to userspace will allow a
>> ptracer to trap and emulate the CPUID instruction.
>>
>> When supported, this feature is controlled by toggling bit 0 of
>> MSR_MISC_FEATURES_ENABLES. It is documented in detail in Section 2.3.2 of
>> http://www.intel.com/content/dam/www/public/us/en/documents/application-notes/virtualization-technology-flexmigration-application-note.pdf
>>
>
>> +       if (!test_and_set_thread_flag(TIF_NOCPUID))
>> +               /*
>> +                * Must flip the CPU state synchronously with
>> +                * TIF_NOCPUID in the current running context.
>> +                */
>> +               switch_cpuid_faulting(true);
>
> If statements with multiple indented lines should have braces in my
> book.  See, for example, "goto fail".
>
>
> static?
>
>> +int set_cpuid_mode(struct task_struct *task, unsigned long val)
>
> static?
>
>> + * Called immediately after a successful exec.
>> + */
>> +void arch_post_exec(void)
>> +{
>> +       /* If cpuid was previously disabled for this task, re-enable it. */
>> +       if (test_thread_flag(TIF_NOCPUID))
>> +               enable_cpuid();
>> +}
>
>> diff --git a/fs/exec.c b/fs/exec.c
>> index 6fcfb3f..0272b7e 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -1287,6 +1287,7 @@ void setup_new_exec(struct linux_binprm * bprm)
>>         else
>>                 set_dumpable(current->mm, suid_dumpable);
>>
>> +       arch_post_exec();
>
> Let's call this arch_setup_new_exec().
>
>>         perf_event_exec();
>>         __set_task_comm(current, kbasename(bprm->filename), true);
>>
>> diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
>> index 2b5b10e..22a3f61 100644
>> --- a/include/linux/thread_info.h
>> +++ b/include/linux/thread_info.h
>> @@ -130,6 +130,10 @@ static inline void check_object_size(const void *ptr, unsigned long n,
>>  { }
>>  #endif /* CONFIG_HARDENED_USERCOPY */
>>
>> +#ifndef arch_post_exec
>> +static inline void arch_post_exec(void) {}
>> +#endif
>> +
>
> thread_info.h is a weird place for this IMO.  Admittedly, elf.h isn't
> a whole lot better.

Maybe fs.h?

- Kyle
