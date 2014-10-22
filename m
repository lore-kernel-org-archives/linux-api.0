From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH V2] kernel, add bug_on_warn
Date: Wed, 22 Oct 2014 14:57:12 +1030
Message-ID: <87bnp491b3.fsf@rustcorp.com.au>
References: <1413910077-9464-1-git-send-email-prarit@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1413910077-9464-1-git-send-email-prarit@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Fabian Frederick <fabf@skynet.be>, vgoyal@redhat.com, isimatu.yasuaki@jp.fujitsu.com, linux-doc@vger.kernel.org, kexec@lists.infradead.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Prarit Bhargava <prarit@redhat.com> writes:
> There have been several times where I have had to rebuild a kernel to
> cause a panic when hitting a WARN() in the code in order to get a crash
> dump from a system.  Sometimes this is easy to do, other times (such as
> in the case of a remote admin) it is not trivial to send new images to the
> user.
>
> A much easier method would be a switch to change the WARN() over to a
> BUG().  This makes debugging easier in that I can now test the actual
> image the WARN() was seen on and I do not have to engage in remote
> debugging.
>
> This patch adds a bug_on_warn kernel parameter, which calls BUG() in the
> warn_slowpath_common() path.  The function will still print out the
> location of the warning.
>
> An example of the bug_on_warn output:
>
> The first line below is from the WARN_ON() to output the WARN_ON()'s location.
> After that the new BUG() call is displayed.
>
>  WARNING: CPU: 27 PID: 3204 at
> /home/rhel7/redhat/debug/dummy-module/dummy-module.c:25 init_dummy+0x28/0x30
> [dummy_module]()
>  bug_on_warn set, calling BUG()...
>  ------------[ cut here ]------------
>  kernel BUG at kernel/panic.c:434!
>  invalid opcode: 0000 [#1] SMP
>  Modules linked in: dummy_module(OE+) sg nfsv3 rpcsec_gss_krb5 nfsv4
> dns_resolver nfs fscache cfg80211 rfkill x86_pkg_temp_thermal intel_powerclamp
> coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel
> ghash_clmulni_intel igb iTCO_wdt aesni_intel iTCO_vendor_support lrw gf128mul
> sb_edac ptp edac_core glue_helper lpc_ich ioatdma pcspkr ablk_helper pps_core
> i2c_i801 mfd_core cryptd dca shpchp ipmi_si wmi ipmi_msghandler acpi_cpufreq
> nfsd auth_rpcgss nfs_acl lockd grace sunrpc xfs libcrc32c sr_mod cdrom sd_mod
> mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper isci ttm
> drm libsas ahci libahci scsi_transport_sas libata i2c_core dm_mirror
> dm_region_hash dm_log dm_mod
>  CPU: 27 PID: 3204 Comm: insmod Tainted: G           OE  3.17.0+ #19
>  Hardware name: Intel Corporation S2600CP/S2600CP, BIOS
> RMLSDP.86I.00.29.D696.1311111329 11/11/2013
>  task: ffff880034e75160 ti: ffff8807fc5ac000 task.ti: ffff8807fc5ac000
>  RIP: 0010:[<ffffffff81076b81>]  [<ffffffff81076b81>] warn_slowpath_common+0xc1/0xd0
>  RSP: 0018:ffff8807fc5afc68  EFLAGS: 00010246
>  RAX: 0000000000000021 RBX: ffff8807fc5afcb0 RCX: 0000000000000000
>  RDX: 0000000000000000 RSI: ffff88081efee5f8 RDI: ffff88081efee5f8
>  RBP: ffff8807fc5afc98 R08: 0000000000000096 R09: 0000000000000000
>  R10: 0000000000000711 R11: ffff8807fc5af93e R12: ffffffffa0424070
>  R13: 0000000000000019 R14: ffffffffa0423068 R15: 0000000000000009
>  FS:  00007f2d4b034740(0000) GS:ffff88081efe0000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007f2d4a99f3c0 CR3: 00000007fd88b000 CR4: 00000000001407e0
>  Stack:
>   ffff8807fc5afcb8 ffffffff8199f020 ffff88080e396160 0000000000000000
>   ffffffffa0423040 ffffffffa0425000 ffff8807fc5afd08 ffffffff81076be5
>   0000000000000008 ffffffffa0424053 ffff880700000018 ffff8807fc5afd18
>  Call Trace:
>   [<ffffffffa0423040>] ? dummy_greetings+0x40/0x40 [dummy_module]
>   [<ffffffff81076be5>] warn_slowpath_fmt+0x55/0x70
>   [<ffffffffa0423068>] init_dummy+0x28/0x30 [dummy_module]
>   [<ffffffff81002144>] do_one_initcall+0xd4/0x210
>   [<ffffffff811b52c2>] ? __vunmap+0xc2/0x110
>   [<ffffffff810f8889>] load_module+0x16a9/0x1b30
>   [<ffffffff810f3d30>] ? store_uevent+0x70/0x70
>   [<ffffffff810f49b9>] ? copy_module_from_fd.isra.44+0x129/0x180
>   [<ffffffff810f8ec6>] SyS_finit_module+0xa6/0xd0
>   [<ffffffff8166ce29>] system_call_fastpath+0x12/0x17
>  Code: c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d c3 48 c7 c7 20 42 8a 81 31 c0 e8 fc
> 80 5e 00 eb 80 48 c7 c7 78 42 8a 81 31 c0 e8 ec 80 5e 00 <0f> 0b 66 66 66 66 2e
> 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55
>  RIP  [<ffffffff81076b81>] warn_slowpath_common+0xc1/0xd0
>   RSP <ffff8807fc5afc68>
>  ---[ end trace 428218934a12088b ]---
>
> Successfully tested by me.
>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Fabian Frederick <fabf@skynet.be>
> Cc: vgoyal@redhat.com
> Cc: isimatu.yasuaki@jp.fujitsu.com
> Cc: linux-doc@vger.kernel.org
> Cc: kexec@lists.infradead.org
> Cc: linux-api@vger.kernel.org
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>
> [v2]: add /proc/sys/kernel/bug_on_warn, additional documentation, modify
>       !slowpath cases
> ---
>  Documentation/kdump/kdump.txt       |    7 +++++++
>  Documentation/kernel-parameters.txt |    3 +++
>  Documentation/sysctl/kernel.txt     |   12 ++++++++++++
>  include/asm-generic/bug.h           |   12 ++++++++++--
>  include/linux/kernel.h              |    1 +
>  include/uapi/linux/sysctl.h         |    1 +
>  kernel/panic.c                      |   21 ++++++++++++++++++++-
>  kernel/sysctl.c                     |    7 +++++++
>  kernel/sysctl_binary.c              |    1 +
>  9 files changed, 62 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
> index 6c0b9f2..a04ed72 100644
> --- a/Documentation/kdump/kdump.txt
> +++ b/Documentation/kdump/kdump.txt
> @@ -471,6 +471,13 @@ format. Crash is available on Dave Anderson's site at the following URL:
>  
>     http://people.redhat.com/~anderson/
>  
> +Trigger Kdump on WARN()
> +=======================
> +
> +The kernel parameter, bug_on_warn, calls BUG() in all WARN() paths.  This
> +will cause a kdump to occur at the BUG() call.  In cases where a user
> +wants to specify this during runtime, /proc/sys/kernel/bug_on_warn can be
> +set to 1 to achieve the same behaviour.

What about during early boot?

I'd recommend you use core_param().  Less code, and can be set on
commandline.

Cheers,
Rusty.
