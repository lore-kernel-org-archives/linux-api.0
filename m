From: Sargun Dhillon <sargun@sargun.me>
Subject: Re: [PATCH v5 2/3] pid: Introduce pidfd_getfd syscall
Date: Fri, 20 Dec 2019 17:45:34 -0800
Message-ID: <CAMp4zn9ivYPP1Sfu48EX897M4JAVXvK+NQB4NZ5=XPM_saJu+g@mail.gmail.com>
References: <20191220232810.GA20233@ircssh-2.c.rugged-nimbus-611.internal> <20191221002734.7rz6lcdrshrrlnqf@yavin.dot.cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191221002734.7rz6lcdrshrrlnqf@yavin.dot.cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <asarai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, =?UTF-8?Q?Emilio_Cobos_=C3=81lvarez?= <ealvarez@mozilla.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, Gian-Carlo Pascutto <gpascutto@mozilla.com>, Jed Davis <jld@mozilla.com>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <christian.brauner@ubuntu.com>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 20, 2019 at 4:27 PM Aleksa Sarai <asarai@suse.de> wrote:
>
> On 2019-12-20, Sargun Dhillon <sargun@sargun.me> wrote:
> > diff --git a/include/uapi/linux/pidfd.h b/include/uapi/linux/pidfd.h
> > new file mode 100644
> > index 000000000000..0a3fc922661d
> > --- /dev/null
> > +++ b/include/uapi/linux/pidfd.h
> > @@ -0,0 +1,10 @@
> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > +#ifndef _UAPI_LINUX_PIDFD_H
> > +#define _UAPI_LINUX_PIDFD_H
> > +
> > +struct pidfd_getfd_options {};
>
> Are empty structs well-defined in C (from memory, some compilers make
> them non-zero in size)? Since we probably plan to add a flags field in
> the future anyway, why not just have a __u64 flags which must be zeroed?
>
It's allowed in GCC:
https://gcc.gnu.org/onlinedocs/gcc-8.1.0/gcc/Empty-Structures.html

I can add an __aligned_u64 flags for now, and just say something like
"reserved". This will also solve the latter issue, and I'll just use
copy_struct_from_user,
as long as Christian is okay with having an unused (reserved) flag member.


> > +     f = fdget(pidfd);
> > +     if (!f.file)
> > +             return -EBADF;
> > +
> > +     pid = pidfd_pid(f.file);
> > +     if (IS_ERR(pid)) {
> > +             ret = PTR_ERR(pid);
> > +             goto out;
> > +     }
> > +
> > +     ret = pidfd_getfd(pid, fd);
> > +
> > +out:
> > +     fdput(f);
> > +     return ret;
> > +}
> > --
> > 2.20.1
>
> --
> Aleksa Sarai
> Senior Software Engineer (Containers)
> SUSE Linux GmbH
> <https://www.cyphar.com/>
