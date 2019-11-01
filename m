From: dann frazier <dann.frazier@canonical.com>
Subject: tracefs splats in lockdown=confidentiality mode
Date: Fri, 1 Nov 2019 15:08:03 -0600
Message-ID: <20191101210803.GA9841@xps13.dannf>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>, Matthew Garrett <matthewgarrett@google.com>, James Morris <jmorris@namei.org>, Linux API <linux-api@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

hey,
  fyi, I'm seeing a bunch of errors from tracefs when booting 5.4-rc5 in
lockdown=confidentiality mode:

[    1.763630] Lockdown: swapper/0: use of tracefs is restricted; see man kernel_lockdown.7
[    1.772332] Could not create tracefs 'available_events' entry
[    1.778633] Lockdown: swapper/0: use of tracefs is restricted; see man kernel_lockdown.7
[    1.787095] Could not create tracefs 'set_event' entry
[    1.792412] Lockdown: swapper/0: use of tracefs is restricted; see man kernel_lockdown.7
(...)
[    2.899481] Could not create tracefs 'set_graph_notrace' entry
[    2.905671] Lockdown: swapper/0: use of tracefs is restricted; see man kernel_lockdown.7
[    2.913934] ------------[ cut here ]------------
[    2.918435] Could not register function stat for cpu 0
[    2.923717] WARNING: CPU: 1 PID: 1 at kernel/trace/ftrace.c:987 ftrace_init_tracefs_toplevel+0x168/0x1bc
[    2.933939] Modules linked in:
[    2.937290] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.4.0-050400rc5-generic #201910271430
[    2.946528] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
[    2.954088] pstate: 60400005 (nZCv daif +PAN -UAO)
[    2.959359] pc : ftrace_init_tracefs_toplevel+0x168/0x1bc
[    2.965262] lr : ftrace_init_tracefs_toplevel+0x168/0x1bc
[    2.971192] sp : ffff80001002bd40
[    2.974852] x29: ffff80001002bd40 x28: 0000000000000000 
[    2.980680] x27: 0000000000000000 x26: ffff8000119f9358 
[    2.986552] x25: ffff8000119f9580 x24: ffff00007fb77200 
[    2.992359] x23: ffff00007c873e80 x22: ffff80001153d200 
[    2.998201] x21: ffff800010d8ad08 x20: 0000000000000000 
[    3.004007] x19: 0000000000000000 x18: 0000000000000010 
[    3.009851] x17: 0000000000000007 x16: 000000000000000e 
[    3.015674] x15: ffff00007d1213e8 x14: ffffffffffffffff 
[    3.021526] x13: ffff80009002ba47 x12: ffff80001002ba4f 
[    3.027338] x11: ffff800011a1e000 x10: 0000000000000000 
[    3.033148] x9 : ffff800011c13000 x8 : 000000000000015d 
[    3.038984] x7 : 0000000000000017 x6 : ffff800011c129c9 
[    3.044783] x5 : 0000000000000007 x4 : 0000000000000000 
[    3.050617] x3 : 0000000000000000 x2 : 00000000ffffffff 
[    3.056430] x1 : bcf0a68bd924d700 x0 : 0000000000000000 
[    3.062258] Call trace:
[    3.064951]  ftrace_init_tracefs_toplevel+0x168/0x1bc
[    3.070571]  tracer_init_tracefs+0xc0/0x1fc
[    3.075165]  do_one_initcall+0x50/0x220
[    3.079384]  kernel_init_freeable+0x1ec/0x2b0
[    3.084186]  kernel_init+0x18/0x108
[    3.088032]  ret_from_fork+0x10/0x18
[    3.091983] ---[ end trace 32f7e54339335d2a ]---
[    3.097149] Lockdown: swapper/0: use of tracefs is restricted; see man kernel_lockdown.7
[    3.105311] Could not create tracefs 'tracing_thresh' entry
[    3.110762] Lockdown: swapper/0: use of tracefs is restricted; see man kernel_lockdown.7
[    3.119199] Could not create tracefs 'README' entry
[    3.124212] Lockdown: swapper/0: use of tracefs is restricted; see man kernel_lockdown.7
[    3.132920] Could not create tracefs 'saved_cmdlines' entry
[    3.139075] Lockdown: swapper/0: use of tracefs is restricted; see man kernel_lockdown.7
[    3.147592] Could not create tracefs 'saved_cmdlines_size' entry
[    3.153950] Lockdown: swapper/0: use of tracefs is restricted; see man kernel_lockdown.7
[    3.162288] Could not create tracefs 'saved_tgids' entry
[    3.206061] Lockdown: swapper/0: use of tracefs is restricted; see man kernel_lockdown.7
[    3.214629] Could not create tracefs 'dyn_ftrace_total_info' entry
[    3.221063] Lockdown: swapper/0: use of tracefs is restricted; see man kernel_lockdown.7
[    3.229245] Could not create tracefs 'funcgraph-overrun' entry
[    3.234990] ------------[ cut here ]------------
[    3.239724] Failed to create trace option: funcgraph-overrun
[    3.239774] WARNING: CPU: 1 PID: 1 at kernel/trace/trace.c:8106 create_trace_option_files+0x200/0x230
[    3.255931] Modules linked in:
[    3.259332] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W         5.4.0-050400rc5-generic #201910271430
[    3.270051] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
[    3.277621] pstate: 60400005 (nZCv daif +PAN -UAO)
[    3.282902] pc : create_trace_option_files+0x200/0x230
[    3.288564] lr : create_trace_option_files+0x200/0x230
[    3.294247] sp : ffff80001002bd10
[    3.297914] x29: ffff80001002bd10 x28: ffff800011a34508 
[    3.303769] x27: ffff00007cb12e00 x26: ffff800011bb243d 
[    3.309638] x25: ffff800010d8b750 x24: ffff00007cb12e00 
[    3.315485] x23: 0000000000000000 x22: ffff800011a34508 
[    3.321327] x21: ffff800011a344d0 x20: 0000000000000000 
[    3.327284] x19: ffff800011a320b8 x18: 0000000000000010 
[    3.333121] x17: 0000000000000007 x16: 000000000000000e 
[    3.338980] x15: ffff00007d1213e8 x14: ffffffffffffffff 
[    3.344827] x13: ffff80009002b9a7 x12: ffff80001002b9af 
[    3.350690] x11: ffff800011a1e000 x10: 0000000000000000 
[    3.356524] x9 : 00000000fffffffe x8 : 6870617267636e75 
[    3.362394] x7 : 66203a6e6f697470 x6 : ffff800011c12498 
[    3.368229] x5 : 0000000000000030 x4 : 0000000000000000 
[    3.374082] x3 : 0000000000000000 x2 : 00000000ffffffff 
[    3.379915] x1 : bcf0a68bd924d700 x0 : 0000000000000000 
[    3.385768] Call trace:
[    3.388478]  create_trace_option_files+0x200/0x230
[    3.393849]  __update_tracer_options+0x34/0x48
[    3.398748]  tracer_init_tracefs+0x1e0/0x1fc
[    3.403454]  do_one_initcall+0x50/0x220
[    3.407692]  kernel_init_freeable+0x1ec/0x2b0
[    3.412494]  kernel_init+0x18/0x108
[    3.416351]  ret_from_fork+0x10/0x18
[    3.420287] ---[ end trace 32f7e54339335d2b ]---
[    3.425479] Lockdown: swapper/0: use of tracefs is restricted; see man kernel_lockdown.7
[    3.433724] Could not create tracefs 'funcgraph-cpu' entry
(...)
[    3.692698] Could not create tracefs 'uprobe_events' entry
[    3.698724] Lockdown: swapper/0: use of tracefs is restricted; see man kernel_lockdown.7
[    3.707217] Could not create tracefs 'uprobe_profile' entry


 -dann
