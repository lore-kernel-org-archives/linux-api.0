From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v18 1/3] proc: add /proc/<pid>/arch_status
Date: Thu, 23 May 2019 20:18:22 -0700
Message-ID: <20190523201822.cc554d68ec567164bec781e1@linux-foundation.org>
References: <20190425143219.102258-1-aubrey.li@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190425143219.102258-1-aubrey.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aubrey Li <aubrey.li@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org, hpa@zytor.com, ak@linux.intel.com, tim.c.chen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, adobriyan@gmail.com, aubrey.li@intel.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, 25 Apr 2019 22:32:17 +0800 Aubrey Li <aubrey.li@linux.intel.com> wrote:

> The architecture specific information of the running processes
> could be useful to the userland. Add /proc/<pid>/arch_status
> interface support to examine process architecture specific
> information externally.

I'll give this an

Acked-by: Andrew Morton <akpm@linux-foundation.org>

from a procfs POV and shall let the x86 maintainers worry about it.

I must say I'm a bit surprised that we don't already provide some form
of per-process CPU-specific info anywhere in procfs.  Something to
piggy-back this onto.  But I can't find such a thing.

I assume we've already discussed why this is a new procfs file rather
than merely a new line in /proc/<pid>/status.  If so, please add the
reasoning to the changelog.  If not, please discuss now ;)
