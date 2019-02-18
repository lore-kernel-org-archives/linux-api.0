From: Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: mremap vs sysctl_max_map_count
Date: Mon, 18 Feb 2019 12:29:29 +0200
Message-ID: <20190218102928.GA25446@rapoport-lnx>
References: <20190218083326.xsnx7cx2lxurbmux@d104.suse.de>
 <a11a10b5-4a31-2537-7b14-83f4b22e5f6c@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a11a10b5-4a31-2537-7b14-83f4b22e5f6c@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, hughd@google.com, viro@zeniv.linux.org.uk, torvalds@linux-foundation.org
List-Id: linux-api@vger.kernel.org

On Mon, Feb 18, 2019 at 10:57:18AM +0100, Vlastimil Babka wrote:
> On 2/18/19 9:33 AM, Oscar Salvador wrote:
> > 
> > Hi all,
> > 
> > I would like to bring up a topic that comes from an issue a customer of ours
> > is facing with the mremap syscall + hitting the max_map_count threshold:
> > 
> > When passing the MREMAP_FIXED flag, mremap() calls mremap_to() which does the
> > following:
> > 
> > 1) it unmaps the region where we want to put the new map:
> >    (new_addr, new_addr + new_len] [1]
> > 2) IFF old_len > new_len, it unmaps the region:
> >    (old_addr + new_len, (old_addr + new_len) + (old_len - new_len)] [2]
> > 
> > Now, having gone through steps 1) and 2), we eventually call move_vma() to do
> > the actual move.
> > 
> > move_vma() checks if we are at least 4 maps below max_map_count, otherwise
> > it bails out with -ENOMEM [3].
> > The problem is that we might have already unmapped the vma's in steps 1) and 2),
> > so it is not possible for userspace to figure out the state of the vma's after
> > it gets -ENOMEM.
> > 
> > - Did new_addr got unmaped?
> > - Did part of the old_addr got unmaped?
> > 
> > Because of that, it gets tricky for userspace to clean up properly on error
> > path.
> > 
> > While it is true that we can return -ENOMEM for more reasons
> > (e.g: see vma_to_resize()->may_expand_vm()), I think that we might be able to
> > pre-compute the number of maps that we are going add/release during the first
> > two do_munmaps(), and check whether we are 4 maps below the threshold
> > (as move_vma() does).
> > Should not be the case, we can bail out early before we unmap anything, so we
> > make sure the vma's are left untouched in case we are going to be short of maps.
> > 
> > I am not sure if that is realistically doable, or there are limitations
> > I overlooked, or we simply do not want to do that.
> 
> IMHO it makes sense to do all such resource limit checks upfront. It
> should all be protected by mmap_sem and thus stable, right? Even if it
> was racy, I'd think it's better to breach the limit a bit due to a race
> than bail out in the middle of operation. Being also resilient against
> "real" ENOMEM's due to e.g. failure to alocate a vma would be much
> harder perhaps (but maybe it's already mostly covered by the
> too-small-to-fail in page allocator), but I'd try with the artificial
> limits at least.

The mremap_to() is called with mmap_sem hold, so there won't be a race.

But it seems mremap_to() is not the only path to call do_munmap(). There is
also an unmap in shrinking remap and possible move_vma() even with
~MREMAP_FIXED.

Maybe it'd make sense to check the limits right after taking the mmap_sem?
 
> > Before investing more time and giving it a shoot, I just wanted to bring
> > this upstream to get feedback on this matter.
> > 
> > Thanks
> > 
> > [1] https://github.com/torvalds/linux/blob/master/mm/mremap.c#L519
> > [2] https://github.com/torvalds/linux/blob/master/mm/mremap.c#L523
> > [3] https://github.com/torvalds/linux/blob/master/mm/mremap.c#L338
> > 
> 

-- 
Sincerely yours,
Mike.
