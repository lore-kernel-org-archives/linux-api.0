From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v4 2/5] pid: Add PIDFD_IOCTL_GETFD to fetch file
 descriptors from processes
Date: Thu, 19 Dec 2019 17:43:17 -0800
Message-ID: <CALCETrUK-SHA=sOUrBscpf+Bpxxff2L3RpXEaAfRHNnHGxa-LQ@mail.gmail.com>
References: <20191218235459.GA17271@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191218235459.GA17271@ircssh-2.c.rugged-nimbus-611.internal>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Tycho Andersen <tycho@tycho.ws>, Jann Horn <jannh@google.com>, Aleksa Sarai <cyphar@cyphar.com>, Christian Brauner <christian.brauner@ubuntu.com>, Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, gpascutto@mozilla.com, ealvarez@mozilla.com, Florian Weimer <fweimer@redhat.com>, jld@mozilla.com, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

On Wed, Dec 18, 2019 at 3:55 PM Sargun Dhillon <sargun@sargun.me> wrote:
>
> +
> +       if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS)) {
> +               file = ERR_PTR(-EPERM);
> +               goto out;
> +       }

I don't think this is MODE_READ.  By copying an fd from the task, you
can easily change its state.

IMO it would be really nice if pidfd could act more like a capability
here and carry a ptrace mode, for example.  But I guess it doesn't
right now.


--Andy
