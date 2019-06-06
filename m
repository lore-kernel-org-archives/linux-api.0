From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v19 1/3] proc: add /proc/<pid>/arch_status
Date: Thu, 6 Jun 2019 14:34:00 -0700
Message-ID: <20190606143400.9f4a584eb1dc640fdf334114@linux-foundation.org>
References: <20190606012236.9391-1-aubrey.li@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190606012236.9391-1-aubrey.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aubrey Li <aubrey.li@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org, hpa@zytor.com, ak@linux.intel.com, tim.c.chen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, adobriyan@gmail.com, aubrey.li@intel.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu,  6 Jun 2019 09:22:34 +0800 Aubrey Li <aubrey.li@linux.intel.com> wrote:

> The architecture specific information of the running processes
> could be useful to the userland. Add /proc/<pid>/arch_status
> interface support to examine process architecture specific
> information externally.

I'll grab these for some testing.  I can merge them up if the x86
maintainers are OK with it all.  However I think it's best that these
be merged via an x86 tree, please.
