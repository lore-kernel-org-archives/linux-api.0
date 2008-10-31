From: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v8][PATCH 11/12] External checkpoint of a task other than
	ourself
Date: Thu, 30 Oct 2008 21:41:24 -0500
Message-ID: <20081031024124.GA7885@us.ibm.com>
References: <1225374675-22850-1-git-send-email-orenl@cs.columbia.edu> <1225374675-22850-12-git-send-email-orenl@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1225374675-22850-12-git-send-email-orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Cc: Linus Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Oren Laadan (orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org):
> Now we can do "external" checkpoint, i.e. act on another task.
> 
> sys_checkpoint() now looks up the target pid (in our namespace) and
> checkpoints that corresponding task. That task should be the root of
> a container.
> 
> sys_restart() remains the same, as the restart is always done in the
> context of the restarting task.
> 
> Signed-off-by: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>

Ok, I'm at a loss right now, and I'm not sure who to blame - Oren,
Daniel, Matt, or someone else.

In one terminal I do:

	lxc-execute -n nonet sleep 100

then in another terminal do
	
	lxc-checkpoint -s -n nonet > /tmp/o

or
	lxc-checkpoint -n nonet > /tmp/o
followed by ctrl-c in the lxc-execute terminal.

Without fail, the second time I do this (if not the first), I get
a BUG (see below).  It really does look like it should have
nothing to do with the c/r patches, but I can't reproduce this
any other way.  I've tried doing

	lxc-freeze -n nonet; lxc-unfreeze -n nonet; lxc-stop -n nonet

I've tried manually doing freeze, checkpoint, unfreeze of containers
hand-crafted to look like what lxc-execute creates (two tasks in private
namespaces with private /proc mount, kill container inits of populated
containers (bc it really looks like another task-exit-vs-container-cleanup
race).

I can't find any other way to reproduce this.

(This is using Oren's patchset with freezer on top, and using
a freshly pulled liblxc from cvs)

-serge

login: ------------[ cut here ]------------
kernel BUG at fs/dcache.c:666!
invalid opcode: 0000 [#1] SMP
Modules linked in:

Pid: 2963, comm: [vinit] Not tainted (2.6.27-rc9-00020-g2265283-dirty #344)
EIP: 0060:[<c0188b5a>] EFLAGS: 00010292 CPU: 1
EIP is at shrink_dcache_for_umount_subtree+0x14b/0x1fe
EAX: 0000004e EBX: c04d22a7 ECX: 00000001 EDX: de6b5160
ESI: df4040a0 EDI: ffffffff EBP: de779d7c ESP: de779d4c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process [vinit] (pid: 2963, ti=de778000 task=de6b5160 task.ti=de778000)
Stack: c04d1eb2 df4040a0 00000001 df404118 ffffffff c04d22a7 df830698 df404118
       00000004 df830400 c041e788 00000020 de779d88 c0188c3a df830400 de779d98
       c017b521 00000001 c054faf0 de779da4 c017b60b df830400 de779db0 c017b64d
Call Trace:
 [<c0188c3a>] ? shrink_dcache_for_umount+0x2d/0x3a
 [<c017b521>] ? generic_shutdown_super+0x15/0xd3
 [<c017b60b>] ? kill_anon_super+0xc/0x35
 [<c017b64d>] ? kill_litter_super+0x19/0x1c
 [<c017b6a3>] ? deactivate_super+0x53/0x6b
 [<c018d422>] ? mntput_no_expire+0xc3/0xe7
 [<c018d4b1>] ? release_mounts+0x6b/0x7a
 [<c018d522>] ? __put_mnt_ns+0x62/0x70
 [<c0134cad>] ? free_nsproxy+0x25/0x80
 [<c0134d4c>] ? switch_task_namespaces+0x44/0x49
 [<c0134d5b>] ? exit_task_namespaces+0xa/0xc
 [<c012403a>] ? do_exit+0x55f/0x6c9
 [<c0124202>] ? do_group_exit+0x5e/0x85
 [<c012c243>] ? get_signal_to_deliver+0x2ea/0x303
 [<c010232c>] ? do_notify_resume+0x6b/0x715
 [<c013bcfe>] ? lock_release_holdtime+0x1a/0x153
 [<c013da7e>] ? trace_hardirqs_on+0xb/0xd
 [<c013da7e>] ? trace_hardirqs_on+0xb/0xd
 [<c0131aa5>] ? remove_wait_queue+0x30/0x34
 [<c0123903>] ? do_wait+0x1d6/0x284
 [<c0152ecb>] ? audit_syscall_exit+0x2b1/0x2cc
 [<c013da52>] ? trace_hardirqs_on_caller+0xe1/0x102
 [<c01031a6>] ? work_notifysig+0x13/0x19
 =======================
Code: 1c 8b 18 8b 46 40 89 45 ec 8b 46 28 85 c0 74 03 8b 50 20 8d 81 98 02 00 00 50 53 57 ff 75 ec 52 56 68 b2 1e 4d c0 e8 9a 04 28 00 <0f> 0b 83 c4 1c eb fe 8b 7e 34 39 f7 75 04 31 ff eb 03 f0 ff 0f
EIP: [<c0188b5a>] shrink_dcache_for_umount_subtree+0x14b/0x1fe SS:ESP 0068:de779d4c
---[ end trace 218551429ab07a44 ]---
Fixing recursive fault but reboot is needed!

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
