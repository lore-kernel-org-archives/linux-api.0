From: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/2] mm: introduce MAP_FIXED_SAFE
Date: Fri, 17 Nov 2017 00:45:49 -0800
Message-ID: <b1848e34-7fcd-8ad8-6a6a-3be3dce3fda7@nvidia.com>
References: <20171116101900.13621-1-mhocko@kernel.org>
 <20171116121438.6vegs4wiahod3byl@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171116121438.6vegs4wiahod3byl-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Abdul Haleem <abdhalee-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/16/2017 04:14 AM, Michal Hocko wrote:
> [Ups, managed to screw the subject - fix it]
> 
> On Thu 16-11-17 11:18:58, Michal Hocko wrote:
>> Hi,
>> this has started as a follow up discussion [1][2] resulting in the
>> runtime failure caused by hardening patch [3] which removes MAP_FIXED
>> from the elf loader because MAP_FIXED is inherently dangerous as it
>> might silently clobber and existing underlying mapping (e.g. stack). The
>> reason for the failure is that some architectures enforce an alignment
>> for the given address hint without MAP_FIXED used (e.g. for shared or
>> file backed mappings).
>>
>> One way around this would be excluding those archs which do alignment
>> tricks from the hardening [4]. The patch is really trivial but it has
>> been objected, rightfully so, that this screams for a more generic
>> solution. We basically want a non-destructive MAP_FIXED.
>>
>> The first patch introduced MAP_FIXED_SAFE which enforces the given
>> address but unlike MAP_FIXED it fails with ENOMEM if the given range
>> conflicts with an existing one. The flag is introduced as a completely
>> new flag rather than a MAP_FIXED extension because of the backward
>> compatibility. We really want a never-clobber semantic even on older
>> kernels which do not recognize the flag. Unfortunately mmap sucks wrt.
>> flags evaluation because we do not EINVAL on unknown flags. On those
>> kernels we would simply use the traditional hint based semantic so the
>> caller can still get a different address (which sucks) but at least not
>> silently corrupt an existing mapping. I do not see a good way around
>> that. Except we won't export expose the new semantic to the userspace at
>> all. It seems there are users who would like to have something like that
>> [5], though. Atomic address range probing in the multithreaded programs
>> sounds like an interesting thing to me as well, although I do not have
>> any specific usecase in mind.

Hi Michal,

>From looking at the patchset, it seems to me that the new MAP_FIXED_SAFE
(or whatever it ends up being named) *would* be passed through from
user space. When you say that "we won't export expose the new semantic 
to the userspace at all", do you mean that glibc won't add it? Or
is there something I'm missing, that prevents that flag from getting
from the syscall, to do_mmap()?

On the usage: there are cases in user space that could probably make
good use of a no-clobber hint to MAP_FIXED. The user space code
that surrounds HMM (speaking loosely there--it's really any user space
code that manages a unified memory address space, across devices)
often ends up using MAP_FIXED, but MAP_FIXED crams several features
into one flag: an exact address, an "atomic" switch to the new mapping,
and unmapping the old mappings. That's pretty overloaded, so being
able to split it up a bit, by removing one of those features, seems
useful.

thanks,
John Hubbard

>>
>> The second patch simply replaces MAP_FIXED use in elf loader by
>> MAP_FIXED_SAFE. I believe other places which rely on MAP_FIXED should
>> follow. Actually real MAP_FIXED usages should be docummented properly
>> and they should be more of an exception.
>>
>> Does anybody see any fundamental reasons why this is a wrong approach?
>>
>> Diffstat says
>>  arch/alpha/include/uapi/asm/mman.h   |  2 ++
>>  arch/metag/kernel/process.c          |  6 +++++-
>>  arch/mips/include/uapi/asm/mman.h    |  2 ++
>>  arch/parisc/include/uapi/asm/mman.h  |  2 ++
>>  arch/powerpc/include/uapi/asm/mman.h |  1 +
>>  arch/sparc/include/uapi/asm/mman.h   |  1 +
>>  arch/tile/include/uapi/asm/mman.h    |  1 +
>>  arch/xtensa/include/uapi/asm/mman.h  |  2 ++
>>  fs/binfmt_elf.c                      | 12 ++++++++----
>>  include/uapi/asm-generic/mman.h      |  1 +
>>  mm/mmap.c                            | 11 +++++++++++
>>  11 files changed, 36 insertions(+), 5 deletions(-)
>>
>> [1] http://lkml.kernel.org/r/20171107162217.382cd754-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
>> [2] http://lkml.kernel.org/r/1510048229.12079.7.camel-JKZ9t1WPFCv1ENwx4SLHqw@public.gmane.org
>> [3] http://lkml.kernel.org/r/20171023082608.6167-1-mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
>> [4] http://lkml.kernel.org/r/20171113094203.aofz2e7kueitk55y-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org
>> [5] http://lkml.kernel.org/r/87efp1w7vy.fsf-W0DJWXSxmBNbyGPkN3NxC2scP1bn1w/D@public.gmane.org
>>
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
> 
