From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v4 1/4] seccomp: add a return code to trap to userspace
Date: Sat, 23 Jun 2018 00:27:43 +0200
Message-ID: <CAG48ez3gobTL5mUnZKjhLedotZx49nGrxYKKud5_7+512PaOFw@mail.gmail.com>
References: <20180621220416.5412-1-tycho@tycho.ws> <20180621220416.5412-2-tycho@tycho.ws>
 <CAG48ez3Ek_KG54ejR=Q=XtW_HDs8hQ+cgFODzn4rQ0nVDVpODg@mail.gmail.com>
 <20180622151514.GM3992@cisco> <E8029AD7-7009-4CBF-911E-186328237176@amacapital.net>
 <CAGXu5jKWQCDzXPdTz=+bxT9+4enaBvgYfMseUiGti+t1KwZT8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jKWQCDzXPdTz=+bxT9+4enaBvgYfMseUiGti+t1KwZT8g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Tycho Andersen <tycho@tycho.ws>, kernel list <linux-kernel@vger.kernel.org>, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, suda.akihiro@lab.ntt.co.jp, "Tobin C. Harding" <me@tobin.cc>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 22, 2018 at 11:51 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Fri, Jun 22, 2018 at 11:09 AM, Andy Lutomirski <luto@amacapital.net> w=
rote:
> > One possible extra issue: IIRC /proc/.../mem uses FOLL_FORCE, which is =
not what we want here.

Uuugh, I forgot about that.

> > How about just adding an explicit =E2=80=9Cread/write the seccomp-trapp=
ed task=E2=80=99s memory=E2=80=9D primitive?  That should be easier than a =
=E2=80=9Copen mem fd=E2=80=9D primitive.
>
> Uuugh. Can we avoid adding another "read/write remote process memory"
> interface? The point of this series was to provide a lightweight
> approach to what should normally be possible via the existing
> seccomp+ptrace interface. I do like Jann's context idea, but I agree
> with Andy: it can't be a handle to /proc/$pid/mem, since it's
> FOLL_FORCE. Is there any other kind of process context id we can use
> for this instead of pid? There was once an idea of pid-fd but it never
> landed... This would let us get rid of the "id" in the structure too.
> And if that existed, we could make process_vm_*v() safer too (taking a
> pid-fd instead of a pid).

Or make a duplicate of /proc/$pid/mem that only differs in whether it
sets FOLL_FORCE? The code is basically already there... something like
this:

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 80aa42506b8b..e8a6a63046da 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -762,6 +762,8 @@ static int mem_open(struct inode *inode, struct file *f=
ile)
        return ret;
 }

+static const struct file_operations proc_mem_operations;
+
 static ssize_t mem_rw(struct file *file, char __user *buf,
                        size_t count, loff_t *ppos, int write)
 {
@@ -782,7 +784,10 @@ static ssize_t mem_rw(struct file *file, char __user *=
buf,
        if (!mmget_not_zero(mm))
                goto free;

-       flags =3D FOLL_FORCE | (write ? FOLL_WRITE : 0);
+       flags =3D (write ? FOLL_WRITE : 0);
+       if (file->f_op =3D=3D &proc_mem_operations) {
+               flags |=3D FOLL_FORCE;
+       }

        while (count > 0) {
                int this_len =3D min_t(int, count, PAGE_SIZE);
@@ -861,6 +866,14 @@ static const struct file_operations proc_mem_operation=
s =3D {
        .release        =3D mem_release,
 };

+static const struct file_operations proc_mem_noforce_operations =3D {
+       .llseek         =3D mem_lseek,
+       .read           =3D mem_read,
+       .write          =3D mem_write,
+       .open           =3D mem_open,
+       .release        =3D mem_release,
+};
+
 static int environ_open(struct inode *inode, struct file *file)
 {
        return __mem_open(inode, file, PTRACE_MODE_READ);
@@ -2916,6 +2929,7 @@ static const struct pid_entry tgid_base_stuff[] =3D {
        REG("numa_maps",  S_IRUGO, proc_pid_numa_maps_operations),
 #endif
        REG("mem",        S_IRUSR|S_IWUSR, proc_mem_operations),
+       REG("mem_noforce", S_IRUSR|S_IWUSR, proc_mem_noforce_operations),
        LNK("cwd",        proc_cwd_link),
        LNK("root",       proc_root_link),
        LNK("exe",        proc_exe_link),
@@ -3302,6 +3316,7 @@ static const struct pid_entry tid_base_stuff[] =3D {
        REG("numa_maps", S_IRUGO, proc_tid_numa_maps_operations),
 #endif
        REG("mem",       S_IRUSR|S_IWUSR, proc_mem_operations),
+       REG("mem_noforce",S_IRUSR|S_IWUSR, proc_mem_noforce_operations),
        LNK("cwd",       proc_cwd_link),
        LNK("root",      proc_root_link),
        LNK("exe",       proc_exe_link),
