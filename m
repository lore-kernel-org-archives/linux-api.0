From: Matthew Garrett <mjg59@google.com>
Subject: Re: tracefs splats in lockdown=confidentiality mode
Date: Mon, 2 Dec 2019 15:31:52 -0800
Message-ID: <CACdnJuuXBQ__Sb8=V7CTZfXH=5LfbiU9SmUKapJov3Cd+aHQcw@mail.gmail.com>
References: <20191101210803.GA9841@xps13.dannf>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191101210803.GA9841@xps13.dannf>
Sender: linux-kernel-owner@vger.kernel.org
To: dann frazier <dann.frazier@canonical.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Seth Forshee <seth.forshee@canonical.com>, James Morris <jmorris@namei.org>, Linux API <linux-api@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 1, 2019 at 2:08 PM dann frazier <dann.frazier@canonical.com> wrote:

> [    1.763630] Lockdown: swapper/0: use of tracefs is restricted; see man kernel_lockdown.7

This is expected.

> [    2.913934] ------------[ cut here ]------------
> [    2.918435] Could not register function stat for cpu 0
> [    2.923717] WARNING: CPU: 1 PID: 1 at kernel/trace/ftrace.c:987 ftrace_init_tracefs_toplevel+0x168/0x1bc

This is not. I'll look into it.
