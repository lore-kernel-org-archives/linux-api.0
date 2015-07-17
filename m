From: =?utf-8?B?T25kxZllaiBCw61sa2E=?= <neleai-9Vj9tDbzfuSlVyrhU4qvOw@public.gmane.org>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU
 number (x86)
Date: Sat, 18 Jul 2015 00:43:53 +0200
Message-ID: <20150717224353.GA7150@domone>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com>
 <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F39C6@PRN-MBX02-1.TheFacebook.com>
 <587954201.31.1436808992876.JavaMail.zimbra@efficios.com>
 <20150717105859.GB21915@domone>
 <626545401.1010.1437149010438.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <626545401.1010.1437149010438.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, libc-alpha <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 17, 2015 at 04:03:30PM +0000, Mathieu Desnoyers wrote:
> ----- On Jul 17, 2015, at 6:58 AM, Ond=C5=99ej B=C3=ADlka neleai@sezn=
am.cz wrote:
> [...]
> >> If we invoke this per-thread registration directly in the glibc NP=
TL
> >> implementation,
> >> in start_thread, do you think it would fit your requirements ?
> >>
> > A generic solution would be adding eager initialization of thread_l=
ocal
> > variables which would fix more performance problems.
>=20
> Concretely, what code would be in charge of this initialization ?
>=20
> What changes does "eager initialization" imply from the current
> implementation ?
>
Now if you write

class foo{
public:
  foo(){
    printf("init\n");
  }
  foo(const foo &x){
    printf("init\n");
  }
  int bar()
  {
    return 32;
  }
};
thread_local class foo x;

Then constructor isn't called in all threads, only main as its lazily
initialized. You need to call x.bar() in each thread to cause
initialization.

> > Second would be write patch to libc adding function
> > pthread_create_add_hook_np to register function that would be ran a=
fter
> > each thread creation.
>=20
> Do you suggest that this callback should be registered once per threa=
d,
> or somehow attached to pthread_attr_t ? As maintainer of lttng-ust,
> where we need some control over our own threads, but where we want mi=
nimal
> impact on the overall application, I would really prefer if we can at=
tach
> the callback to pthread_attr_t.
>=20
Could you elaborate. I was suggesting per-thread callback, what do you
want to do with pthread_attr_t?
