From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v3 2/4] pid: Add PIDFD_IOCTL_GETFD to fetch file
 descriptors from processes
Date: Tue, 17 Dec 2019 12:19:27 +0100
Message-ID: <20191217111926.bgt7jih2noli3cnu@wittgenstein>
References: <20191217010001.GA14461@ircssh-2.c.rugged-nimbus-611.internal>
 <20191217015001.sp6mrhuiqrivkq3u@wittgenstein>
 <CAMp4zn8fzeiJVSn6EtRi6UAGh6AL3QWu=PZxw+=TAYJORjn_Sw@mail.gmail.com>
 <CAK8P3a3G-W8s0G2-XKuDw9dRmupZSyiF6FRRAnvDt9=kMMzS8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a3G-W8s0G2-XKuDw9dRmupZSyiF6FRRAnvDt9=kMMzS8w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sargun Dhillon <sargun@sargun.me>, LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Tycho Andersen <tycho@tycho.ws>, Jann Horn <jannh@google.com>, Aleksa Sarai <cyphar@cyphar.com>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, gpascutto@mozilla.com, ealvarez@mozilla.com, Florian Weimer <fweimer@redhat.com>, jld@mozilla.com
List-Id: linux-api@vger.kernel.org

On Tue, Dec 17, 2019 at 09:54:40AM +0100, Arnd Bergmann wrote:
> On Tue, Dec 17, 2019 at 3:50 AM Sargun Dhillon <sargun@sargun.me> wrote:
> > On Mon, Dec 16, 2019 at 5:50 PM Christian Brauner <christian.brauner@ubuntu.com> wrote:
> Finally, there is the question whether this should be an ioctl
> operation at all, or
> if it would better be done as a proper syscall. Functionally the two
> are the same
> here, but doing such a fundamental operation as an ioctl doesn't feel
> quite right
> to me. As a system call, this could be something like
> 
> int pidfd_get_fd(int pidfd, int their_fd, int flags);
> 
> along the lines of dup3().

Thanks for taking a look, Arnd!

Yeah, Oleg hinted at this in the first version as well. I originally
disagreed but we can sure also do this as a separate syscall.
What we should keep in mind is that people already brought up adding new
fds to a task. Which is not a problem just something to remember as it
might potentially mean another syscall.

Christian
