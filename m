From: =?utf-8?B?T25kxZllaiBCw61sa2E=?= <neleai-9Vj9tDbzfuSlVyrhU4qvOw@public.gmane.org>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU
 number (x86)
Date: Sat, 18 Jul 2015 12:51:25 +0200
Message-ID: <20150718105125.GB30356@domone>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com>
 <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F39C6@PRN-MBX02-1.TheFacebook.com>
 <587954201.31.1436808992876.JavaMail.zimbra@efficios.com>
 <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F5DA0@PRN-MBX02-1.TheFacebook.com>
 <549319255.383.1437070088597.JavaMail.zimbra@efficios.com>
 <CALCETrWEKE=mow3vVh7C4r8CuGy_d5VOEz7KkpijuR5cpBfFtg@mail.gmail.com>
 <CA+55aFz-VBnEKh0SPKgu8xV5=Zb+=6odybVUDoOYOknshbcFJA@mail.gmail.com>
 <20150717232836.GA13604@domone>
 <20150718073433.GH1173@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150718073433.GH1173-C3MtFaGISjmo6RMmaWD+6Sb1p8zYI1N1@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, libc-alpha <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Jul 18, 2015 at 03:34:33AM -0400, Rich Felker wrote:
> On Sat, Jul 18, 2015 at 01:28:36AM +0200, Ond=C5=99ej B=C3=ADlka wrot=
e:
> > On Fri, Jul 17, 2015 at 11:48:14AM -0700, Linus Torvalds wrote:
> > > On Thu, Jul 16, 2015 at 12:27 PM, Andy Lutomirski <luto@amacapita=
l.net> wrote:
> > > >
> > > > If we actually bit the bullet and implemented per-cpu mappings
> > >=20
> > > That's not ever going to happen.
> > >=20
> > > The Linux VM model of "one page table per VM" is the right one.
> > > Anything else sucks, and makes threading a disaster.
> > >=20
> > > So you can try to prove me wrong, but seriously, I doubt you'll s=
ucceed.
> > >=20
> > > On x86, if you want per-cpu memory areas, you should basically pl=
an on
> > > using segment registers instead (although other odd state has bee=
n
> > > used - there's been the people who use segment limits etc rather =
than
> > > the *pointer* itself, preferring to use "lsl" to get percpu data.=
 You
> > > could also imaging hiding things in the vector state somewhere if=
 you
> > > control your environment well enough).
> > >
> > Thats correct, problem is that you need some sort of hack like this=
 on
> > archs that otherwise would need syscall to get tid/access tls varia=
ble.
> >=20
> > On x64 and archs that have register for tls this could be implement=
ed
> > relatively easily.
> >=20
> > Kernel needs to allocate=20
> >=20
> > int running_cpu_for_tid[32768];
>=20
> This does not scale. You're assuming the default task ("pid") number
> limit, but this can be raised up to 512k (beyond that is impossible
> because of PI/robust futex ABI).
>
Doesn't matter much, you will allocate 512k instead. As scaling if you
have simultaneously more than 32k threads running you have different
worries than how slow its to get cpu id.
=20
> > On context switch it atomically writes to this table=20
> >=20
> > running_cpu_for_tid[tid] =3D cpu;
> >=20
> > This table is read-only accessible from userspace as mmaped file.
>=20
> There is a much simpler solution: use a per-cpu (rather than per-task=
)
> page that contains the right value for the cpu. I believe vdso alread=
y
> does something like this, no?
>=20
Thats exactly what I suggested before to improve tls when you don't hav=
e
register for that.

If thats already done its just matter of abi for kernel map per-cpu pag=
e
to fixed virtual page and save/restore tcb in same way as it sets cpuid=
=2E

With that abi a tls access would cost just extra load more than of stat=
ic
variable.
