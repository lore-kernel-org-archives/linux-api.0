From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU number (x86)
Date: Mon, 20 Jul 2015 10:41:09 -0700
Message-ID: <CALCETrUx6wFxmz+9TyW5bNgaMN0q180G8y9YOyq_D41sdhFaRQ@mail.gmail.com>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com>
 <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F39C6@PRN-MBX02-1.TheFacebook.com>
 <587954201.31.1436808992876.JavaMail.zimbra@efficios.com> <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F5DA0@PRN-MBX02-1.TheFacebook.com>
 <549319255.383.1437070088597.JavaMail.zimbra@efficios.com>
 <CALCETrWEKE=mow3vVh7C4r8CuGy_d5VOEz7KkpijuR5cpBfFtg@mail.gmail.com>
 <CA+55aFz-VBnEKh0SPKgu8xV5=Zb+=6odybVUDoOYOknshbcFJA@mail.gmail.com>
 <20150717232836.GA13604@domone> <CALCETrVY=kjeA_4pazy3BL+ekfcV6WHKw8e3z-LBxx_uP1bw2Q@mail.gmail.com>
 <55ACB2DC.5010503@redhat.com> <CALCETrV9Vp5UUOb3e_R5tphyE-urBgTwQR2pFWUOOFnHqWXHKQ@mail.gmail.com>
 <55AD14A4.6030101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55AD14A4.6030101-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, libc-alpha <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?B?T25kxZllaiBCw61sa2E=?= <neleai-9Vj9tDbzfuSlVyrhU4qvOw@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 20, 2015 at 8:32 AM, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 07/20/2015 05:31 PM, Andy Lutomirski wrote:
>> On Jul 20, 2015 1:35 AM, "Florian Weimer" <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>>
>>> On 07/18/2015 01:33 AM, Andy Lutomirski wrote:
>>>
>>>> I think the API should be "set gsbase to x + y*(cpu number)".  On
>>>> x86_64, userspace just allocates a big swath of virtual space and
>>>> populates it as needed.
>>>
>>> This will break WINE and similar applications which use %gs today.
>>
>> Presumably WINE could just opt not to use this facility, just like
>> WINE will have to opt out of whatever the enterprise people who want
>> WRGSBASE were thinking of doing with it.
>
> How is this possible if it's process-global attribute and glibc or some
> library in the process starts using it?
>

glibc will have to expose a way to turn it off, I guess. (ELF flag?)
