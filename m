From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v8 4/6] mm: mlock: Add mlock flags to enable
 VM_LOCKONFAULT usage
Date: Fri, 28 Aug 2015 16:32:51 +0200
Message-ID: <20150828143251.GF5301@dhcp22.suse.cz>
References: <1440613465-30393-1-git-send-email-emunson@akamai.com>
 <1440613465-30393-5-git-send-email-emunson@akamai.com>
 <20150828143130.GE5301@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150828143130.GE5301@dhcp22.suse.cz>
Sender: linux-arch-owner@vger.kernel.org
To: Eric B Munson <emunson@akamai.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Jonathan Corbet <corbet@lwn.net>, "Kirill A. Shutemov" <kirill@shutemov.name>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org

On Fri 28-08-15 16:31:30, Michal Hocko wrote:
> On Wed 26-08-15 14:24:23, Eric B Munson wrote:
> > The previous patch introduced a flag that specified pages in a VMA
> > should be placed on the unevictable LRU, but they should not be made
> > present when the area is created.  This patch adds the ability to set
> > this state via the new mlock system calls.
> > 
> > We add MLOCK_ONFAULT for mlock2 and MCL_ONFAULT for mlockall.
> > MLOCK_ONFAULT will set the VM_LOCKONFAULT modifier for VM_LOCKED.
> > MCL_ONFAULT should be used as a modifier to the two other mlockall
> > flags.  When used with MCL_CURRENT, all current mappings will be marked
> > with VM_LOCKED | VM_LOCKONFAULT.  When used with MCL_FUTURE, the
> > mm->def_flags will be marked with VM_LOCKED | VM_LOCKONFAULT.  When used
> > with both MCL_CURRENT and MCL_FUTURE, all current mappings and
> > mm->def_flags will be marked with VM_LOCKED | VM_LOCKONFAULT.
> > 
> > Prior to this patch, mlockall() will unconditionally clear the
> > mm->def_flags any time it is called without MCL_FUTURE.  This behavior
> > is maintained after adding MCL_ONFAULT.  If a call to
> > mlockall(MCL_FUTURE) is followed by mlockall(MCL_CURRENT), the
> > mm->def_flags will be cleared and new VMAs will be unlocked.  This
> > remains true with or without MCL_ONFAULT in either mlockall()
> > invocation.

Btw. I think we really want a man page for this new mlock call.
-- 
Michal Hocko
SUSE Labs
