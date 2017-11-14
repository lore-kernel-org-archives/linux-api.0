From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFC PATCH 0/2] x86: Fix missing core serialization on migration
Date: Tue, 14 Nov 2017 09:31:22 -0800
Message-ID: <CA+55aFy+uBgzSCvhLewBrv53SfYpC33W7A-oo9s+1yBh_1DcgA@mail.gmail.com>
References: <20171110211249.10742-1-mathieu.desnoyers@efficios.com>
 <617343212.13932.1510592207202.JavaMail.zimbra@efficios.com>
 <4d47fbb8-8f99-19d3-a9cf-66841aeffac3@scylladb.com> <4431530.14831.1510672632887.JavaMail.zimbra@efficios.com>
 <20171114160541.GC3165@worktop.lehotels.local> <20171114160842.GH3857@worktop>
 <798843926.14994.1510678155257.JavaMail.zimbra@efficios.com>
 <98b50de6-4cb1-9c43-4353-9ee7135dc63f@scylladb.com> <1216732828.15017.1510679404571.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1216732828.15017.1510679404571.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, maged michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Russell King, ARM Linux" <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Will
List-Id: linux-api@vger.kernel.org

On Tue, Nov 14, 2017 at 9:10 AM, Mathieu Desnoyers
<mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>> (* OPTION 1 *)
>> Store modified code (as data) into code segment;
>> Jump to new code or an intermediate location;
>> Execute new code;"
>
> Good point, so this is likely why I was having trouble reproducing the
> single-threaded self-modifying code incoherent case. I did have a branch
> in there.

Actually, even *without* the branch, Intel has been very good at
having precise I$ coherency. I think uou can literally store to the
next instruction, and Intel CPU's after the Pentium Pro would notice,
take a micro-fault, and handle it correctly (the i486 and Pentium did
not have that level of coherency, but a taken branch would flush the
fetch buffer).

An in-order Atom probabably has the old Pentium behavior, and you
could see it there.

But starting with the P6, and OoO execution, the "taken branch" thing
meant very little, so Intel started instead just doing the
"store-vs-instruction fetch" coherency explicitly, which causes it to
be precise.

Afaik, the only way to show incoherent I$ fairly easily is to use
virtual aliasing, and store to a different virtual address, because
the fetch buffer coherency is done by virtual address.

But even then, it's only the fetch buffer (and it's been called
different things over the years, now it's a uop loop cache), not the
L1 caches, so you get a very limited window of instructions.

And that fetch buffer is also where any cross-cpu incoherency would
be, for the exact same reason.

          Linus
