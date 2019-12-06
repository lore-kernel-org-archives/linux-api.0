From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC PATCH] ptrace: add PTRACE_GETFD request
Date: Fri, 6 Dec 2019 13:23:11 +0100
Message-ID: <20191206122311.GA820@redhat.com>
References: <20191205234450.GA26369@ircssh-2.c.rugged-nimbus-611.internal>
 <20191206082539.gmefytwu3ylixj5d@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191206082539.gmefytwu3ylixj5d@wittgenstein>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Sargun Dhillon <sargun@sargun.me>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, tycho@tycho.ws
List-Id: linux-api@vger.kernel.org

> On Thu, Dec 05, 2019 at 11:44:53PM +0000, Sargun Dhillon wrote:
>
> > +static int ptrace_getfd(struct task_struct *child, unsigned long fd)
> > +{
> > +=09struct files_struct *files;
> > +=09struct file *file;
> > +=09int ret =3D 0;
> > +
> > +=09files =3D get_files_struct(child);
> > +=09if (!files)
> > +=09=09return -ENOENT;
> > +
> > +=09spin_lock(&files->file_lock);
> > +=09file =3D fcheck_files(files, fd);
> > +=09if (!file)
> > +=09=09ret =3D -EBADF;
> > +=09else
> > +=09=09get_file(file);
> > +=09spin_unlock(&files->file_lock);
> > +=09put_files_struct(files);

may be someone can finally create a helper for this, it can have more users=
.
say,
=09struct file *get_task_file(task, fd)
=09{
=09=09struct file *file =3D NULL;

=09=09task_lock(task);
=09=09rcu_read_lock();
=09=09if (task->files) {
=09=09=09file =3D fcheck_files(task->files, fd);
=09=09=09if (file)
=09=09=09=09get_file(file);
=09=09}
=09=09rcu_read_unlock();
=09=09task_unlock(task);

=09=09return file;
=09}


no need to get/put files_struct, no need to take ->file_lock.

> > +
> > +=09if (ret)
> > +=09=09goto out;
> > +
> > +=09ret =3D get_unused_fd_flags(0);
> > +=09if (ret >=3D 0)
> > +=09=09fd_install(ret, file);
> > +
> > +=09fput(file);

this looks wrong or I am totally confused...

=09if (ret >=3D 0)
=09=09fd_install(file);
=09else
=09=09fput(file);

?

> > @@ -1265,7 +1299,8 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid,=
 unsigned long, addr,
> >  =09}
> > =20
> >  =09ret =3D ptrace_check_attach(child, request =3D=3D PTRACE_KILL ||
> > -=09=09=09=09  request =3D=3D PTRACE_INTERRUPT);
> > +=09=09=09=09  request =3D=3D PTRACE_INTERRUPT ||
> > +=09=09=09=09  request =3D=3D PTRACE_GETFD);

Hmm. not sure why do you want this... But OK, we do not need to stop the tr=
acee.

Oleg.
