From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 1/4] vfs, fdtable: Add get_task_file helper
Date: Mon, 9 Dec 2019 16:52:45 +0100
Message-ID: <20191209155242.GC5388@redhat.com>
References: <20191209070609.GA32438@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191209070609.GA32438@ircssh-2.c.rugged-nimbus-611.internal>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, tycho@tycho.ws, jannh@google.com, cyphar@cyphar.com, christian.brauner@ubuntu.com, luto@amacapital.net, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 12/09, Sargun Dhillon wrote:
>
> +struct file *get_task_file(struct task_struct *task, unsigned int fd)
> +{
> +=09struct file *file =3D NULL;
> +
> +=09task_lock(task);
> +=09rcu_read_lock();
> +
> +=09if (task->files) {
> +=09=09file =3D fcheck_files(task->files, fd);
> +=09=09if (file && !get_file_rcu(file))
> +=09=09=09file =3D NULL;
> +=09}

On second thought this is not exactly right, get_file_rcu() can fail if
get_task_file() races with dup2(), in this case we need to do fcheck_files(=
)
again. And this is what __fget() already does, so may be the patch below
makes more sense?

I will leave this to other reviewers, but suddenly I recall that I have
already sent the patch which adds a similar helper a while ago.

See https://lore.kernel.org/lkml/20180915160423.GA31461@redhat.com/

In short, get_files_struct() should be avoided because it can race with
exec() and break POSIX locks which use ->fl_owner =3D files_struct.

Oleg.

--- x/fs/file.c
+++ x/fs/file.c
@@ -706,9 +706,9 @@ void do_close_on_exec(struct files_struc
 =09spin_unlock(&files->file_lock);
 }
=20
-static struct file *__fget(unsigned int fd, fmode_t mask, unsigned int ref=
s)
+static struct file *__fget_files(struct files_struct *files, unsigned int =
fd,
+=09=09=09=09=09fmode_t mask, unsigned int refs)
 {
-=09struct files_struct *files =3D current->files;
 =09struct file *file;
=20
 =09rcu_read_lock();
@@ -729,6 +729,23 @@ loop:
 =09return file;
 }
=20
+struct file *fget_task(struct task_struct *task, unsigned int fd)
+{
+=09struct file *file;
+
+=09task_lock(task);
+=09if (task->files)
+=09=09file =3D __fget_files(task->files, fd, 0, 1);
+=09task_unlock(task);
+
+=09return file;
+}
+
+static struct file *__fget(unsigned int fd, fmode_t mask, unsigned int ref=
s)
+{
+=09return __fget_files(current->files, fd, mask, refs);
+}
+
 struct file *fget_many(unsigned int fd, unsigned int refs)
 {
 =09return __fget(fd, FMODE_PATH, refs);
