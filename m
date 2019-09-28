From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: [PATCH v5 1/1] random: getrandom(2): warn on large CRNG waits,
 introduce new flags
Date: Sat, 28 Sep 2019 11:30:46 +0200
Message-ID: <20190928093046.GA1039@darwi-home-pc>
References: <20190914122500.GA1425@darwi-home-pc>
 <008f17bc-102b-e762-a17c-e2766d48f515@gmail.com>
 <20190915052242.GG19710@mit.edu>
 <CAHk-=wgg2T=3KxrO-BY3nHJgMEyApjnO3cwbQb_0vxsn9qKN8Q@mail.gmail.com>
 <20190918211503.GA1808@darwi-home-pc>
 <20190918211713.GA2225@darwi-home-pc>
 <CAHk-=wiCqDiU7SE3FLn2W26MS_voUAuqj5XFa1V_tiGTrrW-zQ@mail.gmail.com>
 <20190926204217.GA1366@pc>
 <20190926204425.GA2198@pc>
 <9a9715dc-e30b-24fb-a754-464449cafb2f@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9a9715dc-e30b-24fb-a754-464449cafb2f@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, Florian Weimer <fweimer@redhat.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, lkml <linux-kernel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 26, 2019 at 02:39:44PM -0700, Andy Lutomirski wrote:
> On 9/26/19 1:44 PM, Ahmed S. Darwish wrote:
> > Since Linux v3.17, getrandom(2) has been created as a new and more
> > secure interface for pseudorandom data requests.  It attempted to
> > solve three problems, as compared to /dev/urandom:
> > 
> >    1. the need to access filesystem paths, which can fail, e.g. under a
> >       chroot
> > 
> >    2. the need to open a file descriptor, which can fail under file
> >       descriptor exhaustion attacks
> > 
> >    3. the possibility of getting not-so-random data from /dev/urandom,
> >       due to an incompletely initialized kernel entropy pool
> > 
> > To solve the third point, getrandom(2) was made to block until a
> > proper amount of entropy has been accumulated to initialize the CRNG
> > ChaCha20 cipher.  This made the system call have no guaranteed
> > upper-bound for its initial waiting time.
> > 
> > Thus when it was introduced at c6e9d6f38894 ("random: introduce
> > getrandom(2) system call"), it came with a clear warning: "Any
> > userspace program which uses this new functionality must take care to
> > assure that if it is used during the boot process, that it will not
> > cause the init scripts or other portions of the system startup to hang
> > indefinitely."
> > 
> > Unfortunately, due to multiple factors, including not having this
> > warning written in a scary-enough language in the manpages, and due to
> > glibc since v2.25 implementing a BSD-like getentropy(3) in terms of
> > getrandom(2), modern user-space is calling getrandom(2) in the boot
> > path everywhere (e.g. Qt, GDM, etc.)
> > 
> > Embedded Linux systems were first hit by this, and reports of embedded
> > systems "getting stuck at boot" began to be common.  Over time, the
> > issue began to even creep into consumer-level x86 laptops: mainstream
> > distributions, like Debian Buster, began to recommend installing
> > haveged as a duct-tape workaround... just to let the system boot.
> > 
> > Moreover, filesystem optimizations in EXT4 and XFS, e.g. b03755ad6f33
> > ("ext4: make __ext4_get_inode_loc plug"), which merged directory
> > lookup code inode table IO, and very fast systemd boots, further
> > exaggerated the problem by limiting interrupt-based entropy sources.
> > This led to large delays until the kernel's cryptographic random
> > number generator (CRNG) got initialized.
> > 
> > On a Thinkpad E480 x86 laptop and an ArchLinux user-space, the ext4
> > commit earlier mentioned reliably blocked the system on GDM boot.
> > Mitigate the problem, as a first step, in two ways:
> > 
> >    1. Issue a big WARN_ON when any process gets stuck on getrandom(2)
> >       for more than CONFIG_GETRANDOM_WAIT_THRESHOLD_SEC seconds.
> > 
> >    2. Introduce new getrandom(2) flags, with clear semantics that can
> >       hopefully guide user-space in doing the right thing.
> > 
> > Set CONFIG_GETRANDOM_WAIT_THRESHOLD_SEC to a heuristic 30-second
> > default value. System integrators and distribution builders are deeply
> > encouraged not to increase it much: during system boot, you either
> > have entropy, or you don't. And if you didn't have entropy, it will
> > stay like this forever, because if you had, you wouldn't have blocked
> > in the first place. It's an atomic "either/or" situation, with no
> > middle ground. Please think twice.
> 
> So what do we expect glibc's getentropy() to do?  If it just adds the new
> flag to shut up the warning, we haven't really accomplished much.

Yes, if glibc adds GRND_SECURE_UNBOUNDED_INITIAL_WAIT to gentropy(3),
then this exercise would indeed be invalidated. Hopefully,
coordination with glibc will be done so it won't happen... @Florian?

Afterwards, a sane approach would be for gentropy(3) to be deprecated,
and to add getentropy_secure_unbounded_initial_wait(3) and
getentropy_insecure(3).

Note that this V5 patch does not claim to fully solve the problem, but
it will:

  1. Pinpoint to the processes causing system boots to block
  
  2. Tell people what correct alternative to use when facing problem
     #1 above, through the proposed getrandom_wait(7) manpage. That
     manpage page will fully describe the problem, and advise
     user-space to either use the new getrandom flags, or the new
     glibc gentropy_*() variants.

thanks,

--
Ahmed Darwish
