From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 1/8] signal/alpha: Document a conflict with SI_USER for
	SIGTRAP
Date: Tue, 18 Jul 2017 08:37:36 -0500
Message-ID: <87fudthnmn.fsf@xmission.com>
References: <87efu22set.fsf@xmission.com>
	<20170630123906.8865-1-ebiederm@xmission.com>
	<20170702141320.GA32254@ls3530.fritz.box>
	<87fudz5lol.fsf@xmission.com> <20170717081438.rdbwspz25bn6oz7h@tower>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170717081438.rdbwspz25bn6oz7h@tower> (Michael Cree's message
	of "Mon, 17 Jul 2017 20:14:38 +1200")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Michael Cree <mcree-q3Ck4f9/EBK9koe0gwxAeg@public.gmane.org>
Cc: Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Helge Deller <deller-Mmb7MZpHnFY@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Turner <mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ivan Kokshaysky <ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Richard Henderson <rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-alpha-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Willy Tarreau <w@1wt.eu>
List-Id: linux-api@vger.kernel.org

Michael Cree <mcree-q3Ck4f9/EBK9koe0gwxAeg@public.gmane.org> writes:

> On Fri, Jul 14, 2017 at 05:59:06AM -0500, Eric W. Biederman wrote:
>> in which cases the oddities will happen let alone test them.  Plus at
>> least for ia64 and alpha those architectures don't appear to be
>> receiving updates for new syscalls, and no new hardware is being built
>> so I don't know how much longer they will last.
>> 
>> That is building for alpha gives:
>> >   CALL    /home/eric/projects/linux/linux-exit-cleanups/scripts/checksyscalls.sh
>> > <stdin>:1239:2: warning: #warning syscall seccomp not implemented [-Wcpp]
>> > <stdin>:1248:2: warning: #warning syscall bpf not implemented [-Wcpp]
>> > <stdin>:1299:2: warning: #warning syscall userfaultfd not implemented [-Wcpp]
>> > <stdin>:1302:2: warning: #warning syscall membarrier not implemented [-Wcpp]
>> > <stdin>:1305:2: warning: #warning syscall mlock2 not implemented [-Wcpp]
>> > <stdin>:1308:2: warning: #warning syscall copy_file_range not implemented [-Wcpp]
>> > <stdin>:1311:2: warning: #warning syscall preadv2 not implemented [-Wcpp]
>> > <stdin>:1314:2: warning: #warning syscall pwritev2 not implemented [-Wcpp]
>> > <stdin>:1317:2: warning: #warning syscall pkey_mprotect not implemented [-Wcpp]
>> > <stdin>:1320:2: warning: #warning syscall pkey_alloc not implemented [-Wcpp]
>> > <stdin>:1323:2: warning: #warning syscall pkey_free not implemented [-Wcpp]
>> > <stdin>:1326:2: warning: #warning syscall statx not implemented [-Wcpp]
>
> Patches to wire up most of those syscalls on Alpha was posted recently
> along with others to fix module loading, etc., but unfortunately they
> do not appear to have been applied during the merge window...

Odd.

In general wiring up system calls is something that can even happen in
-rc2 or -rc3 as system calls get added in -rc1 and then the
architectures have a chance to send in the small patches wiring the up.
At least that is how I understand the usual rules for being a non-x86
architecture.

Eric
