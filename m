From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v1 1/2] proc: get process file descriptor from /proc/<pid>
Date: Mon, 19 Nov 2018 19:20:43 +0100
Message-ID: <20181119182038.27obrbpxp54rhfxt@brauner.io>
References: <20181119103241.5229-1-christian@brauner.io>
 <20181119103241.5229-2-christian@brauner.io>
 <CALCETrVvHu2dSJs1dpA-2ozGhZGxbGrnYbUuh98rkCdsz42rfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVvHu2dSJs1dpA-2ozGhZGxbGrnYbUuh98rkCdsz42rfg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Daniel Colascione <dancol@google.com>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 19, 2018 at 07:32:33AM -0800, Andy Lutomirski wrote:
> On Mon, Nov 19, 2018 at 2:33 AM Christian Brauner <christian@brauner.io> wrote:
> >
> > With this patch an open() call on /proc/<pid> will give userspace a handle
> > to struct pid of the process associated with /proc/<pid>. This allows to
> > maintain a stable handle on a process.
> > I have been discussing various approaches extensively during technical
> > conferences this year culminating in a long argument with Eric at Linux
> > Plumbers. The general consensus was that having a handle on a process
> > should be something that is very simple and easy to maintain with the
> > option of being extensible via a more advanced api if the need arises. I
> > believe that this patch is the most simple, dumb, and therefore
> > maintainable solution.
> 
> How does the mechanism you're adding here differ from proc_pid()?

I'm sorry, I am missing the context around proc_pid()?. Are you talking
about the the proc_pid() function in "internal.h"? What exactly is the
proc_pid() mechanism?
