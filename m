From: Jann Horn <jannh@google.com>
Subject: Re: [RFC PATCH] ptrace: add PTRACE_GETFD request
Date: Fri, 6 Dec 2019 20:05:28 +0100
Message-ID: <CAG48ez23UZYRytSNYd74pZuCXPXtOQjZeixP18CL0XZEz-NP0w@mail.gmail.com>
References: <20191205234450.GA26369@ircssh-2.c.rugged-nimbus-611.internal>
 <20191206141045.GA22803@cisco> <CAMp4zn-Ni-nHrQgn34jV6gzanTiF+wxPrr_zqM47McZQ8TKa5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMp4zn-Ni-nHrQgn34jV6gzanTiF+wxPrr_zqM47McZQ8TKa5w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: Tycho Andersen <tycho@tycho.ws>, LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 6, 2019 at 8:03 PM Sargun Dhillon <sargun@sargun.me> wrote:
> On Fri, Dec 6, 2019 at 6:10 AM Tycho Andersen <tycho@tycho.ws> wrote:
> > On Thu, Dec 05, 2019 at 11:44:53PM +0000, Sargun Dhillon wrote:
> > > take action on an FD on behalf of the tracee. For example, this
> > > can be combined with seccomp's user notification feature to extract
> > > a file descriptor and call privileged syscalls, like binding
> > > a socket to a privileged port.
> >
> > This can already be accomplished via injecting parasite code like CRIU
> > does; adding a ptrace() command like this makes it much nicer to be
> > sure, but it is redundant.
> >
> How can you do this if the tracee doesn't have privilege? For example,
> if the tracee doesn't have CAP_SYS_BIND_SERVICE, how could you
> get it to bind to a port that's privileged without taking the file descriptor
> and doing it in a process that does have CAP_SYS_BIND_SERVICE?

(You can let the parasite send the fd to the tracer via
SCM_CREDENTIALS if you have previously set up a unix domain socket for
this.)
