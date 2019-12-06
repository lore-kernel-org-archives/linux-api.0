From: Sargun Dhillon <sargun@sargun.me>
Subject: Re: [RFC PATCH] ptrace: add PTRACE_GETFD request
Date: Fri, 6 Dec 2019 11:03:08 -0800
Message-ID: <CAMp4zn-Ni-nHrQgn34jV6gzanTiF+wxPrr_zqM47McZQ8TKa5w@mail.gmail.com>
References: <20191205234450.GA26369@ircssh-2.c.rugged-nimbus-611.internal> <20191206141045.GA22803@cisco>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191206141045.GA22803@cisco>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 6, 2019 at 6:10 AM Tycho Andersen <tycho@tycho.ws> wrote:
>
> On Thu, Dec 05, 2019 at 11:44:53PM +0000, Sargun Dhillon wrote:
> > PTRACE_GETFD is a generic ptrace API that allows the tracer to
> > get file descriptors from the traceee.
> >
> > The primary reason to use this syscall is to allow sandboxers to
>
> I might change this to "one motivation to use this ptrace command",
> because I'm sure people will invent other crazy uses soon after it's
> added :)
>
Another use-case that's come up has been transparent proxy for
service meshes. Rather than doing intercept at L4 (iptables), or
DNS, just rewriting the connect is nicer. A side benefit is that
getpeername still works.

> > take action on an FD on behalf of the tracee. For example, this
> > can be combined with seccomp's user notification feature to extract
> > a file descriptor and call privileged syscalls, like binding
> > a socket to a privileged port.
>
> This can already be accomplished via injecting parasite code like CRIU
> does; adding a ptrace() command like this makes it much nicer to be
> sure, but it is redundant.
>
> Tycho
How can you do this if the tracee doesn't have privilege? For example,
if the tracee doesn't have CAP_SYS_BIND_SERVICE, how could you
get it to bind to a port that's privileged without taking the file descriptor
and doing it in a process that does have CAP_SYS_BIND_SERVICE?

The other aspect is that doing the parasitic code thing is kind of slow,
in that it requires quite a few operations.
