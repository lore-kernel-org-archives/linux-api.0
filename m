From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v17 3/3] Documentation/filesystems/proc.txt: add arch_status
 file
Date: Wed, 24 Apr 2019 23:27:02 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1904242320101.1762@nanos.tec.linutronix.de>
References: <20190421183529.9141-1-aubrey.li@linux.intel.com> <20190421183529.9141-3-aubrey.li@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190421183529.9141-3-aubrey.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aubrey Li <aubrey.li@linux.intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, hpa@zytor.com, ak@linux.intel.com, tim.c.chen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, adobriyan@gmail.com, akpm@linux-foundation.org, aubrey.li@intel.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, 22 Apr 2019, Aubrey Li wrote:
> +3.12 /proc/<pid>/arch_status - task architecture specific status
> +-------------------------------------------------------------------
> +When CONFIG_PROC_PID_ARCH_STATUS is enabled, this file displays the
> +architecture specific status of the task.
> +
> +Example
> +-------
> + $ cat /proc/6753/arch_status
> + AVX512_elapsed_ms:      8

Examples are nice, but as this is architecture specific this section needs
to list the entries which are exposed by a particular architecture.

x86 specific entries:
---------------------

  AVX512_elapsed_ms:
  ------------------
     If AVX512 is supported ....

Thanks,

	tglx
