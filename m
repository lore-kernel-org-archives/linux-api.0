From: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2 0/2] mm,fork,security: introduce MADV_WIPEONFORK
Date: Wed, 09 Aug 2017 08:31:07 -0400
Message-ID: <1502281867.6577.35.camel@redhat.com>
References: <20170806140425.20937-1-riel@redhat.com>
	 <20170807132257.GH32434@dhcp22.suse.cz>
	 <20170807134648.GI32434@dhcp22.suse.cz>
	 <1502117991.6577.13.camel@redhat.com>
	 <20170809095957.kv47or2w4obaipkn@node.shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170809095957.kv47or2w4obaipkn@node.shutemov.name>
Sender: owner-linux-mm@kvack.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org, mike.kravetz@oracle.com, linux-mm@kvack.org, fweimer@redhat.com, colm@allcosts.net, akpm@linux-foundation.org, keescook@chromium.org, luto@amacapital.net, wad@chromium.org, mingo@kernel.org, dave.hansen@intel.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 2017-08-09 at 12:59 +0300, Kirill A. Shutemov wrote:
> On Mon, Aug 07, 2017 at 10:59:51AM -0400, Rik van Riel wrote:
> > On Mon, 2017-08-07 at 15:46 +0200, Michal Hocko wrote:
> > > On Mon 07-08-17 15:22:57, Michal Hocko wrote:
> > > > This is an user visible API so make sure you CC linux-api
> > > > (added)
> > > > 
> > > > On Sun 06-08-17 10:04:23, Rik van Riel wrote:
> > > > > 
> > > > > A further complication is the proliferation of clone flags,
> > > > > programs bypassing glibc's functions to call clone directly,
> > > > > and programs calling unshare, causing the glibc
> > > > > pthread_atfork
> > > > > hook to not get called.
> > > > > 
> > > > > It would be better to have the kernel take care of this
> > > > > automatically.
> > > > > 
> > > > > This is similar to the OpenBSD minherit syscall with
> > > > > MAP_INHERIT_ZERO:
> > > > > 
> > > > >     https://man.openbsd.org/minherit.2
> > > 
> > > I would argue that a MAP_$FOO flag would be more appropriate. Or
> > > do
> > > you
> > > see any cases where such a special mapping would need to change
> > > the
> > > semantic and inherit the content over the fork again?
> > > 
> > > I do not like the madvise because it is an advise and as such it
> > > can
> > > be
> > > ignored/not implemented and that shouldn't have any correctness
> > > effects
> > > on the child process.
> > 
> > Too late for that. VM_DONTFORK is already implemented
> > through MADV_DONTFORK & MADV_DOFORK, in a way that is
> > very similar to the MADV_WIPEONFORK from these patches.
> 
> It's not obvious to me what would break if kernel would ignore
> MADV_DONTFORK or MADV_DONTDUMP.
> 
You might end up with multiple processes having a device open
which can only handle one process at a time.

Another thing that could go wrong is that if overcommit_memory=2,
a very large process with MADV_DONTFORK on a large memory area
suddenly fails to fork (due to there not being enough available
memory), and is unable to start a helper process.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
