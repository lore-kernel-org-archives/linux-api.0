From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: Re: [OMPI devel] [PATCH v5 0/4] vm: add a syscall to map a process memory into a pipe
Date: Tue, 27 Feb 2018 09:10:20 +0200
Message-ID: <20180227071020.GA24633@rapoport-lnx>
References: <1515479453-14672-1-git-send-email-rppt@linux.vnet.ibm.com> <20180220164406.3ec34509376f16841dc66e34@linux-foundation.org> <3122ec5a-7f73-f6b4-33ea-8c10ef32e5b0@virtuozzo.com> <B9A6330F-48FE-4260-A505-3FF043874F0F@me.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <gdb-return-46337-gdb-gdb=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:gdb-unsubscribe-gdb-gdb=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:gdb-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/gdb/>
List-Post: <mailto:gdb@sourceware.org>
List-Help: <mailto:gdb-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: gdb-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <B9A6330F-48FE-4260-A505-3FF043874F0F@me.com>
To: Nathan Hjelm <hjelmn@me.com>
Cc: Open MPI Developers <devel@lists.open-mpi.org>, Andrei Vagin <avagin@openvz.org>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, rr-dev@mozilla.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>, criu@openvz.org, linux-mm@kvack.org, gdb@sourceware.org, Alexander Viro <viro@zeniv.linux.org.uk>, Greg KH <gregkh@linuxfoundation.org>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 26, 2018 at 09:38:19AM -0700, Nathan Hjelm wrote:
> All MPI implementations have support for using CMA to transfer data
> between local processes. The performance is fairly good (not as good as
> XPMEM) but the interface limits what we can do with to remote process
> memory (no atomics). I have not heard about this new proposal. What is
> the benefit of the proposed calls over the existing calls?

The proposed system call call that combines functionality of
process_vm_read and vmsplice [1] and it's particularly useful when one
needs to read the remote process memory and then write it to a file
descriptor. In this case a sequence of process_vm_read() + write() calls
that involves two copies of data can be replaced with process_vm_splice() +
splice() which does not involve copy at all.

[1] https://lkml.org/lkml/2018/1/9/32
 
> -Nathan
> 
> > On Feb 26, 2018, at 2:02 AM, Pavel Emelyanov <xemul@virtuozzo.com> wrote:
> > 
> > On 02/21/2018 03:44 AM, Andrew Morton wrote:
> >> On Tue,  9 Jan 2018 08:30:49 +0200 Mike Rapoport <rppt@linux.vnet.ibm.com> wrote:
> >> 
> >>> This patches introduces new process_vmsplice system call that combines
> >>> functionality of process_vm_read and vmsplice.
> >> 
> >> All seems fairly strightforward.  The big question is: do we know that
> >> people will actually use this, and get sufficient value from it to
> >> justify its addition?
> > 
> > Yes, that's what bothers us a lot too :) I've tried to start with finding out if anyone
> > used the sys_read/write_process_vm() calls, but failed :( Does anybody know how popular
> > these syscalls are? If its users operate on big amount of memory, they could benefit from
> > the proposed splice extension.
> > 
> > -- Pavel

-- 
Sincerely yours,
Mike.
