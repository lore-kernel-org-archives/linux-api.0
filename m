From: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU number
 (x86)
Date: Mon, 20 Jul 2015 16:18:53 +0300
Message-ID: <moisft$pcl$1@ger.gmane.org>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com> <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F39C6@PRN-MBX02-1.TheFacebook.com> <587954201.31.1436808992876.JavaMail.zimbra@efficios.com> <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F5DA0@PRN-MBX02-1.TheFacebook.com> <549319255.383.1437070088597.JavaMail.zimbra@efficios.com> <CALCETrWEKE=mow3vVh7C4r8CuGy_d5VOEz7KkpijuR5cpBfFtg@mail.gmail.com> <CA+55aFz-VBnEKh0SPKgu8xV5=Zb+=6odybVUDoOYOknshbcFJA@mail.gmail.com> <20150717232836.GA13604@domone> <CALCETrVY=kjeA_4pazy3BL+ekfcV6WHKw8e3z-LBxx_uP1bw2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVY=kjeA_4pazy3BL+ekfcV6WHKw8e3z-LBxx_uP1bw2Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 18.07.2015 02:33, Andy Lutomirski wrote:
> On Fri, Jul 17, 2015 at 4:28 PM, Ond=C5=99ej B=C3=ADlka <neleai@sezna=
m.cz> wrote:
>> On Fri, Jul 17, 2015 at 11:48:14AM -0700, Linus Torvalds wrote:
>>>
>>> On x86, if you want per-cpu memory areas, you should basically plan=
 on
>>> using segment registers instead (although other odd state has been
>>> used - there's been the people who use segment limits etc rather th=
an
>>> the *pointer* itself, preferring to use "lsl" to get percpu data. Y=
ou
>>> could also imaging hiding things in the vector state somewhere if y=
ou
>>> control your environment well enough).
>>>
>> Thats correct, problem is that you need some sort of hack like this =
on
>> archs that otherwise would need syscall to get tid/access tls variab=
le.
>>
>> On x64 and archs that have register for tls this could be implemente=
d
>> relatively easily.
>>
>> Kernel needs to allocate
>>
>> int running_cpu_for_tid[32768];
>>
>> On context switch it atomically writes to this table
>>
>> running_cpu_for_tid[tid] =3D cpu;
>>
>> This table is read-only accessible from userspace as mmaped file.
>>
>> Then userspace just needs to access it with three indirections like:
>>
>> __thread tid;
>>
>> char caches[CPU_MAX];
>> #define getcpu_cache caches[tid > 32768 ? get_cpu() : running_cpu_fo=
r_tid[tid]]
>>
>> With more complicated kernel interface you could eliminate one
>> indirection as we would use void * array instead and thread could do
>> syscall to register what values it should use for each thread.
>
> Or we implement per-cpu segment registers so you can point gs directl=
y
> at percpu data.  This is conceptually easy and has no weird ABI
> issues.  All it needs is an implementation and some good tests.
>
> I think the API should be "set gsbase to x + y*(cpu number)".  On
> x86_64, userspace just allocates a big swath of virtual space and
> populates it as needed.

I've proposed exactly that design last year:
https://lwn.net/Articles/611946/

> --Andy
>
