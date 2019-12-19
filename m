From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 2/5] pid: Add PIDFD_IOCTL_GETFD to fetch file
 descriptors from processes
Date: Thu, 19 Dec 2019 12:31:41 +0100
Message-ID: <CAK8P3a1-hsnidMzQJghRGE-1voP4WHDoOLRZHe9P-UmTpea+Qg@mail.gmail.com>
References: <20191218235459.GA17271@ircssh-2.c.rugged-nimbus-611.internal>
 <CAK8P3a2eT=bHkUamyp-P3Y2adNq1KBk7UknCYBY5_aR4zJmYaQ@mail.gmail.com> <20191219103525.yqb5f4pbd2dvztkb@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191219103525.yqb5f4pbd2dvztkb@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Florian Weimer <fweimer@redhat.com>, Sargun Dhillon <sargun@sargun.me>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Tycho Andersen <tycho@tycho.ws>, Jann Horn <jannh@google.com>, Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, gpascutto@mozilla.com, ealvarez@mozilla.com, jld@mozilla.com
List-Id: linux-api@vger.kernel.org

On Thu, Dec 19, 2019 at 11:35 AM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
> On Thu, Dec 19, 2019 at 09:03:09AM +0100, Arnd Bergmann wrote:
> > On Thu, Dec 19, 2019 at 12:55 AM Sargun Dhillon <sargun@sargun.me> wrote:

> What does everyone else think? Arnd, still in favor of a syscall I take it.

Yes, but I would not object the ioctl if others prefer that.

      Arnd
