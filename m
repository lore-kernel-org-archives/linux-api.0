From: Sargun Dhillon <sargun@sargun.me>
Subject: Re: [PATCH v4 2/5] pid: Add PIDFD_IOCTL_GETFD to fetch file
 descriptors from processes
Date: Thu, 19 Dec 2019 21:21:23 -0800
Message-ID: <CAMp4zn9R3XoV=xLi9y0vn-DotUQGRFA8Cp14aYYvkVYEUuW48w@mail.gmail.com>
References: <20191218235459.GA17271@ircssh-2.c.rugged-nimbus-611.internal> <CALCETrUK-SHA=sOUrBscpf+Bpxxff2L3RpXEaAfRHNnHGxa-LQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUK-SHA=sOUrBscpf+Bpxxff2L3RpXEaAfRHNnHGxa-LQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Tycho Andersen <tycho@tycho.ws>, Jann Horn <jannh@google.com>, Aleksa Sarai <cyphar@cyphar.com>, Christian Brauner <christian.brauner@ubuntu.com>, Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Gian-Carlo Pascutto <gpascutto@mozilla.com>, =?UTF-8?Q?Emilio_Cobos_=C3=81lvarez?= <ealvarez@mozilla.com>, Florian Weimer <fweimer@redhat.com>, Jed Davis <jld@mozilla.com>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

On Thu, Dec 19, 2019 at 5:43 PM Andy Lutomirski <luto@kernel.org> wrote:
>
>
> I don't think this is MODE_READ.  By copying an fd from the task, you
> can easily change its state.
Would PTRACE_MODE_ATTACH_REALCREDS  work? I'm curious what
kind of state change you can cause by borrowing an FD?


>
> IMO it would be really nice if pidfd could act more like a capability
> here and carry a ptrace mode, for example.  But I guess it doesn't
> right now.
>
>
> --Andy
