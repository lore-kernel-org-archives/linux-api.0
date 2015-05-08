From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v4 0/3] idle memory tracking
Date: Fri, 8 May 2015 16:22:42 +0300
Message-ID: <20150508132242.GQ31732@esperanza>
References: <cover.1431002699.git.vdavydov@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1431002699.git.vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, May 07, 2015 at 05:09:39PM +0300, Vladimir Davydov wrote:
> ---- SCRIPT FOR COUNTING IDLE PAGES PER CGROUP ----

Oops, this script is stale. The correct one is here:
---
#! /usr/bin/python
#

import os
import stat
import errno
import struct

CGROUP_MOUNT = "/sys/fs/cgroup/memory"
BUFSIZE = 8 * 1024  # must be multiple of 8


def set_idle():
    f = open("/proc/kpageidle", "wb", BUFSIZE)
    while True:
        try:
            f.write(struct.pack("Q", pow(2, 64) - 1))
        except IOError as err:
            if err.errno == errno.ENXIO:
                break
            raise
    f.close()


def count_idle():
    f_flags = open("/proc/kpageflags", "rb", BUFSIZE)
    f_cgroup = open("/proc/kpagecgroup", "rb", BUFSIZE)
    f_idle = open("/proc/kpageidle", "rb", BUFSIZE)

    pfn = 0
    nr_idle = {}
    while True:
        s = f_flags.read(8)
        if not s:
            break

        flags, = struct.unpack('Q', s)
        cgino, = struct.unpack('Q', f_cgroup.read(8))

        bit = pfn % 64
        if not bit:
            idle_bitmap, = struct.unpack('Q', f_idle.read(8))

        idle = idle_bitmap >> bit & 1
        pfn += 1

        unevictable = flags >> 18 & 1
        huge = flags >> 22 & 1

        if idle and not unevictable:
            nr_idle[cgino] = nr_idle.get(cgino, 0) + (512 if huge else 1)

    f_flags.close()
    f_cgroup.close()
    f_idle.close()
    return nr_idle


print "Setting the idle flag for each page..."
set_idle()

raw_input("Wait until the workload accesses its working set, then press Enter")

print "Counting idle pages..."
nr_idle = count_idle()

for dir, subdirs, files in os.walk(CGROUP_MOUNT):
    ino = os.stat(dir)[stat.ST_INO]
    print dir + ": " + str(nr_idle.get(ino, 0) * 4) + " KB"
