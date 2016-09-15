From: Kyle Huey <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3] arch_prctl,x86 Add ARCH_[GET|SET]_CPUID for controlling the CPUID instruction
Date: Thu, 15 Sep 2016 16:33:21 -0700
Message-ID: <20160915233324.6060-1-khuey@kylehuey.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert O'Callahan <robert-7ok7fSEJICeEi8DpZVb4nw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

rr (http://rr-project.org/), a userspace record-and-replay reverse-
execution debugger, would like to trap and emulate the CPUID instruction.
This would allow us to a) mask away certain hardware features that rr does
not support (e.g. RDRAND) and b) enable trace portability across machines
by providing constant results.

The following changes have been	made since v2.

Patch 1:
- Use of compat_sys_arch_prctl and separate do_arch_prctl_[common|64]
  functions to separate generic and 64-bit only arch_prctls.

Patch 2:
- The hack to suppress the mistakenly advertised CPUID faulting support in
  Xen guests is removed. Doing this for both PV and HVM guests is quite
  tricky, and likely more trouble than it's worth. Instead I'll submit a
  patch to Xen.

Patch 3:
- TIF_NOCPUID is now droppped on exec. I added the arch_post_exec hook
  as I didn't see any existing place to run arch-specific code during
  exec. The test is updated for the new exec behavior.
