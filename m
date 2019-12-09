From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 4/4] samples: Add example of using PTRACE_GETFD in
 conjunction with user trap
Date: Mon, 9 Dec 2019 21:46:35 +0100
Message-ID: <20191209204635.GC10721@redhat.com>
References: <20191209070646.GA32477@ircssh-2.c.rugged-nimbus-611.internal>
 <20191209192959.GB10721@redhat.com>
 <BE3E056F-0147-4A00-8FF7-6CC9DE02A30C@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BE3E056F-0147-4A00-8FF7-6CC9DE02A30C@ubuntu.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Sargun Dhillon <sargun@sargun.me>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, tycho@tycho.ws, jannh@google.com, cyphar@cyphar.com, luto@amacapital.net, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 12/09, Christian Brauner wrote:
>
> >We can
> >add PTRACE_DETACH_ASYNC, but this makes me think that PTRACE_GETFD has
> >nothing
> >to do with ptrace.
> >
> >May be a new syscall which does ptrace_may_access() + get_task_file()
> >will make
> >more sense?
> >
> >Oleg.
>=20
> Once more since this annoying app uses html by default...
>=20
> But we can already do this right now and this is just an improvement.
> That's a bit rich for a new syscall imho...

I agree, and I won't really argue...

but the changelog in 2/4 says

=09The requirement that the tracer has attached to the tracee prior to the
=09capture of the file descriptor may be lifted at a later point.

so may be we should do this right now?

plus this part

=09@@ -1265,7 +1295,8 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, =
unsigned long, addr,
=09=09}
=09=20
=09=09ret =3D ptrace_check_attach(child, request =3D=3D PTRACE_KILL ||
=09-=09=09=09=09  request =3D=3D PTRACE_INTERRUPT);
=09+=09=09=09=09  request =3D=3D PTRACE_INTERRUPT ||
=09+=09=09=09=09  request =3D=3D PTRACE_GETFD);

actually means "we do not need ptrace, but we do not know where else we
can add this fd_install(get_task_file()).

Oleg.
