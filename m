From: Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user
 mappings
Date: Tue, 29 Oct 2019 10:01:58 +0100
Message-ID: <20191029090158.GB18773@rapoport-lnx>
References: <1572171452-7958-1-git-send-email-rppt@kernel.org>
 <87d0eieb0i.fsf@mid.deneb.enyo.de>
 <385EB6D4-A1B0-4617-B256-181AA1C3BDE3@kernel.org>
 <87h83s62mi.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87h83s62mi.fsf@mid.deneb.enyo.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fw@deneb.enyo.de>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, James Bottomley <jejb@linux.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-api@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org, Mike Rapoport <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 28, 2019 at 09:23:17PM +0100, Florian Weimer wrote:
> * Mike Rapoport:
> 
> > On October 27, 2019 12:30:21 PM GMT+02:00, Florian Weimer
> > <fw@deneb.enyo.de> wrote:
> >>* Mike Rapoport:
> >>
> >>> The patch below aims to allow applications to create mappins that
> >>have
> >>> pages visible only to the owning process. Such mappings could be used
> >>to
> >>> store secrets so that these secrets are not visible neither to other
> >>> processes nor to the kernel.
> >>
> >>How is this expected to interact with CRIU?
> >
> > CRIU dumps the memory contents using a parasite code from inside the
> > dumpee address space, so it would work the same way as for the other
> > mappings. Of course, at the restore time the exclusive mapping should
> > be recreated with the appropriate flags.
> 
> Hmm, so it would use a bounce buffer to perform the extraction?

At first I thought that CRIU would extract the memory contents from these
mappings just as it does now using vmsplice(). But it seems that such
mappings won't play well with pipes, so CRIU will need a bounce buffer
indeed.
 
> >>> I've only tested the basic functionality, the changes should be
> >>verified
> >>> against THP/migration/compaction. Yet, I'd appreciate early feedback.
> >>
> >>What are the expected semantics for VM migration?  Should it fail?
> >
> > I don't quite follow. If qemu would use such mappings it would be able
> > to transfer them during live migration.
> 
> I was wondering if the special state is supposed to bubble up to the
> host eventually.

Well, that was not intended.

-- 
Sincerely yours,
Mike.
