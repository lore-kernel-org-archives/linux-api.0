From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v4 4/4] seccomp: add support for passing fds via USER_NOTIF
Date: Fri, 22 Jun 2018 11:21:08 -0700
Message-ID: <8C2AA818-2F53-4F40-842F-288B4C709414@amacapital.net>
References: <20180621220416.5412-1-tycho@tycho.ws> <20180621220416.5412-5-tycho@tycho.ws> <CAG48ez0HW-nScxn4G5p8UHtYy=T435ZkF3Tb1ARTyyijt_cNEg@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez0HW-nScxn4G5p8UHtYy=T435ZkF3Tb1ARTyyijt_cNEg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, kernel list <linux-kernel@vger.kernel.org>, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, suda.akihiro@lab.ntt.co.jp, "Tobin C. Harding" <me@tobin.cc>
List-Id: linux-api@vger.kernel.org



> On Jun 22, 2018, at 9:23 AM, Jann Horn <jannh@google.com> wrote:
>=20
>> On Fri, Jun 22, 2018 at 12:05 AM Tycho Andersen <tycho@tycho.ws> wrote:
>>=20
>> The idea here is that the userspace handler should be able to pass an fd
>> back to the trapped task, for example so it can be returned from socket()=
.
>>=20
>> I've proposed one API here, but I'm open to other options. In particular,=

>> this only lets you return an fd from a syscall, which may not be enough i=
n
>> all cases. For example, if an fd is written to an output parameter instea=
d
>> of returned, the current API can't handle this. Another case is that
>> netlink takes as input fds sometimes (IFLA_NET_NS_FD, e.g.). If netlink
>> ever decides to install an fd and output it, we wouldn't be able to handl=
e
>> this either.
>>=20
>> Still, the vast majority of interesting cases are covered by this API, so=

>> perhaps it is Enough.
>>=20
>> I've left it as a separate commit for two reasons:
>>  * It illustrates the way in which we would grow struct seccomp_notif and=

>>    struct seccomp_notif_resp without using netlink
>>  * It shows just how little code is needed to accomplish this :)
>>=20
> [...]
>> @@ -1669,10 +1706,20 @@ static ssize_t seccomp_notify_write(struct file *=
file, const char __user *buf,
>>                goto out;
>>        }
>>=20
>> +       if (resp.return_fd) {
>> +               knotif->flags =3D resp.fd_flags;
>> +               knotif->file =3D fget(resp.fd);
>> +               if (!knotif->file) {
>> +                       ret =3D -EBADF;
>> +                       goto out;
>> +               }
>> +       }
>> +
>=20
> I think this is a security bug. Imagine the following scenario:
>=20
> - attacker creates processes A and B
> - process A installs a seccomp filter and sends the notification fd
> to process B
> - process A starts a syscall for which the filter returns
> SECCOMP_RET_USER_NOTIF
> - process B reads the notification from the notification fd
> - process B uses dup2() to copy the notification fd to file
> descriptor 1 (stdout)
> - process B executes a setuid root binary
> - the setuid root binary opens some privileged file descriptor
> (something like open("/etc/shadow", O_RDWR))
> - the setuid root binary tries to write some attacker-controlled data to s=
tdout
> - seccomp_notify_write() interprets the start of the written data as
> a struct seccomp_notif_resp
> - seccomp_notify_write() grabs the privileged file descriptor and
> installs a copy in process A
> - process A now has access to the privileged file (e.g. /etc/shadow)
>=20
> It isn't clear whether it would actually be exploitable - you'd need a
> setuid binary that performs the right actions - but it's still bad.

Jann is right. ->read and ->write must not reference any of the calling task=
=E2=80=99s state except the literal memory passed in.

>=20
> Unless I'm missing something, can you please turn the ->read and
> ->write handlers into an ->unlocked_ioctl handler? Something like
> this:
>=20
> struct seccomp_user_notif_args {
>        u64 buf;
>        u64 size;
> };
>=20
> static long unlocked_ioctl(struct file *file, unsigned int cmd,
> unsigned long arg)
> {
>        struct seccomp_user_notif_args args;
>        struct seccomp_user_notif_args __user *uargs;
>=20
>        if (cmd !=3D SECCOMP_USER_NOTIF_READ && cmd !=3D SECCOMP_USER_NOTIF_=
WRITE)
>                return -EINVAL;
>=20
>        if (copy_from_user(&args, uargs, sizeof(args)))
>                return -EFAULT;
>=20
>        switch (cmd) {
>        case SECCOMP_USER_NOTIF_READ:
>                return seccomp_notify_read(file, (char __user
> *)args.buf, (size_t)args.size);
>        case SECCOMP_USER_NOTIF_WRITE:
>                return seccomp_notify_write(file, (char __user
> *)args.buf, (size_t)args.size);
>        default:
>                return -EINVAL;
>        }
> }
