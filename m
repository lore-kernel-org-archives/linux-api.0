From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: tracefs splats in lockdown=confidentiality mode
Date: Fri, 1 Nov 2019 18:15:01 -0400
Message-ID: <20191101181501.4beff81b@grimm.local.home>
References: <20191101210803.GA9841@xps13.dannf>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191101210803.GA9841@xps13.dannf>
Sender: linux-kernel-owner@vger.kernel.org
To: dann frazier <dann.frazier@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>, Matthew Garrett <matthewgarrett@google.com>, James Morris <jmorris@namei.org>, Linux API <linux-api@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Fri, 1 Nov 2019 15:08:03 -0600
dann frazier <dann.frazier@canonical.com> wrote:

> hey,
>   fyi, I'm seeing a bunch of errors from tracefs when booting 5.4-rc5 in
> lockdown=confidentiality mode:
> 
> [    1.763630] Lockdown: swapper/0: use of tracefs is restricted; see man kernel_lockdown.7
> [    1.772332] Could not create tracefs 'available_events' entry
> [    1.778633] Lockdown: swapper/0: use of tracefs is restricted; see man kernel_lockdown.7
> [    1.787095] Could not create tracefs 'set_event' entry
> [    1.792412] Lockdown: swapper/0: use of tracefs is restricted; see man kernel_lockdown.7
> (...)
> [    2.899481] Could not create tracefs 'set_graph_notrace' entry
> [    2.905671] Lockdown: swapper/0: use of tracefs is restricted; see man kernel_lockdown.7
> [    2.913934] ------------[ cut here ]------------
> [    2.918435] Could not register function stat for cpu 0
> [    2.923717] WARNING: CPU: 1 PID: 1 at kernel/trace/ftrace.c:987 ftrace_init_tracefs_toplevel+0x168/0x1bc
> [    2.933939] Modules linked in:
> [    2.937290] CPU: 1 PID: 1 Comm: 

Looks to me that it's working as designed ;-)

I'm guessing we could quiet these warnings for boot up though. :-/

But there should be at least one message that states that the tracefs
files are not being created due to lockdown.

-- Steve
