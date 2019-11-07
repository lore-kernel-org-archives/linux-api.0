From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Continuing the UAPI split
Date: Thu, 07 Nov 2019 14:47:54 +0100
Message-ID: <87v9rvhk6t.fsf@oldenburg2.str.redhat.com>
References: <CALN7hCK0EXLXjPRPr+tuuF2-uQvkLMCFDNzGhv9HS-jrAz6Hmg@mail.gmail.com>
	<0B17C6F2-DC2B-4192-B4AD-BD11D6B9F2B6@ubuntu.com>
	<87zhh7j38y.fsf@oldenburg2.str.redhat.com>
	<CALN7hCJ_umFqC1L0T19CuiGiGoVwac5807NDw4LiDqSD-VJL=Q@mail.gmail.com>
	<87zhh7hlbl.fsf@oldenburg2.str.redhat.com>
	<20191107133652.lqp5cqcdtwu22ibd@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <libc-alpha-return-106751-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <20191107133652.lqp5cqcdtwu22ibd@wittgenstein> (Christian
	Brauner's message of "Thu, 7 Nov 2019 14:36:54 +0100")
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Elichai Turkel <elichai.turkel@gmail.com>, linux-api@vger.kernel.org, libc-alpha <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

* Christian Brauner:

> A problem I recently ran into that is related are problems with
> sys/wait.h and linux/wait.h.
> How P_{PID,PGID,PIDFD} used by the waitid() syscall are defined is
> different for the two headers.
> linux/wait.h uses #define for P_{PID,PGID,PIDFD} whereas sys/wait.h
> uses an enum.
> The problem is that if I simply don't rely on sys/wait.h and just do
> #ifndef P_PID
> #define P_PID <value>
> #endif
> where value is what the syscall expects then technically I need to call
> the waitid() syscall directly since it's not at all guaranteed - afaict
> - that the P_PID enum =3D=3D P_PID define that glibc uses for its waitid(=
)
> syscall wrapper.

Right, and this is where POSIX mandates that there is a type idtype_t
which is an enum, an that it has members P_PID etc.

What we could do is:

typedef enum
{
  P_ALL,=09=09/* Wait for any child.  */
#define P_ALL P_ALL
  P_PID,=09=09/* Wait for specified process.  */
#define P_PID P_PID
  P_PGID=09=09/* Wait for members of process group.  */
#define P_PGID P_PGID
} idtype_t;

The other header can then use #ifdef.  You'll see that pattern in some
cases already.

But that will only work if you include glibc headers first.  The generic
approach uses some shared macro for the coordination so that things work
both ways.

The other issue here is that it gets rather iffy from a language point
of view if the kernel wants to add additional constants and glibc has
still the old idtype_t definition.

> So I'm now in a scenario where I can't call the glibc wrapper for
> waitid() with the linux/wait.h defines and I can't call the syscall
> directly (e.g. because I want to make use of the syscall's rusage
> argument that glibc doesn't expose) with sys/wait.h's P_PID enum.
> I'm not sure what the right solution is here...

Yes, it's a hard problem.  waitid is particularly annoying because POSIX
and the kernel have such different function prototypes.  We could
perhaps expose the actual waitid system call under a different name, and
use int for the ID type parameter.  But that needs someone to write a
patch.  (My efforts to add syscall wrappers have stalled unfortunately.)

Thanks,
Florian
