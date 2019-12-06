From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [RFC PATCH] ptrace: add PTRACE_GETFD request
Date: Fri, 6 Dec 2019 07:10:45 -0700
Message-ID: <20191206141045.GA22803@cisco>
References: <20191205234450.GA26369@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191205234450.GA26369@ircssh-2.c.rugged-nimbus-611.internal>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 05, 2019 at 11:44:53PM +0000, Sargun Dhillon wrote:
> PTRACE_GETFD is a generic ptrace API that allows the tracer to
> get file descriptors from the traceee.
> 
> The primary reason to use this syscall is to allow sandboxers to

I might change this to "one motivation to use this ptrace command",
because I'm sure people will invent other crazy uses soon after it's
added :)

> take action on an FD on behalf of the tracee. For example, this
> can be combined with seccomp's user notification feature to extract
> a file descriptor and call privileged syscalls, like binding
> a socket to a privileged port.

This can already be accomplished via injecting parasite code like CRIU
does; adding a ptrace() command like this makes it much nicer to be
sure, but it is redundant.

Tycho
