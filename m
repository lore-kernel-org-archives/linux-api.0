From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND PATCH 0/3] Allow user to request memory to be locked on
 page fault
Date: Mon, 1 Jun 2015 15:27:46 -0700
Message-ID: <20150601152746.abbbbb9d479c0e2dbdec2aaf@linux-foundation.org>
References: <1432908808-31150-1-git-send-email-emunson@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <1432908808-31150-1-git-send-email-emunson@akamai.com>
Sender: linux-parisc-owner@vger.kernel.org
To: Eric B Munson <emunson@akamai.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, Michal Hocko <mhocko@suse.cz>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 29 May 2015 10:13:25 -0400 Eric B Munson <emunson@akamai.com> wrote:

> mlock() allows a user to control page out of program memory, but this
> comes at the cost of faulting in the entire mapping when it is
> allocated.  For large mappings where the entire area is not necessary
> this is not ideal.
> 
> This series introduces new flags for mmap() and mlockall() that allow a
> user to specify that the covered are should not be paged out, but only
> after the memory has been used the first time.

I almost applied these, but the naming issue (below) stopped me.

A few things...

- The 0/n changelog should reveal how MAP_LOCKONFAULT interacts with
  rlimit(RLIMIT_MEMLOCK).

  I see the implementation is "as if the entire mapping will be
  faulted in" (for mmap) and "as if it was MCL_FUTURE" (for mlockall)
  which seems fine.  Please include changelog text explaining and
  justifying these decisions.  This stuff will need to be in the
  manpage updates as well.

- I think I already asked "why not just use MCL_FUTURE" but I forget
  the answer ;) In general it is a good idea to update changelogs in
  response to reviewer questions, because other people will be
  wondering the same things.  Or maybe I forgot to ask.  Either way,
  please address this in the changelogs.

- I can perhaps see the point in mmap(MAP_LOCKONFAULT) (other
  mappings don't get lock-in-memory treatment), but what's the benefit
  in mlockall(MCL_ON_FAULT) over MCL_FUTURE?  (Add to changelog also,
  please).

- Is there a manpage update?

- Can we rename patch 1/3 from "add flag to ..." to "add mmap flag to
  ...", to distinguish from 2/3 "add mlockall flag ..."?

- The MAP_LOCKONFAULT versus MCL_ON_FAULT inconsistency is
  irritating!  Can we get these consistent please: switch to either
  MAP_LOCK_ON_FAULT or MCL_ONFAULT.

