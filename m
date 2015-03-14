From: Thiago Macieira <thiago.macieira@intel.com>
Subject: Re: [PATCH 0/6] CLONE_FD: Task exit notification via file descriptor
Date: Sat, 14 Mar 2015 12:03:12 -0700
Message-ID: <2279556.Wl6mCVq5Zi@tjmaciei-mobl4>
References: <CAHse=S9hnGm=Z8FR4f+z_TFwnrjBLkcV4wVwjDYgKuOSemdVrA@mail.gmail.com> <CALCETrWwkdWkNCsrcSAn+7f9SJCuYA-TV9=AygWMhXCC9Njp9Q@mail.gmail.com> <4467745.tgv2QnPHiH@tjmaciei-mobl4>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4467745.tgv2QnPHiH@tjmaciei-mobl4>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Josh Triplett <josh@joshtriplett.org>, David Drysdale <drysdale@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Friday 13 March 2015 18:11:32 Thiago Macieira wrote:
> On Friday 13 March 2015 14:51:47 Andy Lutomirski wrote:
> > In any event, we should find out what FreeBSD does in response to
> > read(2) on the fd.
> 
> I've just successfully installed FreeBSD and compiled qtbase (main package
> of Qt 5) on it.
> 
> I'll test pdfork during the weekend and report its behaviour.

Here are my findings about pdfork.

Source: http://fxr.watson.org/fxr/source/kern/sys_procdesc.c?v=FREEBSD10
Qt adaptations: https://codereview.qt-project.org/108561

Processes created with pdfork() are normal processes that still send SIGCHLD 
to their parents. The only difference is that you get the extra file descriptor 
that can be passed to the pdgetpid() system call and works on select()/poll(). 
Trying to read from that file descriptor will result in EOPNOTSUPP.

Since they've never implemented pdwait4() (it's not even declared in the 
headers), the only way to reap a child if you only have the file descriptor is 
to first pdgetpid() and then call wait4() or wait6().

If you don't pass PD_DAEMON, the child process gets killed with SIGKILL when 
the file closes.

Conclusion: 
Pros: this is the bare minimum that we'd need to disentangle the SIGCHLD mess. 
As long as all child process activations use this feature, the problem is 
solved.

Cons: it requires cooperation from all child starters. If some other library 
or the application installs a global SIGCHLD handler that waits on all child 
processes, like libvlc used to do and Glib and Ecore still do, you won't be 
able to get the child exit status.

I have not tested what happens if you try to pass the file descriptor to other 
processes (can you even do that on FreeBSD?). But even if you could and got 
notifications, you couldn't wait on the child to get its exit status -- unless 
they implement pdwait4.

 - pdfork: can be emulated with clone4 + CLONE_FD (+ CLONEFD_KILL_ON_CLOSE)
 - pdwait4: can be emulated with read()
 - pdgetpid: needs an ioctl
 - pdkill: needs an ioctl [or just write()]

-- 
Thiago Macieira - thiago.macieira (AT) intel.com
  Software Architect - Intel Open Source Technology Center
