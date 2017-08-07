From: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2 0/2] mm,fork,security: introduce MADV_WIPEONFORK
Date: Mon, 07 Aug 2017 10:59:51 -0400
Message-ID: <1502117991.6577.13.camel@redhat.com>
References: <20170806140425.20937-1-riel@redhat.com>
	 <20170807132257.GH32434@dhcp22.suse.cz>
	 <20170807134648.GI32434@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170807134648.GI32434@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-kernel@vger.kernel.org, mike.kravetz@oracle.com, linux-mm@kvack.org, fweimer@redhat.com, colm@allcosts.net, akpm@linux-foundation.org, keescook@chromium.org, luto@amacapital.net, wad@chromium.org, mingo@kernel.org, kirill@shutemov.name, dave.hansen@intel.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 2017-08-07 at 15:46 +0200, Michal Hocko wrote:
> On Mon 07-08-17 15:22:57, Michal Hocko wrote:
> > This is an user visible API so make sure you CC linux-api (added)
> > 
> > On Sun 06-08-17 10:04:23, Rik van Riel wrote:
> > > 
> > > A further complication is the proliferation of clone flags,
> > > programs bypassing glibc's functions to call clone directly,
> > > and programs calling unshare, causing the glibc pthread_atfork
> > > hook to not get called.
> > > 
> > > It would be better to have the kernel take care of this
> > > automatically.
> > > 
> > > This is similar to the OpenBSD minherit syscall with
> > > MAP_INHERIT_ZERO:
> > > 
> > >     https://man.openbsd.org/minherit.2
> 
> I would argue that a MAP_$FOO flag would be more appropriate. Or do
> you
> see any cases where such a special mapping would need to change the
> semantic and inherit the content over the fork again?
> 
> I do not like the madvise because it is an advise and as such it can
> be
> ignored/not implemented and that shouldn't have any correctness
> effects
> on the child process.

Too late for that. VM_DONTFORK is already implemented
through MADV_DONTFORK & MADV_DOFORK, in a way that is
very similar to the MADV_WIPEONFORK from these patches.

I wonder if that was done because MAP_* flags are a
bitmap, with a very limited number of values as a result,
while MADV_* constants have an essentially unlimited
numerical namespace available.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
