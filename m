From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: tracefs splats in lockdown=confidentiality mode
Date: Mon, 2 Dec 2019 18:54:26 -0500
Message-ID: <20191202185426.432ca21b@gandalf.local.home>
References: <20191101210803.GA9841@xps13.dannf>
        <CACdnJuuXBQ__Sb8=V7CTZfXH=5LfbiU9SmUKapJov3Cd+aHQcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJuuXBQ__Sb8=V7CTZfXH=5LfbiU9SmUKapJov3Cd+aHQcw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: dann frazier <dann.frazier@canonical.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Seth Forshee <seth.forshee@canonical.com>, James Morris <jmorris@namei.org>, Linux API <linux-api@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Mon, 2 Dec 2019 15:31:52 -0800
Matthew Garrett <mjg59@google.com> wrote:

> On Fri, Nov 1, 2019 at 2:08 PM dann frazier <dann.frazier@canonical.com> wrote:
> 
> > [    1.763630] Lockdown: swapper/0: use of tracefs is restricted; see man kernel_lockdown.7  
> 
> This is expected.
> 
> > [    2.913934] ------------[ cut here ]------------
> > [    2.918435] Could not register function stat for cpu 0
> > [    2.923717] WARNING: CPU: 1 PID: 1 at kernel/trace/ftrace.c:987 ftrace_init_tracefs_toplevel+0x168/0x1bc  
> 
> This is not. I'll look into it.

I think it has to do with ftrace triggering WARN_ON() if it fails to
create files. We don't want this to happen if it fails because of
lockdown.

I'm already looking into it.

Thanks!

-- Steve
