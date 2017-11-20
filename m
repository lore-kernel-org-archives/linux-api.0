From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH 0/2] mm: introduce MAP_FIXED_SAFE
Date: Mon, 20 Nov 2017 10:05:09 +0100
Message-ID: <20171120090509.moagbwu7ug3y42gj@dhcp22.suse.cz>
References: <20171116101900.13621-1-mhocko@kernel.org>
 <20171116121438.6vegs4wiahod3byl@dhcp22.suse.cz>
 <b1848e34-7fcd-8ad8-6a6a-3be3dce3fda7@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b1848e34-7fcd-8ad8-6a6a-3be3dce3fda7@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Hubbard <jhubbard@nvidia.com>
Cc: linux-api@vger.kernel.org, Khalid Aziz <khalid.aziz@oracle.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Abdul Haleem <abdhalee@linux.vnet.ibm.com>, Joel Stanley <joel@jms.id.au>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Fri 17-11-17 00:45:49, John Hubbard wrote:
> On 11/16/2017 04:14 AM, Michal Hocko wrote:
> > [Ups, managed to screw the subject - fix it]
> > 
> > On Thu 16-11-17 11:18:58, Michal Hocko wrote:
> >> Hi,
> >> this has started as a follow up discussion [1][2] resulting in the
> >> runtime failure caused by hardening patch [3] which removes MAP_FIXED
> >> from the elf loader because MAP_FIXED is inherently dangerous as it
> >> might silently clobber and existing underlying mapping (e.g. stack). The
> >> reason for the failure is that some architectures enforce an alignment
> >> for the given address hint without MAP_FIXED used (e.g. for shared or
> >> file backed mappings).
> >>
> >> One way around this would be excluding those archs which do alignment
> >> tricks from the hardening [4]. The patch is really trivial but it has
> >> been objected, rightfully so, that this screams for a more generic
> >> solution. We basically want a non-destructive MAP_FIXED.
> >>
> >> The first patch introduced MAP_FIXED_SAFE which enforces the given
> >> address but unlike MAP_FIXED it fails with ENOMEM if the given range
> >> conflicts with an existing one. The flag is introduced as a completely
> >> new flag rather than a MAP_FIXED extension because of the backward
> >> compatibility. We really want a never-clobber semantic even on older
> >> kernels which do not recognize the flag. Unfortunately mmap sucks wrt.
> >> flags evaluation because we do not EINVAL on unknown flags. On those
> >> kernels we would simply use the traditional hint based semantic so the
> >> caller can still get a different address (which sucks) but at least not
> >> silently corrupt an existing mapping. I do not see a good way around
> >> that. Except we won't export expose the new semantic to the userspace at
> >> all. It seems there are users who would like to have something like that
> >> [5], though. Atomic address range probing in the multithreaded programs
> >> sounds like an interesting thing to me as well, although I do not have
> >> any specific usecase in mind.
> 
> Hi Michal,
> 
> From looking at the patchset, it seems to me that the new MAP_FIXED_SAFE
> (or whatever it ends up being named) *would* be passed through from
> user space. When you say that "we won't export expose the new semantic 
> to the userspace at all", do you mean that glibc won't add it? Or
> is there something I'm missing, that prevents that flag from getting
> from the syscall, to do_mmap()?

I meant that I could make it an internal flag outside of the map_type
space. So the userspace will not be able to use it.
 
> On the usage: there are cases in user space that could probably make
> good use of a no-clobber hint to MAP_FIXED. The user space code
> that surrounds HMM (speaking loosely there--it's really any user space
> code that manages a unified memory address space, across devices)
> often ends up using MAP_FIXED, but MAP_FIXED crams several features
> into one flag: an exact address, an "atomic" switch to the new mapping,
> and unmapping the old mappings. That's pretty overloaded, so being
> able to split it up a bit, by removing one of those features, seems
> useful.

Yes, atomic address range probing sounds useful. I cannot comment on HMM
usage but if you have any more specific I would welcome any links to add
them to the changelog.
-- 
Michal Hocko
SUSE Labs
